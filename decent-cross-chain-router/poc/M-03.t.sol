// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/M03Mocks.sol";

contract DecentM03Test is Test {
    MockFeeCollector internal feeCollector;
    MockUTB internal utb;
    MockActionTarget internal target;

    address payable internal refund = payable(address(0xBEEF));

    function setUp() public {
        feeCollector = new MockFeeCollector();
        utb = new MockUTB(feeCollector);
        target = new MockActionTarget();
    }

    function test_ReceiveFromBridgeBypassesFeesAndSignatureChecks() public {
        MockSwapInstructions memory instructions = MockSwapInstructions({amountOut: 1 ether});
        bytes memory payload = abi.encodeWithSelector(MockActionTarget.execute.selector, 1337);

        utb.receiveFromBridge(instructions, address(target), payload, refund);

        assertEq(target.storedValue(), 1337);
        assertEq(target.lastRefund(), refund);
        assertEq(feeCollector.totalFeesCollected(), 0);
    }

    function test_NormalPathStillChargesFeeAndNeedsSignature() public {
        MockSwapInstructions memory instructions = MockSwapInstructions({amountOut: 1 ether});
        bytes memory payload = abi.encodeWithSelector(MockActionTarget.execute.selector, 7);

        utb.swapAndExecute{value: 1 ether}(
            instructions,
            address(target),
            payload,
            refund,
            1 ether,
            bytes("valid-signature")
        );

        assertEq(target.storedValue(), 7);
        assertEq(feeCollector.totalFeesCollected(), 1 ether);
    }
}
