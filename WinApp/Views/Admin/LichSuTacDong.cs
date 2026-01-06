using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Mvc;
using Vst.Controls;

namespace WinApp.Views.LichSuTacDong
{
    using TC = TableColumn;
    using TE = EditorInfo;
    class Index : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Lịch sử thao tác người dùng";

            MainView.Header.ActionPanel.Children.Clear();

            context.TableColumns = new TC[] {
                new TC { Name = "MoTa", Caption = "Thao Tác", Width = 500 },
                new TC { Name = "ThoiGian", Caption = "Thời gian", Width = 250 },
            };

            context.Search = (o, s) =>
            {
                var e = (Models.LichSuTacDong)o;
                return e.TenTaiKhoan.ToLower().Contains(s);
            };
        }
    }

    class Edit : Add
    {
        protected override void OnReady()
        {
            Find("Id", e => e.IsEnabled = false);
            ShowDeleteAction("TenTaiKhoan");
        }
    }
    class Add : EditView
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Cập nhật lịch sử chỉnh sủa người dùng";
            context.Editors = new object[] {
                new TE { Name = "MoTa", Caption = "Mô tả" },
            };
        }
    }
}
