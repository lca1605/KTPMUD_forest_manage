using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace WinApp.Controllers
{
    // KẾ THỪA DataController<CoSo> giống HanhChinhController
    partial class CoSoController : DataController<CoSo>
    {
        protected override CoSo CreateEntity() => new CoSo { LoaiCoSoId = CoSo.LoaiCoSoDangXuLy };

        public object Add(CoSo one) => View(new EditContext { Model = one, Action = EditActions.Insert });

        public override object Index()
        {
            CheckUserActivity();
            // Trả về tất cả cơ sở cho View mới
            return View(CoSo.All);
        }

        protected object Select(int? loaiCoSoId)
        {
            return CoSo.DanhSach(CoSo.LoaiCoSoDangXuLy = loaiCoSoId);
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
                message = $"Không thể xóa {((CoSo)UpdateContext.Model).Ten}";
            }
            return base.Error(code, message);
        }
    }
}