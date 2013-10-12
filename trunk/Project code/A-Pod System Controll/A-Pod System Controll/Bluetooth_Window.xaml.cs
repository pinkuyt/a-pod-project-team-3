using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.ComponentModel;
using System.Threading;
using InTheHand.Net;
using InTheHand.Net.Sockets;
using System.IO.Ports;//

namespace A_Pod_System_Controll
{
    /// <summary>
    /// Interaction logic for Bluetooth_Window.xaml
    /// </summary>
    public partial class Bluetooth_Window : Window
    {
        BackgroundWorker bg;
        //private BluetoothClient bluetoothClient;
        int Selected;
        //BackgroundWorker bg_send;
        public Bluetooth_Window()
        {
            InitializeComponent();
            bg = new BackgroundWorker();
            //bg_send = new BackgroundWorker();

            bg.DoWork += new DoWorkEventHandler(bg_DoWork);
            bg.RunWorkerCompleted += new RunWorkerCompletedEventHandler(bg_RunWorkerCompleted);

        }



        private void bg_DoWork(object sender, DoWorkEventArgs e)
        {
            List<Device> devices = new List<Device>();
            InTheHand.Net.Sockets.BluetoothClient bc = new InTheHand.Net.Sockets.BluetoothClient();
            InTheHand.Net.Sockets.BluetoothDeviceInfo[] array = bc.DiscoverDevices();
            int count = array.Length;
            for (int i = 0; i < count; i++)
            {
                Device device = new Device(array[i]);
                devices.Add(device);
            }
            e.Result = devices;
        }

        private void bg_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            device_list.ItemsSource = (List<Device>)e.Result;
            pb.Visibility = Visibility.Hidden;
        }

        private void btn_Find_Click(object sender, RoutedEventArgs e)
        {
            if (!bg.IsBusy)
            {
                pb.Visibility = Visibility.Visible;
                bg.RunWorkerAsync();
            }
        }

        private void device_list_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (device_list.SelectedItem != null)
            {
                Device device = (Device)device_list.SelectedItem;

                txt_Authenticated.Text = device.Authenticated.ToString();
                txt_Connected.Text = device.Connected.ToString();
                txt_devicename.Text = device.DeviceName.ToString();
                txt_LastSeen.Text = device.LastSeen.ToString();
                txt_LastUsed.Text = device.LastUsed.ToString();
                txt_Nap.Text = device.Nap.ToString();
                txt_Remembered.Text = device.Remembered.ToString();
                txt_Sap.Text = device.Sap.ToString();

            }
        }

        //public string FilePath { get; set; }

       

        private void btn_send_file_Click(object sender, RoutedEventArgs e)
        {
            byte[] Command = Encoding.ASCII.GetBytes("It works");//{0x00,0x01,0x88};

            SerialPort BlueToothConnection = new SerialPort();
            BlueToothConnection.BaudRate = (9600);

            BlueToothConnection.PortName = "COM3";
            BlueToothConnection.Open();
            if (BlueToothConnection.IsOpen)
            {

                //BlueToothConnection.ErrorReceived += new SerialErrorReceivedEventHandler(BlueToothConnection_ErrorReceived);

                //// Declare a 2 bytes vector to store the message length header
                //Byte[] MessageLength = { 0x00, 0x00 };

                ////set the LSB to the length of the message
                //MessageLength[0] = (byte)Command.Length;


                ////send the 2 bytes header
                //BlueToothConnection.Write(MessageLength, 0, MessageLength.Length);

                //// send the message itself

                //System.Threading.Thread.Sleep(2000);
                //BlueToothConnection.Write(Command, 0, Command.Length);

                //Messages(5, ""); //This is the last thing that prints before it just waits for response.

                //int length = BlueToothConnection.ReadByte();
                //Messages(6, "");
                //// retrieve the reply data
                //for (int i = 0; i < length; i++)
                //{
                //    Messages(7, (BlueToothConnection.ReadByte().ToString()));
                //}
            }

        }

        private void BlueToothConnection_ErrorReceived(object sender, SerialErrorReceivedEventArgs e)
        {
            MessageBox.Show("Connection problem occurred! ");
        }

        private void btn_browse_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_connect_Click(object sender, RoutedEventArgs e)
        {

            if (this.device_list.SelectedIndex == -1)
            {
                MessageBox.Show("Please select a device.");
                return;
            }
            //Selected = this.device_list.SelectedIndex;
            else
            {
                bool equal = string.Equals(txt_devicename.Text, "HC-05");
                if (equal == true)
                {
                    //SerialPort BlueToothConnection = new SerialPort();
                    //BlueToothConnection.BaudRate = (9600);

                    //BlueToothConnection.PortName = "COM4";
                    //BlueToothConnection.Open();
                    //MessageBox.Show("HC-05 connected!");
                    //this.Close();

                }
                else
                {
                    MessageBox.Show("Does not allow other devices connected!");
                }
            }
          
            //this.thrSend = new Thread(new ThreadStart(sendfile));
            //this.thrSend.Start();
        }
    }
}
