// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/EmployeeManagement.sol";
import "../src/RoleManagement.sol";

contract EmployeeManagementTest is Test {
    EmployeeManagement private empManagement;
    RoleManagement private roleManagement;
    
    address private root = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address private hrManager = address(2);
    address private employee1 = address(3);
    address private employee2 = address(4);

    function setUp() public {
        // Deploy as root
        vm.startPrank(root);
        
        // Deploy contracts
        roleManagement = new RoleManagement();
        empManagement = new EmployeeManagement(address(roleManagement));
        
        // Assign HR role
        roleManagement.assignRole(hrManager, RoleManagement.Role.HRManager);
        
        vm.stopPrank();
        
        // Verify role assignments
        assertEq(uint(roleManagement.checkRole(root)), uint(RoleManagement.Role.Root));
        assertEq(uint(roleManagement.checkRole(hrManager)), uint(RoleManagement.Role.HRManager));
        assertTrue(roleManagement.isRootOrHR(hrManager));
    }

    function testRoleAssignment() public view {
        assertEq(uint(roleManagement.checkRole(hrManager)), uint(RoleManagement.Role.HRManager));
    }

    // Thêm test case mới để kiểm tra role
    function testInitialRoles() public view {
        assertTrue(roleManagement.isRoot(root), "Root should be set");
        assertEq(
            uint(roleManagement.checkRole(hrManager)),
            uint(RoleManagement.Role.HRManager),
            "HR Manager should be set"
        );
    }

    // Helper function để kiểm tra refcode và tạo employee
    function _createAndVerifyEmployee(
        address employeeAddr,
        string memory name,
        string memory dept,
        uint256 salary
    ) internal returns (string memory) {
        string memory refcode = empManagement.createRefCode();
        assertTrue(empManagement.isValidRefcode(refcode), "Refcode should be valid");
        
        empManagement.addEmployee(
            refcode,
            employeeAddr,
            name,
            dept,
            salary,
            block.timestamp
        );

        (
            string memory empName,
            string memory empDept,
            uint256 empSalary,
            ,
            
        ) = empManagement.getEmployeeInfo(employeeAddr);

        assertEq(empName, name);
        assertEq(empDept, dept);
        assertEq(empSalary, salary);
        
        return refcode;
    }

    function testRefCodeCreation() public {
        vm.startPrank(hrManager);
        string memory refcode = empManagement.createRefCode();
        assertTrue(empManagement.isValidRefcode(refcode));
        vm.stopPrank();
    }

    function testRefCodeUniqueness() public {
        vm.startPrank(hrManager);
        string memory refcode1 = empManagement.createRefCode();
        string memory refcode2 = empManagement.createRefCode();
        assertFalse(keccak256(abi.encodePacked(refcode1)) == keccak256(abi.encodePacked(refcode2)));
        vm.stopPrank();
    }

    // Sửa lại các test case hiện có
    function testAddEmployee() public {
        vm.startPrank(hrManager);
        string memory refcode = empManagement.createRefCode();
        roleManagement.assignRole(employee1, RoleManagement.Role.Employee);
        require(roleManagement.isHRManager(hrManager), "HR Manager role not set properly");
        empManagement.addEmployee(
            refcode,
            employee1,
            "John Doe",
            "Engineering",
            5000,
            block.timestamp
        );

        (string memory name,,,,) = empManagement.getEmployeeInfo(employee1);
        assertEq(name, "John Doe");
        vm.stopPrank();
    }

    function testUpdateEmployee() public {

        
        vm.startPrank(hrManager);
        string memory refcode = empManagement.createRefCode();
        
        empManagement.addEmployee(
            refcode,
            employee1,
            "John Doe",
            "Engineering",
            5000,
            block.timestamp
        );

        empManagement.updateEmployeeInfo(
            employee1,
            "John Updated",
            "Marketing",
            6000
        );

        (string memory name,,,, ) = empManagement.getEmployeeInfo(employee1);
        assertEq(name, "John Updated");
        vm.stopPrank();
    }

    function testRemoveEmployee() public {
        vm.startPrank(hrManager);
        string memory refcode = empManagement.createRefCode();
        roleManagement.assignRole(employee1, RoleManagement.Role.Employee);
        empManagement.addEmployee(
            refcode,
            employee1,
            "John Doe",
            "Engineering",
            5000,
            block.timestamp
        );

        empManagement.removeEmployee(employee1);
        roleManagement.revokeRole(employee1);
        
        vm.expectRevert("Employee does not exist");
        empManagement.getEmployeeInfo(employee1);
        vm.stopPrank();
    }

    function testUnauthorizedAccess() public {
        vm.startPrank(employee1);
        
        vm.expectRevert("Only Root or HR Manager can perform this action");
        empManagement.createRefCode();

        vm.expectRevert("Only Root or HR Manager can perform this action");
        empManagement.addEmployee(
            "123456",
            employee2,
            "Jane Doe",
            "Finance",
            4000,
            block.timestamp
        );
        vm.stopPrank();
    }

    function testInvalidRefcode() public {
        vm.startPrank(hrManager);
        vm.expectRevert("Invalid or used refcode");
        empManagement.addEmployee(
            "invalid",
            employee1,
            "John Doe",
            "Engineering",
            5000,
            block.timestamp
        );
        vm.stopPrank();
    }

    function testGetAllEmployees() public {

        
        vm.startPrank(hrManager);
        string memory refcode1 = empManagement.createRefCode();
        string memory refcode2 = empManagement.createRefCode();
        
        empManagement.addEmployee(
            refcode1,
            employee1,
            "John Doe",
            "Engineering",
            5000,
            block.timestamp
        );

        empManagement.addEmployee(
            refcode2,
            employee2,
            "Jane Doe",
            "Finance",
            4000,
            block.timestamp
        );

        address[] memory employees = empManagement.getAllEmployees();
        assertEq(employees.length, 2);
        vm.stopPrank();
    }

    // Add debug test
    function testPermissions() public view {
        assertTrue(roleManagement.isRoot(root), "Root should be recognized");
        assertTrue(roleManagement.isHRManager(hrManager), "HR should be recognized");
        assertTrue(roleManagement.isRootOrHR(hrManager), "HR should have correct permissions");
    }
}
