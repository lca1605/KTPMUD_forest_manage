using System.Collections.Generic;
using WinApp.Views;

namespace WinApp.Views.Map
{
    // Trang Map: dùng layout mặc định MainUserLayout
    public class FacilityMap : BaseView<FacilityMapViewLayout, IEnumerable<object>>
    {
        protected override void RenderCore(ViewContext context)
        {
            context.Title = "Bản đồ cơ sở";
            context.BackUrl = App.LastUrl;
        }
    }
}
