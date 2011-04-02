using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Text;

namespace KinectSpaceToWindowCoords
{
    public class BindableTraceListener : TraceListener, INotifyPropertyChanged
    {
        StringBuilder output;

        public BindableTraceListener()
        {
            this.output = new StringBuilder();
        }

        public string Trace
        {
            get { return this.output.ToString(); }
        }

        public override void Write(string message)
        {
            #if (DEBUG)
            this.WriteMessage(message);
            #endif
        }

        public override void WriteLine(string message)
        {
            #if (DEBUG)
            this.WriteMessage(message);
            #endif
        }

        void WriteMessage(string message)
        {
            this.output.AppendFormat("{0}{1}", message, Environment.NewLine);
            this.OnTraceChanged();
        }

        void OnTraceChanged()
        {
            if (this.PropertyChanged != null)
                this.PropertyChanged(this,
                    new PropertyChangedEventArgs("Trace"));
        }

        public event PropertyChangedEventHandler PropertyChanged;
    }
}
