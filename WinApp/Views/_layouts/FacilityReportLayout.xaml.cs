using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Models;

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
            Header.DataContext = context;

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
            if (tableConfigs == null || tableConfigs.Count == 0)
                return;

            foreach (var config in tableConfigs)
            {
                // Container cho mỗi bảng
                var tableSection = new StackPanel
                {
                    Margin = new Thickness(0, 0, 0, 20)
                };

                // Header của bảng (tiêu đề + filter/search)
                var headerPanel = new Grid
                {
                    Margin = new Thickness(0, 0, 0, 10)
                };
                headerPanel.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                headerPanel.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

                // Tiêu đề bảng
                var title = new TextBlock
                {
                    Text = config.Title,
                    FontSize = 14,
                    FontWeight = FontWeights.Bold,
                    VerticalAlignment = VerticalAlignment.Center,
                    Foreground = new SolidColorBrush(Color.FromRgb(0x33, 0x33, 0x33))
                };
                Grid.SetColumn(title, 0);
                headerPanel.Children.Add(title);

                // Tạo bảng
                var grid = new Vst.Controls.TableView();

                var allItems = new List<object>();
                if (config.Items != null)
                {
                    foreach (var item in config.Items)
                    {
                        if (item != null)
                        {
                            allItems.Add(item);
                        }
                    }
                }

                // Set chiều cao ban đầu dựa trên số items
                int initialRowCount = allItems.Count;
                int initialVisibleRows = Math.Min(initialRowCount, 15); // Tối đa 15 dòng
                double initialHeight = 30 + (initialVisibleRows * 30) + 20; // header + rows + scrollbar
                grid.Height = initialHeight;

                // Thêm các cột từ config
                if (config.Columns != null)
                {
                    foreach (Vst.Controls.TableColumn col in config.Columns)
                    {
                        grid.Columns.Add(col);
                    }
                }


                // Kiểm tra nếu không có dữ liệu
                if (allItems.Count == 0)
                {
                    var noDataPanel = new Border
                    {
                        Height = 80,
                        Background = Brushes.White,
                        BorderBrush = new SolidColorBrush(Color.FromRgb(0xE0, 0xE0, 0xE0)),
                        BorderThickness = new Thickness(1),
                        Child = new TextBlock
                        {
                            Text = "Không có dữ liệu",
                            FontSize = 14,
                            Foreground = new SolidColorBrush(Color.FromRgb(0x99, 0x99, 0x99)),
                            FontStyle = FontStyles.Italic,
                            HorizontalAlignment = HorizontalAlignment.Center,
                            VerticalAlignment = VerticalAlignment.Center
                        }
                    };

                    tableSection.Children.Add(headerPanel);
                    tableSection.Children.Add(noDataPanel);
                    TablesContainer.Children.Add(tableSection);
                    continue;
                }

                grid.ItemsSource = allItems;

                // Xử lý sự kiện mở item
                grid.OpenItem += e => {
                    App.RedirectToAction("edit", e);
                };

                // Kiểm tra loại filter
                ComboBox periodTypeCombo = null;
                ComboBox periodCombo = null;
                Vst.Controls.SearchBox searchBox = null;
                TextBlock periodLabel = null;

                if (config.HasPeriodFilter)
                {
                    // Filter theo thời gian (tháng/quý/năm)
                    var filterPanel = new StackPanel
                    {
                        Orientation = Orientation.Horizontal,
                        VerticalAlignment = VerticalAlignment.Center
                    };

                    // Combo chọn loại kỳ (Tháng/Quý/Năm)
                    var periodTypeLabel = new TextBlock
                    {
                        Text = "Loại: ",
                        VerticalAlignment = VerticalAlignment.Center,
                        Margin = new Thickness(0, 0, 10, 0)
                    };

                    periodTypeCombo = new ComboBox
                    {
                        Width = 100,
                        Margin = new Thickness(0, 0, 15, 0)
                    };
                    periodTypeCombo.Items.Add(new ComboBoxItem { Content = "Tháng", Tag = 1 });
                    periodTypeCombo.Items.Add(new ComboBoxItem { Content = "Quý", Tag = 2 });
                    periodTypeCombo.Items.Add(new ComboBoxItem { Content = "Năm", Tag = 3 });
                    periodTypeCombo.SelectedIndex = 0;

                    // Label và Combo chọn kỳ cụ thể (sẽ ẩn/hiện theo loại)
                    periodLabel = new TextBlock
                    {
                        Text = "Chọn: ",
                        VerticalAlignment = VerticalAlignment.Center,
                        Margin = new Thickness(0, 0, 10, 0)
                    };

                    periodCombo = new ComboBox
                    {
                        Width = 200
                    };

                    filterPanel.Children.Add(periodTypeLabel);
                    filterPanel.Children.Add(periodTypeCombo);
                    filterPanel.Children.Add(periodLabel);
                    filterPanel.Children.Add(periodCombo);

                    Grid.SetColumn(filterPanel, 1);
                    headerPanel.Children.Add(filterPanel);
                }
                else if (config.HasSearch)
                {
                    // Tìm kiếm
                    searchBox = new Vst.Controls.SearchBox
                    {
                        Width = 200,
                        VerticalAlignment = VerticalAlignment.Center
                    };
                    Grid.SetColumn(searchBox, 1);
                    headerPanel.Children.Add(searchBox);
                }

                tableSection.Children.Add(headerPanel);
                tableSection.Children.Add(grid);

                // Lưu context để xử lý filter/search
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

                // Xử lý sự kiện thay đổi loại kỳ
                if (periodTypeCombo != null && periodCombo != null && periodLabel != null)
                {
                    periodTypeCombo.SelectionChanged += (s, e) =>
                    {
                        if (periodTypeCombo.SelectedItem is ComboBoxItem selectedType)
                        {
                            int loaiKy = (int)selectedType.Tag;

                            // Nếu chọn Năm (loaiKy = 3), ẩn label và combo "Chọn"
                            if (loaiKy == 3)
                            {
                                periodLabel.Visibility = Visibility.Collapsed;
                                periodCombo.Visibility = Visibility.Collapsed;

                                // Load danh sách năm và hiển thị data
                                LoadYearData(tableContext);
                            }
                            else
                            {
                                // Hiện lại label và combo "Chọn" cho Tháng/Quý
                                periodLabel.Visibility = Visibility.Visible;
                                periodCombo.Visibility = Visibility.Visible;

                                // Load dữ liệu theo loại
                                LoadPeriodCombo(tableContext, loaiKy);
                            }
                        }
                    };

                    // Load dữ liệu ban đầu (Tháng)
                    LoadPeriodCombo(tableContext, 1);

                    // Xử lý sự kiện chọn kỳ
                    periodCombo.SelectionChanged += (s, e) =>
                    {
                        ApplyPeriodFilter(tableContext);
                    };
                }

                // Xử lý sự kiện tìm kiếm
                if (searchBox != null)
                {
                    searchBox.Cleared += () =>
                    {
                        grid.ItemsSource = tableContext.OriginalItems;
                        UpdateTotalCount();
                    };

                    searchBox.Searching += (searchText) =>
                    {
                        ApplySearch(tableContext, searchText);
                    };
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
            Header.CreateAction(new ActionContext("Xuất báo cáo", () => App.RedirectToAction("export")));
        }
    }
}