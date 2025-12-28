using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    // ===== MODELS CŨ =====

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

    public partial class TaiKhoan
    {
        public string Ten { get; set; }
        public string MatKhau { get; set; }
        public int QuyenId { get; set; }
        public int HoSoId { get; set; }
        public DateTime? LanCuoiHoatDong { get; set; }
        public string TrangThai { get; set; }
        public int? MaDonViId { get; set; }
        public string HoTen { get; set; }
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

    // ===== MODELS MỚI =====

    // 1. Cơ sở
    public partial class CoSo
    {
        public int? Id { get; set; }
        public int? DonViId { get; set; }
        public int? LoaiCoSoId { get; set; }
        public string Ten { get; set; }
        public string DiaChi { get; set; }
        public string SDT { get; set; }
        public string NguoiDaiDien { get; set; }
    }

    public partial class ViewCoSo
    {
        public int? Id { get; set; }
        public int? DonViId { get; set; }
        public int? LoaiCoSoId { get; set; }
        public string Ten { get; set; }
        public string DiaChi { get; set; }
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

    // 2. Giống cây trồng
    public partial class LoaiGiongCayTrong
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public string MoTa { get; set; }
    }

    public partial class CoSoGiongCayTrong
    {
        public int? CoSoId { get; set; }
    }

    public partial class CoSoGiong_LoaiGiong
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

    // 3. Gỗ
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

    // 4. Động vật
    public partial class CoSoLuuGiuDongVat
    {
        public int? CoSoId { get; set; }
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
        public int? LoaiDongVatId { get; set; }
        public int? LoaiKyBaoCaoId { get; set; }
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
        public int? CoSoId { get; set; }
        public int? LoaiDongVatId { get; set; }
        public int? LoaiBienDongId { get; set; }
        public DateTime? NgayBienDong { get; set; }
        public decimal? SoLuong { get; set; }
        public string GhiChu { get; set; }
    }

    // 5. Phân quyền
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

    // 6. Danh mục
    public partial class LoaiKyBaoCao
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
    }
}