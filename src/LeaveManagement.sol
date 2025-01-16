// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./RoleManagement.sol";
import "./EmployeeManagement.sol";

contract LeaveManagement {
    struct LeaveRequest {
        address employeeAddress;
        uint256 startDate;
        uint256 endDate;
        string reason;
        LeaveStatus status;
        string rejectionReason;
        uint256 requestTime;
    }

    enum LeaveStatus {
        Pending,
        Approved,
        Rejected
    }

    RoleManagement private roleManager;
    EmployeeManagement private empManager;
    
    uint256 private leaveRequestCount;
    mapping(uint256 => LeaveRequest) private leaveRequests;
    mapping(address => uint256[]) private employeeLeaveRequests;
    
    event LeaveRequested(uint256 indexed leaveId, address indexed employee);
    event LeaveApproved(uint256 indexed leaveId);
    event LeaveRejected(uint256 indexed leaveId, string reason);
    event LeaveBalanceUpdated(address indexed employee, uint256 remainingDays);

    constructor(address _roleManagerAddress, address _empManagerAddress) {
        roleManager = RoleManagement(_roleManagerAddress);
        empManager = EmployeeManagement(_empManagerAddress);
        leaveRequestCount = 0;
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

    function requestLeave(
        uint256 startDate,
        uint256 endDate,
        string memory reason
    ) external onlyEmployee returns (uint256) {
        require(startDate >= block.timestamp, "Invalid start date");
        require(endDate >= startDate, "End date must be after start date");
        
        uint256 leaveDays = (endDate - startDate) / 1 days + 1;
        (, , , , uint256 remainingLeaveDays) = empManager.getEmployeeInfo(msg.sender);
        require(remainingLeaveDays >= leaveDays, "Insufficient leave balance");

        uint256 leaveId = ++leaveRequestCount;
        LeaveRequest storage newRequest = leaveRequests[leaveId];
        newRequest.employeeAddress = msg.sender;
        newRequest.startDate = startDate;
        newRequest.endDate = endDate;
        newRequest.reason = reason;
        newRequest.status = LeaveStatus.Pending;
        newRequest.requestTime = block.timestamp;

        employeeLeaveRequests[msg.sender].push(leaveId);
        
        emit LeaveRequested(leaveId, msg.sender);
        return leaveId;
    }

    function approveLeave(uint256 leaveId) external onlyHR {
        LeaveRequest storage request = leaveRequests[leaveId];
        require(request.status == LeaveStatus.Pending, "Request not pending");
        
        request.status = LeaveStatus.Approved;
        uint256 leaveDays = (request.endDate - request.startDate) / 1 days + 1;
        
        // Update leave balance
        updateLeaveBalance(request.employeeAddress, leaveDays);
        
        emit LeaveApproved(leaveId);
    }

    function rejectLeave(uint256 leaveId, string memory rejectionReason) external onlyHR {
        LeaveRequest storage request = leaveRequests[leaveId];
        require(request.status == LeaveStatus.Pending, "Request not pending");
        
        request.status = LeaveStatus.Rejected;
        request.rejectionReason = rejectionReason;
        
        emit LeaveRejected(leaveId, rejectionReason);
    }

    function updateLeaveBalance(address employeeAddress, uint256 daysUsed) internal {
        (, , , , uint256 remainingLeaveDays) = empManager.getEmployeeInfo(employeeAddress);
        require(remainingLeaveDays >= daysUsed, "Insufficient leave balance");
        
        // Note: This will revert if empManager doesn't have a method to update leave balance
        // You may need to add this functionality to EmployeeManagement contract
        
        emit LeaveBalanceUpdated(employeeAddress, remainingLeaveDays - daysUsed);
    }

    function getLeaveRequest(uint256 leaveId) external view returns (
        address employeeAddress,
        uint256 startDate,
        uint256 endDate,
        string memory reason,
        LeaveStatus status,
        string memory rejectionReason
    ) {
        LeaveRequest memory request = leaveRequests[leaveId];
        return (
            request.employeeAddress,
            request.startDate,
            request.endDate,
            request.reason,
            request.status,
            request.rejectionReason
        );
    }

    function getLeaveRequestsByEmployee(address employeeAddress) external view returns (
        uint256[] memory leaveIds,
        uint256[] memory startDates,
        uint256[] memory endDates,
        string[] memory reasons,
        LeaveStatus[] memory statuses
    ) {
        uint256[] memory empLeaveIds = employeeLeaveRequests[employeeAddress];
        uint256 length = empLeaveIds.length;
        
        startDates = new uint256[](length);
        endDates = new uint256[](length);
        reasons = new string[](length);
        statuses = new LeaveStatus[](length);
        
        for (uint256 i = 0; i < length; i++) {
            LeaveRequest memory request = leaveRequests[empLeaveIds[i]];
            startDates[i] = request.startDate;
            endDates[i] = request.endDate;
            reasons[i] = request.reason;
            statuses[i] = request.status;
        }
        
        return (empLeaveIds, startDates, endDates, reasons, statuses);
    }
}
