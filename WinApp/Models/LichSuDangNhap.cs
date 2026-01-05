using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class LichSuDangNhap
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public DateTime? ThoiGian { get; set; }
        public string TrangThai { get; set; }
        public string GhiChu { get; set; }
    }

    public partial class ViewLichSuDangNhap
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public DateTime? ThoiGian { get; set; }
        public string TrangThai { get; set; }
        public string GhiChu { get; set; }
        public string TenNguoiDung { get; set; }
    }
}