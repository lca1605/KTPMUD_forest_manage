using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media;
using Vst.Controls;

namespace WinApp.Views.CoSo
{
    using Vst.Controls;
    using Models;

    class DongVat : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
    {
        base.RenderCore(context);
        context.Title = "Cơ sở lưu giữ động vật rừng";
        context.TableColumns = new object[] {
                new TableColumn { Name = "Ten", Caption = "Tên cơ sở", Width = 200, },
                new TableColumn { Name = "DiaChi", Caption = "Địa chỉ", Width = 250, },
                new TableColumn { Name = "NguoiDaiDien", Caption = "Người đại diện", Width = 150, },
                new TableColumn { Name = "SDT", Caption = "Số điện thoại", Width = 120, },
            };
    }
}
}