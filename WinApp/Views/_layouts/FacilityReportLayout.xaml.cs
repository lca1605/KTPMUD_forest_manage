using Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Vst.Controls;

namespace WinApp.Views
{
    /// <summary>
    /// Interaction logic for FacilityReportLayout.xaml
    /// </summary>
    public partial class FacilityReportLayout : UserControl, ILayout
    {
        private List<TableFilterContext> tableContexts = new List<TableFilterContext>();
        private int currentCoSoId = 0;

        public void Render(ViewContext context)
        {
            Console.WriteLine($"[DEBUG] Rendering FacilityReport. CoSoId in Context: {context.CoSoId}");

            if (context.FacilityData == null)
                Console.WriteLine("[DEBUG] WARNING: FacilityData is NULL");
            else
                Console.WriteLine($"[DEBUG] FacilityData count: {context.FacilityData.Count}");

            if (context.TableConfigs == null)
                Console.WriteLine("[DEBUG] WARNING: TableConfigs is NULL");
            context.BackUrl = App.LastUrl;
            Header.DataContext = context;
            Header.SearchBox.Visibility = Visibility.Collapsed;


            // Lưu CoSoId
            if (context.CoSoId.HasValue)
            {
                currentCoSoId = context.CoSoId.Value;
            }

            // Phần 1: Render thông tin cơ sở
            if (context.FacilityData != null)
            {
                RenderFacilityInfo(context.FacilityData);
            }

            // Phần 2: Render các bảng với filter
            if (context.TableConfigs != null)
            {
                RenderTables(context);
            }

            UpdateTotalCount();
        }

        private void RenderFacilityInfo(Dictionary<string, string> facilityData)
        {
            FacilityInfo.Children.Clear();

            if (facilityData == null || facilityData.Count == 0)
                return;

            foreach (var item in facilityData)
            {
                var infoPanel = new StackPanel
                {
                    Orientation = Orientation.Horizontal,
                    Margin = new Thickness(0, 3, 0, 3)
                };

                var label = new TextBlock
                {
                    Text = item.Key + ": ",
                    FontWeight = FontWeights.SemiBold,
                    Foreground = new SolidColorBrush(Color.FromRgb(0x66, 0x66, 0x66)),
                    MinWidth = 150
                };

                var value = new TextBlock
                {
                    Text = item.Value,
                    Foreground = new SolidColorBrush(Color.FromRgb(0x33, 0x33, 0x33))
                };

                infoPanel.Children.Add(label);
                infoPanel.Children.Add(value);
                FacilityInfo.Children.Add(infoPanel);
            }
        }

