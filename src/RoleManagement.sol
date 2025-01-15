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

    function assignRole(address user, Role role) external onlyRoot {
        require(user != address(0), "Invalid address");
        require(role != Role.Root, "Cannot assign Root role");
        require(role != Role.None, "Cannot assign None role");
        roles[user] = role;
        emit RoleAssigned(user, role);
    }

    function checkRole(address user) external view returns (Role) {
        return roles[user];
    }

    function revokeRole(address user) external onlyRoot {
        require(user != ROOT_ADDRESS, "Cannot revoke Root role");
        require(roles[user] != Role.None, "Role already None");
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
}
