// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OvaultMocks.sol";

contract LayerZeroOvaultH01Test is Test {
    function test_H01_refundUsesZeroedSendParamAndPermanentlyFails() public {
        MockToken token = new MockToken();
        BrokenRefundComposer composer = new BrokenRefundComposer(token);

        BrokenRefundComposer.SendParam memory sendParam =
            BrokenRefundComposer.SendParam({dstEid: 10, to: address(this), amountLD: 100 ether, minAmountLD: 100 ether});
        BrokenRefundComposer.SendParam memory refundSendParam =
            BrokenRefundComposer.SendParam({dstEid: 11, to: address(this), amountLD: 100 ether, minAmountLD: 100 ether});

        bytes32 guid = keccak256("H01");
        composer.storeFailedMessage(guid, sendParam, refundSendParam);

        vm.expectRevert(BrokenRefundComposer.SlippageExceeded.selector);
        composer.refund(guid);
    }
}
