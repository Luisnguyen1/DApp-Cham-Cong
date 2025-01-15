// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract RoleManagement {
    enum Role {
        None,
        Employee,
        Accountant,
        HRManager,
        Root
    }

    address private constant ROOT_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    mapping(address => Role) private roles;

    event RoleAssigned(address indexed user, Role role);
    event RoleRevoked(address indexed user);

    constructor() {
        require(msg.sender == ROOT_ADDRESS, "Only predefined Root can deploy");
        roles[ROOT_ADDRESS] = Role.Root;
    }   

    modifier onlyRoot() {
        require(msg.sender == ROOT_ADDRESS, "Only Root can perform this action");
        _; 
    }

    // Thêm hàm kiểm tra root hoặc HR
    function isRootOrHR(address user) external view returns (bool) {
        return user == ROOT_ADDRESS || roles[user] == Role.HRManager;
    }


    modifier onlyRootOrHR() {
        require(
            msg.sender == ROOT_ADDRESS || roles[msg.sender] == Role.HRManager,
            "Only Root or HR Manager can perform this action"
        );
        _;
    }

    function assignRole(address user, Role role) external onlyRootOrHR {
        require(user != address(0), "Invalid address");
        require(role != Role.Root, "Cannot assign Root role");
        require(role != Role.None, "Cannot assign None role");
        
        if (roles[msg.sender] == Role.HRManager) {
            // HR Manager chỉ có thể gán role Employee hoặc Accountant
            require(
                role == Role.Employee || role == Role.Accountant,
                "HR Manager can only assign Employee or Accountant roles"
            );
        }
        
        roles[user] = role;
        emit RoleAssigned(user, role);
    }

    function checkRole(address user) external view returns (Role) {
        // Trả về Role.Root nếu là ROOT_ADDRESS
        if (user == ROOT_ADDRESS) {
            return Role.Root;
        }
        return roles[user];
    }

    function revokeRole(address user) external onlyRootOrHR {
        require(user != ROOT_ADDRESS, "Cannot revoke Root role");
        require(roles[user] != Role.None, "Role already None");
        
        if (roles[msg.sender] == Role.HRManager) {
            // HR Manager chỉ có thể thu hồi role Employee hoặc Accountant
            require(
                roles[user] == Role.Employee || roles[user] == Role.Accountant,
                "HR Manager can only revoke Employee or Accountant roles"
            );
        }
        
        roles[user] = Role.None;
        emit RoleRevoked(user);
    }

    function isRoot(address user) external pure returns (bool) {
        return user == ROOT_ADDRESS;
    }

    function getRootAddress() external pure returns (address) {
        return ROOT_ADDRESS;
    }

    function checkCallerRole() external view returns (Role) {
        return roles[msg.sender];
    }

    // Thêm hàm mới để kiểm tra HR Manager
    function isHRManager(address user) external view returns (bool) {
        return roles[user] == Role.HRManager;
    }

}
