using System.Windows;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Shapes;
using WebKit;
using System.Windows.Forms.Integration;
using System.Windows.Data;
using System.IO;
using System.Configuration;

namespace Teudu.InteractiveDisplay
{
    public partial class MainWindow : Window
    {
#region Private Members
        private WebKitBrowser wkBrowser;
        private System.Windows.Forms.Timer setupTimer;
#endregion

#region Public Members
        MainWindowViewModel ViewModel
        {
            get { return (MainWindowViewModel)this.DataContext; }
        }
#endregion

#region WebKitBrowser Routines
        /// <summary>
        /// Sends javascript calls to the underlying webkit engine
        /// </summary>
        /// <param name="js">string containing javascript code</param>
        public void MakeJSCall(string js)
        {
            try
            {
                wkBrowser.StringByEvaluatingJavaScriptFromString(js);
            }
            catch (System.Exception h)
            {
                InitializeComponent(); // Restart UI
            }
        }
#endregion

#region Initialization
        public MainWindow()
        {
            InitializeComponent();
            this.DataContext = new MainWindowViewModel();
            App.Current.Exit += new ExitEventHandler(Current_Exit);
            this.KeyDown += new KeyEventHandler(MainWindow_KeyDown);
           
            player.LoadedBehavior = player2.LoadedBehavior = player3.LoadedBehavior = System.Windows.Controls.MediaState.Manual;
            setupTimer = new System.Windows.Forms.Timer();
            setupTimer.Interval = 3000;
            setupTimer.Tick += new System.EventHandler(setupTimer_Tick);
        }
        /// <summary>
        /// Setup routines to run after the application has initialized
        /// </summary>
        public void PostInitialize()
        {
            //MakeJSCall("$('body, container').css('overflow','hidden');");
            /*MakeJSCall("$('#create_event_btn').css('visibility', 'hidden');");
            MakeJSCall("$('.event_edit_btn').css('visibility', 'hidden');");
            MakeJSCall("$('.destroy_event_btn').css('visibility', 'hidden');");*/
        }

        /// <summary>
        /// Initializes several code routines after the webkit containing element loads
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void browserContainer_Loaded(object sender, RoutedEventArgs e)
        {
            WindowsFormsHost host = new WindowsFormsHost();

            wkBrowser = new WebKit.WebKitBrowser();
            host.Child = wkBrowser;

            this.browserContainer.Children.Add(host);


            wkBrowser.Navigate(ConfigurationManager.AppSettings["url"]);

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
#endregion 

#region Interface Adjustments
        /// <summary>
        /// Handles key down event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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

        /// <summary>
        /// Plays a sound cue for certain inputs
        /// </summary>
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
#endregion

#region Timers
        /// <summary>
        /// Setup timer for calling a post initialization routine after application has initialized
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void setupTimer_Tick(object sender, System.EventArgs e)
        {
            PostInitialize();
            setupTimer.Stop();
        }
#endregion

#region Exit

        void Current_Exit(object sender, ExitEventArgs e)
        {
            CameraSession.ShutDown = true;
        }

#endregion
    }
}
