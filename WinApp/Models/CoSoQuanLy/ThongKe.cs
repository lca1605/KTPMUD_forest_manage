using Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WinApp.Views;

namespace Models
{
    public class ThongKeChart
    {
        public string Label { get; set; }
        public decimal Value { get; set; }
    }

    public partial class LoaiKyBaoCao
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
    }

    public class ChiTieuThongKe
    {
        public string Key { get; set; }
        public string Ten { get; set; }
        public string DonVi { get; set; }
    }

    public class BaoCaoThongKeContext : ViewContext
    {
        public int CoSoId { get; set; }
        public int LoaiCoSoId { get; set; }
        public int Nam { get; set; }
        public int LoaiKyBaoCaoId { get; set; }
        public string ChiTieuKey { get; set; }
        public BaoCaoProvider Provider { get; set; }
    }
}