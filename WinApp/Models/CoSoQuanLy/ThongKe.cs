using Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using WinApp.Views;

namespace Models
{
    public partial class LoaiKyBaoCao
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
    }

    public class PeriodInfo
    {
        public int LoaiKyBaoCaoId { get; set; }
        public int? KySo { get; set; }
        public int? Nam { get; set; }
    }

    public class TableConfig
    {
        public string Title { get; set; }
        public string ControllerName { get; set; }
        public string AddAction { get; set; }
        public string EditAction { get; set; }
        public System.Collections.IEnumerable Columns { get; set; }
        public System.Collections.IEnumerable Items { get; set; }
        public Func<object, int, int?, int?, bool> PeriodFilter { get; set; }
        public Func<object, string, bool> Search { get; set; }
        public List<PeriodInfo> AvailablePeriods { get; set; }

        public bool HasPeriodFilter => PeriodFilter != null;
        public bool HasSearch => Search != null;
    }

    public class TableFilterContext
    {
        public Vst.Controls.TableView TableView { get; set; }
        public List<object> AllItems { get; set; }
        public List<object> OriginalItems { get; set; }  // THAY ĐỔI: Từ IEnumerable thành List<object>
        public Func<object, int, int?, int?, bool> PeriodFilterFunc { get; set; }
        public Func<object, string, bool> SearchFunc { get; set; }
        public ComboBox PeriodTypeCombo { get; set; }
        public ComboBox PeriodCombo { get; set; }
        public Vst.Controls.SearchBox SearchBox { get; set; }
        public List<PeriodInfo> AvailablePeriods { get; set; }
        public System.Windows.Controls.TextBlock PeriodLabel { get; set; }
    }
    static class AppContexts
    {
        public static int? CurrentCoSoId { get; set; }
    }
}