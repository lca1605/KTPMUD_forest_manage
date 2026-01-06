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
        protected override void TryUpdate(LichSuTacDong e)
        {
            var moTaCu = LichSuTacDongDb.GetValueById("MoTa", e.Id)?.ToString();
            GhiLichSu("UPDATE", $"sua lich su tac dong {moTaCu} thành {e.MoTa}");
            ExecSQL(LichSuTacDongDb.CreateUpdateSql(e));
        }
        protected override void TryDelete(LichSuTacDong e)
        {
            GhiLichSu("DELETE", $"xóa lich su tac dong {e.MoTa}");
            ExecSQL(LichSuTacDongDb.CreateDeleteSql(e));
        }
    }
}
