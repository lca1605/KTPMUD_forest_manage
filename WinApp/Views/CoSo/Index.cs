using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using Vst.Controls;
using Services;

namespace WinApp.Views.CoSo
{
    using Models;
    using Vst.Controls;
    using TC = TableColumn;
    using TE = EditorInfo;

    class CoSoView : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Danh sách cơ sở";
            context.TableColumns = new object[] {
                new TC { Name = "Ten", Caption = "Tên cơ sở", Width = 200 },
                new TC { Name = "TenLoaiCoSo", Caption = "Loại cơ sở", Width = 200 },
                new TC { Name = "TenDonVi", Caption = "Đơn vị", Width = 150 },
                new TC { Name = "DiaChi", Caption = "Địa chỉ", Width = 200 },
                new TC { Name = "NguoiDaiDien", Caption = "Người đại diện", Width = 130 },
                new TC { Name = "SDT", Caption = "Số điện thoại", Width = 100 },
            };
            context.Search = (o, s) =>
            {
                var e = (ViewCoSo)o;
                return e.Ten.ToLower().Contains(s) ||
                       (e.DiaChi != null && e.DiaChi.ToLower().Contains(s));
            };
        }
    }

    class Index : CoSoView
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Quản lý cơ sở - Tất cả";
            context.Model = CoSoService.DanhSach(null);
        }
    }

    class Edit : Add
    {
        protected override void OnReady()
        {
            ShowDeleteAction("Ten");
            Find("Id", c => c.IsEnabled = false);
        }
    }

    class Add : EditView
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Thông tin cơ sở";
            context.Editors = new object[] {
                new TE { Name = "Ten", Caption = "Tên cơ sở", Layout = 12 },

                new TE { Name = "LoaiCoSoId", Caption = "Loại cơ sở", Layout = 6,
                    Type = "select", ValueName = "Id", DisplayName = "Ten",
                    Options = Provider.GetTable("LoaiCoSo").ToList<LoaiCoSo>(null, null) },

                new TE { Name = "DonViId", Caption = "Đơn vị", Layout = 6,
                    Type = "ssb", ValueName = "Id", DisplayName = "TenDayDu",
                    Options = DonViService.GetAll() },

                new TE { Name = "DiaChi", Caption = "Địa chỉ", Layout = 12 },
                new TE { Name = "NguoiDaiDien", Caption = "Người đại diện", Layout = 6 },
                new TE { Name = "SDT", Caption = "Số điện thoại", Layout = 6 },
            };
        }
    }
}