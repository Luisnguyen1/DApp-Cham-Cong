Mô tả chi tiết về **input** và **output** của từng hàm trong **LeaveManagement Contract** :

---

## 1. **Hàm gửi yêu cầu nghỉ phép (`requestLeave`)**
- **Mục đích**: Cho phép nhân viên gửi yêu cầu nghỉ phép.
- **Input**:
  - `uint256 startDate`: Ngày bắt đầu nghỉ phép (timestamp).
  - `uint256 endDate`: Ngày kết thúc nghỉ phép (timestamp).
  - `string reason`: Lý do nghỉ phép.
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ nhân viên (Employee) mới có thể gọi hàm này.

---

## 2. **Hàm duyệt yêu cầu nghỉ phép (`approveLeave`)**
- **Mục đích**: Duyệt yêu cầu nghỉ phép của nhân viên.
- **Input**:
  - `uint256 leaveId`: ID của yêu cầu nghỉ phép cần duyệt.
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ HR Manager hoặc HR Staff mới có thể gọi hàm này.

---

## 3. **Hàm từ chối yêu cầu nghỉ phép (`rejectLeave`)**
- **Mục đích**: Từ chối yêu cầu nghỉ phép của nhân viên.
- **Input**:
  - `uint256 leaveId`: ID của yêu cầu nghỉ phép cần từ chối.
  - `string rejectionReason`: Lý do từ chối.
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ HR Manager hoặc HR Staff mới có thể gọi hàm này.

---

## 4. **Hàm cập nhật số ngày phép còn lại (`updateLeaveBalance`)**
- **Mục đích**: Cập nhật số ngày phép còn lại của nhân viên sau khi yêu cầu nghỉ phép được duyệt.
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần cập nhật.
  - `uint256 daysUsed`: Số ngày phép đã sử dụng.
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Hàm này thường được gọi tự động sau khi yêu cầu nghỉ phép được duyệt.

---

## 5. **Hàm lấy thông tin yêu cầu nghỉ phép (`getLeaveRequest`)**
- **Mục đích**: Truy vấn thông tin chi tiết của một yêu cầu nghỉ phép.
- **Input**:
  - `uint256 leaveId`: ID của yêu cầu nghỉ phép cần truy vấn.
- **Output**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên gửi yêu cầu.
  - `uint256 startDate`: Ngày bắt đầu nghỉ phép (timestamp).
  - `uint256 endDate`: Ngày kết thúc nghỉ phép (timestamp).
  - `string reason`: Lý do nghỉ phép.
  - `string status`: Trạng thái yêu cầu (ví dụ: "Pending", "Approved", "Rejected").
  - `string rejectionReason`: Lý do từ chối (nếu có).
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

## 6. **Hàm lấy danh sách yêu cầu nghỉ phép (`getLeaveRequestsByEmployee`)**
- **Mục đích**: Truy vấn danh sách các yêu cầu nghỉ phép của một nhân viên.
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần truy vấn.
- **Output**:
  - `uint256[] leaveIds`: Danh sách ID của các yêu cầu nghỉ phép.
  - `uint256[] startDates`: Danh sách ngày bắt đầu nghỉ phép.
  - `uint256[] endDates`: Danh sách ngày kết thúc nghỉ phép.
  - `string[] reasons`: Danh sách lý do nghỉ phép.
  - `string[] statuses`: Danh sách trạng thái yêu cầu.
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

### Tổng kết
Các hàm trong **LeaveManagement Contract** được thiết kế để quản lý yêu cầu nghỉ phép và quy trình duyệt/từ chối một cách hiệu quả. Dưới đây là bảng tóm tắt:

| Tên hàm                  | Input                                                                 | Output                     | Mục đích                                   |
|--------------------------|-----------------------------------------------------------------------|----------------------------|--------------------------------------------|
| `requestLeave`           | `uint256 startDate`, `uint256 endDate`, `string reason`               | Không có                   | Gửi yêu cầu nghỉ phép.                    |
| `approveLeave`           | `uint256 leaveId`                                                    | Không có                   | Duyệt yêu cầu nghỉ phép.                  |
| `rejectLeave`            | `uint256 leaveId`, `string rejectionReason`                          | Không có                   | Từ chối yêu cầu nghỉ phép.                |
| `updateLeaveBalance`     | `address employeeAddress`, `uint256 daysUsed`                        | Không có                   | Cập nhật số ngày phép còn lại.            |
| `getLeaveRequest`        | `uint256 leaveId`                                                    | `address employeeAddress`, `uint256 startDate`, `uint256 endDate`, `string reason`, `string status`, `string rejectionReason` | Truy vấn thông tin yêu cầu nghỉ phép.     |
| `getLeaveRequestsByEmployee` | `address employeeAddress`                                         | `uint256[] leaveIds`, `uint256[] startDates`, `uint256[] endDates`, `string[] reasons`, `string[] statuses` | Truy vấn danh sách yêu cầu nghỉ phép của nhân viên. |
