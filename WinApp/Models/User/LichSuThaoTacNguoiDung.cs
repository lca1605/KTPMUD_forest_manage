using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public partial class TacDong
    {
        public int? Id { get; set; }
        public string Ma { get; set; }
    }

    public partial class LichSuTacDong
    {
        public int? Id { get; set; }
        public string TenTaiKhoan { get; set; }
        public int? TacDongId { get; set; }
        public DateTime? ThoiGian { get; set; }
        public string MoTa { get; set; }
    }
}