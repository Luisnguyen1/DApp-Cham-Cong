DDanh sách các **task chi tiết** cần triển khai để xây dựng hệ thống DAPP quản lý chấm công. Các task được phân loại theo từng contract và mục đích cụ thể:

---

### 1. **RoleManagement Contract**
**Mục đích**: Quản lý vai trò và quyền hạn trong hệ thống.
- **Task chi tiết**:
  - Thiết kế cấu trúc lưu trữ các vai trò (Root, Trưởng phòng Nhân sự, Nhân viên Nhân sự, Kế toán, Nhân viên).
  - Hardcode địa chỉ ví của Root để phân biệt quyền cao nhất.
  - Triển khai hàm gán quyền (assignRole) để Root có thể gán quyền cho các địa chỉ ví khác.
  - Triển khai hàm kiểm tra quyền (checkRole) để xác định vai trò của một địa chỉ ví.
  - Triển khai hàm thu hồi quyền (revokeRole) để Root có thể thu hồi quyền từ một địa chỉ ví.
  - Đảm bảo chỉ Root có thể gán và thu hồi quyền.

---

### 2. **EmployeeManagement Contract**
**Mục đích**: Quản lý thông tin nhân viên và quy trình onboarding.
- **Task chi tiết**:
  - Thiết kế cấu trúc lưu trữ thông tin nhân viên (địa chỉ ví, tên, phòng ban, ngày vào công ty, lương, ngày phép còn lại, v.v.).
  - Triển khai hàm tạo refcode (createRefCode) để Root tạo mã giới thiệu duy nhất.
  - Triển khai hàm thêm nhân viên mới (addEmployee) thông qua refcode.
  - Triển khai hàm cập nhật thông tin nhân viên (updateEmployeeInfo) để chỉnh sửa thông tin như lương, phòng ban, v.v.
  - Triển khai hàm xóa nhân viên (removeEmployee) khi nhân viên nghỉ việc.
  - Triển khai hàm lấy thông tin nhân viên (getEmployeeInfo) để truy vấn thông tin chi tiết.

---

### 3. **AttendanceManagement Contract**
**Mục đích**: Quản lý chấm công và theo dõi thời gian làm việc.
- **Task chi tiết**:
  - Thiết kế cấu trúc lưu trữ dữ liệu chấm công (check-in, check-out, thời gian làm việc, đi trễ, về sớm, vắng mặt có phép/không phép).
  - Triển khai hàm check-in (checkIn) để nhân viên ghi nhận thời gian bắt đầu làm việc.
  - Triển khai hàm check-out (checkOut) để nhân viên ghi nhận thời gian kết thúc làm việc.
  - Triển khai hàm tính toán thời gian làm việc (calculateWorkingHours) dựa trên check-in và check-out.
  - Triển khai hàm ghi nhận vắng mặt (recordAbsence) với lý do (có phép/không phép).
  - Triển khai hàm hỗ trợ chấm công thủ công (manualAttendance) cho các trường hợp đặc biệt (do HR hoặc Trưởng phòng Nhân sự thực hiện).

---

### 4. **LeaveManagement Contract**
**Mục đích**: Quản lý yêu cầu nghỉ phép và duyệt/từ chối yêu cầu.
- **Task chi tiết**:
  - Thiết kế cấu trúc lưu trữ yêu cầu nghỉ phép (nhân viên, lý do, thời gian, trạng thái duyệt/từ chối).
  - Triển khai hàm gửi yêu cầu nghỉ phép (requestLeave) để nhân viên gửi yêu cầu.
  - Triển khai hàm duyệt yêu cầu nghỉ phép (approveLeave) để HR hoặc Trưởng phòng Nhân sự duyệt yêu cầu.
  - Triển khai hàm từ chối yêu cầu nghỉ phép (rejectLeave) để HR hoặc Trưởng phòng Nhân sự từ chối yêu cầu.
  - Triển khai hàm cập nhật số ngày phép còn lại (updateLeaveBalance) sau khi yêu cầu được duyệt.
  - Triển khai hàm lấy thông tin yêu cầu nghỉ phép (getLeaveRequest) để truy vấn chi tiết.

---

### 5. **DeductionManagement Contract**
**Mục đích**: Quản lý các khoản khấu trừ lương do vi phạm.
- **Task chi tiết**:
  - Thiết kế cấu trúc lưu trữ các khoản khấu trừ (nhân viên, loại vi phạm, số tiền khấu trừ, lý do).
  - Triển khai hàm ghi nhận vi phạm (recordViolation) để HR hoặc Trưởng phòng Nhân sự ghi nhận các vi phạm (đi trễ, về sớm, nghỉ không phép).
  - Triển khai hàm tính toán khấu trừ lương (calculateDeduction) dựa trên vi phạm.
  - Triển khai hàm áp dụng khấu trừ vào lương (applyDeduction).

---

### 6. **SalaryManagement Contract**
**Mục đích**: Tính toán và quản lý lương cho nhân viên.
- **Task chi tiết**:
  - Thiết kế cấu trúc lưu trữ thông tin lương (nhân viên, lương cơ bản, ngày công, khoản khấu trừ, lương thực nhận).
  - Triển khai hàm tính toán lương (calculateSalary) dựa trên ngày công, ngày phép, và các khoản khấu trừ.
  - Triển khai hàm xuất báo cáo lương (exportSalaryReport) để Kế toán hoặc Root xuất báo cáo.
  - Triển khai hàm cập nhật lương cơ bản (updateBaseSalary) để Root hoặc HR cập nhật lương cho nhân viên.

---

### 7. **ReportManagement Contract**
**Mục đích**: Quản lý việc xuất báo cáo và chia sẻ dữ liệu.
- **Task chi tiết**:
  - Thiết kế cấu trúc lưu trữ metadata của các báo cáo (hash của file Excel, thời gian tạo, người tạo).
  - Triển khai hàm tạo báo cáo (generateReport) để tạo và lưu trữ metadata của báo cáo.
  - Triển khai hàm chia sẻ báo cáo (shareReport) để tạo ID truy cập một lần với thời gian giới hạn.
  - Triển khai hàm xác minh quyền truy cập báo cáo (verifyReportAccess).

---

### 8. **AccessControlContract**
**Mục đích**: Quản lý việc chia sẻ dữ liệu với bên ngoài (ví dụ: ngân hàng).
- **Task chi tiết**:
  - Thiết kế cấu trúc lưu trữ ID truy cập một lần (ID, thời gian hết hạn, quyền truy cập).
  - Triển khai hàm tạo ID truy cập (generateAccessID) để chia sẻ bảng lương hoặc chấm công.
  - Triển khai hàm xác minh ID truy cập (verifyAccessID) để kiểm tra quyền truy cập.

---