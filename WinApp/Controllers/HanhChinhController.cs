using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using System.Mvc; // QUAN TRỌNG: Dòng này sửa lỗi "The name 'View' does not exist"

namespace WinApp.Controllers
{
    partial class HanhChinhController
    {
        protected override ViewDonVi CreateEntity() => new ViewDonVi { HanhChinhId = DonVi.CapHanhChinhDangXuLy };

        public object Add(ViewDonVi one) => View(new EditContext { Model = one, Action = EditActions.Insert });

        public override object Index()
        {
            return View(Select(null));
        }

        protected object Select(int? cap)
        {
            return DonVi.DanhSach(DonVi.CapHanhChinhDangXuLy = cap);
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
    }
}