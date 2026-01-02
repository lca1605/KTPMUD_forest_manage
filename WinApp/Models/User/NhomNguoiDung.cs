using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class NhomNguoiDung
    {
        public int? Id { get; set; }
        public int? MaDonViId { get; set; }
        public string TenNhom { get; set; }
    }

    public partial class NguoiDungTrongNhom
    {
        public string UserName { get; set; }
        public int? GroupId { get; set; }
    }

    public partial class TacDong
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
    }

    public partial class QuyenNhom
    {
        public int? GroupId { get; set; }
        public int? TacDongId { get; set; }
    }

    public partial class LoaiKyBaoCao
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
    }
}