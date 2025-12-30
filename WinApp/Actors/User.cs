using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace System
{
    public class User
    {
        // Giữ nguyên các thuộc tính phục vụ UI Menu
        public ActionContext TopMenu { get; set; }
        public ActionContext SideMenu { get; set; }

        // Ánh xạ từ bảng TaiKhoan (DbModels.cs)
        public string UserName { get; set; }  // Cột Ten (Khóa chính)
        public string HoTen { get; set; }     // Cột HoTen
        public int QuyenId { get; set; }      // 2: Admin, 3: Staff (Dựa theo Tables.sql)
        public int? MaDonViId { get; set; }   // Đơn vị quản lý của user này

        // Các hàm kiểm tra nhanh dùng trong View/Controller
        public bool IsAdmin => QuyenId == 2;
        public bool IsStaff => QuyenId == 3;
        public bool IsDev => QuyenId == 1;

        public object Profile { get; set; }
        public string Description { get; set; }
    }
}

namespace Actors
{
    public partial class Admin : User { }
    public partial class Developer : User { }
    public partial class Staff : User { }
}
