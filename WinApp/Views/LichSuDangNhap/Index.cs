using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace WinApp.Views.LichSuDangNhap
{
    class Index : BaseView<DataListViewLayout>
    {
        public Index()
        {
            var list = (List<ViewLichSuDangNhap>)Model;

            MainView.Context = new ViewContext
            {
                Title = "Lịch sử đăng nhập",
                Model = list,
                TableColumns = new Vst.Controls.TableColumn[]
                {
                    new Vst.Controls.TableColumn { Header = "ID", Binding = "Id", Width = 80 },
                    new Vst.Controls.TableColumn { Header = "Tài khoản", Binding = "Ten", Width = 120 },
                    new Vst.Controls.TableColumn { Header = "Người dùng", Binding = "TenNguoiDung", Width = 150 },
                    new Vst.Controls.TableColumn { Header = "Thời gian", Binding = "ThoiGian", Width = 150 },
                    new Vst.Controls.TableColumn { Header = "Trạng thái", Binding = "TrangThai", Width = 100 },
                    new Vst.Controls.TableColumn { Header = "Ghi chú", Binding = "GhiChu", Width = 250 }
                },
                Search = (item, text) =>
                {
                    var g = (ViewLichSuDangNhap)item;
                    return g.Ten?.ToLower().Contains(text) == true ||
                           g.TenNguoiDung?.ToLower().Contains(text) == true;
                }
            };
        }
    }
}