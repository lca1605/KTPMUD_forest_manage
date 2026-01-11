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
            return View(CoSoService.DanhSach(CoSoService.LoaiCoSoDangXuLy));

        }

        protected object Select(int? loaiCoSoId)
        {
            return CoSoService.DanhSach(CoSoService.LoaiCoSoDangXuLy = loaiCoSoId);
        }

        public object Giong()
        {
            return View(Select(1));
        }

        public object Go()
        {
            return View(Select(2));
        }

        public object DongVat()
        {
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
            return View(id);
        }

        public object BaoCaoGo(int id)
        {
            return View(id);
        }

        public object BaoCaoDongVat(int id)
        {
            return View(id);
        }

        #region Không dùng Procedure - Insert/Update/Delete trực tiếp
        DataSchema.Table CoSoDb => Provider.GetTable<CoSo>();
        DataSchema.Table DiaChiDb => Provider.GetTable<DiaChi>();

        protected override string GetProcName() => null;

        protected override void TryInsert(ViewCoSo e)
        {
            Console.WriteLine(e.DiaChi);
            if (e.DiaChi == null)
            {
                Console.WriteLine("null");
            }
            var diaChi = new DiaChi
            {
                DiaChiDayDu = e.DiaChi
            };
            ExecSQL(DiaChiDb.CreateInsertSql(diaChi));
            var diaChiId = (int?)DiaChiDb.GetValue("Id", $"DiaChiDayDu = N'{e.DiaChi}'");

            var coSo = new CoSo
            {
                DonViId = e.DonViId,
                LoaiCoSoId = e.LoaiCoSoId,
                Ten = e.Ten,
                DiaChiId = diaChiId,
                SDT = e.SDT,
                NguoiDaiDien = e.NguoiDaiDien
            };

            GhiLichSu("INSERT", $"thêm mới cơ sở: {e.Ten}");
            ExecSQL(CoSoDb.CreateInsertSql(coSo));

            e.DonViId = diaChiId;
        }

        protected override void TryUpdate(ViewCoSo e)
        {
            var diaChi = new DiaChi
            {
                DiaChiDayDu = e.DiaChi
            };
            ExecSQL(DiaChiDb.CreateUpdateSql(diaChi));
            var diaChiId = (int?)DiaChiDb.GetValue("Id", $"DiaChiDayDu = N'{e.DiaChi}'");

            var coSo = new CoSo
            {
                DonViId = e.DonViId,
                LoaiCoSoId = e.LoaiCoSoId,
                Ten = e.Ten,
                DiaChiId = diaChiId,
                SDT = e.SDT,
                NguoiDaiDien = e.NguoiDaiDien
            };

            GhiLichSu("UPDATE", $"cập nhật cơ sở: {e.Ten}");
            ExecSQL(CoSoDb.CreateUpdateSql(coSo));

            e.DonViId = diaChiId;
        }

        protected override void TryDelete(ViewCoSo e)
        {
            GhiLichSu("DELETE", $"cóa cơ sở: {e.Ten}");
            ExecSQL(CoSoDb.CreateDeleteSql(new CoSo { Id = e.Id }));
        }
        #endregion
    }
}