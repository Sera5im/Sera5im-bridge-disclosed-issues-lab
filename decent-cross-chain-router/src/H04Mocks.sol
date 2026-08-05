// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockDcntEth {
    mapping(address => uint256) public balanceOf;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

contract MockWethReserves {
    mapping(address => uint256) public balanceOf;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }
}

contract MockDestinationAdapter {
    // Intentionally no withdrawal path.
}

contract MockReserveSensitiveRouter {
    uint8 internal constant MT_ETH_TRANSFER = 0;

    MockDcntEth public immutable dcntEth;
    MockWethReserves public immutable weth;

    constructor(MockDcntEth _dcntEth, MockWethReserves _weth) {
        dcntEth = _dcntEth;
        weth = _weth;
    }

    function onOFTReceived(
        address, /* from */
        address to,
        uint256 amount,
        uint8 msgType
    ) external {
        if (weth.balanceOf(address(this)) < amount) {
            // Vulnerability: for payload-bearing messages, `to` is the execution target,
            // not the user refund recipient.
            dcntEth.transfer(to, amount);
            return;
        }

        if (msgType == MT_ETH_TRANSFER) {
            revert("not-used-in-this-poc");
        }
    }
}
