using System;
using System.Diagnostics;
using ManagedNite;

namespace KinectSpaceToWindowCoords
{
    public static class CameraSession
    {
        static readonly object LockObject = new object();
        static bool shutdown;
        static XnMSessionManager sessionManager;

        public static bool Active { get; private set; }
        public static bool KinectExists { get; private set; }
        public static bool KinectFail { get; private set; }
        public static double PositionX { get; private set; }
        public static double PositionY { get; private set; }
        public static bool SwipeRight { get; set; }
        public static bool SwipeLeft { get; set; }
        public static bool SwipeDown { get; set; }
        public static bool SwipeUp{get;set;}
        public static bool Push { get; set; }
        public static bool HorSwipeStarted { get; private set; }
        public static bool VertSwipeStarted { get; private set; }
        public static bool Steady { get; private set; }

        private static double leftBoundary = -(double)4*(300.00/(double)7); // Left treshold needed for swipe
        private static double rightBoundary = -leftBoundary; // Right treshold needed for swipe
        private static double topBoundary = (double)4*(200.00 / (double)7); //Top treshold
        private static double botBoundary = -topBoundary; //Bottom treshold


        public static bool ShutDown
        {
            get
            {
                lock (LockObject)
                {
                    return shutdown;
                }
            }
            set
            {
                lock (LockObject)
                {
                    shutdown = value;
                }
            }
        }

        public static void Run()
        {
            XnMOpenNIContext context = new XnMOpenNIContext();

            try
            {
                context.Init();
                KinectExists = true;
            }
            catch (XnMException)
            {
                Trace.WriteLine("Kinect device was not found.");
                Active = false;
                KinectFail = true;
                return;
            }

            Trace.WriteLine("Kinect device found.");

            sessionManager = new XnMSessionManager(context, "Wave", "RaiseHand");
            sessionManager.SessionStarted +=
                new EventHandler<PointEventArgs>(sessionManager_SessionStarted);
            sessionManager.SessionEnded +=
                new EventHandler(sessionManager_SessionEnded);


            RegisterGestures();
          

            while (!ShutDown)
            {
                context.Update();
                sessionManager.Update(context);
            }
        }

        static void RegisterGestures()
        {
            XnMPointDenoiser pointFilter = new XnMPointDenoiser();
            XnMPointControl pointControl = new XnMPointControl();
            pointControl.PointUpdate += new EventHandler<PointBasedEventArgs>(control_PointUpdate);
            pointFilter.PointCreate += new EventHandler<PointBasedEventArgs>(control_PointCreate);

            XnMSwipeDetector swipeDetector = new XnMSwipeDetector(true);
            swipeDetector.MotionSpeedThreshold = 1f;
            swipeDetector.MotionTime = 350;
            swipeDetector.SteadyDuration = 300;

            swipeDetector.SwipeRight += new EventHandler<SwipeDetectorEventArgs>(swipeDetector_SwipeRight);
            swipeDetector.SwipeLeft += new EventHandler<SwipeDetectorEventArgs>(swipeDetector_SwipeLeft);
            swipeDetector.SwipeDown += new EventHandler<SwipeDetectorEventArgs>(swipeDetector_SwipeDown);
            swipeDetector.SwipeUp += new EventHandler<SwipeDetectorEventArgs>(swipeDetector_SwipeUp);

            XnMSteadyDetector steadyDetector = new XnMSteadyDetector();
            steadyDetector.DetectionDuration = 300;
            steadyDetector.Steady += new EventHandler<SteadyEventArgs>(steadyDetector_Steady);

            XnMPushDetector pushDetector = new XnMPushDetector();
            pushDetector.Push += new EventHandler<PushDetectorEventArgs>(pushDetector_Push);

            XnMBroadcaster broadcaster = new XnMBroadcaster();
            broadcaster.AddListener(pointFilter);
            pointFilter.AddListener(pointControl);
            broadcaster.AddListener(swipeDetector);
            broadcaster.AddListener(pushDetector);
            broadcaster.AddListener(steadyDetector);

            sessionManager.AddListener(broadcaster);
        }

        static void swipeDetector_SwipeLeft(object sender, SwipeDetectorEventArgs e)
        {
            if (HorSwipeStarted)
            {
                Trace.WriteLine("Swipe left!");
                SwipeLeft = true;
                HorSwipeStarted = false;
            }
        }

        static void steadyDetector_Steady(object sender, SteadyEventArgs e)
        {
            Steady = true;

            if (PositionY >= topBoundary || PositionY <= botBoundary)
            {
                Trace.WriteLine("Steady at velocity: " + e.Velocity);
                Trace.WriteLine("At top boundary: " + topBoundary + " Bottom is " + botBoundary);
                VertSwipeStarted = true;
            }
            else
                VertSwipeStarted = false;

            if (PositionX <= leftBoundary || PositionX >= rightBoundary)
            {
                Trace.WriteLine("Steady at velocity: " + e.Velocity);
                Trace.WriteLine("Left boundary is" + leftBoundary + " Right is " + rightBoundary);
                HorSwipeStarted = true;
            }
            else
                HorSwipeStarted = false;
        }

        static void control_PointUpdate(object sender, PointBasedEventArgs e)
        {
            PositionX = e.Position.X;
            PositionY = e.Position.Y;
            Trace.WriteLine("At y: " + e.Position.Y);
        }

        static void control_PointCreate(object sender, PointBasedEventArgs e)
        {
            Active = true;
        }

        static void sessionManager_SessionEnded(object sender, EventArgs e)
        {
            Active = false;
            Trace.WriteLine("Kinect hand point lost.");
        }

        static void sessionManager_SessionStarted(object sender, PointEventArgs e)
        {
            Trace.WriteLine("Kinect hand point detected.");
            sessionManager.TrackPoint(e.Point);
        }

        static void swipeDetector_SwipeRight(object sender, EventArgs e)
        {
            if (HorSwipeStarted)
            {
                Trace.WriteLine("Swipe right!");
                SwipeRight = true;
                HorSwipeStarted = false;
            }
        }

        static void swipeDetector_SwipeDown(object sender, EventArgs e)
        {
            if (VertSwipeStarted)
            {
                Trace.WriteLine("Swipe down!");
                SwipeDown = true;
                VertSwipeStarted = false;
            }
        }

        static void swipeDetector_SwipeUp(object sender, EventArgs e)
        {
            if (VertSwipeStarted)
            {
                Trace.WriteLine("Swipe up!");
                SwipeUp = true;
                VertSwipeStarted = false;
            }
        }

        static void pushDetector_Push(object sender, EventArgs e)
        {
            Trace.WriteLine("Push!");
            Push = true;
        }
    }
}
