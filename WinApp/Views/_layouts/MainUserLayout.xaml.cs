using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Vst.Controls;

namespace WinApp.Views
{
    /// <summary>
    /// Interaction logic for MainUserLayout.xaml
    /// </summary>
    public partial class MainUserLayout : UserControl
    {
        public MainUserLayout()
        {
            InitializeComponent();

            MeButton.SetAction(
                new ActionContext("Đăng xuất", "Home/Logout")
            );
        }
    }

    class AppMainMenu : HorizontalMenu
    {
        public AppMainMenu()
        {
            DataContextChanged += (s, e) => {
                foreach (ButtonBase btn in Children)
                {
                    var a = (ActionContext)btn.DataContext;
                    if (a.HasChild)
                    {
                        btn.Click += (_s, _e) => App.User.SideMenu = a;
                    }
                }
            };
        }
    }

}
