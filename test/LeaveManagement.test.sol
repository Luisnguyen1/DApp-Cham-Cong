// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../src/LeaveManagement.sol";
import "../src/RoleManagement.sol";
import "../src/EmployeeManagement.sol";
import "forge-std/Test.sol";

contract LeaveManagementTest is Test {
    RoleManagement roleManager;
    EmployeeManagement empManager;
    LeaveManagement leaveManager;

    address constant ROOT = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address constant HR = address(1);
    address constant EMPLOYEE = address(2);
    
    function setUp() public {
        // Deploy with ROOT account
        vm.startPrank(ROOT);
        
        roleManager = new RoleManagement();
        empManager = new EmployeeManagement(address(roleManager));
        leaveManager = new LeaveManagement(address(roleManager), address(empManager));
        
        // Setup HR
        roleManager.assignRole(HR, RoleManagement.Role.HRManager);
        
        // Create refcode and add employee
        vm.stopPrank();
        
        vm.startPrank(HR);
        string memory refcode = empManager.createRefCode();
        empManager.addEmployee(
            refcode,
            EMPLOYEE,
            "John Doe",
            "Engineering",
            5000,
            block.timestamp
        );
        roleManager.assignRole(EMPLOYEE, RoleManagement.Role.Employee);
        vm.stopPrank();
    }

    function testRequestLeave() public {
        vm.startPrank(EMPLOYEE);
        
        uint256 startDate = block.timestamp + 1 days;
        uint256 endDate = block.timestamp + 3 days;
        
        uint256 leaveId = leaveManager.requestLeave(
            startDate,
            endDate,
            "Annual vacation"
        );
        
        (
            address employeeAddress,
            uint256 reqStartDate,
            uint256 reqEndDate,
            string memory reason,
            LeaveManagement.LeaveStatus status,
            string memory rejectionReason
        ) = leaveManager.getLeaveRequest(leaveId);
        
        assertEq(employeeAddress, EMPLOYEE);
        assertEq(reqStartDate, startDate);
        assertEq(reqEndDate, endDate);
        assertEq(reason, "Annual vacation");
        assertEq(uint(status), uint(LeaveManagement.LeaveStatus.Pending));
        assertEq(rejectionReason, "");
        
        vm.stopPrank();
    }

    function testApproveLeave() public {
        // First create a leave request
        vm.startPrank(EMPLOYEE);
        uint256 leaveId = leaveManager.requestLeave(
            block.timestamp + 1 days,
            block.timestamp + 3 days,
            "Annual vacation"
        );
        vm.stopPrank();
        
        // HR approves the leave
        vm.startPrank(HR);
        leaveManager.approveLeave(leaveId);
        
        (, , , , LeaveManagement.LeaveStatus status, ) = leaveManager.getLeaveRequest(leaveId);
        assertEq(uint(status), uint(LeaveManagement.LeaveStatus.Approved));
        
        vm.stopPrank();
    }

    function testRejectLeave() public {
        // First create a leave request
        vm.startPrank(EMPLOYEE);
        uint256 leaveId = leaveManager.requestLeave(
            block.timestamp + 1 days,
            block.timestamp + 3 days,
            "Annual vacation"
        );
        vm.stopPrank();
        
        // HR rejects the leave
        vm.startPrank(HR);
        leaveManager.rejectLeave(leaveId, "Not enough team coverage");
        
        (, , , , LeaveManagement.LeaveStatus status, string memory reason) = 
            leaveManager.getLeaveRequest(leaveId);
            
        assertEq(uint(status), uint(LeaveManagement.LeaveStatus.Rejected));
        assertEq(reason, "Not enough team coverage");
        
        vm.stopPrank();
    }

    function testGetLeaveRequestsByEmployee() public {
        // Create multiple leave requests
        vm.startPrank(EMPLOYEE);
        
        leaveManager.requestLeave(
            block.timestamp + 1 days,
            block.timestamp + 3 days,
            "Vacation 1"
        );
        
        leaveManager.requestLeave(
            block.timestamp + 10 days,
            block.timestamp + 12 days,
            "Vacation 2"
        );
        
        (
            uint256[] memory leaveIds,
            // uint256[] memory startDates,
            // uint256[] memory endDates,
            ,
            ,
            string[] memory reasons,
            LeaveManagement.LeaveStatus[] memory statuses
        ) = leaveManager.getLeaveRequestsByEmployee(EMPLOYEE);
        
        assertEq(leaveIds.length, 2);
        assertEq(reasons[0], "Vacation 1");
        assertEq(reasons[1], "Vacation 2");
        assertEq(uint(statuses[0]), uint(LeaveManagement.LeaveStatus.Pending));
        assertEq(uint(statuses[1]), uint(LeaveManagement.LeaveStatus.Pending));
        
        vm.stopPrank();
    }

    // Thay thế testFailRequestLeaveInvalidDates
    function test_RevertWhen_RequestLeaveInvalidDates() public {
        vm.startPrank(EMPLOYEE);
        
        // Vì startDate < endDate sẽ gây ra arithmetic underflow
        vm.expectRevert(stdError.arithmeticError);
        leaveManager.requestLeave(
            block.timestamp - 1 days,
            block.timestamp + 1 days,
            "Invalid request"
        );
        
        vm.stopPrank();
    }

    // Thay thế testFailUnauthorizedApproval
    function test_RevertWhen_UnauthorizedApproval() public {
        // First create a leave request as employee
        vm.startPrank(EMPLOYEE);
        uint256 leaveId = leaveManager.requestLeave(
            block.timestamp + 1 days,
            block.timestamp + 3 days,
            "Vacation"
        );
        vm.stopPrank();
        
        // Try to approve as another employee (not HR)
        address anotherEmployee = address(3);
        vm.startPrank(anotherEmployee);
        
        vm.expectRevert("Only HR Manager can perform this action");
        leaveManager.approveLeave(leaveId);
        
        vm.stopPrank();
    }
}
