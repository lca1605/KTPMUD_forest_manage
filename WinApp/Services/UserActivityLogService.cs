using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace Services
{
    public partial class UserActivityLogService
    {
        static public List<ViewUserActivityLog> DanhSach()
        {
            return Provider.Select<ViewUserActivityLog>()
                .OrderByDescending(x => x.ThoiGian)
                .ToList();
        }

        static public List<ViewUserActivityLog> DanhSachTheoNguoiDung(string tenDangNhap)
        {
            return Provider.Select<ViewUserActivityLog>()
                .Where(x => x.TenDangNhap == tenDangNhap)
                .OrderByDescending(x => x.ThoiGian)
                .ToList();
        }

        static public List<ViewUserActivityLog> DanhSachTheoNgay(DateTime tuNgay, DateTime denNgay)
        {
            return Provider.Select<ViewUserActivityLog>()
                .Where(x => x.ThoiGian >= tuNgay && x.ThoiGian <= denNgay)
                .OrderByDescending(x => x.ThoiGian)
                .ToList();
        }

        static public void GhiLog(string tenDangNhap, string hanhDong, string chucNang, string ghiChu = null)
        {
            Provider.CreateCommand(cmd => {
                cmd.CommandText = @"INSERT INTO UserActivityLog (TenDangNhap, HanhDong, ChucNang, GhiChu) 
                                   VALUES (@TenDangNhap, @HanhDong, @ChucNang, @GhiChu)";
                cmd.Parameters.AddWithValue("@TenDangNhap", tenDangNhap ?? "");
                cmd.Parameters.AddWithValue("@HanhDong", hanhDong ?? "");
                cmd.Parameters.AddWithValue("@ChucNang", chucNang ?? "");
                cmd.Parameters.AddWithValue("@GhiChu", ghiChu ?? "");
                try { cmd.ExecuteNonQuery(); } catch { }
            });
        }
    }
}