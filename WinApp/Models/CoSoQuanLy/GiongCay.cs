using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class GiongCay
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public string Nguon { get; set; }
        public string MoTa { get; set; }
    }

    public partial class CoSoGiongLoaiGiong
    {
        public int? Id { get; set; }
        public int? CoSoId { get; set; }
        public int? LoaiGiongId { get; set; }
        public string GhiChu { get; set; }
    }

    public partial class ThongKeCoSoGiong
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