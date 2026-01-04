using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using Vst.Controls;
using Services;
using Models;

namespace WinApp.Views.CoSo
{
    using Vst.Controls;
    using TC = TableColumn;
    using TE = EditorInfo;
    // Màn hình danh sách cơ sở
    class Giong : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Cơ sở sản xuất giống cây trồng";

            context.TableColumns = new object[] {
                new TableColumn { Name = "Ten", Caption = "Tên cơ sở", Width = 200 },
                new TableColumn { Name = "DiaChi", Caption = "Địa chỉ", Width = 250 },
                new TableColumn { Name = "NguoiDaiDien", Caption = "Người đại diện", Width = 150 },
                new TableColumn { Name = "SDT", Caption = "Số điện thoại", Width = 120 },
            };

            // Gán vào Model (Vì ViewContext không có DataSource)
            context.Model = CoSoService.DanhSach(1);
        }

        protected override void OnReady()
        {
            base.OnReady();
            MainView.OpenAction = "baocaogiong";
        }
    }

    // Màn hình chi tiết báo cáo
    class BaoCaoGiong : BaseView<FacilityReportLayout>
    {

        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            int coSoId = (int)context.Model;
            context.CoSoId = coSoId;


            // 1. Lấy thông tin cơ sở từ Service có sẵn
            var coSo = CoSoService.DanhSach(1).FirstOrDefault(x => x.Id == coSoId);
            if (coSo == null) return;

            context.Title = "Báo cáo thống kê cơ sở giống";
            context.CoSoId = coSoId;

            // 2. Đổ thông tin vào phần Header của Report
            context.FacilityData = new Dictionary<string, string> {
                { "Tên cơ sở", coSo.Ten },
                { "Địa chỉ", coSo.DiaChi },
                { "Người đại diện", coSo.NguoiDaiDien },
                { "Số điện thoại", coSo.SDT }
            };

            // 3. Cấu hình các bảng sử dụng đúng thuộc tính của TableConfig
            var dsThongKe = GiongService.LayLichSuThongKe(coSoId);
            var dsGiong = GiongService.LayDanhMucGiong();

            // TEST PeriodFilter với dữ liệu thực tế
            Func<object, int, int?, int?, bool> testFilter = (item, type, ky, nam) => {
                var x = (ThongKeCoSoGiong)item;
                bool result = (type == 0 || x.LoaiKyBaoCaoId == type) &&
                       (ky == null || x.KySo == ky) &&
                       (nam == null || x.Nam == nam);

                return result;
            };

            // Test ngay với dữ liệu
            var test2024 = dsThongKe.Where(x => {
                var item = x as object;
                return testFilter(item, 1, null, 2024);
            }).ToList();

            context.TableConfigs = new List<TableConfig> {
                new TableConfig {
                    Title = "Diện tích và sản lượng",
                    Columns = new object[] {
                        new TC { Name = "KySo", Caption = "Kỳ", Width = 80 },
                        new TC { Name = "Nam", Caption = "Năm", Width = 80 },
                        new TC { Name = "DienTich", Caption = "Diện tích (ha)", Width = 120 },
                        new TC { Name = "SanLuong", Caption = "Sản lượng (tấn)", Width = 120 },
                        new TC { Name = "GiaTriKy", Caption = "Giá trị (triệu)", Width = 120 },
                        new TC { Name = "GhiChu", Caption = "Ghi chú", Width = 200 }
                    },
                    Items = dsThongKe,
                    AvailablePeriods = GiongService.LayDanhSachKy(coSoId),
                    PeriodFilter = testFilter
                },
                new TableConfig {
                    Title = "Danh sách giống cây đang sản xuất",
                    Columns = new object[] {
                        new TC { Name = "Ten", Caption = "Tên giống", Width = 200 },
                        new TC { Name = "Nguon", Caption = "Nguồn gốc", Width = 400 },
                        new TC { Name = "MoTa", Caption = "Mô tả", Width = 400 }
                    },
                    Items = dsGiong,
                    Search = (item, text) => {
                        var x = (GiongCay)item;
                        return x.Ten.ToLower().Contains(text.ToLower()) ||
                               (x.Nguon != null && x.Nguon.ToLower().Contains(text.ToLower()));
                    }
                }
            };


        }
    }
}