using Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Services
{
    /*public class ThongKeCoSoGiongService : ThongKeBaseService<ThongKeCoSoGiong>,
          BaoCaoProvider
    {
        #region BaoCaoProvider
        public List<ChiTieuThongKe> GetChiTieuThongKe()
        {
            return new List<ChiTieuThongKe>
            {
                new ChiTieuThongKe
                {
                    Key = "SanLuong",
                    Ten = "Sản lượng",
                    DonVi = "tấn"
                },
                new ChiTieuThongKe
                {
                    Key = "DienTich",
                    Ten = "Diện tích",
                    DonVi = "ha"
                },
                new ChiTieuThongKe
                {
                    Key = "GiaTri",
                    Ten = "Giá trị",
                    DonVi = "VNĐ"
                }
            };
        }

        public List<ThongKeChart> GetChartData(
            int coSoId,
            int nam,
            int loaiKyBaoCaoId,
            string chiTieuKey)
        {
            var valueSelector = GetValueSelector(chiTieuKey);
            if (valueSelector == null)
                return new List<ThongKeChart>();

            switch (loaiKyBaoCaoId)
            {
                case 1: // Tháng
                    return BuildChart(
                        nam,
                        coSoId,
                        loaiKyBaoCaoId,
                        valueSelector,
                        ky => $"Tháng {ky}"
                    );

                case 2: // Quý
                    return BuildChart(
                        nam,
                        coSoId,
                        loaiKyBaoCaoId,
                        valueSelector,
                        ky => $"Quý {((ky - 1) / 3 + 1)}"
                    );

                case 3: // Năm
                    var data = GetSource(nam, coSoId, loaiKyBaoCaoId);
                    return new List<ThongKeChart>
                    {
                        new ThongKeChart
                        {
                            Label = nam.ToString(),
                            Value = data.Sum(x => valueSelector(x) ?? 0)
                        }
                    };

                default:
                    return new List<ThongKeChart>();
            }
        }
        #endregion

        #region ThongKeBaseService override
        /*protected override IQueryable<ThongKeCoSoGiong> GetSource(
            int nam,
            int coSoId,
            int loaiKyBaoCaoId)
        {
            //return Provider.Select<ThongKeCoSoGiong>().Where(x => x.Nam == nam )


        }

        protected override int GetKySo(ThongKeCoSoGiong item)
        {
            return item.KySo ?? 0;
        }

        #endregion

        #region Private helpers

        private Func<ThongKeCoSoGiong, decimal?> GetValueSelector(string key)
        {
            switch (key)
            {
                case "SanLuong":
                    return x => x.SanLuong;

                case "DienTich":
                    return x => x.DienTich;

                case "GiaTri":
                    return x => x.GiaTriKy;

                default:
                    return null;
            }
        }

        #endregion
    }*/
}
