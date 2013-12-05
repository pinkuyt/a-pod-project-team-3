using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using APOD_Controller.APOD.Communication;

namespace APOD_Controller.APOD.Object_Tracking
{
    class ObjectTracker
    {
        private Indicator Target;
        private BluetoothDevice Bluetooth;
        public BackgroundWorker Worker;

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="bluetooth">Communication instance</param>
        /// <param name="target"> Target</param>
        public ObjectTracker(BluetoothDevice bluetooth, Indicator target)
        {
            Target = target;
            Bluetooth = bluetooth;
            Worker = new BackgroundWorker();
            Worker.DoWork += Tracking;
        }

        /// <summary>
        /// Tracking executioner
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void Tracking(object sender, DoWorkEventArgs doWorkEventArgs)
        {
            BackgroundWorker worker = (BackgroundWorker)sender;
            while (!worker.CancellationPending)
            {
                // terminate token
                Bluetooth.SendCommand(0xAA);
                while (!Bluetooth.Read().Contains(".")) ;
                // lost sight
                if (Target.Lost)
                {
                    return;
                }

                // check distance
                Bluetooth.ClearPreviousResponse();
                Bluetooth.SendCommand(0xDD);
                System.Threading.Thread.Sleep(600);
                byte d = Bluetooth.ReadResponse();

                // reached the object
                if (d <= 60)
                {
                    // Set flag
                    Target.Found = true;
                    // continue adjust position until object in center region
                }
                // left region
                if (Target.X <= Indicator.LeftBoundary)
                {
                    Bluetooth.SendCommand(Command.TurnLeft);
                    System.Threading.Thread.Sleep(1000);
                }
                // right region
                else if (Target.X >= Indicator.RightBoundary)
                {
                    Bluetooth.SendCommand(Command.TurnRight);
                    System.Threading.Thread.Sleep(1000);
                }
                // middle region
                else
                {
                    // if object is found, no need to move forward
                    if (Target.Found) return;

                    Bluetooth.SendCommand(Command.MoveForwardCont);
                    System.Threading.Thread.Sleep(2000);
                }
            }
        }

        /// <summary>
        /// Start tracking
        /// </summary>
        public void Start()
        {
            if (!Worker.IsBusy)
            {
                Worker.RunWorkerAsync(); 
            }
        }

        /// <summary>
        /// Status of current tracker
        /// </summary>
        /// <returns></returns>
        public bool IsTracking()
        {
            return Worker.IsBusy;
        }

        /// <summary>
        /// Stop tracking
        /// </summary>
        public void Stop()
        {
            if (Worker.IsBusy)
            {
                Worker.CancelAsync();
            }
        }
    }

}
