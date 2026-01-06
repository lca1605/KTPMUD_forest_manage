using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinApp.Views.Login
{
    using Vst.Controls;
    class Index : EditView
    {
        protected override object CreateLayout() => null;
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Editors = new object[] {
                new EditorInfo { Name = "TenDangNhap", Caption = "Tên đăng nhập" },
                new EditorInfo { Name = "MatKhau", Type = "password", Caption = "Mật khẩu", Placeholder = "Mật khẩu" },
                //new EditorInfo { Name = "Keep", Type = "check", Caption = "Tự động đăng nhập cho lần sau" },
            };
            context.Title = "ĐĂNG NHẬP";
            MainView.CancelButton.IsVisible = false;
        }
    }
}
