using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    partial class CoSo
    {
        static List<ViewCoSo> _all;
        static public List<ViewCoSo> All
        {
            get
            {
                if (_all == null || _all.Count == 0)
                    _all = Provider.Select<ViewCoSo>();
                return _all;
            }
        }

        static public int? LoaiCoSoDangXuLy { get; set; }

        static public List<ViewCoSo> DanhSach(int? loaiCoSoId)
        {
            if (loaiCoSoId == null)
                return All;

            var lst = new List<ViewCoSo>();
            lst.AddRange(All.Where(x => x.LoaiCoSoId == loaiCoSoId).OrderBy(x => x.Ten));
            return lst;
        }

        static LoaiCoSo[] _loaiCoSo;
        static public LoaiCoSo[] LoaiCoSoList
        {
            get
            {
                if (_loaiCoSo == null)
                {
                    _loaiCoSo = Provider.Select<LoaiCoSo>().ToArray();
                }
                return _loaiCoSo;
            }
        }
    }
}