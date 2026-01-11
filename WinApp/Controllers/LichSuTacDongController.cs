using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinApp.Controllers
{
    internal class LichSuTacDongController : DataController<LichSuTacDong>
    {
        DataSchema.Table LichSuTacDongDb => Provider.GetTable<LichSuTacDong>();
        protected override string GetProcName() => null;
        protected override void TryUpdate(LichSuTacDong e)
        {
            var moTaCu = LichSuTacDongDb.GetValueById("MoTa", e.Id)?.ToString();
            GhiLichSu("UPDATE", $"sửa một lịch sử tác động.");
            ExecSQL(LichSuTacDongDb.CreateUpdateSql(e));
        }
        protected override void TryDelete(LichSuTacDong e)
        {
            GhiLichSu("DELETE", $"xóa một lịch sử tác động.");
            ExecSQL(LichSuTacDongDb.CreateDeleteSql(e));
        }
    }
}
