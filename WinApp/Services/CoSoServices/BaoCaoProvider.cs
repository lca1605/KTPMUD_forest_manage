using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace Services
{
    public interface BaoCaoProvider
    {
        List<ChiTieuThongKe> GetChiTieuThongKe();
        List<ThongKeChart> GetChartData(
            int coSoId,
            int nam,
            int loaiKyBaoCaoId,
            string chiTieuKey
        );
    }


    public abstract class ThongKeBaseService<T>
    {
        protected abstract IQueryable<T> GetSource(
            int nam,
            int coSoId,
            int loaiKyBaoCaoId
        );
        protected abstract int GetKySo(T item);

        protected List<ThongKeChart> BuildChart(
            int nam,
            int coSoId,
            int loaiKyBaoCaoId,
            Func<T, decimal?> valueSelector,
            Func<int, string> labelBuilder)
        {
            var data = GetSource(nam, coSoId, loaiKyBaoCaoId);

            return data
                .GroupBy(x => GetKySo(x))
                .Select(g => new ThongKeChart
                {
                    Label = labelBuilder(g.Key),
                    Value = g.Sum(x => valueSelector(x) ?? 0)
                })
                .OrderBy(x => x.Label)
                .ToList();
        }
    }
}
