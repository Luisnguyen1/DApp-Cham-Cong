// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./RoleManagement.sol";
import "./EmployeeManagement.sol";

contract AttendanceManagement {
    struct AttendanceRecord {
        uint256 checkInTime;
        uint256 checkOutTime;
        uint256 workingHours;
        bool isAbsent;
        string absenceReason;
        bool isAuthorized;
    }

    RoleManagement private roleManager;
    EmployeeManagement private empManager;
    
    // employee => date => record
    mapping(address => mapping(uint256 => AttendanceRecord)) private attendanceRecords;
    // employee => absence dates array
    mapping(address => uint256[]) private absenceDates;
    
    event CheckIn(address indexed employee, uint256 timestamp);
    event CheckOut(address indexed employee, uint256 timestamp);
    event AbsenceRecorded(address indexed employee, uint256 date, bool isAuthorized);
    event ManualAttendanceRecorded(address indexed employee, uint256 checkIn, uint256 checkOut);

    constructor(address _roleManagerAddress, address _empManagerAddress) {
        roleManager = RoleManagement(_roleManagerAddress);
        empManager = EmployeeManagement(_empManagerAddress);
    }

    modifier onlyEmployee() {
        require(
            roleManager.checkRole(msg.sender) == RoleManagement.Role.Employee,
            "Only employees can perform this action"
        );
        _;
    }

    modifier onlyHR() {
        require(
            roleManager.isRootOrHR(msg.sender),
            "Only HR Manager can perform this action"
        );
        _;
    }

    function checkIn(uint256 timestamp) external onlyEmployee {
        require(timestamp <= block.timestamp, "Invalid timestamp");
        uint256 date = timestamp / 86400 * 86400; // Normalize to start of day
        
        AttendanceRecord storage record = attendanceRecords[msg.sender][date];
        require(record.checkInTime == 0, "Already checked in");
        require(!record.isAbsent, "Marked as absent");

        record.checkInTime = timestamp;
        emit CheckIn(msg.sender, timestamp);
    }

    function checkOut(uint256 timestamp) external onlyEmployee {
        require(timestamp <= block.timestamp, "Invalid timestamp");
        uint256 date = timestamp / 86400 * 86400; // Normalize to start of day
        
        AttendanceRecord storage record = attendanceRecords[msg.sender][date];
        require(record.checkInTime > 0, "Must check in first");
        require(record.checkOutTime == 0, "Already checked out");
        require(timestamp > record.checkInTime, "Check out time must be after check in");

        record.checkOutTime = timestamp;
        record.workingHours = (timestamp - record.checkInTime) / 3600; // Convert to hours
        emit CheckOut(msg.sender, timestamp);
    }

    function recordAbsence(
        address employeeAddress,
        uint256 date,
        string memory reason,
        bool isAuthorized
    ) external onlyHR {
        require(date <= block.timestamp, "Invalid date");
        date = date / 86400 * 86400; // Normalize to start of day
        
        AttendanceRecord storage record = attendanceRecords[employeeAddress][date];
        require(record.checkInTime == 0, "Employee has checked in for this date");
        
        record.isAbsent = true;
        record.absenceReason = reason;
        record.isAuthorized = isAuthorized;
        absenceDates[employeeAddress].push(date);
        
        emit AbsenceRecorded(employeeAddress, date, isAuthorized);
    }

    function manualAttendance(
        address employeeAddress,
        uint256 checkInTime,
        uint256 checkOutTime
    ) external onlyHR {
        require(checkOutTime > checkInTime, "Invalid time range");
        uint256 date = checkInTime / 86400 * 86400;
        
        AttendanceRecord storage record = attendanceRecords[employeeAddress][date];
        require(!record.isAbsent, "Employee marked as absent");
        
        record.checkInTime = checkInTime;
        record.checkOutTime = checkOutTime;
        record.workingHours = (checkOutTime - checkInTime) / 3600;
        
        emit ManualAttendanceRecorded(employeeAddress, checkInTime, checkOutTime);
    }

    function calculateWorkingHours(address employeeAddress, uint256 date) 
        external 
        view 
        returns (uint256) 
    {
        date = date / 86400 * 86400;
        return attendanceRecords[employeeAddress][date].workingHours;
    }

    function getAttendanceRecord(address employeeAddress, uint256 date)
        external
        view
        returns (
            uint256 checkInTime,
            uint256 checkOutTime,
            uint256 workingHours,
            bool isAbsent,
            string memory absenceReason,
            bool isAuthorized
        )
    {
        date = date / 86400 * 86400;
        AttendanceRecord memory record = attendanceRecords[employeeAddress][date];
        return (
            record.checkInTime,
            record.checkOutTime,
            record.workingHours,
            record.isAbsent,
            record.absenceReason,
            record.isAuthorized
        );
    }

    function getAbsenceRecords(address employeeAddress)
        external
        view
        returns (
            uint256[] memory dates,
            string[] memory reasons,
            bool[] memory authorizations
        )
    {
        uint256[] memory absDates = absenceDates[employeeAddress];
        uint256 length = absDates.length;
        
        reasons = new string[](length);
        authorizations = new bool[](length);
        
        for (uint256 i = 0; i < length; i++) {
            AttendanceRecord memory record = attendanceRecords[employeeAddress][absDates[i]];
            reasons[i] = record.absenceReason;
            authorizations[i] = record.isAuthorized;
        }
        
        return (absDates, reasons, authorizations);
    }
}
