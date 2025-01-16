// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./RoleManagement.sol";

contract EmployeeManagement {
    struct Employee {
        string name;
        string department;
        uint256 salary;
        uint256 joiningDate;
        uint256 remainingLeaveDays;
        bool isActive;
    }

    RoleManagement private roleManager;
    mapping(string => bool) private refcodes;
    mapping(string => bool) private usedRefcodes;
    mapping(address => Employee) private employees;
    address[] private employeeList;
    uint256 private nonce = 0;

    event RefCodeCreated(string refcode);
    event EmployeeAdded(address indexed employeeAddress, string name);
    event EmployeeUpdated(address indexed employeeAddress);
    event EmployeeRemoved(address indexed employeeAddress);

    constructor(address _roleManagerAddress) {
        roleManager = RoleManagement(_roleManagerAddress);
    }

    modifier onlyRoot() {
        require(roleManager.isRoot(msg.sender), "Only Root can perform this action");
        _;
    }

    modifier onlyRootOrHR() {
        require(
            roleManager.isRootOrHR(msg.sender),
            "Only Root or HR Manager can perform this action"
        );
        _;
    }

    function createRefCode() external onlyRootOrHR returns (string memory) {
        nonce++;
        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    msg.sender,
                    nonce
                )
            )
        ) % 1000000; // 6 chữ số

        // Chuyển số thành string và thêm các số 0 phía trước nếu cần
        string memory refcode = _uintToString(randomNumber);
        while (bytes(refcode).length < 6) {
            refcode = string(abi.encodePacked("0", refcode));
        }

        require(!refcodes[refcode], "Refcode already exists. Try again.");
        refcodes[refcode] = true;
        emit RefCodeCreated(refcode);
        return refcode;
    }

    function _uintToString(uint256 value) private pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function addEmployee(
        string memory refcode,
        address employeeAddress,
        string memory name,
        string memory department,
        uint256 salary,
        uint256 joiningDate
    ) external onlyRootOrHR {  
        require(refcodes[refcode] && !usedRefcodes[refcode], "Invalid or used refcode");
        require(!employees[employeeAddress].isActive, "Employee already exists");
        require(employeeAddress != address(0), "Invalid address");

        employees[employeeAddress] = Employee({
            name: name,
            department: department,
            salary: salary,
            joiningDate: joiningDate,
            remainingLeaveDays: 12, // Default annual leave days
            isActive: true
        });

        employeeList.push(employeeAddress);
        usedRefcodes[refcode] = true;
        
        // roleManager.assignRole(employeeAddress, RoleManagement.Role.Employee);
        
        emit EmployeeAdded(employeeAddress, name);
    }

    function updateEmployeeInfo(
        address employeeAddress,
        string memory name,
        string memory department,
        uint256 salary
    ) external onlyRootOrHR {
        require(employees[employeeAddress].isActive, "Employee does not exist");

        Employee storage employee = employees[employeeAddress];
        employee.name = name;
        employee.department = department;
        employee.salary = salary;

        emit EmployeeUpdated(employeeAddress);
    }

    function removeEmployee(address employeeAddress) external onlyRootOrHR {
        require(employees[employeeAddress].isActive, "Employee does not exist");
        
        employees[employeeAddress].isActive = false;
        // roleManager.revokeRole(employeeAddress);
        
        emit EmployeeRemoved(employeeAddress);
    }

    function getEmployeeInfo(address employeeAddress) external view 
        returns (
            string memory name,
            string memory department,
            uint256 salary,
            uint256 joiningDate,
            uint256 remainingLeaveDays
        )
    {
        require(employees[employeeAddress].isActive, "Employee does not exist");
        Employee memory employee = employees[employeeAddress];
        
        return (
            employee.name,
            employee.department,
            employee.salary,
            employee.joiningDate,
            employee.remainingLeaveDays
        );
    }

    function isValidRefcode(string memory refcode) external view returns (bool) {
        return refcodes[refcode] && !usedRefcodes[refcode];
    }

    function getAllEmployees() external view returns (address[] memory) {
        return employeeList;
    }
}
