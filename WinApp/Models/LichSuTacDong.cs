using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class LichSuTacDong
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public string HanhDong { get; set; }
        public string ChucNang { get; set; }
        public DateTime? ThoiGian { get; set; }
        public string GhiChu { get; set; }
    }

    public partial class ViewLichSuTacDong
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public string HanhDong { get; set; }
        public string ChucNang { get; set; }
        public DateTime? ThoiGian { get; set; }
        public string GhiChu { get; set; }
        public string TenNguoiDung { get; set; }
    }
}