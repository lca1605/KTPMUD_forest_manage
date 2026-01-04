using Models;
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

    public partial class GiongService
    {
        // 1. Lấy lịch sử thống kê (Dữ liệu cho bảng 1)
        public static List<ThongKeCoSoGiong> LayLichSuThongKe(int coSoId)
        {
            return Provider.Select<ThongKeCoSoGiong>()
                .Where(x => x.CoSoId == coSoId)
                .OrderByDescending(x => x.Nam)
                .ThenByDescending(x => x.KySo)
                .ToList();
        }

        // 2. Lấy danh mục giống (Dữ liệu cho bảng 2)
        public static List<GiongCay> LayDanhMucGiong()
        {
            return Provider.Select<GiongCay>().OrderBy(x => x.Ten).ToList();
        }

        // 3. Lấy danh sách các kỳ báo cáo duy nhất để đổ vào ComboBox lọc
        public static List<PeriodInfo> LayDanhSachKy(int coSoId)
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