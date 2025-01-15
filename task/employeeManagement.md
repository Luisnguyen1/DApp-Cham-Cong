Mô tả chi tiết về **input** và **output** của từng hàm trong **EmployeeManagement Contract**:

---

## 1. **Hàm tạo refcode (`createRefCode`)**
- **Mục đích**: Tạo một mã giới thiệu (refcode) duy nhất để sử dụng trong quy trình onboarding nhân viên mới.
- **Input**:
  - `string refcode`: Mã giới thiệu cần tạo.
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ có địa chỉ Root mới có thể gọi hàm này.

---

## 2. **Hàm thêm nhân viên mới (`addEmployee`)**
- **Mục đích**: Thêm một nhân viên mới vào hệ thống thông qua mã giới thiệu (refcode).
- **Input**:
  - `string refcode`: Mã giới thiệu đã được tạo bởi Root.
  - `address employeeAddress`: Địa chỉ ví của nhân viên mới.
  - `string name`: Tên của nhân viên.
  - `string department`: Phòng ban của nhân viên.
  - `uint256 salary`: Lương cơ bản của nhân viên.
  - `uint256 joiningDate`: Ngày vào công ty của nhân viên (timestamp).
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Mã giới thiệu phải hợp lệ và chưa được sử dụng trước đó.

---

## 3. **Hàm cập nhật thông tin nhân viên (`updateEmployeeInfo`)**
- **Mục đích**: Cập nhật thông tin của một nhân viên hiện có (ví dụ: lương, phòng ban).
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần cập nhật.
  - `string name`: Tên mới của nhân viên (nếu cần thay đổi).
  - `string department`: Phòng ban mới của nhân viên (nếu cần thay đổi).
  - `uint256 salary`: Lương mới của nhân viên (nếu cần thay đổi).
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ có Root hoặc HR Manager mới có thể gọi hàm này.

---

## 4. **Hàm xóa nhân viên (`removeEmployee`)**
- **Mục đích**: Xóa một nhân viên khỏi hệ thống khi họ nghỉ việc.
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần xóa.
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ có Root hoặc HR Manager mới có thể gọi hàm này.

---

## 5. **Hàm lấy thông tin nhân viên (`getEmployeeInfo`)**
- **Mục đích**: Truy vấn thông tin chi tiết của một nhân viên.
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần truy vấn.
- **Output**:
  - `string name`: Tên của nhân viên.
  - `string department`: Phòng ban của nhân viên.
  - `uint256 salary`: Lương cơ bản của nhân viên.
  - `uint256 joiningDate`: Ngày vào công ty của nhân viên (timestamp).
  - `uint256 remainingLeaveDays`: Số ngày phép còn lại của nhân viên.
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

## 6. **Hàm kiểm tra mã giới thiệu (`isValidRefcode`)**
- **Mục đích**: Kiểm tra xem một mã giới thiệu có hợp lệ và chưa được sử dụng hay không.
- **Input**:
  - `string refcode`: Mã giới thiệu cần kiểm tra.
- **Output**:
  - `bool`: Trả về `true` nếu mã giới thiệu hợp lệ và chưa được sử dụng, ngược lại trả về `false`.
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

### Tổng kết
Các hàm trong **EmployeeManagement Contract** được thiết kế để quản lý thông tin nhân viên và quy trình onboarding một cách hiệu quả. Dưới đây là bảng tóm tắt:

| Tên hàm                  | Input                                                                 | Output                     | Mục đích                                   |
|--------------------------|-----------------------------------------------------------------------|----------------------------|--------------------------------------------|
| `createRefCode`          | `string refcode`                                                     | Không có                   | Tạo mã giới thiệu duy nhất.                |
| `addEmployee`            | `string refcode`, `address employeeAddress`, `string name`, `string department`, `uint256 salary`, `uint256 joiningDate` | Không có                   | Thêm nhân viên mới vào hệ thống.           |
| `updateEmployeeInfo`     | `address employeeAddress`, `string name`, `string department`, `uint256 salary` | Không có                   | Cập nhật thông tin nhân viên.              |
| `removeEmployee`         | `address employeeAddress`                                            | Không có                   | Xóa nhân viên khỏi hệ thống.               |
| `getEmployeeInfo`        | `address employeeAddress`                                            | `string name`, `string department`, `uint256 salary`, `uint256 joiningDate`, `uint256 remainingLeaveDays` | Truy vấn thông tin nhân viên.              |
| `isValidRefcode`         | `string refcode`                                                     | `bool`                     | Kiểm tra tính hợp lệ của mã giới thiệu.    |

Các hàm này đảm bảo hệ thống quản lý nhân viên hoạt động chính xác và an toàn, đồng thời cung cấp khả năng truy vấn và cập nhật thông tin một cách dễ dàng.