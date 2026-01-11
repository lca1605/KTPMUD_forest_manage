using Microsoft.Web.WebView2.Core;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using Vst.Controls;

namespace WinApp.Views
{
    public partial class FacilityMapViewLayout : UserControl, ILayout
    {
        public class FacilityPoint
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int TypeId { get; set; }
            public double Lat { get; set; }
            public double Lng { get; set; }
        }

        private List<FacilityPoint> _all = new List<FacilityPoint>();
        private List<FacilityPoint> _filtered = new List<FacilityPoint>();
        private bool _webReady;

        // === Base flow: engine sẽ gọi Render(context) ===
        public void Render(ViewContext context)
        {
            context.BackUrl = App.LastUrl;

            if (string.IsNullOrWhiteSpace(context.Title))
                context.Title = "Bản đồ cơ sở";

            // Nếu XAML bạn có PageHeader x:Name="Header"
            if (Header != null)
            {
                Header.DataContext = context;
                // Map có search riêng => ẩn search của header nếu có
                if (Header.SearchBox != null)
                    Header.SearchBox.Visibility = Visibility.Collapsed;
            }

            // Lấy danh sách từ context.Model
            if (context.Model is System.Collections.IEnumerable ie)
            {
                var pts = new List<FacilityPoint>();
                foreach (var item in ie)
                {
                    var p = ToFacilityPoint(item);
                    if (p != null) pts.Add(p);
                }
                SetFacilities(pts);
            }
            else
            {
                SetFacilities(new List<FacilityPoint>());
            }
        }

        public FacilityMapViewLayout()
        {
            InitializeComponent();

            // UI controls
            FacilitySearch.Placeholder = "Tìm cơ sở...";
            FacilitySelect.Placeholder = "Chọn cơ sở...";
            FacilitySelect.DisplayName = "Name";
            FacilitySelect.ValueName = "Id";

            FacilitySearch.Searching += q => ApplySearch(q);
            FacilitySearch.Cleared += () => ApplySearch(string.Empty);

            var cb = FacilitySelect.GetInput() as ComboBox;
            if (cb != null)
            {
                cb.SelectionChanged += (s, e) =>
                {
                    var selected = cb.SelectedItem as FacilityPoint;
                    if (selected != null) SelectFacilityOnMap(selected.Id);
                };
            }

            FitButton.Click += (s, e) => FitToFacilities();

            // WebView2
            MapWebView.CoreWebView2InitializationCompleted += OnWebInitCompleted;
            MapWebView.WebMessageReceived += OnWebMessageReceived;

            // Init WebView2
            try
            {
                MapWebView.EnsureCoreWebView2Async();
            }
            catch
            {
                _webReady = false;
            }
        }

        public void SetFacilities(IEnumerable<FacilityPoint> facilities)
        {
            _all = facilities != null ? facilities.Where(x => x != null).ToList() : new List<FacilityPoint>();
            _filtered = _all.ToList();

            FacilitySelect.SetOptions(_filtered);
            PushFacilitiesToMap(_filtered);
        }

        private void ApplySearch(string query)
        {
            if (query == null) query = string.Empty;

            var q = RemoveVietnameseDiacritics(query).Trim();

            if (string.IsNullOrWhiteSpace(q))
            {
                _filtered = _all.ToList();
            }
            else
            {
                _filtered = _all.Where(f =>
                {
                    var name = RemoveVietnameseDiacritics(f != null ? (f.Name ?? string.Empty) : string.Empty);
                    return name.Contains(q);
                }).ToList();
            }

            FacilitySelect.SetOptions(_filtered);
            PushFacilitiesToMap(_filtered);
            FitToFacilities();
        }

        private void OnWebInitCompleted(object sender, CoreWebView2InitializationCompletedEventArgs e)
        {
            if (!e.IsSuccess || MapWebView.CoreWebView2 == null)
            {
                _webReady = false;
                return;
            }

            var web = MapWebView.CoreWebView2;
            web.Settings.AreDefaultContextMenusEnabled = false;
            web.Settings.AreDevToolsEnabled = false;

            var htmlPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "facility_map.html");
            if (!File.Exists(htmlPath))
            {
                MapWebView.NavigateToString(
                    "<html><body style='font-family:Segoe UI;padding:20px'>" +
                    "<h3>Missing file: facility_map.html</h3>" +
                    "<p>Hãy set file là Content và Copy to Output Directory.</p>" +
                    "</body></html>"
                );
                _webReady = false;
                return;
            }

            MapWebView.Source = new Uri(htmlPath);
            _webReady = true;

