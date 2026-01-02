using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class DonVi
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public int? HanhChinhId { get; set; }
        public string TenHanhChinh { get; set; }
        public int? TrucThuocId { get; set; }
    }

    public class HanhChinh
    {
        public int Id { get; set; }
        public string Ten { get; set; }
        public int TrucThuocId { get; set; }
    }



    public class TenHanhChinh
    {
        public string Ten { get; set; }
        public int HanhChinhId { get; set; }
    }

    public partial class ViewDonVi
    {
        public int? Id { get; set; }
        public string Ten { get; set; }
        public int? HanhChinhId { get; set; }
        public string TenHanhChinh { get; set; }
        public int? TrucThuocId { get; set; }
        public string Cap { get; set; }
        public string TrucThuoc { get; set; }
        public string TenDayDu => $"{TenHanhChinh} {Ten}";
    }
    
}