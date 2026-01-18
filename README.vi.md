# Hệ Thống Quản Lý Lâm Nghiệp (KTPMUD)

[🇬🇧 View English version](README.md)

## Tổng quan dự án
Forestry Management System là một ứng dụng desktop Windows chuyên dụng, được thiết kế để quản lý toàn diện các tài nguyên lâm nghiệp. Hệ thống cung cấp một nền tảng tập trung nhằm theo dõi vườn ươm cây giống, cơ sở chế biến gỗ và các trung tâm bảo tồn động vật hoang dã. Ứng dụng được xây dựng trên nền tảng .NET Framework, sử dụng kiến trúc Model-View-Controller (MVC) tùy chỉnh và có khả năng hiển thị bản đồ tương tác.

## Chức năng chính
- **Quản lý cơ sở**: Quản lý tập trung các nguồn cây giống, cơ sở chế biến gỗ và khu bảo tồn.
- **Quản lý đơn vị hành chính**: Hệ thống quản lý địa lý 4 cấp (Tỉnh, Huyện, Xã, Thôn/Ấp).
- **Bản đồ tương tác**: Tích hợp Microsoft Edge WebView2 để hiển thị dữ liệu không gian và vị trí các cơ sở.
- **Ghi log hệ thống**: Tự động ghi lại hoạt động người dùng và các thay đổi hệ thống nhằm đảm bảo tính toàn vẹn và khả năng truy vết dữ liệu.

## Thông số kỹ thuật
- **Ngôn ngữ lập trình**: C#
- **Nền tảng**: .NET Framework 4.7.2 (WPF)
- **Kiến trúc**: MVC tùy chỉnh
- **Cơ sở dữ liệu**: Microsoft SQL Server
- **Thư viện chính**:
    - **Newtonsoft.Json**: Dùng cho tuần tự hóa dữ liệu và cấu hình hệ thống.
    - **Microsoft.Web.WebView2**: Dùng để nhúng các thành phần bản đồ nền web.
    - **Vst.Controls**: Thư viện giao diện người dùng tùy chỉnh, đảm bảo tính nhất quán UI.

## Phân quyền người dùng (RBAC)
Hệ thống triển khai mô hình phân quyền có cấu trúc, được định nghĩa trong metadata hành động nhằm đảm bảo truy cập dữ liệu an toàn.

| Vai trò | Mức truy cập | Trách nhiệm chính |
| :--- | :--- | :--- |
| **Developer** | Toàn hệ thống | Migration CSDL, cấu hình lõi, debug hệ thống |
| **Admin** | Quản lý | Quản lý tài khoản, phân quyền nhóm, thiết lập đơn vị hành chính |
| **Staff** | Tác nghiệp | Quản lý cây giống, chế biến gỗ và dữ liệu động vật hoang dã |

## Khởi tạo cơ sở dữ liệu
Ứng dụng sử dụng SQL Server làm backend. Thực hiện các bước sau để thiết lập tầng dữ liệu:

1. **Tạo database**: Tạo cơ sở dữ liệu mới với tên `KTPM`.
2. **Triển khai schema**: Chạy script `SQL/Tables.sql` để tạo các bảng và dữ liệu khởi tạo.
3. **Logic nghiệp vụ**: Chạy script `SQL/Procs.sql` để cài đặt các Stored Procedure phục vụ hệ thống.

## Kiến trúc hệ thống
Dự án được thiết kế theo hướng module hóa nhằm tách biệt trách nhiệm:
- **Controllers**: Nằm trong thư mục `/Controllers`, xử lý logic nghiệp vụ và kết nối giữa UI với CSDL.
- **Views**: Nằm trong thư mục `/Views`, quản lý giao diện WPF và các template HTML/JS cho bản đồ.
- **Models**: Định nghĩa các cấu trúc dữ liệu sử dụng trong toàn hệ thống.
- **Data Provider**: Bộ máy thực thi tập trung, dùng để gọi Stored Procedure một cách an toàn và hiệu quả.

## Cài đặt và thiết lập
1. **Yêu cầu**:
    - Visual Studio 2019 trở lên.
    - Microsoft SQL Server 2016+.
    - Microsoft Edge WebView2 Runtime.
2. **Clone mã nguồn**:
   ```bash
   git clone https://github.com/lca1605/KTPMUD_forest_manage.git

