using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace Services
{
    public partial class UserGroupService
    {
        static public List<ViewNhomNguoiDung> DanhSachNhom()
        {
            return Provider.Select<ViewNhomNguoiDung>()
                .OrderBy(x => x.TenNhom)
                .ToList();
        }

        static public List<ViewNguoiDungTrongNhom> DanhSachNguoiDungTrongNhom(int? groupId = null)
        {
            var all = Provider.Select<ViewNguoiDungTrongNhom>();
            if (groupId == null)
                return all.OrderBy(x => x.TenNhom).ToList();

            return all
                .Where(x => x.GroupId == groupId)
                .OrderBy(x => x.TenNguoiDung)
                .ToList();
        }

        static public List<QuyenNhom> DanhSachQuyenNhom(int groupId)
        {
            return Provider.Select<QuyenNhom>()
                .Where(x => x.GroupId == groupId)
                .ToList();
        }

        static public List<TacDong> DanhSachTacDong()
        {
            return Provider.Select<TacDong>().ToList();
        }
    }
}