        private void RenderTables(ViewContext context)
        {
            TablesContainer.Children.Clear();
            tableContexts.Clear();

            var tableConfigs = context.TableConfigs;
            if (tableConfigs == null || tableConfigs.Count == 0) return;

            foreach (var config in tableConfigs)
            {
                // 1. Container cho mỗi bảng
                var tableSection = new StackPanel { Margin = new Thickness(0, 0, 0, 25) };

                // 2. Header Grid: Chia làm 2 cột (Tiêu đề bên trái, Filter/Nút bên phải)
                var headerPanel = new Grid { Margin = new Thickness(0, 0, 0, 10) };
                headerPanel.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                headerPanel.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

                // Tiêu đề bảng
                var title = new TextBlock
                {
                    Text = config.Title,
                    FontSize = 15,
                    FontWeight = FontWeights.Bold,
                    VerticalAlignment = VerticalAlignment.Center,
                    Foreground = new SolidColorBrush(Color.FromRgb(0x33, 0x33, 0x33))
                };
                headerPanel.Children.Add(title);

                // Group điều khiển bên phải (Nút thêm + Search/Filter)
                var controlPanel = new StackPanel { Orientation = Orientation.Horizontal, VerticalAlignment = VerticalAlignment.Center };
                Grid.SetColumn(controlPanel, 1);
                headerPanel.Children.Add(controlPanel);

                // 3. Nút Thêm mới (nếu có)
                if (!string.IsNullOrEmpty(config.ControllerName) && !string.IsNullOrEmpty(config.AddAction))
                {
                    var btnAdd = new Vst.Controls.Button
                    {
                        Width = 75,
                        Height = 26,
                        BorderRadius = 13,
                        FontSize = 11,
                        Margin = new Thickness(10, 0, 0, 0) // Cách ra khỏi filter
                    };
                    btnAdd.SetAction(new ActionContext("+ Thêm", () => {
                        object args = currentCoSoId > 0 ? new { coSoId = currentCoSoId } : null;
                        AppContexts.CurrentCoSoId = currentCoSoId;
                        App.RedirectToAction(config.AddAction, currentCoSoId);
                    }));
                    controlPanel.Children.Add(btnAdd);
                }

                // 4. Khởi tạo Bảng dữ liệu
                var grid = new Vst.Controls.TableView();
                var allItems = config.Items?.Cast<object>().ToList() ?? new List<object>();

                // Tính toán chiều cao linh hoạt (Max 15 dòng)
                int initialVisibleRows = Math.Min(allItems.Count, 15);
                if (initialVisibleRows == 0) initialVisibleRows = 2; // Chiều cao tối thiểu nếu trống
                grid.Height = 35 + (initialVisibleRows * 30) + 15;

                // Sự kiện Double Click để sửa
                grid.OpenItem += (item) => {
                    if (item != null && !string.IsNullOrEmpty(config.ControllerName) && !string.IsNullOrEmpty(config.EditAction))
                    {
                        var idValue = item.GetType().GetProperty("Id")?.GetValue(item);
                        if (idValue != null) App.Request(config.ControllerName + "/" + config.AddAction, currentCoSoId);
                    }
                };

                // Thêm cột
                if (config.Columns != null)
                {
                    foreach (Vst.Controls.TableColumn col in config.Columns) grid.Columns.Add(col);
                }

                // 5. Xử lý Filter & Search (Gán vào controlPanel bên phải)
                ComboBox periodTypeCombo = null; ComboBox periodCombo = null;
                Vst.Controls.SearchBox searchBox = null; TextBlock periodLabel = null;

                if (config.HasPeriodFilter)
                {
                    var filterStack = new StackPanel { Orientation = Orientation.Horizontal };
                    periodTypeCombo = new ComboBox { Width = 90, Margin = new Thickness(5, 0, 5, 0) };
                    periodTypeCombo.Items.Add(new ComboBoxItem { Content = "Tháng", Tag = 1 });
                    periodTypeCombo.Items.Add(new ComboBoxItem { Content = "Quý", Tag = 2 });
                    periodTypeCombo.Items.Add(new ComboBoxItem { Content = "Năm", Tag = 3 });
                    periodTypeCombo.SelectedIndex = 0;

                    periodLabel = new TextBlock { Text = " Kỳ: ", VerticalAlignment = VerticalAlignment.Center };
                    periodCombo = new ComboBox { Width = 150 };

                    filterStack.Children.Add(new TextBlock { Text = "Loại: ", VerticalAlignment = VerticalAlignment.Center });
                    filterStack.Children.Add(periodTypeCombo);
                    filterStack.Children.Add(periodLabel);
                    filterStack.Children.Add(periodCombo);
                    controlPanel.Children.Insert(0, filterStack); // Ưu tiên Filter nằm trước nút Thêm
                }
                else if (config.HasSearch)
                {
                    searchBox = new Vst.Controls.SearchBox { Width = 180 };
                    controlPanel.Children.Insert(0, searchBox);
                }

                // 6. Assemble các thành phần vào Layout
                tableSection.Children.Add(headerPanel);

                if (allItems.Count == 0)
                {
                    tableSection.Children.Add(new Border
                    {
                        Height = 80,
                        Background = Brushes.White,
                        CornerRadius = new CornerRadius(4),
                        BorderBrush = new SolidColorBrush(Color.FromRgb(0xE0, 0xE0, 0xE0)),
                        BorderThickness = new Thickness(1),
                        Child = new TextBlock
                        {
                            Text = "Không có dữ liệu",
                            FontSize = 13,
                            FontStyle = FontStyles.Italic,
                            Foreground = Brushes.Gray,
                            HorizontalAlignment = HorizontalAlignment.Center,
                            VerticalAlignment = VerticalAlignment.Center
                        }
                    });
                }
                else
                {
                    grid.ItemsSource = allItems;
                    tableSection.Children.Add(grid);
                }

                // Lưu context cho filter logic
                var tableContext = new TableFilterContext
                {
                    TableView = grid,
                    AllItems = allItems,
                    OriginalItems = allItems,
                    PeriodFilterFunc = config.PeriodFilter,
                    SearchFunc = config.Search,
                    PeriodTypeCombo = periodTypeCombo,
                    PeriodCombo = periodCombo,
                    SearchBox = searchBox,
                    AvailablePeriods = config.AvailablePeriods,
                    PeriodLabel = periodLabel
                };
                tableContexts.Add(tableContext);

                // Gán logic Filter/Search (Giống code của bạn)
                if (periodTypeCombo != null)
                {
                    periodTypeCombo.SelectionChanged += (s, e) => {
                        int loaiKy = (int)((ComboBoxItem)periodTypeCombo.SelectedItem).Tag;
                        if (loaiKy == 3) { periodLabel.Visibility = periodCombo.Visibility = Visibility.Collapsed; LoadYearData(tableContext); }
                        else { periodLabel.Visibility = periodCombo.Visibility = Visibility.Visible; LoadPeriodCombo(tableContext, loaiKy); }
                    };
                    LoadPeriodCombo(tableContext, 1);
                    periodCombo.SelectionChanged += (s, e) => ApplyPeriodFilter(tableContext);
                }
                if (searchBox != null)
                {
                    searchBox.Cleared += () => { grid.ItemsSource = allItems; UpdateTotalCount(); };
                    searchBox.Searching += (txt) => ApplySearch(tableContext, txt);
                }

                TablesContainer.Children.Add(tableSection);
            }
        }

