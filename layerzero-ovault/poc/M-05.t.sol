pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OvaultMocks.sol";

contract LayerZeroOvaultM05Test is Test {
    function test_M05_localSlippageCheckPassesButEndpointDustCheckReverts() public {
        DustEndpoint endpoint = new DustEndpoint();
        DifferentSlippageComposer composer = new DifferentSlippageComposer(endpoint);

        vm.expectRevert(DustEndpoint.SlippageExceeded.selector);
        composer.executeOVaultAction(123, 123);
    }
}
