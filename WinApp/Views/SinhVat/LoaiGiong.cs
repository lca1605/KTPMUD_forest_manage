using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using Vst.Controls;

namespace WinApp.Views.LoaiGiong
{
    using TC = TableColumn;
    using TE = EditorInfo;

    class Index : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Danh sách giống cây ở Việt Nam";

            context.TableColumns = new TC[] {
                new TC { Name = "Ten", Caption = "Tên Giống", Width = 250 },
                new TC { Name = "Nguon", Caption = "Nguồn giống", Width = 250 },
                new TC { Name = "MoTa", Caption = "Mô Tả", Width = 400 },
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
            ShowDeleteAction("Ten");
        }
    }
    class Add : EditView
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Cập nhật loài động vật";
            context.Editors = new object[] {
                new TE { Name = "Ten", Caption = "Tên Giống" },
                new TE { Name = "Nguon", Caption = "Nguồn Giống" },
                new TE { Name = "MoTa", Caption = "Mô Tả Giống" },
            };
        }
    }
}