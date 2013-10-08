using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;
using SharpDX.XInput;

namespace WpfGamepaddState
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        DispatcherTimer timer = new DispatcherTimer();
        public MainWindow()
        {
            InitializeComponent();
            timer.Tick += new EventHandler(timerCounter_Tick);
            timer.Interval = new TimeSpan(0, 0, 1/10);
            timer.Start();
        }
        private void timerCounter_Tick(object sender, EventArgs e)
        {
            lblStatus.Content = "Connect an XInput Pad";

            if (Controller_pad.IsConnected)
            {
                lblStatus.Content = "XInput Pad Connected";

                Gamepad pad = Controller_pad.GetState().Gamepad;

                ShowButtonStatus(pad);

                ShowDPad(pad); 
            }

        }

        private void ShowDPad(Gamepad pad)
        {
            if ((pad.Buttons & GamepadButtonFlags.DPadUp) != 0)
            {
                btn_up.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.DPadUp) == 0)
            {
                btn_up.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.DPadDown) != 0)
            {
                btn_down.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.DPadDown) == 0)
            {
                btn_down.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.DPadLeft) != 0)
            {
                btn_left.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.DPadLeft) == 0)
            {
                btn_left.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.DPadRight) != 0)
            {
                btn_right.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.DPadRight) == 0)
            {
                btn_right.Visibility = Visibility.Visible;// visible
            }
        }

        private void ShowButtonStatus(Gamepad pad)
        {
            
            if ((pad.Buttons & GamepadButtonFlags.A) != 0)
            {
                btn_circle.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.A) == 0)
            {
                btn_circle.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.B) != 0)
            {
                btn_cross.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.B) == 0)
            {
                btn_cross.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.X) != 0)
            {
                btn_triangle.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.X) == 0)
            {
                btn_triangle.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.Y) != 0)
            {
                btn_square.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.Y) == 0)
            {
                btn_square.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.Back) != 0)
            {
                btn_select.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.Back) == 0)
            {
                btn_select.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.Start) != 0)
            {
                btn_start.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.Start) == 0)
            {
                btn_start.Visibility = Visibility.Visible;// visible
            }

            if ((pad.LeftTrigger) != 0)
            {
                btn_L1.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.LeftTrigger) == 0)
            {
                btn_L1.Visibility = Visibility.Visible;// visible
            }

            if ((pad.RightTrigger) != 0)
            {
                btn_R1.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.RightTrigger) == 0)
            {
                btn_R1.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.LeftShoulder) != 0)
            {
                btn_L2.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.LeftShoulder) == 0)
            {
                btn_L2.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.RightShoulder) != 0)
            {
                btn_R2.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.RightShoulder) == 0)
            {
                btn_R2.Visibility = Visibility.Visible;// visible
            }
            
        }
        // initial controller
        Controller Controller_pad = new Controller(UserIndex.One);

        private void Button_Click(object sender, RoutedEventArgs e)
        {

        }

        private void Image_ImageFailed(object sender, ExceptionRoutedEventArgs e)
        {

        }
    }
}
