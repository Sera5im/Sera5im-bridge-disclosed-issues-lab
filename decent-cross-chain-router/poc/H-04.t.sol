pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/H04Mocks.sol";

contract DecentH04Test is Test {
    MockDcntEth internal dcntEth;
    MockWethReserves internal weth;
    MockReserveSensitiveRouter internal router;
    MockDestinationAdapter internal adapter;

    address internal user = address(0xBEEF);

    function setUp() public {
        dcntEth = new MockDcntEth();
        weth = new MockWethReserves();
        router = new MockReserveSensitiveRouter(dcntEth, weth);
        adapter = new MockDestinationAdapter();

        dcntEth.mint(address(router), 40 ether);
        weth.mint(address(router), 5 ether);
    }

    function test_ReserveShortfallStrandsDcntEthInsideAdapter() public {
        router.onOFTReceived(
            address(0xAAA1),
            address(adapter),
            20 ether,
            1
        );

        assertEq(dcntEth.balanceOf(address(adapter)), 20 ether);
        assertEq(dcntEth.balanceOf(user), 0);
        assertEq(dcntEth.balanceOf(address(router)), 20 ether);
    }
}
