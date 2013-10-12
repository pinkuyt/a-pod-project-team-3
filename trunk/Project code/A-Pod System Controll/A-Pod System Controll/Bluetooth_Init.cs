using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.IO.Ports;
using System.Threading;

namespace A_Pod_System_Controll
{
    public class Bluetooth_Init : APod_control
    {
        private static char type;
        bool isNew = true;
        List<string> list = new List<string>();
        //private static int 

        public char Type
        {
            get
            {
                return type;
            }
            set
            {
                type = value;
            }
        }

        public override void OpenPort()
        {
            try
            {
                SerialPort.Open();
                //SerialPort.DataReceived += new SerialDataReceivedEventHandler(receiveData_SerialPort);
                SerialPort.DtrEnable = true;
                SerialPort.RtsEnable = true;
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Unable to open Bluetooth \n More detail: " + ex.Message);
            }
        }
        public override void ClosePort()
        {
            try
            {
                SerialPort.Close();
                //SerialPort.DataReceived -= new SerialDataReceivedEventHandler(receiveData_SerialPort);
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Unable to close the bluetooth" + ex.Message);
            }
        }

        public void writeData_SerialPort(string data)
        {
            try
            {
                if (!SerialPort.IsOpen) SerialPort.Open();
                SerialPort.Write(data);
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Unable ToString write data to SerialPort port" + ex.Message);
            }
        }

 

    }
}