        private void LoadPeriodCombo(TableFilterContext context, int loaiKyBaoCao)
        {
            context.PeriodCombo.Items.Clear();

            if (context.AvailablePeriods == null || context.AvailablePeriods.Count == 0)
            {
                context.PeriodCombo.Items.Add(new ComboBoxItem
                {
                    Content = "Không có dữ liệu",
                    Tag = null,
                    IsEnabled = false
                });
                context.PeriodCombo.SelectedIndex = 0;
                return;
            }

            // Lọc các kỳ theo loại
            var periods = new List<PeriodInfo>();
            foreach (var p in context.AvailablePeriods)
            {
                if (p.LoaiKyBaoCaoId == loaiKyBaoCao)
                {
                    periods.Add(p);
                }
            }

            // Sắp xếp giảm dần
            periods = periods.OrderByDescending(p => p.Nam).ThenByDescending(p => p.KySo).ToList();

            if (periods.Count == 0)
            {
                context.PeriodCombo.Items.Add(new ComboBoxItem
                {
                    Content = "Không có dữ liệu",
                    Tag = null,
                    IsEnabled = false
                });
                context.PeriodCombo.SelectedIndex = 0;
                return;
            }

            // Nhóm theo năm
            var yearGroups = periods.GroupBy(p => p.Nam).OrderByDescending(g => g.Key);

            foreach (var yearGroup in yearGroups)
            {
                int? nam = yearGroup.Key;

                // Thêm option "Năm XXXX - Tất cả"
                string allLabel = loaiKyBaoCao == 1 ? $"Năm {nam} - Tất cả" : $"Năm {nam} - Tất cả";
                context.PeriodCombo.Items.Add(new ComboBoxItem
                {
                    Content = allLabel,
                    Tag = new PeriodInfo { LoaiKyBaoCaoId = loaiKyBaoCao, KySo = null, Nam = nam },
                    FontWeight = FontWeights.SemiBold,
                    Foreground = new SolidColorBrush(Color.FromRgb(0x00, 0x7A, 0xCC))
                });

                // Thêm các kỳ cụ thể trong năm đó
                var periodsInYear = yearGroup.OrderByDescending(p => p.KySo);
                foreach (var period in periodsInYear)
                {
                    string label = "";
                    switch (loaiKyBaoCao)
                    {
                        case 1: // Tháng
                            label = $"  Tháng {period.KySo}/{period.Nam}";
                            break;
                        case 2: // Quý
                            label = $"  Quý {period.KySo}/{period.Nam}";
                            break;
                    }

                    context.PeriodCombo.Items.Add(new ComboBoxItem
                    {
                        Content = label,
                        Tag = period
                    });
                }
            }

            context.PeriodCombo.SelectedIndex = 0;
        }

