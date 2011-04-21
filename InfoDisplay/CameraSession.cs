using System;
using System.Diagnostics;
using ManagedNite;
using System.Configuration;

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
        public static bool NearLeft { get; set; }
        public static bool NearRight { get; set; }
        public static bool NearTop { get; set; }
        public static bool NearBottom { get; set; }
        public static bool HorSwipeStarted { get; private set; }
        public static bool VertSwipeStarted { get; private set; }
        public static bool Steady { get; private set; }

        private static double leftBoundary = -(double)5*(300.00/(double)7); // Left treshold needed for swipe
        private static double rightBoundary = -leftBoundary; // Right treshold needed for swipe
        private static double topBoundary = (double)6*(200.00 / (double)7); //Top treshold
        private static double botBoundary = -topBoundary; //Bottom treshold
        private static double baseKinectHeight = 54;
        private static double adjustedHeight = baseKinectHeight;


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

            sessionManager = new XnMSessionManager(context, "RaiseHand", "RaiseHand");
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
            double hBound = 5;
            double vBound = 6;

            Double.TryParse(ConfigurationManager.AppSettings["horBound"], out hBound);
            Double.TryParse(ConfigurationManager.AppSettings["verBound"], out vBound);

            leftBoundary = -(double)hBound*(300.00/(double)7); // Left treshold needed for swipe
            rightBoundary = -leftBoundary; // Right treshold needed for swipe
            topBoundary = (double)vBound*(200.00 / (double)7); //Top treshold
            botBoundary = -topBoundary; //Bottom treshold

            double actHeight = 0;
            Double.TryParse(ConfigurationManager.AppSettings["kinectHeight"], out actHeight);

            adjustedHeight = actHeight - baseKinectHeight;

            XnMPointDenoiser pointFilter = new XnMPointDenoiser();
            XnMPointControl pointControl = new XnMPointControl();
            pointControl.PointUpdate += new EventHandler<PointBasedEventArgs>(control_PointUpdate);
            pointFilter.PointCreate += new EventHandler<PointBasedEventArgs>(control_PointCreate);

            XnMSwipeDetector swipeDetector = new XnMSwipeDetector(true);
            swipeDetector.MotionSpeedThreshold = 0.8f;
            swipeDetector.MotionTime = 180; //350
            swipeDetector.SteadyDuration = 150; //200

            swipeDetector.SwipeRight += new EventHandler<SwipeDetectorEventArgs>(swipeDetector_SwipeRight);
            swipeDetector.SwipeLeft += new EventHandler<SwipeDetectorEventArgs>(swipeDetector_SwipeLeft);
            swipeDetector.SwipeDown += new EventHandler<SwipeDetectorEventArgs>(swipeDetector_SwipeDown);
            swipeDetector.SwipeUp += new EventHandler<SwipeDetectorEventArgs>(swipeDetector_SwipeUp);

            XnMSteadyDetector steadyDetector = new XnMSteadyDetector();
            steadyDetector.DetectionDuration = 800;
            steadyDetector.Steady += new EventHandler<SteadyEventArgs>(steadyDetector_Steady);
            
            //XnMPushDetector pushDetector = new XnMPushDetector();
            //pushDetector.Push += new EventHandler<PushDetectorEventArgs>(pushDetector_Push);

            XnMBroadcaster broadcaster = new XnMBroadcaster();
            pointFilter.AddListener(pointControl);
            broadcaster.AddListener(pointFilter);
            broadcaster.AddListener(swipeDetector);
            broadcaster.AddListener(steadyDetector);
            //broadcaster.AddListener(steadyDetector);
            HorSwipeStarted = VertSwipeStarted = true;
            sessionManager.AddListener(broadcaster);
        }

        static void swipeDetector_SwipeLeft(object sender, SwipeDetectorEventArgs e)
        {
            if (HorSwipeStarted)
            {
                Trace.WriteLine("Swipe left!");
                SwipeLeft = true;
                //HorSwipeStarted = false;
            }
        }

        static void steadyDetector_Steady(object sender, SteadyEventArgs e)
        {
            if(PositionX > leftBoundary && PositionX < rightBoundary)
                Push = true;
/*
            if (PositionY >= topBoundary || PositionY <= botBoundary)
            {
                VertSwipeStarted = true;
            }
            else
                VertSwipeStarted = false;

            if (PositionX <= leftBoundary || PositionX >= rightBoundary)
            {
                HorSwipeStarted = true;
            }
            else
                HorSwipeStarted = false;*/
        }

        static void control_PointUpdate(object sender, PointBasedEventArgs e)
        {
            PositionX = e.Position.X;
            PositionY = e.Position.Y + adjustedHeight*15;

            if (PositionX <= leftBoundary)
                NearLeft = true;
            else if (PositionX >= rightBoundary)
                NearRight = true;
            else if (PositionY >= topBoundary)
                NearTop = true;
            else if (PositionY <= botBoundary)
                NearBottom = true;
            else
                NearLeft = NearRight = NearTop = NearBottom = false;

            Trace.WriteLine("xpos " + PositionX + " ypos " + PositionY + "\n");
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
                //HorSwipeStarted = false;
            }
        }

        static void swipeDetector_SwipeDown(object sender, EventArgs e)
        {
            if (VertSwipeStarted)
            {
                Trace.WriteLine("Swipe down!");
                SwipeDown = true;
                //VertSwipeStarted = false;
            }
        }

        static void swipeDetector_SwipeUp(object sender, EventArgs e)
        {
            if (VertSwipeStarted)
            {
                Trace.WriteLine("Swipe up!");
                SwipeUp = true;
                //VertSwipeStarted = false;
            }
        }

        static void pushDetector_Push(object sender, EventArgs e)
        {
            Trace.WriteLine("Push!");
            Push = true;
        }
    }
}
