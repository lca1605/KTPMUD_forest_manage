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

    // 1. Màn hình danh sách cơ sở (Giữ nguyên phong cách cũ nhưng đồng bộ OpenAction)
    class DongVat : BaseView<DataListViewLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);
            context.Title = "Cơ sở lưu giữ động vật rừng";

            context.TableColumns = new object[] {
                new TC { Name = "Ten", Caption = "Tên cơ sở", Width = 200 },
                new TC { Name = "DiaChi", Caption = "Địa chỉ", Width = 250 },
                new TC { Name = "NguoiDaiDien", Caption = "Người đại diện", Width = 150 },
                new TC { Name = "SDT", Caption = "Số điện thoại", Width = 120 },
            };

            context.Model = CoSoService.DanhSach(3); // Loại 3: Động vật
        }

        protected override void OnReady()
        {
            base.OnReady();
            MainView.OpenAction = "baocaodongvat";
        }
    }

    // 2. Màn hình chi tiết báo cáo thống kê - LÀM MỚI THEO STYLE GO.CS
    class BaoCaoDongVat : BaseView<FacilityReportLayout>
    {
        protected override void RenderCore(ViewContext context)
        {
            base.RenderCore(context);

            // Lấy CoSoId từ model truyền vào
            int coSoId = (int)context.Model;
            context.CoSoId = coSoId;

            // 1. Lấy thông tin cơ sở
            var coSo = CoSoService.DanhSach(3).FirstOrDefault(x => x.Id == coSoId);
            if(coSo == null) return;

            context.Title = "Báo cáo thống kê sinh vật rừng";
            context.CoSoId = coSoId;

            context.FacilityData = new Dictionary<string, string> {
                { "Tên cơ sở", coSo.Ten },
                { "Địa chỉ", coSo.DiaChi },
                { "Người đại diện", coSo.NguoiDaiDien },
                { "Số điện thoại", coSo.SDT }
            };

            // 3. Cấu hình bảng thống kê dựa trên dữ liệu mới
            // Service đã có TenLoai và SoLuongLoai
            var dsThongKe = DongVatService.LayLichSuThongKe(coSoId);

            context.TableConfigs = new List<TableConfig> {
                new TableConfig {
                    Title = "Thống kê số lượng cá thể theo loài",
                    Columns = new object[] {
                        new TC { Name = "TenLoai", Caption = "Tên loài động vật", Width = 180 },
                        new TC { Name = "KySo", Caption = "Kỳ", Width = 80 },
                        new TC { Name = "Nam", Caption = "Năm", Width = 80 },
                        new TC { Name = "SoLuongLoai", Caption = "Số lượng", Width = 120 },
                        new TC { Name = "GhiChu", Caption = "Ghi chú", Width = 250 }
                    },
                    Items = dsThongKe,
                    
                    // Sử dụng bộ lọc kỳ báo cáo giống hệt Go.cs
                    AvailablePeriods = DongVatService.LayDanhSachKy(coSoId),
                    PeriodFilter = (item, type, ky, nam) => {
                        var x = (ThongKeSoLuongDongVat)item;
                        return (type == 0 || x.LoaiKyBaoCaoId == type) &&
                               (ky == 0 || x.KySo == ky) &&
                               (nam == 0 || x.Nam == nam);
                    }
                }
            };
        }
    }
}