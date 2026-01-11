using System.Collections.Generic;
using System;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using Services;
using WinApp.Views.Map;

namespace WinApp.Controllers
{
    class FacilityMapController : BaseController
    {
        public object Index()
        { 

            var points = CoSoService.TatCaCoSo;
            return View(new FacilityMap(), points);
        }
    }
}

