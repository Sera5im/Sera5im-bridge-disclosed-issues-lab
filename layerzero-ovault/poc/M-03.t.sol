// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OvaultMocks.sol";

contract LayerZeroOvaultM03Test is Test {
    function test_M03_retryPathFailsWhenDstEidEqualsHubEid() public {
        MockToken token = new MockToken();
        HubSendComposer composer = new HubSendComposer(100, token);

        HubSendComposer.SendParam memory sendParam =
            HubSendComposer.SendParam({dstEid: 100, to: address(0xCAFE), amountLD: 55 ether});

        composer.send(sendParam);
        assertEq(token.balanceOf(address(0xCAFE)), 55 ether, "normal send handles local hub route");

        vm.expectRevert(HubSendComposer.NoPeer.selector);
        composer.internalRetryLikePath(sendParam);
    }
}
