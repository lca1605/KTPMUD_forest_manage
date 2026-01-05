using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using Vst.Controls;

namespace WinApp.Views.LoaiDongVat
{
    using TC = TableColumn;
    using TE = EditorInfo;

    class Index : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Danh sách loài động vật ở Việt Nam";

            context.TableColumns = new TC[] {
                new TC { Name = "TenKhoaHoc", Caption = "Họ tên", Width = 250 },
                new TC { Name = "TenTiengViet", Caption = "Số điện thoại", Width = 250 },
                new TC { Name = "NhomLoai", Caption = "Email", Width = 150 },
                new TC { Name = "MucBaoTon", Caption = "Tên đăng nhập", Width = 150 },
            };

            context.Search = (o, s) =>
            {
                var e = (Models.ViewHoSo)o;
                return e.Ten.ToLower().Contains(s) || e.TenDangNhap.Contains(s);
            };
        }
    }
    class Edit : Add
    {
        protected override void OnReady()
        {
            Find("Id", e => e.IsEnabled = false);
            ShowDeleteAction("TenKhoaHoc");
        }
    }
    class Add : EditView
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Cập nhật loài động vật";
            context.Editors = new object[] {
                new TE { Name = "TenKhoaHoc", Caption = "Tên Khoa Học" },
                new TE { Name = "TenTiengViet", Caption = "Tên Tiếng Việt" },
                new TE { Name = "NhomLoai", Caption = "Nhóm loài",  Layout = 6 },
                new TE { Name = "MucBaoTon", Caption = "Mục bảo tồn",  Layout = 6 },
            };
        }
    }
}