﻿using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace Hexapod
{
    class Connector
    {
        private SerialPort Port;

        public Connector(String portName, int baud)
        {
            Port = new SerialPort(portName, baud, Parity.None, 8, StopBits.One)
                {
                    ReadTimeout = 1000
                };
        }

        public Connector(SerialPort port)
        {
            Port = port;
        }

        /// <summary>
        /// Checking if current port is available
        /// </summary>
        /// <returns></returns>
        public bool IsOpen()
        {
            return Port.IsOpen;
        }

        /// <summary>
        /// Open Serial Port
        /// </summary>
        public void Open()
        {
            Port.Open();
        }

        /// <summary>
        /// Close Serial port
        /// </summary>
        public void Close()
        {
            Port.Close();
        }

        /// <summary>
        /// Send command to hexapod
        /// </summary>
        /// <param name="cmd">Movement command</param>
        /// <param name="time">Execution time</param>
        public int SendCommand(String cmd, int time)
        {
            if (!Port.IsOpen)
            {
                return 0;
            }

            byte servo;
            int pos;

            var pattern = cmd.Trim().Split('#', 'P');
            var binaryCommand = new List<byte>();

            for (int i = 0; i < pattern.Length / 2; i++)
            {
                servo = byte.Parse(pattern[2 * i + 1]);
                pos = int.Parse(pattern[2 * i + 2]);

                binaryCommand.Add((byte)'#');
                binaryCommand.Add(servo);
                binaryCommand.Add((byte)(pos >> 8));
                binaryCommand.Add((byte)(pos & 0xFF));
            }

            binaryCommand.Add((byte)'T');
            binaryCommand.Add((byte) time);
            Port.Write(binaryCommand.ToArray(), 0, binaryCommand.Count);

            return 1;
        }

        /// <summary>
        /// Send command to hexapod
        /// </summary>
        /// <param name="cmd">Movement command</param>
        public int SendCommand(String cmd)
        {
            if (!Port.IsOpen)
            {
                return 0;
            }

            byte servo;
            int pos;

            var pattern = cmd.Trim().Split('#', 'P');
            var binaryCommand = new List<byte>();

            for (int i = 0; i < pattern.Length / 2; i++)
            {
                servo = byte.Parse(pattern[2 * i + 1]);
                pos = int.Parse(pattern[2 * i + 2]);

                binaryCommand.Add((byte)'#');
                binaryCommand.Add(servo);
                binaryCommand.Add((byte)(pos >> 8));
                binaryCommand.Add((byte)(pos & 0xFF));
            }

            binaryCommand.Add((byte) 'T');
            binaryCommand.Add(0);
            Port.Write(binaryCommand.ToArray(), 0, binaryCommand.Count);

            return 1;
        }

        /// <summary>
        /// Send command to hexapod
        /// </summary>
        /// <param name="cmd">Movement command</param>
        public int SendCommand(byte[] cmd)
        {
            if (!Port.IsOpen)
            {
                return 0;
            }

            Port.Write(cmd, 0, 2);

            return 1;
        }
        /// <summary>
        /// Query movement Status
        /// </summary>
        /// <returns></returns>
        public char ReadResponse()
        {
            char response;
            try
            {
                response = (char) Port.ReadByte();
            }
            catch (TimeoutException)
            {
                response = '-';
            }
            return response;
        }
    }
}