## How to run
```
forge test
```
## Test Failures Report (January 15, 2024)

### Issue Description

During test execution (`forge test`), the following failures were encountered:

```shell
[FAIL: revert: Only Root or HR Manager can perform this action] testAddEmployee() (gas: 282810)
[FAIL: revert: Only Root or HR Manager can perform this action] testGetAllEmployees() (gas: 310742)
[FAIL: revert: Only Root or HR Manager can perform this action] testRemoveEmployee() (gas: 279592)
[FAIL: revert: Only Root or HR Manager can perform this action] testUpdateEmployee() (gas: 279572)
```

### Root Cause

Lỗi gặp phải vì modifier onlyRootOrHR trong RoleManagement.sol constract gặp vấn đề và em chưa thể tìm ra nguyên nhân cụ thể mặc dụ đã set up trong file test đầy đủ. 
