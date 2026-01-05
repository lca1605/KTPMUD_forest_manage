using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace WinApp.Views.LichSuTacDong
{
    class Index : BaseView<DataListViewLayout>
    {
        public Index()
        {
            var list = (List<ViewLichSuTacDong>)Model;

            MainView.Context = new ViewContext
            {
                Title = "Lịch sử tác động",
                Model = list,
                TableColumns = new Vst.Controls.TableColumn[]
                {
                    new Vst.Controls.TableColumn { Header = "ID", Binding = "Id", Width = 80 },
                    new Vst.Controls.TableColumn { Header = "Tài khoản", Binding = "Ten", Width = 120 },
                    new Vst.Controls.TableColumn { Header = "Người dùng", Binding = "TenNguoiDung", Width = 150 },
                    new Vst.Controls.TableColumn { Header = "Hành động", Binding = "HanhDong", Width = 100 },
                    new Vst.Controls.TableColumn { Header = "Chức năng", Binding = "ChucNang", Width = 150 },
                    new Vst.Controls.TableColumn { Header = "Thời gian", Binding = "ThoiGian", Width = 150 },
                    new Vst.Controls.TableColumn { Header = "Ghi chú", Binding = "GhiChu", Width = 200 }
                },
                Search = (item, text) =>
                {
                    var g = (ViewLichSuTacDong)item;
                    return g.Ten?.ToLower().Contains(text) == true ||
                           g.HanhDong?.ToLower().Contains(text) == true;
                }
            };
        }
    }
}