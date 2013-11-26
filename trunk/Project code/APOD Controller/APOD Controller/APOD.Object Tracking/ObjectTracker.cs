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
        /// Activator
        /// </summary>
        public System.Windows.Controls.CheckBox Activator { get; set; }

        /// <summary>
        /// Timer for checking position;
        /// </summary>
        private Timer TimerClock;

        public bool Found { get; set; }

        /// <summary>
        /// Communication channel
        /// </summary>
        private BluetoothDevice Bluetooth;
        
        public ObjectTracker(BluetoothDevice bluetooth, Indicator target, System.Windows.Controls.CheckBox activator)
        {
            Target = target;
            Bluetooth = bluetooth;
            Activator = activator;
            TimerClock = new Timer();
            TimerClock.Interval = 5000;
            TimerClock.Tick += TimerClockTick;

            Found = false;
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
            // check distance
            Bluetooth.SendCommand(0x13);
            System.Threading.Thread.Sleep(500);
            // reached the object
            if (Bluetooth.ReadResponse() <= 6)
            {
                TimerClock.Stop();
                Activator.IsChecked = false;
                Found = true;
                return;
            } 
            if (Target.Lost)
            {
                TimerClock.Stop();
                Activator.IsChecked = false;
                return;
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
