using System.Windows;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Shapes;
using WebKit;
using System.Windows.Forms.Integration;
using System.Windows.Data;
using System.IO;

namespace KinectSpaceToWindowCoords
{
    public partial class MainWindow : Window
    {
        //private WebKitBrowserWrapper wkBrowser;
        private WebKitBrowser wkBrowser;
        
        static readonly Color HoverColor = Colors.Yellow;
        Color oldColor;

        private System.Windows.Forms.Timer setupTimer;
        //private System.Windows.Forms.Timer cursorTimer;

        public MainWindow()
        {
            InitializeComponent();
            this.DataContext = new MainWindowViewModel();
            App.Current.Exit += new ExitEventHandler(Current_Exit);
            this.KeyDown += new KeyEventHandler(MainWindow_KeyDown);
            
           // Mouse.OverrideCursor = mainCursor;
            player.LoadedBehavior = player2.LoadedBehavior = player3.LoadedBehavior = System.Windows.Controls.MediaState.Manual;
            setupTimer = new System.Windows.Forms.Timer();
            setupTimer.Interval = 3000;
            setupTimer.Tick += new System.EventHandler(setupTimer_Tick);

          /*  cursorTimer = new System.Windows.Forms.Timer();
            cursorTimer.Interval = 1;
            cursorTimer.Tick += new System.EventHandler(cursorTimer_Tick);*/
        }

        void cursorTimer_Tick(object sender, System.EventArgs e)
        {
            //Mouse.OverrideCursor = mainCursor;
        }

        void setupTimer_Tick(object sender, System.EventArgs e)
        {
            PostInitialize();
            setupTimer.Stop();
        }

        public void PostInitialize()
        {
            MakeJSCall("$('body, container').css('overflow','hidden');");
           // cursorTimer.Start();
        }

        public void MakeJSCall(string js)
        {
            try
            {
                //wkBrowser.Browser.StringByEvaluatingJavaScriptFromString(js);
                wkBrowser.StringByEvaluatingJavaScriptFromString(js);
            }
            catch (System.Exception h)
            {
                InitializeComponent();
            }
        }

        MainWindowViewModel ViewModel{
            get{ return (MainWindowViewModel)this.DataContext; }
        }

        void MainWindow_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Escape)
            {
                App.Current.Shutdown();
            }
            else if (e.Key == Key.Down)
            {
                this.ViewModel.DecrementScale();
            }
            else if (e.Key == Key.Up)
            {
                this.ViewModel.IncrementScale();
            }
        }

        void Current_Exit(object sender, ExitEventArgs e)
        {
            CameraSession.ShutDown = true;
        }

        void EllipseMouseEnter(object sender, MouseEventArgs e)
        {
            var ellipse = (Ellipse)sender;
            oldColor = ((SolidColorBrush)ellipse.Fill).Color;
            ellipse.Fill = new SolidColorBrush(HoverColor);
        }

        void EllipseMouseLeave(object sender, MouseEventArgs e)
        {
            var ellipse = (Ellipse)sender;
            ellipse.Fill = new SolidColorBrush(oldColor);
        }

        private void browserContainer_Loaded(object sender, RoutedEventArgs e)
        {
            WindowsFormsHost host = new WindowsFormsHost();
            //wkBrowser = new WebKitBrowserWrapper();
            //host.Child = wkBrowser.Browser;
            
            //this.browserContainer.Children.Add(host);

            //wkBrowser.Browser.Navigate("http://www.tinyurl.com/BoredCast1");
            
            //this.ViewModel.PropertyChanged += (o, f) =>
            //{
            //    if (f.PropertyName.Equals("URI"))
            //    {
            //        MakeJSCall(this.ViewModel.URI);                    
            //        playSoundFeedback();
            //    }
            //};

            wkBrowser = new WebKit.WebKitBrowser();
            host.Child = wkBrowser;
            

            this.browserContainer.Children.Add(host);


            wkBrowser.Navigate("http://www.tinyurl.com/BoredCast1");

            this.ViewModel.PropertyChanged += (o, f) =>
            {
                if (f.PropertyName.Equals("URI"))
                {
                    MakeJSCall(this.ViewModel.URI);
                    playSoundFeedback();
                }
            };

            setupTimer.Start();

            
        }


        public void playSoundFeedback()
        {
            if (CameraSession.SwipeLeft || CameraSession.SwipeRight)
            {
                player.Stop(); player.Play();
            }
            else if (CameraSession.SwipeUp || CameraSession.SwipeDown)
            {
                player2.Stop(); player2.Play();
            }
            else
            {
                player3.Stop(); player3.Play();
            }
        }
    }
}
