using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.IO.Ports;

namespace A_Pod_System_Controll
{
    public abstract class APod_control
    {
        private static SerialPort serialPort = new SerialPort();

        //getter, setter
        public SerialPort SerialPort
        {
            get
            {
                return APod_control.serialPort;
            }
            set
            {
                APod_control.serialPort = value;
            }
        }

        /*
         * OpenType = 0: no connection
         * OpenType = 1: Bluetooth connected
         * 
         */

        private static int OpenType = 0;

        public int PortOpenType
        {
            get
            {
                return APod_control.OpenType;
            }
            set
            {
                APod_control.OpenType = value;
            }
        }
        public abstract void OpenPort();

        public abstract void ClosePort();

        //public abstract void receiveData_SerialPort(object sender, SerialDataReceivedEventArgs e);

    }
}
