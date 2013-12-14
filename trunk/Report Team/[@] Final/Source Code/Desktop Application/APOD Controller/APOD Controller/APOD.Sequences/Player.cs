using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using APOD_Controller.APOD.Communication;

namespace APOD_Controller.APOD.Sequences
{
    class Player
    {
        public MoveItemsCollection Collection { get; set; }

        /// <summary>
        /// Device button event listener
        /// </summary>
        private BackgroundWorker Worker;

        /// <summary>
        /// Communication channel
        /// </summary>
        private BluetoothDevice Bluetooth;
        
        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="collection">Moves Collection</param>
        /// <param name="bluetooth">Communicate Object</param>
        public Player(MoveItemsCollection collection, BluetoothDevice bluetooth)
        {
            Collection = collection;
            Bluetooth = bluetooth;
            // register worker
            Worker = new BackgroundWorker();
            Worker.DoWork+= worker_DoWork;
        }

        /// <summary>
        /// Grouping continues moves.
        /// </summary>
        public void Normalize()
        {
            int i = 0;
            while (i< (Collection.Count-1))
            {
                if (Collection[i].Name == Collection[i + 1].Name && MoveItem.IsPositionMove(Collection[i].Name))
                {
                    Collection[i].Interval += Collection[i + 1].Interval;
                    Collection.RemoveAt(i+1);
                }
                else
                {
                    i++;
                }
            }
        }

        /// <summary>
        /// Playing the sequences
        /// </summary>
        /// <param name="sender">Event Source</param>
        /// <param name="e">Event arguments</param>
        void worker_DoWork(object sender, DoWorkEventArgs e)
        {
            bool result = true;
            result = Bluetooth.SendCommand(Command.Start);
            foreach (MoveItem moveItem in Collection)
            {
                System.Threading.Thread.Sleep(100);
                switch (moveItem.Name)
                {
                    case "Forward":
                        result = Bluetooth.SendCommand(Command.MoveForwardCont);
                        System.Threading.Thread.Sleep(moveItem.Interval *1000);
                        // send finish token
                        result = Bluetooth.SendCommand(0xAA);
                        while (!Bluetooth.Read().Contains(".")) ;
                        break;
                    case "Backward":
                        result = Bluetooth.SendCommand(Command.MoveBackwardCont);
                        System.Threading.Thread.Sleep(moveItem.Interval *1000);
                        // send finish token
                        result = Bluetooth.SendCommand(0xAA);
                        while (!Bluetooth.Read().Contains(".")) ;
                        break;
                    case "Turn Left":
                        result = Bluetooth.SendCommand(Command.TurnLeftCont);
                        System.Threading.Thread.Sleep(moveItem.Interval *1000);
                        // send finish token
                        result = Bluetooth.SendCommand(0xAA);
                        while (!Bluetooth.Read().Contains(".")) ;
                        break;
                    case "Turn Right":
                        result = Bluetooth.SendCommand(Command.TurnRightCont);
                        System.Threading.Thread.Sleep(moveItem.Interval *1000);
                        // send finish token
                        result = Bluetooth.SendCommand(0xAA);
                        while (!Bluetooth.Read().Contains(".")) ;
                        break;
                    case "Body Lift":
                        result = Bluetooth.SendCommand(Command.StandLift);
                        break;
                    case "Body Drop":
                        result = Bluetooth.SendCommand(Command.StandDrop);
                        break;
                    case "Toward Front":
                        result = Bluetooth.SendCommand(Command.TowardFront);
                        break;
                    case "Toward Back":
                        result = Bluetooth.SendCommand(Command.TowardBack);
                        break;
                    case "Squeeze Left":
                        result = Bluetooth.SendCommand(Command.SqueezeLeft);
                        break;
                    case "Squeeze Right":
                        result = Bluetooth.SendCommand(Command.SqueezeRight);
                        break;
                    case "Head Up":
                        result = Bluetooth.SendCommand(Command.LiftHeadUp);
                        break;
                    case "Head Down":
                        result = Bluetooth.SendCommand(Command.DropHeadDown);
                        break;
                    case "Head Left":
                        result = Bluetooth.SendCommand(Command.TurnHeadLeft);
                        break;
                    case "Head Right":
                        result = Bluetooth.SendCommand(Command.TurnHeadRight);
                        break;
                    case "Head Roll Left":
                        result = Bluetooth.SendCommand(Command.RotateHeadLeft);
                        break;
                    case "Head Roll Right":
                        result = Bluetooth.SendCommand(Command.RotateHeadRight);
                        break;
                }
                System.Threading.Thread.Sleep(100);
                if (!result) return;
            }
        }

        /// <summary>
        /// Start playing
        /// </summary>
        public void Start()
        {
            Worker.RunWorkerAsync();
        }
        
        /// <summary>
        /// Status of current player
        /// </summary>
        /// <returns>Is there any sequence playing at the moment?</returns>
        public bool IsPlaying()
        {
            return Worker.IsBusy;
        }

        /// <summary>
        /// Signal to stop current player
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
