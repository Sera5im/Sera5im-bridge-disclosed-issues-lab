// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct MockSwapInstructions {
    uint256 amountOut;
}

contract MockFeeCollector {
    uint256 public totalFeesCollected;

    function collectFees(uint256 requiredFee, bytes calldata signature) external payable {
        require(msg.value == requiredFee, "wrong-fee");
        require(keccak256(signature) == keccak256("valid-signature"), "bad-signature");
        totalFeesCollected += msg.value;
    }
}

contract MockActionTarget {
    uint256 public storedValue;
    address public lastRefund;

    function execute(uint256 newValue, address refund) external {
        storedValue = newValue;
        lastRefund = refund;
    }
}

contract MockUTB {
    MockFeeCollector public immutable feeCollector;

    constructor(MockFeeCollector _feeCollector) {
        feeCollector = _feeCollector;
    }

    function swapAndExecute(
        MockSwapInstructions calldata instructions,
        address target,
        bytes calldata payload,
        address payable refund,
        uint256 feeAmount,
        bytes calldata signature
    ) external payable {
        feeCollector.collectFees{value: msg.value}(feeAmount, signature);
        _swapAndExecute(instructions, target, payload, refund);
    }

    function receiveFromBridge(
        MockSwapInstructions calldata instructions,
        address target,
        bytes calldata payload,
        address payable refund
    ) external {
        // Vulnerability: public alternate path reaches execution
        // without fee collection or signature validation.
        _swapAndExecute(instructions, target, payload, refund);
    }

    function _swapAndExecute(
        MockSwapInstructions calldata, /* instructions */
        address target,
        bytes calldata payload,
        address payable refund
    ) internal {
        (bool ok,) = target.call(abi.encodePacked(payload, abi.encode(refund)));
        require(ok, "exec-failed");
    }
}
