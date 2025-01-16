Mô tả chi tiết về **input** và **output** của từng hàm trong **AttendanceManagement Contract** mà không bao gồm code:

---

## 1. **Hàm check-in (`checkIn`)**
- **Mục đích**: Ghi nhận thời gian check-in của nhân viên.
- **Input**:
  - `uint256 timestamp`: Thời gian check-in (timestamp).
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ nhân viên (Employee) mới có thể gọi hàm này.

---

## 2. **Hàm check-out (`checkOut`)**
- **Mục đích**: Ghi nhận thời gian check-out của nhân viên.
- **Input**:
  - `uint256 timestamp`: Thời gian check-out (timestamp).
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ nhân viên (Employee) mới có thể gọi hàm này.

---

## 3. **Hàm ghi nhận vắng mặt (`recordAbsence`)**
- **Mục đích**: Ghi nhận việc vắng mặt của nhân viên (có phép hoặc không phép).
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên vắng mặt.
  - `uint256 date`: Ngày vắng mặt (timestamp).
  - `string reason`: Lý do vắng mặt.
  - `bool isAuthorized`: Trạng thái vắng mặt (có phép hoặc không phép).
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ HR Manager hoặc HR Staff mới có thể gọi hàm này.

---

## 4. **Hàm hỗ trợ chấm công thủ công (`manualAttendance`)**
- **Mục đích**: Hỗ trợ chấm công thủ công cho các trường hợp đặc biệt (ví dụ: quên check-in/check-out).
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần chấm công thủ công.
  - `uint256 checkInTime`: Thời gian check-in (timestamp).
  - `uint256 checkOutTime`: Thời gian check-out (timestamp).
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ HR Manager hoặc HR Staff mới có thể gọi hàm này.

---

## 5. **Hàm tính toán thời gian làm việc (`calculateWorkingHours`)**
- **Mục đích**: Tính toán thời gian làm việc của nhân viên dựa trên check-in và check-out.
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần tính toán.
  - `uint256 date`: Ngày cần tính toán (timestamp).
- **Output**:
  - `uint256`: Tổng thời gian làm việc trong ngày (tính bằng giây hoặc phút).
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

## 6. **Hàm lấy thông tin chấm công (`getAttendanceRecord`)**
- **Mục đích**: Truy vấn thông tin chấm công của một nhân viên trong một ngày cụ thể.
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần truy vấn.
  - `uint256 date`: Ngày cần truy vấn (timestamp).
- **Output**:
  - `uint256 checkInTime`: Thời gian check-in.
  - `uint256 checkOutTime`: Thời gian check-out.
  - `uint256 workingHours`: Tổng thời gian làm việc.
  - `bool isAbsent`: Trạng thái vắng mặt (true nếu vắng mặt).
  - `string absenceReason`: Lý do vắng mặt (nếu có).
  - `bool isAuthorized`: Trạng thái vắng mặt (có phép hoặc không phép).
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

## 7. **Hàm lấy danh sách vắng mặt (`getAbsenceRecords`)**
- **Mục đích**: Truy vấn danh sách các ngày vắng mặt của một nhân viên.
- **Input**:
  - `address employeeAddress`: Địa chỉ ví của nhân viên cần truy vấn.
- **Output**:
  - `uint256[] dates`: Danh sách các ngày vắng mặt (timestamp).
  - `string[] reasons`: Danh sách lý do vắng mặt.
  - `bool[] isAuthorized`: Danh sách trạng thái vắng mặt (có phép hoặc không phép).
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

### Tổng kết
Các hàm trong **AttendanceManagement Contract** được thiết kế để quản lý chấm công và theo dõi thời gian làm việc của nhân viên một cách hiệu quả. Dưới đây là bảng tóm tắt:

| Tên hàm                  | Input                                                                 | Output                     | Mục đích                                   |
|--------------------------|-----------------------------------------------------------------------|----------------------------|--------------------------------------------|
| `checkIn`                | `uint256 timestamp`                                                  | Không có                   | Ghi nhận thời gian check-in.               |
| `checkOut`               | `uint256 timestamp`                                                  | Không có                   | Ghi nhận thời gian check-out.              |
| `recordAbsence`          | `address employeeAddress`, `uint256 date`, `string reason`, `bool isAuthorized` | Không có                   | Ghi nhận việc vắng mặt của nhân viên.      |
| `manualAttendance`       | `address employeeAddress`, `uint256 checkInTime`, `uint256 checkOutTime` | Không có                   | Hỗ trợ chấm công thủ công.                 |
| `calculateWorkingHours`  | `address employeeAddress`, `uint256 date`                            | `uint256`                  | Tính toán thời gian làm việc.              |
| `getAttendanceRecord`    | `address employeeAddress`, `uint256 date`                            | `uint256 checkInTime`, `uint256 checkOutTime`, `uint256 workingHours`, `bool isAbsent`, `string absenceReason`, `bool isAuthorized` | Truy vấn thông tin chấm công.              |
| `getAbsenceRecords`      | `address employeeAddress`                                            | `uint256[] dates`, `string[] reasons`, `bool[] isAuthorized` | Truy vấn danh sách vắng mặt.               |
