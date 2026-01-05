using System;

namespace Models
{
    public partial class LoaiDongVat
    {
        public int? Id { get; set; }
        public string TenKhoaHoc { get; set; }
        public string TenTiengViet { get; set; }
        public string NhomLoai { get; set; }
        public string MucBaoTon { get; set; }
    }

    public partial class ThongKeSoLuongDongVat
    {
        public int? Id { get; set; }
        public int? CoSoDongVatLoaiDongVatId { get; set; }
        public int? LoaiKyBaoCaoId { get; set; }
        public int? Nam { get; set; }
        public int? KySo { get; set; }
        public int? SoLuongLoai { get; set; }
        public string GhiChu { get; set; }
        public string TenLoai { get; set; }
    }

    public class CoSoDongVatLoaiDongVat
    {
        public int? Id { get; set; }
        public int? CoSoId { get; set; }
        public int? LoaiDongVatId { get; set; }
        public string GhiChu { get; set; }
    }
}