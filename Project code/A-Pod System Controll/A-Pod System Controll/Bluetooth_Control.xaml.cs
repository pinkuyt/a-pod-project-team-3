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

namespace A_Pod_System_Controll
{
    /// <summary>
    /// Interaction logic for Bluetooth_Control.xaml
    /// </summary>
    public partial class Bluetooth_Control : Window
    {
        private Bluetooth_Init Bluetooh_Control_Init;

        bool isClicked = false;
        public Bluetooth_Control()
        {
            InitializeComponent();
            Bluetooh_Control_Init = new Bluetooth_Init();
            this.Loaded += BluetoothSeting_Loaded;
        }

        private void BluetoothSeting_Loaded(object sender, RoutedEventArgs e)
        {
            if (Bluetooh_Control_Init.PortOpenType == 0)
            {
                Check_Connect(true);
            }
            Keyboard.Focus(this.cmb_Port);
 
        }

        private void btn_Connect_Bluetooth_Click(object sender, RoutedEventArgs e)
        {
            Check_Connect(isClicked);
        }

        private void Check_Connect(bool check)
        {
            if (check == false)
            {
                try
                {
                    Bluetooh_Control_Init.SerialPort.PortName = this.cmb_Port.Text;
                    Bluetooh_Control_Init.SerialPort.BaudRate = Convert.ToInt32(this.cmb_Baudrate.Text);
                    Bluetooh_Control_Init.PortOpenType = 1;
                    try
                    {
                        Bluetooh_Control_Init.OpenPort();
                        MessageBox.Show(this.cmb_Port.Text + "is connected.");
                        this.btn_Connect_Bluetooth.Content = "Disconnect";
                        this.cmb_Port.IsEnabled = false;
                        this.cmb_Baudrate.IsEnabled = false;
                        isClicked = true;
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
                    this.btn_Connect_Bluetooth.Content = "Connect";
                    this.cmb_Port.IsEnabled = true;
                    this.cmb_Baudrate.IsEnabled = true;
                    Bluetooh_Control_Init.PortOpenType = 0;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Fail" + ex.Message);
                }
            }
        }
    }
}
