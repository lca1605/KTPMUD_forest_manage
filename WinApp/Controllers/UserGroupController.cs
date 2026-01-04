using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using Services;

namespace WinApp.Controllers
{
    class UserGroupController : DataController<ViewNhomNguoiDung>
    {
        public override object Index()
        {
            CheckUserActivity();
            var list = UserGroupService.DanhSachNhom();
            return View(list);
        }

        public object Members(int groupId)
        {
            CheckUserActivity();
            var list = UserGroupService.DanhSachNguoiDungTrongNhom(groupId);
            return View(list);
        }

        public object Permissions(int groupId)
        {
            CheckUserActivity();
            var permissions = UserGroupService.DanhSachQuyenNhom(groupId);
            var actions = UserGroupService.DanhSachTacDong();
            return View(new { Permissions = permissions, Actions = actions, GroupId = groupId });
        }
    }
}