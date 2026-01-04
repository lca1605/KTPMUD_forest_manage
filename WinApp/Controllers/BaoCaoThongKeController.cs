using Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace WinApp.Controllers
{
    class BaoCaoThongKeController : BaseController
    {
        public object Index(
            int coSoId,
            int nam,
            int loaiKyBaoCaoId,
            string loaiCoSo,
            string chiTieuKey)
        {
            List<ThongKeChart> result;

            if (loaiCoSo == "GIONG")
            {
                var table = Provider.GetTable<ThongKeCoSoGiong>();

                var source = table
                    .ToList<ThongKeCoSoGiong>(null, null)
                    .Where(x =>
                        x.CoSoId == coSoId &&
                        x.Nam == nam &&
                        x.LoaiKyBaoCaoId == loaiKyBaoCaoId
                    )
                    .AsQueryable();


                var service = new ThongKeCoSoGiongService();

                Func<ThongKeCoSoGiong, decimal?> selector =
                    GetGiongSelector(chiTieuKey);

                result = service.BuildChart(
                    source,
                    loaiKyBaoCaoId,
                    selector
                );
            }
            else
            {
                throw new Exception("Loại cơ sở chưa hỗ trợ");
            }

            return View(new BaoCaoThongKeContext
            {
                CoSoId = coSoId,
                Nam = nam,
                LoaiKyBaoCaoId = loaiKyBaoCaoId,
                ChiTieuKey = chiTieuKey,
                Charts = result
            });
        }

        private Func<ThongKeCoSoGiong, decimal?> GetGiongSelector(string key)
        {
            switch (key)
            {
                case "SanLuong": return x => x.SanLuong;
                case "DienTich": return x => x.DienTich;
                case "GiaTri": return x => x.GiaTriKy;
                default: return x => 0;
            }
        }
    }

}
