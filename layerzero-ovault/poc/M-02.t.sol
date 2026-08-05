// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OvaultMocks.sol";

contract LayerZeroOvaultM02Test is Test {
    function test_M02_unsatisfiedSlippageLeavesFundsLockedWithoutEscapePath() public {
        SlippageLockedComposer composer = new SlippageLockedComposer();
        composer.markFailed(address(this), 100 ether, 1_000 ether);

        vm.expectRevert(SlippageLockedComposer.SlippageNotSatisfied.selector);
        composer.retryWithSwap(500 ether);

        (, , , bool active) = composer.failedSwap();
        assertTrue(active, "failed swap remains locked");
    }
}
