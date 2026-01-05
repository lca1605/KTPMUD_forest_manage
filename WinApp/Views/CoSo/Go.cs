using System;
using System.Collections.Generic;
using System.Linq;
using Vst.Controls;
using Models;
using Services;
using WinApp.Views;

namespace WinApp.Views.CoSo
{
    using TC = TableColumn;

    // Màn hình danh sách cơ sở chế biến gỗ
    class Go : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Cơ sở chế biến gỗ";

            context.TableColumns = new object[] {
                new TableColumn { Name = "Ten", Caption = "Tên cơ sở", Width = 200 },
                new TableColumn { Name = "DiaChi", Caption = "Địa chỉ", Width = 250 },
                new TableColumn { Name = "NguoiDaiDien", Caption = "Người đại diện", Width = 150 },
                new TableColumn { Name = "SDT", Caption = "Số điện thoại", Width = 120 },
            };

            // Gán danh sách cơ sở vào Model (Loại 2: Chế biến gỗ)
            context.Model = CoSoService.DanhSach(2);
        }

        protected override void OnReady()
        {
            base.OnReady();
            MainView.OpenAction = "baocaogo";
        }
    }

    // Màn hình chi tiết báo cáo thống kê gỗ
    class BaoCaoGo : BaseView<FacilityReportLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            int coSoId = (int)context.Model;
            context.CoSoId = coSoId;

            // 1. Lấy thông tin cơ sở và chuyên ngành
            var coSo = CoSoService.DanhSach(2).FirstOrDefault(x => x.Id == coSoId);
            if (coSo == null) return;

            var chuyenNganh = GoService.LayThongTinChuyenNganh(coSoId);
            var loaiHinh = GoService.DanhMucLoaiHinh.FirstOrDefault(x => x.Id == chuyenNganh?.LoaiHinhSanXuatGoId);
            var hinhThuc = GoService.DanhMucHinhThuc.FirstOrDefault(x => x.Id == chuyenNganh?.HinhThucHoatDongGoId);

            context.Title = "Báo cáo thống kê cơ sở gỗ";

            // 2. Hiển thị thông tin Header
            context.FacilityData = new Dictionary<string, string> {
                { "Tên cơ sở", coSo.Ten },
                { "Địa chỉ", coSo.DiaChi },
                { "Loại hình sản xuất", loaiHinh?.Ten ?? "Chưa xác định" },
                { "Hình thức hoạt động", hinhThuc?.Ten ?? "Chưa xác định" },
                { "Người đại diện", coSo.NguoiDaiDien },
                { "Số điện thoại", coSo.SDT }
            };

            // 3. Cấu hình bảng thống kê diện tích, sản lượng gỗ
            var dsThongKe = GoService.LayLichSuThongKe(coSoId);

            context.TableConfigs = new List<TableConfig> {
                new TableConfig {
                    Title = "Thống kê sản lượng gỗ chế biến",
                    Columns = new object[] {
                        new TC { Name = "KySo", Caption = "Kỳ", Width = 80 },
                        new TC { Name = "Nam", Caption = "Năm", Width = 80 },
                        new TC { Name = "DienTich", Caption = "Diện tích (ha)", Width = 120 },
                        new TC { Name = "SanLuong", Caption = "Sản lượng (m³)", Width = 120 },
                        new TC { Name = "GiaTriKy", Caption = "Giá trị (triệu)", Width = 120 },
                        new TC { Name = "GhiChu", Caption = "Ghi chú", Width = 200 }
                    },
                    Items = dsThongKe,
                    AvailablePeriods = GoService.LayDanhSachKy(coSoId),
                    PeriodFilter = (item, type, ky, nam) => {
                        var x = (ThongKeCoSoGo)item;
                        return (type == 0 || x.LoaiKyBaoCaoId == type) &&
                               (ky == null || x.KySo == ky) &&
                               (nam == null || x.Nam == nam);
                    }
                }
            };
        }
    }
}