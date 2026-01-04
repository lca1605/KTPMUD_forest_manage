using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace Services
{
    using Models;
    using System.Collections.Generic;
    using System.Linq;
    using WinApp.Views.CoSo;

    public partial class DongVatService
    {
        public static List<ThongKeCoSoDongVat> GetThongKe(int coSoId)
        {
            return Provider.Select<ThongKeCoSoDongVat>()
                .Where(x => x.CoSoId == coSoId)
                .OrderByDescending(x => x.Nam)
                .ToList();
        }

        public static List<DongVat> GetDanhSachDongVat(int coSoId)
        {
            var ids = Provider.Select<CoSoDongVat_LoaiDongVat>()
                              .Where(x => x.CoSoId == coSoId)
                              .Select(x => x.LoaiDongVatId);

            return Provider.Select<DongVat>()
                           .Where(x => ids.Contains(x.Id))
                           .ToList();
        }
    }
}