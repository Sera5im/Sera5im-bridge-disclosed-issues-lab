// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/H03Mocks.sol";

contract DecentH03Test is Test {
    MockWETH internal weth;
    MockDecentBridgeExecutor internal executor;
    MockDecentEthRouter internal router;
    AlwaysFailTarget internal failingTarget;

    address internal wrongRefundAddress = address(0xAAA1);
    address internal intendedUser = address(0xBEEF);

    function setUp() public {
        weth = new MockWETH();
        executor = new MockDecentBridgeExecutor(weth);
        router = new MockDecentEthRouter(weth, executor);
        failingTarget = new AlwaysFailTarget();

        weth.mint(address(router), 100 ether);
    }

    function test_FailedExecutionRefundsToWrongAddress() public {
        router.onOFTReceived(
            wrongRefundAddress,
            address(failingTarget),
            25 ether,
            abi.encodeWithSignature("doesNotMatter()")
        );

        assertEq(weth.balanceOf(wrongRefundAddress), 25 ether);
        assertEq(weth.balanceOf(intendedUser), 0);
        assertEq(weth.balanceOf(address(router)), 75 ether);
    }
}
