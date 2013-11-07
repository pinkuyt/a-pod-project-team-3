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
using System.IO.Ports;

using APOD_Controller.APOD.Connector;

namespace APOD_Controller
{
    /// <summary>
    /// Interaction logic for BluetoothConnection.xaml
    /// </summary>
    public partial class BluetoothConnection : Window
    {
        private Bluetooth_Init Bluetooh_Control_Init;

        bool isClicked = false;
        bool isOpen = false;
        public BluetoothConnection()
        {
            InitializeComponent();
            Bluetooh_Control_Init = new APOD.Connector.Bluetooth_Init();
            this.Loaded += BluetoothSeting_Loaded;
        }

        private void BluetoothSeting_Loaded(object sender, RoutedEventArgs e)
        {
            if (Bluetooh_Control_Init.PortOpenType == 0)
            {
                Check_Connect(true);
            }
            Keyboard.Focus(this.cmbPortCom);
        }

        private void Check_Connect(bool check)
        {
            if (check == false)
            {
                try
                {
                    Bluetooh_Control_Init.SerialPort.PortName = this.cmbPortCom.Text;
                    Bluetooh_Control_Init.SerialPort.BaudRate = Convert.ToInt32(this.cmbBaudrate.Text);
                    Bluetooh_Control_Init.PortOpenType = 1;
                    try
                    {
                        Bluetooh_Control_Init.OpenPort();
                        MessageBox.Show(this.cmbPortCom.Text + "is connected.");
                        this.btnConnectBluetooth.Content = "Disconnect";
                        this.cmbPortCom.IsEnabled = false;
                        this.cmbBaudrate.IsEnabled = false;
                        isClicked = true;
                        isOpen = true;
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Fail" + ex.Message);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Fail" + ex.Message);
                }
            }
            else
            {
                try
                {
                    isClicked = false;
                    Bluetooh_Control_Init.ClosePort();
                    this.btnConnectBluetooth.Content = "Connect";
                    this.cmbPortCom.IsEnabled = true;
                    this.cmbBaudrate.IsEnabled = true;
                    Bluetooh_Control_Init.PortOpenType = 0;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Fail" + ex.Message);
                }
            }
        }

        private void btnConnectBluetooth_Click(object sender, RoutedEventArgs e)
        {
            Check_Connect(isClicked);
        }
    }
}