            PushFacilitiesToMap(_filtered);
        }

        private void OnWebMessageReceived(object sender, CoreWebView2WebMessageReceivedEventArgs e)
        {
            try
            {
                // Ví dụ payload: { type:'markerClick', id: 123 }
                var jo = JObject.Parse(e.WebMessageAsJson);

                var typeToken = jo["type"];
                var type = typeToken != null ? typeToken.ToString() : null;

                if (type == "markerClick")
                {
                    var idToken = jo["id"];
                    int id;

                    if (idToken != null && int.TryParse(idToken.ToString(), out id))
                    {
                        var cb = FacilitySelect.GetInput() as ComboBox;
                        if (cb != null)
                        {
                            var found = _filtered.FirstOrDefault(x => x.Id == id) ?? _all.FirstOrDefault(x => x.Id == id);
                            if (found != null) cb.SelectedItem = found;
                        }
                    }
                }
            }
            catch
            {
                // ignore
            }
        }

        private async void PushFacilitiesToMap(IEnumerable<FacilityPoint> facilities)
        {
            if (!_webReady || MapWebView.CoreWebView2 == null) return;

            var list = facilities != null ? facilities.ToList() : new List<FacilityPoint>();

            // camelCase để khớp JS: id, name, typeId, lat, lng
            var payload = JsonConvert.SerializeObject(
                list,
                new JsonSerializerSettings
                {
                    ContractResolver = new CamelCasePropertyNamesContractResolver()
                }
            );

            try
            {
                await MapWebView.ExecuteScriptAsync("window.setFacilities(" + payload + ");");
            }
            catch
            {
                // ignore
            }
        }

        private async void SelectFacilityOnMap(int facilityId)
        {
            if (!_webReady || MapWebView.CoreWebView2 == null) return;
            try { await MapWebView.ExecuteScriptAsync("window.selectFacility(" + facilityId + ");"); } catch { }
        }

        private async void FitToFacilities()
        {
            if (!_webReady || MapWebView.CoreWebView2 == null) return;
            try { await MapWebView.ExecuteScriptAsync("window.fitToFacilities();"); } catch { }
        }

        private static string RemoveVietnameseDiacritics(string text)
        {
            if (string.IsNullOrEmpty(text)) return string.Empty;

            string normalized = text.Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder();

            foreach (char c in normalized)
            {
                var category = CharUnicodeInfo.GetUnicodeCategory(c);
                if (category != UnicodeCategory.NonSpacingMark) sb.Append(c);
            }

            return sb.ToString()
                     .Normalize(NormalizationForm.FormC)
                     .ToLowerInvariant();
        }

        // =========================
        // Convert context.Model item -> FacilityPoint
        // =========================

        private static FacilityPoint ToFacilityPoint(object item)
        {
            if (item == null) return null;

            var fp = item as FacilityPoint;
            if (fp != null) return fp;

            int? id = GetInt(item, "Id") ?? GetInt(item, "CoSoId");
            string name = GetString(item, "Name") ?? GetString(item, "Ten") ?? GetString(item, "TenCoSo") ?? GetString(item, "CoSoTen");
            int typeId = GetInt(item, "TypeId") ?? GetInt(item, "LoaiCoSoId") ?? 0;

            double? lat = GetDouble(item, "Lat") ?? GetDouble(item, "Latitude") ?? GetDouble(item, "ViDo");
            double? lng = GetDouble(item, "Lng") ?? GetDouble(item, "Longitude") ?? GetDouble(item, "KinhDo");

            if (!id.HasValue) return null;
            if (!lat.HasValue || !lng.HasValue) return null;

            return new FacilityPoint
            {
                Id = id.Value,
                Name = !string.IsNullOrEmpty(name) ? name : ("#" + id.Value),
                TypeId = typeId,
                Lat = lat.Value,
                Lng = lng.Value
            };
        }

        private static System.Reflection.PropertyInfo FindProp(object o, string name)
        {
            return o.GetType()
                    .GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance)
                    .FirstOrDefault(p => string.Equals(p.Name, name, StringComparison.OrdinalIgnoreCase));
        }

        private static string GetString(object o, string prop)
        {
            try
            {
                var p = FindProp(o, prop);
                var v = p != null ? p.GetValue(o, null) : null;
                return v != null ? v.ToString() : null;
            }
            catch { return null; }
        }

        private static int? GetInt(object o, string prop)
        {
            try
            {
                var p = FindProp(o, prop);
                var v = p != null ? p.GetValue(o, null) : null;
                if (v == null) return null;

                if (v is int) return (int)v;

                int r;
                if (int.TryParse(v.ToString(), out r)) return r;

                return null;
            }
            catch { return null; }
        }

        private static double? GetDouble(object o, string prop)
        {
            try
            {
                var p = FindProp(o, prop);
                var v = p != null ? p.GetValue(o, null) : null;
                if (v == null) return null;

                if (v is double) return (double)v;
                if (v is float) return (double)(float)v;
                if (v is decimal) return (double)(decimal)v;

                var s = v.ToString();
                if (string.IsNullOrWhiteSpace(s)) return null;

                s = s.Trim().Replace(',', '.');

                double r;
                if (double.TryParse(s, NumberStyles.Float, CultureInfo.InvariantCulture, out r)) return r;

                return null;
            }
            catch { return null; }
        }
    }
}
