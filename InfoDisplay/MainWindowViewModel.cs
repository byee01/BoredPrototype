using System;
using System.Diagnostics;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Forms;
using System.Windows.Threading;

namespace KinectSpaceToWindowCoords
{
    public class MainWindowViewModel : PropertyChangeBase
    {
        [DllImportAttribute("user32.dll", EntryPoint = "SetCursorPos")]
        [return: MarshalAsAttribute(System.Runtime.InteropServices.UnmanagedType.Bool)]
        public static extern bool SetCursorPos(int X, int Y);

        [DllImport("user32.dll")]
        private static extern void mouse_event(UInt32 dwFlags, UInt32 dx, UInt32 dy, UInt32 dwData, IntPtr dwExtraInfo);
        private const UInt32 MouseEventLeftDown = 0x0002;
        private const UInt32 MouseEventLeftUp = 0x0004;

        private int currentPage = 0;
        private int dummyVariable = 0;

        double cursorX;
        double cursorY;
        string instructions;
        string uri;
        double scale;
        DispatcherTimer cameraTimer;
        Rectangle workingArea;

        System.Windows.Forms.Timer cursorTimer;

        public MainWindowViewModel()
        {
            this.Initialize();
        }

        public BindableTraceListener TraceListener
        {
            get { return App.TraceListener; }
        }

        public double Scale
        {
            get { return this.scale; }
            set
            {
                this.scale = value;
                this.OnPropertyChanged("Scale");
            }
        }

        public string Instructions
        {
            get { return this.instructions; }
            set
            {
                if (this.instructions != value)
                {
                    this.instructions = value;
                    this.OnPropertyChanged("Instructions");
                }
            }
        }

        public string URI
        {
            get { return this.uri; }
            set
            {
                if (this.uri != value)
                {
                    this.uri = value;
                    this.OnPropertyChanged("URI");
                }
            }
        }

        public double CursorX
        {
            get { return this.cursorX; }
            set
            {
                this.cursorX = value;
                this.OnPropertyChanged("CursorX");
            }
        }

        public double CursorY
        {
            get { return this.cursorY; }
            set
            {
                this.cursorY = value;
                this.OnPropertyChanged("CursorY");
            }
        }

        public double SensorX
        {
            get { return CameraSession.PositionX; }
        }

        public double SensorY
        {
            get { return CameraSession.PositionY; }
        }

        public void IncrementScale()
        {
            if (this.Scale < 10)
                this.Scale++;
        }

        public void DecrementScale()
        {
            if (this.Scale > 1)
                this.Scale--;
        }

        public static void SendMouseClick()
        {
            mouse_event(MouseEventLeftDown, 0, 0, 0, new System.IntPtr());
            mouse_event(MouseEventLeftUp, 0, 0, 0, new System.IntPtr());
        }


        void Initialize()
        {
            Trace.Listeners.Add(App.TraceListener);

            this.Scale = 2d;
            this.Scale++;
            var start = new ThreadStart(CameraSession.Run);
            var cameraThread = new Thread(start);
            cameraThread.Start();
            
            Trace.Flush();
            Trace.Write("Initializing...");

            // assumes only single/first monitor
            var screen = Screen.AllScreens[0];
            this.workingArea = screen.WorkingArea;

            this.cameraTimer = new DispatcherTimer()
            {
                Interval = TimeSpan.FromMilliseconds(10)
            };

            this.cameraTimer.Tick += new EventHandler(cameraTimer_Tick);
            this.cameraTimer.Start();

            this.cursorTimer = new System.Windows.Forms.Timer()
            {
                Interval = 1
            };

            this.cursorTimer.Tick += new EventHandler(cursorTimer_Tick);

            Trace.Write("Kinect device starting...");
        }

        /// <summary>
        /// Rapidly changes the mouse cursor
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void cursorTimer_Tick(object sender, EventArgs e)
        {
            System.Windows.Input.Mouse.OverrideCursor = System.Windows.Input.Cursors.ScrollWE;
            Trace.WriteLine("is no");
        }

        void cameraTimer_Tick(object sender, EventArgs e)
        {
            if (CameraSession.KinectFail)
            {
                this.Instructions = "No Kinect device was found. Sorry.";
                this.cameraTimer.Stop();
                return;
            }
            
            if (CameraSession.KinectExists)
            {
                if (CameraSession.Active)
                {
                    this.Instructions = "Move your hand as the mouse pointer.";

                    this.CursorX = this.workingArea.Width / 2 + CameraSession.PositionX * this.Scale;
                    this.CursorY = this.workingArea.Height / 2 - CameraSession.PositionY * this.Scale;
                    this.OnPropertyChanged("SensorX");
                    this.OnPropertyChanged("SensorY");
                    SetCursorPos((int)this.cursorX, (int)this.cursorY);

                    if (CameraSession.HorSwipeStarted || CameraSession.VertSwipeStarted)
                    {
                        cursorTimer.Start();
                        Trace.WriteLine("swipe started");
                    }
                    else if (!CameraSession.HorSwipeStarted && !CameraSession.VertSwipeStarted)
                        cursorTimer.Stop();

                    if (CameraSession.SwipeRight)
                    {
                        if (currentPage < 10)
                        {
                            currentPage++;
                            this.URI = "$('a.col" + currentPage + "').click()";
                            this.URI = "$('a.col" + currentPage + "').click()";

                        }
                        CameraSession.SwipeRight = CameraSession.SwipeLeft = false;
                        
                    }
                    if (CameraSession.SwipeLeft)
                    {
                        if (currentPage > 0)
                        {
                            currentPage--;
                            if (currentPage == 0)
                                this.URI = "$('a.all').click()";
                            else
                            {
                                this.URI = "$('a.col" + currentPage + "').click()";
                                this.URI = "$('a.col" + currentPage + "').click()";
                            }
                        }
                        CameraSession.SwipeLeft = CameraSession.SwipeRight = false;

                    }
                    if (CameraSession.SwipeDown)
                    {
                        this.URI = "$('html, body').animate({'scrollTop': $('body').scrollTop() + 0.5*$(window).height()}); if(null){" + dummyVariable + "}";
                        CameraSession.SwipeDown = CameraSession.SwipeUp = false;
                        dummyVariable = (dummyVariable + 1)% 2;
                        
                    }
                    if (CameraSession.SwipeUp)
                    {
                        this.URI = "$('html, body').animate({'scrollTop': $('body').scrollTop() - 0.5*$(window).height()}); if(null){" + dummyVariable + "}";
                        CameraSession.SwipeUp = CameraSession.SwipeDown = false;
                        dummyVariable = (dummyVariable + 1) % 2;
                    }
                    if (CameraSession.Push)
                    {
                        SendMouseClick();
                        CameraSession.Push = false;
                    }
                }
                else
                {
                    this.Instructions = "Wave at the Kinect to begin.";
                }
            }
            else
            {
                this.Instructions = "Please wait while your Kinect sensor is found...";
            }
        }
    }
}
