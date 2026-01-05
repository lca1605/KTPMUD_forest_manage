using System;
using System.Collections.Generic;
using System.Linq;
using Models;

namespace Services
{
    public partial class DongVatService
    {
        public static List<ThongKeSoLuongDongVat> LayLichSuThongKe(int coSoId)
        {
            var dsTrungGian = Provider.Select<CoSoDongVatLoaiDongVat>()
                .Where(x => x.CoSoId == coSoId).ToList();

            var idsTrungGian = dsTrungGian.Select(x => x.Id).ToList();

            var dsThongKe = Provider.Select<ThongKeSoLuongDongVat>()
                .Where(x => idsTrungGian.Contains(x.CoSoDongVatLoaiDongVatId))
                .OrderByDescending(x => x.Nam)
                .ThenByDescending(x => x.KySo)
                .ToList();

            var tatCaLoai = Provider.Select<LoaiDongVat>();

            foreach (var item in dsThongKe)
            {
                var tg = dsTrungGian.FirstOrDefault(x => x.Id == item.CoSoDongVatLoaiDongVatId);
                if (tg != null)
                {
                    item.TenLoai = tatCaLoai.FirstOrDefault(l => l.Id == tg.LoaiDongVatId)?.TenTiengViet;
                }
            }

            return dsThongKe;
        }

        public static List<PeriodInfo> LayDanhSachKy(int coSoId)
        {
            var ids = Provider.Select<CoSoDongVatLoaiDongVat>()
                .Where(x => x.CoSoId == coSoId).Select(x => x.Id).ToList();

            return Provider.Select<ThongKeSoLuongDongVat>()
                .Where(x => ids.Contains(x.CoSoDongVatLoaiDongVatId))
                .Select(x => new PeriodInfo
                {
                    LoaiKyBaoCaoId = x.LoaiKyBaoCaoId ?? 1,
                    KySo = x.KySo,
                    Nam = x.Nam
                })
                .Distinct()
                .OrderByDescending(x => x.Nam)
                .ToList();
        }
    }
}