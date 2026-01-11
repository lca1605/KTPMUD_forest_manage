namespace Models
{
    public partial class CoSo
    {
        public int? Id { get; set; }
        public int? DonViId { get; set; }
        public int? LoaiCoSoId { get; set; }
        public string Ten { get; set; }

        public int? DiaChiId { get; set; }      // FK

        public string SDT { get; set; }
        public string NguoiDaiDien { get; set; }
    }

    public partial class DiaChi
    {
        public int? Id { get; set; }
        public string DiaChiDayDu { get; set; }
        public double? Lat { get; set; }
        public double? Lng { get; set; }
    }

    public partial class ViewCoSo
    {
        public int? Id { get; set; }
        public int? DonViId { get; set; }
        public int? LoaiCoSoId { get; set; }
        public string Ten { get; set; }
        public int? DiaChiId { get; set; }
        public string DiaChi { get; set; }
        public double? Lat { get; set; }
        public double? Lng { get; set; }

        public string SDT { get; set; }
        public string NguoiDaiDien { get; set; }
        public string TenDonVi { get; set; }
        public string TenLoaiCoSo { get; set; }
    }

    public partial class LoaiCoSo
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
    }
}
