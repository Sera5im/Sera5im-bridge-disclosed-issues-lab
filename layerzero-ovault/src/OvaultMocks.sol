// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockToken {
    mapping(address => uint256) public balanceOf;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function burn(address from, uint256 amount) external {
        balanceOf[from] -= amount;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function moveFrom(address from, address to, uint256 amount) external {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }
}

contract BrokenRefundComposer {
    struct SendParam {
        uint32 dstEid;
        address to;
        uint256 amountLD;
        uint256 minAmountLD;
    }

    struct FailedMessage {
        SendParam sendParam;
        SendParam refundSendParam;
    }

    mapping(bytes32 => FailedMessage) public failedMessages;
    MockToken public immutable token;

    error SlippageExceeded();

    constructor(MockToken _token) {
        token = _token;
    }

    function storeFailedMessage(
        bytes32 guid,
        SendParam memory sendParam,
        SendParam memory refundSendParam
    ) external {
        sendParam.amountLD = 0;
        failedMessages[guid] = FailedMessage(sendParam, refundSendParam);
    }

    function refund(bytes32 guid) external {
        FailedMessage memory failedMessage = failedMessages[guid];
        SendParam memory refundSendParam = failedMessage.sendParam; // vulnerability

        if (refundSendParam.amountLD < refundSendParam.minAmountLD) revert SlippageExceeded();
        token.mint(refundSendParam.to, refundSendParam.amountLD);
    }
}

contract VulnerableVault {
    MockToken public immutable asset;
    mapping(address => uint256) public shares;
    uint256 public totalSupply;

    constructor(MockToken _asset) {
        asset = _asset;
    }

    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }

    function deposit(uint256 assets, address receiver) external returns (uint256 mintedShares) {
        asset.moveFrom(msg.sender, address(this), assets);
        if (totalSupply == 0) {
            mintedShares = assets;
        } else {
            mintedShares = (assets * totalSupply) / totalAssets();
        }
        shares[receiver] += mintedShares;
        totalSupply += mintedShares;
    }

    function redeem(uint256 shareAmount, address owner) external returns (uint256 assetsOut) {
        assetsOut = (shareAmount * totalAssets()) / totalSupply;
        shares[owner] -= shareAmount;
        totalSupply -= shareAmount;
        asset.transfer(owner, assetsOut);
    }

    function donate(uint256 amount) external {
        asset.moveFrom(msg.sender, address(this), amount);
    }
}

contract SaferVault {
    MockToken public immutable asset;
    mapping(address => uint256) public shares;
    uint256 public totalSupply;
    uint256 internal constant VIRTUAL_SHARES = 1e18;
    uint256 internal constant VIRTUAL_ASSETS = 1;

    constructor(MockToken _asset) {
        asset = _asset;
    }

    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }

    function deposit(uint256 assets, address receiver) external returns (uint256 mintedShares) {
        asset.moveFrom(msg.sender, address(this), assets);
        if (totalSupply == 0) {
            mintedShares = assets;
        } else {
            mintedShares = (assets * (totalSupply + VIRTUAL_SHARES)) / (totalAssets() + VIRTUAL_ASSETS);
        }
        shares[receiver] += mintedShares;
        totalSupply += mintedShares;
    }
}

contract SlippageLockedComposer {
    struct FailedSwap {
        address user;
        uint256 amountIn;
        uint256 minOut;
        bool active;
    }

    FailedSwap public failedSwap;

    error SlippageNotSatisfied();

    function markFailed(address user, uint256 amountIn, uint256 minOut) external {
        failedSwap = FailedSwap(user, amountIn, minOut, true);
    }

    function retryWithSwap(uint256 actualOut) external {
        if (actualOut < failedSwap.minOut) revert SlippageNotSatisfied();
        failedSwap.active = false;
    }
}

contract HubSendComposer {
    struct SendParam {
        uint32 dstEid;
        address to;
        uint256 amountLD;
    }

    uint32 public immutable HUB_EID;
    mapping(uint32 => bool) public peers;
    MockToken public immutable token;

    error NoPeer();

    constructor(uint32 hubEid, MockToken _token) {
        HUB_EID = hubEid;
        token = _token;
    }

    function setPeer(uint32 eid, bool ok) external {
        peers[eid] = ok;
    }

    function send(SendParam memory sendParam) external {
        if (sendParam.dstEid == HUB_EID) {
            token.mint(sendParam.to, sendParam.amountLD);
            return;
        }
        if (!peers[sendParam.dstEid]) revert NoPeer();
    }

    function internalRetryLikePath(SendParam memory sendParam) external {
        _send(sendParam);
    }

    function _send(SendParam memory sendParam) internal view {
        if (!peers[sendParam.dstEid]) revert NoPeer();
        sendParam;
    }
}

contract NativeValueComposer {
    struct FailedMessage {
        uint256 requiredNative;
        bool active;
    }

    mapping(bytes32 => FailedMessage) public failedMessages;

    error NotEnoughNative();

    function lzCompose(bytes32 guid, uint256 requiredNative) external payable {
        failedMessages[guid] = FailedMessage(requiredNative, true);
    }

    function retry(bytes32 guid) external payable {
        FailedMessage memory failed = failedMessages[guid];
        if (msg.value < failed.requiredNative) revert NotEnoughNative();
        delete failedMessages[guid];
    }
}

contract DustEndpoint {
    error SlippageExceeded();

    function debitView(uint256 amountLD, uint256 minAmountLD) public pure returns (uint256) {
        uint256 amountSentLD = (amountLD / 100) * 100;
        if (amountSentLD < minAmountLD) revert SlippageExceeded();
        return amountSentLD;
    }
}

contract DifferentSlippageComposer {
    DustEndpoint public immutable endpoint;

    constructor(DustEndpoint _endpoint) {
        endpoint = _endpoint;
    }

    error LocalSlippageExceeded();

    function executeOVaultAction(uint256 amountLD, uint256 minAmountLD) external view returns (uint256) {
        if (amountLD < minAmountLD) revert LocalSlippageExceeded();
        return endpoint.debitView(amountLD, minAmountLD);
    }
}
