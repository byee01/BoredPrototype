using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using WebKit;

namespace KinectSpaceToWindowCoords
{
    public class WebKitBrowserWrapper : DependencyObject
    {
        private WebKitBrowser wb;

        public readonly DependencyProperty URIProperty = DependencyProperty.Register("URI", typeof(string), typeof(WebKitBrowserWrapper),
            new PropertyMetadata("No Name", URIChangedCallback, URICoerceCallback), URIValidateCallback);


        public WebKitBrowserWrapper()
        {
            wb = new WebKitBrowser();
        }

        public WebKitBrowser Browser { get { return this.wb; } }

        private static void URIChangedCallback(DependencyObject obj, DependencyPropertyChangedEventArgs e)
        {
            Console.WriteLine("Changed!");
        }

        private static object URICoerceCallback(DependencyObject obj, object o)
        {
            return o;
        }

        private static bool URIValidateCallback(object value)
        {
            return value != null;
        }

        public string URI
        {
            get
            {
                return (string)GetValue(URIProperty);
            }
            set
            {
                wb.Navigate(value);
                SetValue(URIProperty, value);
                Console.WriteLine(value);
            }
        }

    }

}
