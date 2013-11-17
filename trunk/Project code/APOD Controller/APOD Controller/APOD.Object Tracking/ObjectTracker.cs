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
        /// <summary>
        /// Object offset
        /// </summary>
        public Indicator Target { get; set; }

        /// <summary>
        /// Timer for checking position;
        /// </summary>
        private Timer TimerClock;

        /// <summary>
        /// Device button event listener
        /// </summary>
        private BackgroundWorker Worker;

        /// <summary>
        /// Communication channel
        /// </summary>
        private BluetoothDevice Bluetooth;
        
        public ObjectTracker(BluetoothDevice bluetooth, Indicator target)
        {
            Target = target;
            Bluetooth = bluetooth;
            TimerClock = new Timer();
            TimerClock.Interval = 5000;
            TimerClock.Tick += TimerClockTick;

            Worker = new BackgroundWorker();
            Worker.DoWork+= worker_DoWork;
        }

        void TimerClockTick(object sender, EventArgs e)
        {
            if (((string) TimerClock.Tag).Contains("+"))
            {
                TimerClock.Tag = "-";
            }
            else
            {
                Bluetooth.SendCommand(0xAA);
                while (!Bluetooth.Read().Contains(".")) ;
            }
            // left region
            if (Target.X < 200)
            {
                Bluetooth.SendCommand(Command.TurnLeft);
                return;
            }
            // right region
            if (Target.X > 400)
            {
                Bluetooth.SendCommand(Command.TurnRight);
                return;
            }
            Bluetooth.SendCommand(Command.MoveForwardCont);
        }

        private void worker_DoWork(object sender, DoWorkEventArgs e)
        {
            throw new NotImplementedException();
        }

        public void Start()
        {
            TimerClock.Start();
            TimerClock.Tag = "+";
        }

        public bool IsTracking()
        {
            return TimerClock.Enabled;
        }

        public void Stop()
        {
            TimerClock.Stop();
            TimerClock.Tag = ".";
        }
    }
}
