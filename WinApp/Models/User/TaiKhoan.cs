using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class TaiKhoan
    {
        public string TenDangNhap { get; set; }
        public string MatKhau { get; set; }
        public int QuyenId { get; set; }
        public int HoSoId { get; set; }
        public DateTime? LanCuoiHoatDong { get; set; }
        public int? MaDonViId { get; set; }
    }

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
        public DateTime? LanCuoiHoatDong { get; set; }

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
}