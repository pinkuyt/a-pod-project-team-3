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

namespace A_Pod_System_Controll
{
    /// <summary>
    /// Interaction logic for Bluetooth_Window.xaml
    /// </summary>
    public partial class Bluetooth_Window : Window
    {
        BackgroundWorker bg;
        private BluetoothClient bluetoothClient;
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

        public string FilePath { get; set; }

       

        private void btn_send_file_Click(object sender, RoutedEventArgs e)
        {
            
        }

        private void btn_browse_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_connect_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
