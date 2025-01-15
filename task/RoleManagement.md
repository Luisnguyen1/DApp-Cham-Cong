Mô tả chi tiết về **input** và **output** của từng hàm trong **RoleManagement Contract**:

---

## 1. **Hàm gán quyền (`assignRole`)**
- **Mục đích**: Gán một vai trò cụ thể cho một địa chỉ ví.
- **Input**:
  - `address user`: Địa chỉ ví của người dùng cần gán quyền.
  - `Role role`: Vai trò cần gán (ví dụ: `HRManager`, `Accountant`, `Employee`, v.v.).
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ có địa chỉ Root mới có thể gọi hàm này.

---

## 2. **Hàm kiểm tra quyền (`checkRole`)**
- **Mục đích**: Kiểm tra vai trò của một địa chỉ ví cụ thể.
- **Input**:
  - `address user`: Địa chỉ ví cần kiểm tra vai trò.
- **Output**:
  - `Role`: Vai trò của địa chỉ ví (ví dụ: `Root`, `HRManager`, `Accountant`, `Employee`, hoặc `None` nếu không có vai trò).
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

## 3. **Hàm thu hồi quyền (`revokeRole`)**
- **Mục đích**: Thu hồi quyền (vai trò) từ một địa chỉ ví.
- **Input**:
  - `address user`: Địa chỉ ví cần thu hồi quyền.
- **Output**:
  - Không có giá trị trả về (hàm thực hiện thay đổi trạng thái trên blockchain).
- **Lưu ý**:
  - Chỉ có địa chỉ Root mới có thể gọi hàm này.

---

## 4. **Hàm kiểm tra địa chỉ Root (`isRoot`)**
- **Mục đích**: Kiểm tra xem một địa chỉ ví có phải là Root không.
- **Input**:
  - `address user`: Địa chỉ ví cần kiểm tra.
- **Output**:
  - `bool`: Trả về `true` nếu địa chỉ ví là Root, ngược lại trả về `false`.
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

## 5. **Hàm lấy địa chỉ Root (`getRootAddress`)**
- **Mục đích**: Trả về địa chỉ ví của Root.
- **Input**:
  - Không có input.
- **Output**:
  - `address`: Địa chỉ ví của Root.
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

## 6. **Hàm kiểm tra quyền của người gọi (`checkCallerRole`)**
- **Mục đích**: Kiểm tra vai trò của người gọi hàm hiện tại.
- **Input**:
  - Không có input.
- **Output**:
  - `Role`: Vai trò của người gọi hàm (ví dụ: `Root`, `HRManager`, `Accountant`, `Employee`, hoặc `None` nếu không có vai trò).
- **Lưu ý**:
  - Hàm này là một hàm `view`, không làm thay đổi trạng thái blockchain.

---

### Tóm tắt 
Địa chỉ root là địa chỉ hardcode như sau: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
Các hàm trong **RoleManagement Contract** được thiết kế để quản lý và kiểm tra quyền hạn một cách rõ ràng và minh bạch. Dưới đây là bảng tóm tắt:

| Tên hàm              | Input                              | Output                     | Mục đích                                   |
|-----------------------|------------------------------------|----------------------------|--------------------------------------------|
| `assignRole`          | `address user`, `Role role`        | Không có                   | Gán quyền cho một địa chỉ ví.              |
| `checkRole`           | `address user`                     | `Role`                     | Kiểm tra vai trò của một địa chỉ ví.       |
| `revokeRole`          | `address user`                     | Không có                   | Thu hồi quyền từ một địa chỉ ví.           |
| `isRoot`              | `address user`                     | `bool`                     | Kiểm tra xem địa chỉ ví có phải là Root không. |
| `getRootAddress`      | Không có                           | `address`                  | Trả về địa chỉ ví của Root.                |
| `checkCallerRole`     | Không có                           | `Role`                     | Kiểm tra vai trò của người gọi hàm.        |
