using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace WinApp.Views.UserHistory
{
    class Index : BaseView<DataListViewLayout>
    {
        public Index()
        {
            var list = (List<ViewUserActivityLog>)Model;

            MainView.Context = new ViewContext
            {
                Title = "Lịch sử hoạt động người dùng",
                Model = list,
                TableColumns = new Vst.Controls.TableColumn[]
                {
                    new Vst.Controls.TableColumn { Header = "Thời gian", Binding = "ThoiGianFormatted", Width = 150 },
                    new Vst.Controls.TableColumn { Header = "Người dùng", Binding = "TenNguoiDung", Width = 150 },
                    new Vst.Controls.TableColumn { Header = "Tài khoản", Binding = "TenDangNhap", Width = 120 },
                    new Vst.Controls.TableColumn { Header = "Hành động", Binding = "HanhDong", Width = 120 },
                    new Vst.Controls.TableColumn { Header = "Chức năng", Binding = "ChucNang", Width = 150 },
                    new Vst.Controls.TableColumn { Header = "Ghi chú", Binding = "GhiChu", Width = 250 }
                },
                Search = (item, text) =>
                {
                    var log = (ViewUserActivityLog)item;
                    return log.TenNguoiDung?.ToLower().Contains(text) == true ||
                           log.TenDangNhap?.ToLower().Contains(text) == true ||
                           log.HanhDong?.ToLower().Contains(text) == true ||
                           log.ChucNang?.ToLower().Contains(text) == true;
                }
            };
        }
    }
}