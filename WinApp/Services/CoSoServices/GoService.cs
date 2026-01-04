using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services
{
    using Models;
    using System.Collections.Generic;
    using System.Linq;

    public partial class GoService
    {
        // 1. Cache danh mục (Loại hình sản xuất & Hình thức hoạt động)
        static List<LoaiHinhSanXuatGo> _dsLoaiHinh;
        static public List<LoaiHinhSanXuatGo> DanhMucLoaiHinh =>
            _dsLoaiHinh ?? (_dsLoaiHinh = Provider.Select<LoaiHinhSanXuatGo>());

        static List<HinhThucHoatDongGo> _dsHinhThuc;
        static public List<HinhThucHoatDongGo> DanhMucHinhThuc =>
            _dsHinhThuc ?? (_dsHinhThuc = Provider.Select<HinhThucHoatDongGo>());

        // 2. Lấy dữ liệu thống kê của cơ sở
        static public List<ThongKeCoSoGo> LayLichSuThongKe(int coSoId)
        {
            return Provider.Select<ThongKeCoSoGo>()
                .Where(x => x.CoSoId == coSoId)
                .OrderByDescending(x => x.Nam)
                .ThenByDescending(x => x.KySo)
                .ToList();
        }

        // 3. Lấy thông tin chuyên ngành (Loại hình/Hình thức cụ thể của cơ sở đó)
        static public CoSoCheBienGo LayThongTinChuyenNganh(int coSoId)
        {
            return Provider.Select<CoSoCheBienGo>()
                .FirstOrDefault(x => x.CoSoId == coSoId);
        }

        // 4. Lấy danh sách các kỳ báo cáo duy nhất
        static public List<PeriodInfo> LayDanhSachKy(int coSoId)
        {
            return LayLichSuThongKe(coSoId)
                .Select(x => new PeriodInfo
                {
                    LoaiKyBaoCaoId = x.LoaiKyBaoCaoId ?? 1,
                    KySo = x.KySo,
                    Nam = x.Nam
                })
                .GroupBy(x => new { x.LoaiKyBaoCaoId, x.KySo, x.Nam })
                .Select(g => g.First())
                .ToList();
        }
    }
}
