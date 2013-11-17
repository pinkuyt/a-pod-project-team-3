using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace APOD_Controller.APOD.Configuration
{
    /// <summary>
    /// Interaction logic for Configuration.xaml
    /// </summary>
    public partial class Configuration
    {
        public static bool Initiated = false;
        public static string CameraIp;
        public static string OutgoingPort;
        public static int OutgoingBaudrate;
        public static string IncomingPort;
        public static int IncomingBaudrate;
        public static string Login;
        public static string Password;

        public Configuration()
        {
            InitializeComponent();

            LoadPort();
        }

        private void LoadPort()
        {
            cbBTOutgoing.ItemsSource = SerialPort.GetPortNames();

            cbBTOutgoing.Items.Refresh();
        }

        private bool IsValid()
        {
            bool result = true;
            string regex = @"^\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b$";
            if (!Regex.IsMatch(txtCameraIP.Text, regex) || (txtCameraIP.Text == ""))
            {
                lblCameraIp.Foreground = Brushes.OrangeRed;
                result = false;
            }
            else
            {
                lblCameraIp.Foreground = Brushes.FloralWhite;
            }

            if (cbBTOutgoing.Text == "")
            {
                lblBTOutPort.Foreground = Brushes.OrangeRed;
                result = false;
            }
            else
            {
                lblBTOutPort.Foreground = Brushes.FloralWhite;
            }

            return result;
        }

        
        private void btnOK_Click(object sender, RoutedEventArgs e)
        {
            if (IsValid())
            {
                CameraIp = txtCameraIP.Text;
                OutgoingPort = cbBTOutgoing.Text;
                OutgoingBaudrate = int.Parse(cbBTOutgoingBaud.Text);
                Login = txtLogin.Text;
                Password = txtPassword.Password;

                Initiated = true;
                DialogResult = true;
                Close();
            }
        }

        private void btnBTRefresh_Click(object sender, RoutedEventArgs e)
        {
            LoadPort();
        }
    }
}
