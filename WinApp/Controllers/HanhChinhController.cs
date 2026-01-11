using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using Services;
using System.Mvc;

namespace WinApp.Controllers
{
    partial class HanhChinhController : DataController<ViewDonVi>
    {
        protected override ViewDonVi CreateEntity()
            => new ViewDonVi { HanhChinhId = DonViService.CapHanhChinhDangXuLy };

        public object Add(ViewDonVi one)
            => View(new EditContext { Model = one, Action = EditActions.Insert });

        public override object Index()
        {
            return View(Select(null));
        }

        protected object Select(int? cap)
        {
            return DonViService.DanhSach(DonViService.CapHanhChinhDangXuLy = cap);
        }

        public object Huyen() => View(Select(2));
        public object Xa() => View(Select(3));
        protected override object Error(int code, string message)
        {
            if (UpdateContext.Action == EditActions.Delete)
            {
                message = $"{((ViewDonVi)UpdateContext.Model).TenDayDu} có các đơn vị con";
            }
            return base.Error(code, message);
        }

        DataSchema.Table DonViDb => Provider.GetTable<DonVi>();

        protected override string GetProcName() => null;

        protected override void TryInsert(ViewDonVi e)
        {
            var donVi = new DonVi
            {
                Ten = e.Ten,
                HanhChinhId = e.HanhChinhId,
                TenHanhChinh = e.TenHanhChinh,
                TrucThuocId = e.TrucThuocId
            };

            GhiLichSu("INSERT", $"thêm đơn vị hành chính: {e.Ten}");
            ExecSQL(DonViDb.CreateInsertSql(donVi));
        }

        protected override void TryUpdate(ViewDonVi e)
        {
            var donVi = new DonVi
            {
                Id = e.Id,
                Ten = e.Ten,
                HanhChinhId = e.HanhChinhId,
                TenHanhChinh = e.TenHanhChinh,
                TrucThuocId = e.TrucThuocId
            };

            GhiLichSu("UPDATE", $"cập nhật đơn vị hành chính: {e.Ten}");
            ExecSQL(DonViDb.CreateUpdateSql(donVi));
        }

        protected override void TryDelete(ViewDonVi e)
        {
            GhiLichSu("DELETE", $"xóa đơn vị hành chính: {e.Ten}");
            ExecSQL(DonViDb.CreateDeleteSql(new DonVi { Id = e.Id }));
        } 
    }
}
