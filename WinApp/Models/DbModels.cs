using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    // Định nghĩa GiongCay
    public partial class GiongCay
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public string Nguon { get; set; }
    }

    // Định nghĩa DonVi
    public partial class DonVi
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public int? HanhChinhId { get; set; }
        public string TenHanhChinh { get; set; }
        public int? TrucThuocId { get; set; }
    }

    // Định nghĩa TaiKhoan (Có thêm LanCuoiHoatDong)
    public partial class TaiKhoan
    {
        public string Ten { get; set; }
        public string MatKhau { get; set; }
        public int QuyenId { get; set; }
        public int HoSoId { get; set; }

        // Thêm trường này ở đây luôn, không cần file extension nào khác
        public DateTime? LanCuoiHoatDong { get; set; }
    }

    // Định nghĩa ViewHoSo (Có thêm TrangThai)
    public partial class ViewHoSo
    {
        public int Id { get; set; }
        public string Ten { get; set; }
        public string SDT { get; set; }
        public string Email { get; set; }
        public string Ext { get; set; }
        public string TenDangNhap { get; set; }
        public string MatKhau { get; set; }
        public int QuyenId { get; set; }
        public string Quyen { get; set; }

        // Map dữ liệu từ DB
        public DateTime? LanCuoiHoatDong { get; set; }

        // Logic Online/Offline
        public string TrangThai
        {
            get
            {
                if (LanCuoiHoatDong != null && LanCuoiHoatDong.Value > DateTime.Now.AddMinutes(-5))
                {
                    return "Online";
                }
                return "Offline";
            }
        }
    }

    // Các class phụ trợ khác
    public class HanhChinh
    {
        public int Id { get; set; }
        public string Ten { get; set; }
        public int TrucThuocId { get; set; }
    }

    public class HoSo
    {
        public int Id { get; set; }
        public string Ten { get; set; }
        public string SDT { get; set; }
        public string Email { get; set; }
        public string Ext { get; set; }
    }

    public class Quyen
    {
        public int Id { get; set; }
        public string Ten { get; set; }
        public string Ext { get; set; }
    }

    public class TenHanhChinh
    {
        public string Ten { get; set; }
    }

    public partial class ViewDonVi
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public int? HanhChinhId { get; set; }
        public string TenHanhChinh { get; set; }
        public int? TrucThuocId { get; set; }
        public string Cap { get; set; }
        public string TrucThuoc { get; set; }
    }
}