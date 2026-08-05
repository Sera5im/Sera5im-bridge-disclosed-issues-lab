// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OvaultMocks.sol";

contract LayerZeroOvaultM04Test is Test {
    function test_M04_msgValueCanBeTrappedAndMustBePaidAgainOnRetry() public {
        NativeValueComposer composer = new NativeValueComposer();
        bytes32 guid = keccak256("M04");

        composer.lzCompose{value: 1 ether}(guid, 1 ether);
        assertEq(address(composer).balance, 1 ether, "native value stays in composer");

        vm.expectRevert(NativeValueComposer.NotEnoughNative.selector);
        composer.retry(guid);

        composer.retry{value: 1 ether}(guid);
        (, bool active) = composer.failedMessages(guid);
        assertFalse(active, "retry only works after paying native again");
    }
}
