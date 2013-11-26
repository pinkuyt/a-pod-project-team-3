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
        public static int CameraPort;
        public static string OutgoingPort;
        public static int OutgoingBaudrate;
        public static string IncomingPort;
        public static int IncomingBaudrate;
        public static string Login;
        public static string Password;

        /// <summary>
        /// Default constructor
        /// </summary>
        public Configuration()
        {
            InitializeComponent();
            LoadPort();
            // default ip and port
            txtCameraIP.Text = "192.168.2.105";
            txtCameraPort.Text = "80";
            // Default port: Com 4
            cbBTOutgoing.SelectedIndex = cbBTOutgoing.Items.Count - 1;
        }

        /// <summary>
        /// Get all available portnames.
        /// </summary>
        private void LoadPort()
        {
            cbBTOutgoing.ItemsSource = SerialPort.GetPortNames();
            // update layout
            cbBTOutgoing.Items.Refresh();
        }

        /// <summary>
        /// Is current information valid.
        /// </summary>
        /// <returns></returns>
        private bool IsValid()
        {
            bool result = true;
            // IP check
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

            int port;
            if (!int.TryParse(txtCameraPort.Text, out port))
            {
                lblCameraPort.Foreground = Brushes.OrangeRed;
                result = false;
            }
            else
            {
                lblCameraPort.Foreground = Brushes.FloralWhite;
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

        /// <summary>
        ///  Update avalable port
        /// </summary>
        /// <param name="sender">Event Source</param>
        /// <param name="e">Event Arguments</param>
        private void btnBTRefresh_Click(object sender, RoutedEventArgs e)
        {
            LoadPort();
        }

        /// <summary>
        /// Return result for parents window
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnOK_Click(object sender, RoutedEventArgs e)
        {
            if (IsValid())
            {
                // set static value
                CameraIp = txtCameraIP.Text;
                CameraPort = int.Parse(txtCameraPort.Text);
                Login = txtLogin.Text;
                Password = txtPassword.Password;

                OutgoingPort = cbBTOutgoing.Text;
                OutgoingBaudrate = int.Parse(cbBTOutgoingBaud.Text);
                
                Initiated = true;
                DialogResult = true;
                Close();
            }
        }

    }
}
