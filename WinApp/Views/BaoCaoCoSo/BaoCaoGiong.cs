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

    // Danh sách cơ sở giống - Click vào hàng mở báo cáo
    class Giong : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Cơ sở sản xuất giống cây trồng";
            context.TableColumns = new object[] {
                new TableColumn { Name = "Ten", Caption = "Tên cơ sở", Width = 200, },
                new TableColumn { Name = "DiaChi", Caption = "Địa chỉ", Width = 250, },
                new TableColumn { Name = "NguoiDaiDien", Caption = "Người đại diện", Width = 150, },
                new TableColumn { Name = "SDT", Caption = "Số điện thoại", Width = 120, },
            };
        }

        protected override void OnReady()
        {
            base.OnReady();

            // Tìm TableView và ghi đè sự kiện OpenItem
            var body = MainView.FindName("Body") as Border;
            if (body?.Child is Vst.Controls.TableView tableView)
            {
                // Tạo TableView mới
                var newTableView = new Vst.Controls.TableView();

                // Copy columns và data
                foreach (Vst.Controls.TableColumn col in tableView.Columns)
                {
                    newTableView.Columns.Add(col);
                }
                newTableView.ItemsSource = tableView.ItemsSource;

                // Gán event mới - mở báo cáo thay vì edit
                newTableView.OpenItem += e => {
                    var coSo = e as ViewCoSo;
                    if (coSo?.Id != null)
                    {
                        App.RedirectToAction("baocaogiong", coSo.Id.Value);
                    }
                };

                // Thay thế TableView cũ
                body.Child = newTableView;
            }
        }
    }

    // View báo cáo thống kê cơ sở giống
    class BaoCaoGiong : BaseView<FacilityReportLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);

            context.Title = "Báo cáo thống kê cơ sở giống";

            // Lấy thông tin cơ sở từ Model
            var coSoId = (int)context.Model;
            context.CoSoId = coSoId;

            var coSo = GetCoSoInfo(coSoId);

            // Phần 1: Thông tin cơ sở giống
            context.FacilityData = new Dictionary<string, string>
            {
                { "Tên cơ sở", coSo.Ten ?? "" },
                { "Địa chỉ", coSo.DiaChi ?? "" },
                { "Người đại diện", coSo.NguoiDaiDien ?? "" },
                { "Số điện thoại", coSo.SDT ?? "" },
                { "Loại cơ sở", coSo.TenLoaiCoSo ?? "" },
                { "Đơn vị quản lý", coSo.TenDonVi ?? "" }
            };

            // Lấy danh sách các kỳ có dữ liệu
            var availablePeriods = GetAvailablePeriods(coSoId);

            // Phần 2: Các bảng
            context.TableConfigs = new List<TableConfig>
            {
                // Bảng 1: Diện tích và sản lượng theo tháng/quý/năm
                new TableConfig
                {
                    Title = "Diện tích và sản lượng",
                    Columns = new object[]
                    {
                        new TableColumn { Name = "KySo", Caption = "Kỳ", Width = 80 },
                        new TableColumn { Name = "Nam", Caption = "Năm", Width = 80 },
                        new TableColumn { Name = "DienTich", Caption = "Diện tích (ha)", Width = 120 },
                        new TableColumn { Name = "SanLuong", Caption = "Sản lượng (tấn)", Width = 120 },
                        new TableColumn { Name = "GiaTriKy", Caption = "Giá trị (triệu)", Width = 120 },
                        new TableColumn { Name = "GhiChu", Caption = "Ghi chú", Width = 200 }
                    },
                    Items = GetThongKeList(coSoId),
                    AvailablePeriods = availablePeriods,
                    PeriodFilter = (item, loaiKy, kySo, nam) =>
                    {
                        var tk = (ThongKeCoSoGiong)item;
                        
                        // Filter theo loại kỳ
                        if (tk.LoaiKyBaoCaoId != loaiKy)
                            return false;
                        
                        // Nếu không chọn cụ thể (Tất cả) thì hiển thị tất cả theo loại kỳ
                        if (!kySo.HasValue || !nam.HasValue)
                            return true;
                        
                        // Filter theo kỳ cụ thể
                        return tk.KySo == kySo && tk.Nam == nam;
                    }
                },
                
                // Bảng 2: Danh sách giống cây với tìm kiếm
                new TableConfig
                {
                    Title = "Danh sách giống cây",
                    Columns = new object[]
                    {
                        new TableColumn { Name = "Ten", Caption = "Tên giống", Width = 200 },
                        new TableColumn { Name = "Nguon", Caption = "Nguồn gốc", Width = 150 },
                        new TableColumn { Name = "MoTa", Caption = "Mô tả", Width = 300 }
                    },
                    Items = GetGiongCayList(coSoId),
                    Search = (item, keyword) =>
                    {
                        var giong = (GiongCay)item;
                        return (giong.Ten != null && giong.Ten.ToLower().Contains(keyword)) ||
                               (giong.Nguon != null && giong.Nguon.ToLower().Contains(keyword)) ||
                               (giong.MoTa != null && giong.MoTa.ToLower().Contains(keyword));
                    }
                }
            };
        }

        private ViewCoSo GetCoSoInfo(int coSoId)
        {
            using (var db = new AppDbContext())
            {
                return db.ViewCoSos.FirstOrDefault(x => x.Id == coSoId) ?? new ViewCoSo
                {
                    Ten = "Cơ sở giống",
                    DiaChi = "Chưa có thông tin",
                    NguoiDaiDien = "Chưa có thông tin",
                    SDT = "",
                    TenLoaiCoSo = "Cơ sở giống cây trồng",
                    TenDonVi = ""
                };
            }
        }

        private List<PeriodInfo> GetAvailablePeriods(int coSoId)
        {
            using (var db = new AppDbContext())
            {
                // Lấy tất cả các kỳ có dữ liệu của cơ sở này
                var periods = db.ThongKeCoSoGiongs
                    .Where(x => x.CoSoId == coSoId)
                    .GroupBy(x => new { x.LoaiKyBaoCaoId, x.KySo, x.Nam })
                    .Select(g => new PeriodInfo
                    {
                        LoaiKyBaoCaoId = g.Key.LoaiKyBaoCaoId ?? 1,
                        KySo = g.Key.KySo,
                        Nam = g.Key.Nam
                    })
                    .ToList();

                return periods;
            }
        }

        private List<ThongKeCoSoGiong> GetThongKeList(int coSoId)
        {
            using (var db = new AppDbContext())
            {
                // Lấy tất cả thống kê của cơ sở
                return db.ThongKeCoSoGiongs
                    .Where(x => x.CoSoId == coSoId)
                    .OrderByDescending(x => x.Nam)
                    .ThenByDescending(x => x.KySo)
                    .ToList();
            }
        }

        private List<GiongCay> GetGiongCayList(int coSoId)
        {
            using (var db = new AppDbContext())
            {
                // Lấy các giống cây mà cơ sở này có
                var loaiGiongIds = db.CoSoGiongLoaiGiongs
                    .Where(x => x.CoSoId == coSoId)
                    .Select(x => x.LoaiGiongId)
                    .ToList();

                return db.GiongCays
                    .Where(x => loaiGiongIds.Contains(x.Id))
                    .OrderBy(x => x.Ten)
                    .ToList();
            }
        }
    }
}