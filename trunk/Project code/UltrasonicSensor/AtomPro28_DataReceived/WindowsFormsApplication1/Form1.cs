using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.IO.Ports;
using System.Diagnostics;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        // Set COM port
        SerialPort port = new SerialPort("COM7", 9600, Parity.None, 8, StopBits.One);
        // Set Data Received = 3 Bytes
        const int COUNT = 3;
        public Form1()
        {
            InitializeComponent();
            port.ReceivedBytesThreshold = COUNT;
            port.DataReceived += port_DataReceived;
        }

        /* Function : Receiving data from ATom Pro 28 */
        public void port_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            try
            {
                char[] buff = new char[COUNT];
                var le = port.Read(buff, 0, COUNT);
                // Store value in Integer type variable "value"
                int value = Int32.Parse(new String(buff, 0, COUNT), System.Globalization.NumberStyles.Any);
                Debug.WriteLine(value);
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Error : {0}", ex);
            }     
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            port.Open();
            if (port.IsOpen)
            {
                btnConnect.Enabled = false;
            }
        }
    }
}
