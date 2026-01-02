using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class CoSoCheBienGo
    {
        public int? CoSoId { get; set; }
        public int? LoaiHinhSanXuatGoId { get; set; }
        public int? HinhThucHoatDongGoId { get; set; }
    }

    public partial class LoaiHinhSanXuatGo
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public string MoTa { get; set; }
    }

    public partial class HinhThucHoatDongGo
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public string MoTa { get; set; }
    }

    public partial class ThongKeCoSoGo
    {
        public int? Id { get; set; }
        public int? CoSoId { get; set; }
        public int? LoaiKyBaoCaoId { get; set; }
        public int? Nam { get; set; }
        public int? KySo { get; set; }
        public decimal? GiaTriKy { get; set; }
        public decimal? DienTich { get; set; }
        public decimal? SanLuong { get; set; }
        public string GhiChu { get; set; }
    }

    
}