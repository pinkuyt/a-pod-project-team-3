using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace APOD_Controller.APOD.Communication
{
    class BluetoothDevice
    {
        public SerialPort ComPort { get; set; }

        public BluetoothDevice(string port, int baud)
        {
            ComPort = new SerialPort(port, baud, Parity.None, 8, StopBits.One)
                {
                    ReadTimeout = 1000
                };
        }

        public BluetoothDevice(SerialPort port)
        {
            ComPort = port;
        }

        /// <summary>
        /// Open port for communication
        /// </summary>
        /// <returns>Number of ports</returns>
        public int Open()
        {
            try
            {
                int count = 0;
                if (!ComPort.IsOpen)
                {
                    ComPort.Open();
                    count++;
                }
                return count;
            }

            catch (UnauthorizedAccessException)
            {
                return 0;
            }
            catch (ArgumentOutOfRangeException)
            {
                return 0;
            }
            catch (ArgumentException)
            {
                return 0;
            }
            catch (System.IO.IOException)
            {
                return 0;
            }
            catch (InvalidOperationException)
            {
                return 0;
            }
        }

        /// <summary>
        /// Close Serial port
        /// </summary>
        public int Close()
        {
            try
            {
                int count = 0;
                if (ComPort.IsOpen)
                {
                    ComPort.Close();
                    count++;
                }
                return count;
            }
            catch (System.IO.IOException)
            {
                return 0;
            }
        }

        /// <summary>
        /// Send non-movement command to hexapod
        /// </summary>
        /// <param name="cmd">Movement command</param>
        public bool SendCommand(byte cmd)
        {
            if (!ComPort.IsOpen)
            {
                return false;
            }
            try
            {
                ComPort.Write(new[] {cmd}, 0, 1);
            }
            catch (ArgumentNullException)
            {
                return false;
            }
            catch (InvalidOperationException)
            {
                return false;
            }
            catch (ArgumentOutOfRangeException)
            {
                return false;
            }
            catch (ArgumentException)
            {
                return false;
            }
            catch (TimeoutException)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Send non-movement command to hexapod
        /// </summary>
        /// <param name="cmd">Movement command</param>
        public bool SendCommand(byte[] cmd)
        {
            if (!ComPort.IsOpen)
            {
                return false;
            }
            try
            {
                ComPort.Write(cmd, 0, cmd.Length);
            }
            catch (ArgumentNullException)
            {
                return false;
            }
            catch (InvalidOperationException)
            {
                return false;
            }
            catch (ArgumentOutOfRangeException)
            {
                return false;
            }
            catch (ArgumentException)
            {
                return false;
            }
            catch (TimeoutException)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        ///  Reading response from APOD
        /// </summary>
        /// <param name="num">Number of responses expected</param>
        /// <returns></returns>
        public char[] ReadResponse(int num)
        {
            if (!ComPort.IsOpen) return null;
            char[] responses = new char[num];
            try
            {
                ComPort.Read(responses, 0, num);
            }

            catch (ArgumentNullException)
            {
                return null;
            }
            catch (ArgumentOutOfRangeException)
            {
                return null;
            }
            catch (ArgumentException)
            {
                return null;
            }
            catch (InvalidOperationException)
            {
                return null;
            }
            catch (TimeoutException)
            {
                return null;
            }
            return responses;
        }

        /// <summary>
        ///  Reading response from APOD
        /// </summary>
        /// <param name="num">Number of responses expected</param>
        /// <returns></returns>
        public byte ReadResponse()
        {
            if (!ComPort.IsOpen) return 0;
            byte[] responses = new byte[1];
            try
            {
                ComPort.Read(responses, 0, 1);
            }
            catch (ArgumentNullException)
            {
                return 0;
            }
            catch (ArgumentOutOfRangeException)
            {
                return 0;
            }
            catch (ArgumentException)
            {
                return 0;
            }
            catch (InvalidOperationException)
            {
                return 0;
            }
            catch (TimeoutException)
            {
                return 0;
            }
            return responses[0];
        }
        /// <summary>
        /// Read all current response in buffer
        /// </summary>
        /// <returns>String contain response value</returns>
        public string Read()
        {
            string result;
            try
            {
                result = ComPort.ReadExisting();
            }
            catch (InvalidOperationException)
            {
                result = "-";
            }
            return result;
        }

        /// <summary>
        /// Clear junk responses from buffer
        /// </summary>
        public void ClearPreviousResponse()
        {
            ComPort.ReadExisting();
        }
    }
}
