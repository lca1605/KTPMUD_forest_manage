using Models;
using Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinApp.Controllers
{
    internal class LoaiGiongController : DataController<GiongCay>
    {
        protected override GiongCay CreateEntity() => new GiongCay();
        DataSchema.Table LoaiGiongDb => Provider.GetTable<GiongCay>();
        DataSchema.Table CoSoGiongLoaiGiongDb => Provider.GetTable<CoSoGiongLoaiGiong>();
        protected override string GetProcName() => null;
        protected override void TryInsert(GiongCay e)
        {
            if (LoaiGiongDb.GetValue("Ten", $"Ten = N'{e.Ten}'") != null && LoaiGiongDb.GetValue("Nguon", $"Nguon = N'{e.Nguon}'") != null)
            {
                UpdateContext.Message = "Đã có giong cay " + e.Ten + " tu nguon " + e.Nguon;
                return;
            }
            GhiLichSu("INSERT", $"thêm loài giống: {e.Ten}");
            ExecSQL(LoaiGiongDb.CreateInsertSql(e));
        }
        protected override void TryDelete(GiongCay e)
        {
            string sqlDeleteRelative = $"DELETE FROM CoSoGiongLoaiGiong WHERE LoaiGiongId = {e.Id}";
            ExecSQL(sqlDeleteRelative);
            GhiLichSu("DELETE", $"xóa loài giống: {e.Ten}");
            ExecSQL(LoaiGiongDb.CreateDeleteSql(e));
        }
    }
}
