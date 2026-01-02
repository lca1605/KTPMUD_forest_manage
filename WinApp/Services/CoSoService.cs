using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace Services
{
    partial class CoSoService
    {
        static public int? LoaiCoSoDangXuLy { get; set; }

        static public List<ViewCoSo> DanhSach(int? loaiCoSoId)
        {
            var all = Provider.Select<ViewCoSo>();

            if (loaiCoSoId == null)
                return all;

            return all
                .Where(x => x.LoaiCoSoId == loaiCoSoId)
                .OrderBy(x => x.Ten)
                .ToList();
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