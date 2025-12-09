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
    }

    public partial class DonVi
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public int? HanhChinhId { get; set; }
        public string TenHanhChinh { get; set; }
        public int? TrucThuocId { get; set; }
    }

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

    public class TaiKhoan
    {
        public string Ten { get; set; }
        public string MatKhau { get; set; }
        public int QuyenId { get; set; }
        public int HoSoId { get; set; }
        // KTPMUD: Thêm trường này để mapping với cột mới tạo trong SQL
        public DateTime? LanCuoiHoatDong { get; set; }
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

    public class ViewHoSo
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

        // KTPMUD: Lấy dữ liệu thời gian từ DB lên
        public DateTime? LanCuoiHoatDong { get; set; }

        // KTPMUD: Logic kiểm tra Online (trong vòng 5 phút)
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
}