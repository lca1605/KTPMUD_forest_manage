using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class UserActivityLog
    {
        public int? Id { get; set; }
        public string TenDangNhap { get; set; }
        public string HanhDong { get; set; }
        public string ChucNang { get; set; }
        public DateTime? ThoiGian { get; set; }
        public string DiaChi { get; set; }
        public string GhiChu { get; set; }
    }

    public partial class ViewUserActivityLog
    {
        public int? Id { get; set; }
        public string TenDangNhap { get; set; }
        public string HanhDong { get; set; }
        public string ChucNang { get; set; }
        public DateTime? ThoiGian { get; set; }
        public string DiaChi { get; set; }
        public string GhiChu { get; set; }
        public string TenNguoiDung { get; set; }
        public string LoaiQuyen { get; set; }

        public string ThoiGianFormatted
        {
            get
            {
                if (ThoiGian != null)
                {
                    return ThoiGian.Value.ToString("dd/MM/yyyy HH:mm:ss");
                }
                return "";
            }
        }
    }
}