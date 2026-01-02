using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class CoSoDongVat
    {
        public int Id { get; set; }
        public int CoSoId { get; set; }
        public int LoaiDongVatId { get; set; }
        public decimal SoLuongHienTai { get; set; }
        public string GhiChu { get; set; }
    }

    public partial class LoaiDongVat
    {
        public int? Id { get; set; }
        public string TenKhoaHoc { get; set; }
        public string TenTiengViet { get; set; }
        public string NhomLoai { get; set; }
        public string MucBaoTon { get; set; }
    }

    public partial class LoaiBienDong
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
    }

    public partial class ThongKeSoLuongDongVat
    {
        public int? Id { get; set; }
        public int? CoSoId { get; set; }
        public int? CoSoDongVatId { get; set; }
        public int? Nam { get; set; }
        public int? KySo { get; set; }
        public decimal? GiaTriKy { get; set; }
        public decimal? SoDauKy { get; set; }
        public decimal? SoCuoiKy { get; set; }
        public string GhiChu { get; set; }
    }

    public partial class BienDongSoLuongDongVat
    {
        public int? Id { get; set; }
        public int? CoSoDongVatId { get; set; }
        public int? LoaiBienDongId { get; set; }
        public DateTime? NgayBienDong { get; set; }
        public decimal? SoLuong { get; set; }
        public string GhiChu { get; set; }
    }
}