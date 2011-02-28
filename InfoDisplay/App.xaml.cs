using System.Windows;

namespace KinectSpaceToWindowCoords
{
    public partial class App : Application
    {
        static BindableTraceListener traceListener;

        public static BindableTraceListener TraceListener
        {
            get
            {
                if (traceListener == null)
                    traceListener = new BindableTraceListener();
                return traceListener;
            }
        }
    }
}
