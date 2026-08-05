// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockWETH {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
        }
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

contract AlwaysFailTarget {
    fallback() external payable {
        revert("target-failed");
    }
}

contract MockDecentBridgeExecutor {
    MockWETH public immutable weth;

    constructor(MockWETH _weth) {
        weth = _weth;
    }

    function execute(
        address from,
        address target,
        bool, /* deliverEth */
        uint256 amount,
        bytes memory callPayload
    ) external {
        weth.transferFrom(msg.sender, address(this), amount);
        weth.approve(target, amount);

        (bool success,) = target.call(callPayload);
        if (!success) {
            // Vulnerability: refund goes to `from`, even if `from`
            // is only an internal bridge-side address.
            weth.transfer(from, amount);
            return;
        }
    }
}

contract MockDecentEthRouter {
    MockWETH public immutable weth;
    MockDecentBridgeExecutor public immutable executor;

    constructor(MockWETH _weth, MockDecentBridgeExecutor _executor) {
        weth = _weth;
        executor = _executor;
    }

    function onOFTReceived(
        address from,
        address to,
        uint256 amount,
        bytes memory callPayload
    ) external {
        weth.approve(address(executor), amount);
        executor.execute(from, to, false, amount, callPayload);
    }
}
