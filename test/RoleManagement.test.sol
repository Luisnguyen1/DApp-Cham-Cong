// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/RoleManagement.sol";

contract RoleManagementTest is Test {
    RoleManagement private roleManagement;
    address constant ROOT_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address constant TEST_USER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address constant TEST_USER2 = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

    event RoleAssigned(address indexed user, RoleManagement.Role role);
    event RoleRevoked(address indexed user);

    function setUp() public {
        vm.startPrank(ROOT_ADDRESS);
        roleManagement = new RoleManagement();
        vm.stopPrank();
    }

    function testDeployment() public view {
        assertEq(roleManagement.getRootAddress(), ROOT_ADDRESS);
        assertTrue(roleManagement.isRoot(ROOT_ADDRESS));
        assertEq(uint(roleManagement.checkRole(ROOT_ADDRESS)), uint(RoleManagement.Role.Root));
    }

    function testAssignRole() public {
        vm.startPrank(ROOT_ADDRESS);
        
        vm.expectEmit(true, false, false, true);
        emit RoleAssigned(TEST_USER, RoleManagement.Role.HRManager);
        roleManagement.assignRole(TEST_USER, RoleManagement.Role.HRManager);
        
        assertEq(uint(roleManagement.checkRole(TEST_USER)), uint(RoleManagement.Role.HRManager));
        vm.stopPrank();
    }

    function testAssignRoleFail() public {
        vm.startPrank(TEST_USER);
        vm.expectRevert("Only Root can perform this action");
        roleManagement.assignRole(TEST_USER2, RoleManagement.Role.Employee);
        vm.stopPrank();
    }

    function testRevokeRole() public {
        vm.startPrank(ROOT_ADDRESS);
        roleManagement.assignRole(TEST_USER, RoleManagement.Role.HRManager);
        
        vm.expectEmit(true, false, false, true);
        emit RoleRevoked(TEST_USER);
        roleManagement.revokeRole(TEST_USER);
        
        assertEq(uint(roleManagement.checkRole(TEST_USER)), uint(RoleManagement.Role.None));
        vm.stopPrank();
    }

    function testRevokeRoleFail() public {
        vm.startPrank(ROOT_ADDRESS);
        vm.expectRevert("Cannot revoke Root role");
        roleManagement.revokeRole(ROOT_ADDRESS);
        vm.stopPrank();
    }

    function testCheckCallerRole() public {
        vm.startPrank(ROOT_ADDRESS);
        roleManagement.assignRole(TEST_USER, RoleManagement.Role.Employee);
        vm.stopPrank();

        vm.startPrank(TEST_USER);
        assertEq(uint(roleManagement.checkCallerRole()), uint(RoleManagement.Role.Employee));
        vm.stopPrank();
    }

    function testCannotAssignRootRole() public {
        vm.startPrank(ROOT_ADDRESS);
        vm.expectRevert("Cannot assign Root role");
        roleManagement.assignRole(TEST_USER, RoleManagement.Role.Root);
        vm.stopPrank();
    }

    function testCannotAssignNoneRole() public {
        vm.startPrank(ROOT_ADDRESS);
        vm.expectRevert("Cannot assign None role");
        roleManagement.assignRole(TEST_USER, RoleManagement.Role.None);
        vm.stopPrank();
    }

    function testInvalidAddress() public {
        vm.startPrank(ROOT_ADDRESS);
        vm.expectRevert("Invalid address");
        roleManagement.assignRole(address(0), RoleManagement.Role.Employee);
        vm.stopPrank();
    }
}
