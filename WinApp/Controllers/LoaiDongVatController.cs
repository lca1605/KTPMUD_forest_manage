using Models;
using Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinApp.Controllers
{
    internal class LoaiDongVatController : DataController<LoaiDongVat>
    {
        protected override LoaiDongVat CreateEntity() => new LoaiDongVat();
        DataSchema.Table LoaiDongVatDb => Provider.GetTable<LoaiDongVat>();
        protected override string GetProcName() => null;
        protected override void TryInsert(LoaiDongVat e)
        {
            if (LoaiDongVatDb.GetValue("TenTiengViet", $"TenTiengViet = N'{e.TenTiengViet}'") != null)
            {
                UpdateContext.Message = "Đã có loài thú: " + e.TenTiengViet;
                return;
            }
            if (LoaiDongVatDb.GetValue("TenKhoaHoc", $"TenKhoaHoc = N'{e.TenKhoaHoc}'") != null)
            {
                UpdateContext.Message = "Đã có tên khoa học: " + e.TenKhoaHoc;
                return;
            }
            GhiLichSu("INSERT", $"thêm loài động vật: {e.TenTiengViet}");
            ExecSQL(LoaiDongVatDb.CreateInsertSql(e));
        }
        protected override void TryUpdate(LoaiDongVat e)
        {
            GhiLichSu("UPDATE", $"cập nhật loài động vật: {e.TenTiengViet}");
            ExecSQL(LoaiDongVatDb.CreateUpdateSql(e));
        }
        protected override void TryDelete(LoaiDongVat e)
        {
            string sqlDeleteRelative = $"DELETE FROM CoSoDongVatLoaiDongVat WHERE LoaiDongVatId = {e.Id}";
            ExecSQL(sqlDeleteRelative);
            GhiLichSu("DELETE", $"xóa loài động vật: {e.TenTiengViet}");
            ExecSQL(LoaiDongVatDb.CreateDeleteSql(e));
        }
    }
}
