using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using Services;

namespace WinApp.Controllers
{
    partial class CoSoController : DataController<ViewCoSo>
    {
        protected override ViewCoSo CreateEntity() => new ViewCoSo { LoaiCoSoId = CoSoService.LoaiCoSoDangXuLy };

        public object Add(ViewCoSo one) => View(new EditContext { Model = one, Action = EditActions.Insert });

        public override object Index()
        {
            CheckUserActivity();
            return View(CoSoService.DanhSach(CoSoService.LoaiCoSoDangXuLy));

        }

        protected object Select(int? loaiCoSoId)
        {
            return CoSoService.DanhSach(CoSoService.LoaiCoSoDangXuLy = loaiCoSoId);
        }

        public object Giong()
        {
            CheckUserActivity();
            return View(Select(1));
        }

        public object Go()
        {
            CheckUserActivity();
            return View(Select(2));
        }

        public object DongVat()
        {
            CheckUserActivity();
            return View(Select(3));
        }

        protected override object Error(int code, string message)
        {
            if (UpdateContext.Action == EditActions.Delete)
            {
                message = $"Không thể xóa {((ViewCoSo)UpdateContext.Model).Ten}";
            }
            return base.Error(code, message);
        }

        public object BaoCaoGiong(int id)
        {
            CheckUserActivity();
            return View(id);
        }

        public object BaoCaoGo(int id)
        {
            CheckUserActivity();
            return View(id);
        }

        #region Không dùng Procedure - Insert/Update/Delete trực tiếp
        DataSchema.Table CoSoDb => Provider.GetTable<CoSo>();

        protected override string GetProcName() => null;

        protected override void TryInsert(ViewCoSo e)
        {
            var coSo = new CoSo
            {
                DonViId = e.DonViId,
                LoaiCoSoId = e.LoaiCoSoId,
                Ten = e.Ten,
                DiaChi = e.DiaChi,
                SDT = e.SDT,
                NguoiDaiDien = e.NguoiDaiDien
            };

            var sql = CoSoDb.CreateInsertSql(coSo);
            ExecSQL(sql);
        }

        protected override void TryUpdate(ViewCoSo e)
        {
            var coSo = new CoSo
            {
                Id = e.Id,
                DonViId = e.DonViId,
                LoaiCoSoId = e.LoaiCoSoId,
                Ten = e.Ten,
                DiaChi = e.DiaChi,
                SDT = e.SDT,
                NguoiDaiDien = e.NguoiDaiDien
            };

            ExecSQL(CoSoDb.CreateUpdateSql(coSo));
        }

        protected override void TryDelete(ViewCoSo e)
        {
            ExecSQL(CoSoDb.CreateDeleteSql(new CoSo { Id = e.Id }));
        }
        #endregion
    }
}