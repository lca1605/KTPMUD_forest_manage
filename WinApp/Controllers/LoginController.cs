using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinApp.Controllers
{
    using Models;

    // Kế thừa DataController<TaiKhoan> -> Có sẵn kết nối SQL
    class LoginController : DataController<TaiKhoan>
    {
        public override object Index()
        {
            return View(new EditContext(new TaiKhoan()));
        }
        protected override void UpdateCore(TaiKhoan acc)
        {
            var pass = acc.MatKhau;
            acc = DataEngine.Find<TaiKhoan>(acc.TenDangNhap);

            if (acc == null)
            {
                UpdateContext.Message = "Người dùng không tồn tại";
                return;
            }
            if (acc.MatKhau != pass)
            {
                UpdateContext.Message = "Sai mật khẩu";
                return;
            }

            var userName = acc.TenDangNhap.Replace("'", "''");

            var role = Provider.GetTable<Quyen>().GetValueById("Ext", acc.QuyenId);
            var u = (User)Activator.CreateInstance(Type.GetType($"Actors.{role}"));

            u.UserName = acc.TenDangNhap;
            u.QuyenId = acc.QuyenId;
            if (acc.HoSoId != 0)
            {
                var p = Provider.GetTable<HoSo>().Find<HoSo>(acc.HoSoId);
                u.Description = p.Ten;
                u.HoTen = p.Ten;
                u.Profile = p;
            }
            App.User = u;
        }

        static int errorCount = 0;
        protected override object UpdateError()
        {
            const int max = 3;
            if (errorCount == max)
            {
                App.Current.Shutdown();
                return null;
            }
            UpdateContext.Message += $".\nĐược phép sai thêm {max - (++errorCount)} lần.";
            return Error(1, UpdateContext.Message);
        }
        protected override object UpdateSuccess()
        {
            errorCount = 0;
            return Redirect("home");
        }
    }
}