        private void LoadYearData(TableFilterContext context)
        {
            if (context.AvailablePeriods == null || context.AvailablePeriods.Count == 0)
            {
                // Hiển thị tất cả data
                context.TableView.ItemsSource = context.OriginalItems;
                UpdateTotalCount();
                return;
            }

            // Lấy danh sách năm có data (loại = 3 - Năm)
            var years = context.AvailablePeriods
                .Where(p => p.LoaiKyBaoCaoId == 3 && p.Nam.HasValue)
                .Select(p => p.Nam.Value)
                .Distinct()
                .OrderByDescending(y => y)
                .ToList();

            if (years.Count == 0)
            {
                // Không có data năm, hiển thị tất cả
                context.TableView.ItemsSource = context.OriginalItems;
                UpdateTotalCount();
                return;
            }

            // Lấy năm đầu tiên (mới nhất) và filter
            int selectedYear = years.First();
            ApplyYearFilter(context, selectedYear);
        }

        private void ApplyYearFilter(TableFilterContext context, int nam)
        {
            if (context.PeriodFilterFunc == null)
            {
                context.TableView.ItemsSource = context.OriginalItems;
                UpdateTotalCount();
                return;
            }

            // Filter theo năm (loại = 3)
            var filtered = new List<object>();
            foreach (var item in context.AllItems)
            {
                if (context.PeriodFilterFunc(item, 3, null, nam))
                {
                    filtered.Add(item);
                }
            }
            context.TableView.ItemsSource = filtered;
            UpdateTotalCount();
        }

        private void ApplyPeriodFilter(TableFilterContext context)
        {
            if (context.PeriodCombo.SelectedItem is ComboBoxItem selectedItem)
            {
                var period = selectedItem.Tag as PeriodInfo;

                if (period == null || context.PeriodFilterFunc == null)
                {
                    context.TableView.ItemsSource = context.OriginalItems;
                    UpdateTotalCount();
                    return;
                }

                // Nếu không chọn cụ thể (Tất cả theo năm)
                if (!period.KySo.HasValue && period.Nam.HasValue)
                {
                    // Hiển thị tất cả theo loại kỳ và năm
                    var filtered = new List<object>();
                    foreach (var item in context.AllItems)
                    {
                        if (context.PeriodFilterFunc(item, period.LoaiKyBaoCaoId, null, period.Nam))
                        {
                            filtered.Add(item);
                        }
                    }

                    context.TableView.ItemsSource = filtered;
                }
                else if (period.KySo.HasValue && period.Nam.HasValue)
                {
                    // Filter theo kỳ cụ thể
                    var filtered = new List<object>();
                    foreach (var item in context.AllItems)
                    {
                        if (context.PeriodFilterFunc(item, period.LoaiKyBaoCaoId, period.KySo, period.Nam))
                        {
                            filtered.Add(item);
                        }
                    }
                    context.TableView.ItemsSource = filtered;
                }
                else
                {
                    // Hiển thị tất cả
                    context.TableView.ItemsSource = context.OriginalItems;
                }

                UpdateTotalCount();
            }
        }

        private void ApplySearch(TableFilterContext context, string searchText)
        {
            if (context.SearchFunc == null)
            {
                context.TableView.ItemsSource = context.OriginalItems;
                return;
            }

            var filtered = new List<object>();
            searchText = searchText.ToLower();
            foreach (var item in context.AllItems)
            {
                if (context.SearchFunc(item, searchText))
                {
                    filtered.Add(item);
                }
            }
            context.TableView.ItemsSource = filtered;
            UpdateTotalCount();
        }

        private void UpdateTotalCount()
        {
            int totalRows = 0;
            foreach (var context in tableContexts)
            {
                totalRows += context.TableView.RowsCount;
            }
            Total.Text = totalRows.ToString();
        }

        public FacilityReportLayout()
        {
            InitializeComponent();
        }
    }
}