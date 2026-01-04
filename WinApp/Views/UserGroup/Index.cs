using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace WinApp.Views.UserGroup
{
    class Index : BaseView<DataListViewLayout>
    {
        public Index()
        {
            var list = (List<ViewNhomNguoiDung>)Model;

            MainView.Context = new ViewContext
            {
                Title = "Danh sách nhóm người dùng",
                Model = list,
                TableColumns = new Vst.Controls.TableColumn[]
                {
                    new Vst.Controls.TableColumn { Header = "ID", Binding = "Id", Width = 80 },
                    new Vst.Controls.TableColumn { Header = "Tên nhóm", Binding = "TenNhom", Width = 300 },
                    new Vst.Controls.TableColumn { Header = "Đơn vị", Binding = "TenDonVi", Width = 200 },
                    new Vst.Controls.TableColumn { Header = "Cấp", Binding = "CapDonVi", Width = 150 }
                },
                Search = (item, text) =>
                {
                    var g = (ViewNhomNguoiDung)item;
                    return g.TenNhom?.ToLower().Contains(text) == true ||
                           g.TenDonVi?.ToLower().Contains(text) == true;
                }
            };
        }
    }
}
