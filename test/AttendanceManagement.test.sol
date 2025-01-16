// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/AttendanceManagement.sol";
import "../src/EmployeeManagement.sol";
import "../src/RoleManagement.sol";

contract AttendanceManagementTest is Test {
    AttendanceManagement private attManagement;
    EmployeeManagement private empManagement;
    RoleManagement private roleManagement;
    
    address private root = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address private hrManager = address(2);
    address private employee1 = address(3);
    
    function setUp() public {
        vm.startPrank(root);
        
        roleManagement = new RoleManagement();
        empManagement = new EmployeeManagement(address(roleManagement));
        attManagement = new AttendanceManagement(
            address(roleManagement),
            address(empManagement)
        );
        
        roleManagement.assignRole(hrManager, RoleManagement.Role.HRManager);
        vm.stopPrank();
        
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
        vm.stopPrank();
    }

    function testCheckInCheckOut() public {
        uint256 checkInTime = block.timestamp;
        uint256 checkOutTime = checkInTime + 8 hours;
        
        vm.startPrank(employee1);
        
        attManagement.checkIn(checkInTime);
        vm.warp(checkOutTime);
        attManagement.checkOut(checkOutTime);
        
        (
            uint256 recordedCheckIn,
            uint256 recordedCheckOut,
            uint256 workingHours,
            ,
            ,
            
        ) = attManagement.getAttendanceRecord(employee1, checkInTime);
        
        assertEq(recordedCheckIn, checkInTime);
        assertEq(recordedCheckOut, checkOutTime);
        assertEq(workingHours, 8);
        
        vm.stopPrank();
    }

    function testRecordAbsence() public {
        vm.startPrank(hrManager);
        
        attManagement.recordAbsence(
            employee1,
            block.timestamp,
            "Sick leave",
            true
        );
        
        (
            ,
            ,
            ,
            bool isAbsent,
            string memory reason,
            bool isAuthorized
        ) = attManagement.getAttendanceRecord(employee1, block.timestamp);
        
        assertTrue(isAbsent);
        assertEq(reason, "Sick leave");
        assertTrue(isAuthorized);
        
        vm.stopPrank();
    }
}
