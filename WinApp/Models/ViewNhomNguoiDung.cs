using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class ViewNhomNguoiDung
    {
        public int? Id { get; set; }
        public int? MaDonViId { get; set; }
        public string TenNhom { get; set; }
        public string TenDonVi { get; set; }
        public string CapDonVi { get; set; }
    }

    public partial class ViewNguoiDungTrongNhom
    {
        public string UserName { get; set; }
        public int? GroupId { get; set; }
        public string TenNhom { get; set; }
        public string TenNguoiDung { get; set; }
        public int? QuyenId { get; set; }
        public string TenQuyen { get; set; }
    }
}