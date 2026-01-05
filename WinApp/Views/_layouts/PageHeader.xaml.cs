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

namespace WinApp.Views
{
    /// <summary>
    /// Interaction logic for PageHeader.xaml
    /// </summary>
    public partial class PageHeader : UserControl
    {
        public PageHeader()
        {
            InitializeComponent();
            this.DataContextChanged += (s, e) => {
                if (e.NewValue is ViewContext context && !string.IsNullOrEmpty(context.BackUrl))
                {
                    // Sử dụng ký tự mũi tên to (Left Arrow)
                    BtnBack.SetAction(new ActionContext("\u2190", () => {
                        System.Mvc.Engine.Execute(context.BackUrl);
                    }));

                    BtnBack.Visibility = Visibility.Visible;
                }
                else
                {
                    BtnBack.Visibility = Visibility.Collapsed;
                }
            };
        }

        public Vst.Controls.ButtonBase CreateAction(ActionContext context)
        {
            var btn = new Vst.Controls.Button().SetAction(context);
            ActionPanel.Children.Add(btn);
            return btn;
        }
    }
}
