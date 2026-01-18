using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Controls;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace WinApp.Views.Home
{
    class Staff : Index
    {
        protected override void ShowComment(string un)
        {
            try
            {
                var bitmap = new BitmapImage();
                bitmap.BeginInit();
                bitmap.UriSource = new Uri("https://cdn.baolaocai.vn/images/40a39358c2d4bd872f86d755a35b7fb5287bd1125131bc314edb372191842e648c91794c3be7daf08be5fcc2acf4587b/1.png");
                bitmap.EndInit();

                var image = new Image
                {
                    Source = bitmap,
                    Stretch = Stretch.UniformToFill,
                    Height = 900,
                    HorizontalAlignment = System.Windows.HorizontalAlignment.Stretch,
                    Margin = new System.Windows.Thickness(0, 10, 0, 10)
                };
                MainView.Children.Add(image);
            }
            catch (Exception ex)
            {
                Add("Lỗi tải ảnh: " + ex.Message, 14, Brushes.Red);
            }
        }
    }
}
