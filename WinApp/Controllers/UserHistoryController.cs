using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using Services;

namespace WinApp.Controllers
{
    class UserHistoryController : DataController<ViewUserActivityLog>
    {
        public override object Index()
        {
            CheckUserActivity();
            var list = UserActivityLogService.DanhSach();
            return View(list);
        }

        public object ByUser(string username)
        {
            CheckUserActivity();
            var list = UserActivityLogService.DanhSachTheoNguoiDung(username);
            return View(list);
        }

        public object ByDate(DateTime fromDate, DateTime toDate)
        {
            CheckUserActivity();
            var list = UserActivityLogService.DanhSachTheoNgay(fromDate, toDate);
            return View(list);
        }
    }
}