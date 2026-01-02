using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace Services
{
    partial class DonViService
    {
        static public List<ViewDonVi> GetAll()
        {
            return Provider.Select<ViewDonVi>();
        }

        static public int? CapHanhChinhDangXuLy { get; set; }
        static public List<ViewDonVi> DanhSach(int? cap)
        {
            var all = GetAll();

            if (cap == null)
                return all;

            return all
                .Where(x => x.HanhChinhId == cap)
                .OrderBy(x => x.Ten)
                .ToList();
        }

        static HanhChinh[] _hanhChinh;
        static public HanhChinh[] HanhChinh
        {
            get
            {
                if (_hanhChinh == null)
                {
                    _hanhChinh = Provider.Select<HanhChinh>().ToArray();
                }
                return _hanhChinh;
            }
        }
    }
}
