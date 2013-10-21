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
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;
using SharpDX;
using SharpDX.XInput;

namespace A_Pod_System_Controll
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        DispatcherTimer timer = new DispatcherTimer();
        private Bluetooth_Init BT_Controll;
        private Boolean PortisOpen;

        public MainWindow()
        {
            InitializeComponent();
            BT_Controll = new Bluetooth_Init();
            timer.Tick += new EventHandler(timerCounter_Tick);
            timer.Interval = new TimeSpan(0, 0, 1 / 10);
            timer.Start();
            
        }

        private void timerCounter_Tick(object sender, EventArgs e)
        {
            working_status.Visibility = Visibility.Collapsed;
            if (Controller_pad.IsConnected)
            {
                working_status.Visibility = Visibility.Visible;
                Gamepad pad = Controller_pad.GetState().Gamepad;

                ShowButtonStatus(pad);

                ShowDPad(pad);
                ShowJoyAxis(pad);
            }
        }
      
        public Boolean Open
        {
            get { return PortisOpen; }
            set { PortisOpen = value; }
        }

        private void ShowJoyAxis(Gamepad pad)
        {
            int leftL = (pad.LeftThumbX * 50) / 32768;
            int topL = (pad.LeftThumbY * 50) / -32768;

            if (leftL < 0)
            {
                btn_left.Visibility = Visibility.Collapsed;
            }
            else if (leftL == 0)
            {
                btn_left.Visibility = Visibility.Visible;
            }

            if (leftL > 0)
            {
                btn_right.Visibility = Visibility.Collapsed;
            }
            else if (leftL == 0)
            {
                btn_right.Visibility = Visibility.Visible;
            }

            if (topL < 0)
            {
                btn_up.Visibility = Visibility.Collapsed;
            }
            else if (leftL == 0)
            {
                btn_up.Visibility = Visibility.Visible;
            }

            if (topL > 0)
            {
                btn_down.Visibility = Visibility.Collapsed;
            }
            else if (topL == 0)
            {
                btn_down.Visibility = Visibility.Visible;
            }
        }
        private void ShowDPad(Gamepad pad)
        {
            if ((pad.Buttons & GamepadButtonFlags.DPadUp) != 0)
            {
                btn_up.Visibility = Visibility.Collapsed;// hide
                if (Open)
                {
                    //BT_Controll.writeData_SerialPort(ControlConstant.DECREASE_GRIPPER_TORGUE);
                }
            }
            else if ((pad.Buttons & GamepadButtonFlags.DPadUp) == 0)
            {
                btn_up.Visibility = Visibility.Visible;// visible

            }

            if ((pad.Buttons & GamepadButtonFlags.DPadDown) != 0)
            {
                btn_down.Visibility = Visibility.Collapsed;// hide
                //BT_Controll.writeData_SerialPort(ControlConstant.DECREASE_GRIPPER_TORGUE);
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
                BT_Controll.writeData_SerialPort(ControlConstant.DECREASE_GRIPPER_TORGUE);
                //System.Threading.Thread.Sleep(200);
            }
            else if ((pad.Buttons & GamepadButtonFlags.Back) == 0)
            {
                btn_select.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.Start) != 0)
            {
                btn_start.Visibility = Visibility.Collapsed;// hide
                BT_Controll.writeData_SerialPort(ControlConstant.CLOSE_MANDIBLES);
                //System.Threading.Thread.Sleep(200);
            }
            else if ((pad.Buttons & GamepadButtonFlags.Start) == 0)
            {
                btn_start.Visibility = Visibility.Visible;// visible
            }

            if ((pad.LeftTrigger) != 0)
            {
                L1.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.LeftTrigger) == 0)
            {
                L1.Visibility = Visibility.Visible;// visible
            }

            if ((pad.RightTrigger) != 0)
            {
                R1.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.RightTrigger) == 0)
            {
                R1.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.LeftShoulder) != 0)
            {
                L2.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.LeftShoulder) == 0)
            {
                L2.Visibility = Visibility.Visible;// visible
            }

            if ((pad.Buttons & GamepadButtonFlags.RightShoulder) != 0)
            {
                R2.Visibility = Visibility.Collapsed;// hide
            }
            else if ((pad.Buttons & GamepadButtonFlags.RightShoulder) == 0)
            {
                R2.Visibility = Visibility.Visible;// visible
            }

        }

        // initial controller
        Controller Controller_pad = new Controller(UserIndex.One);

        private void btn_Bluetooth_Click(object sender, RoutedEventArgs e)
        {
            Bluetooth_Control btControl = new Bluetooth_Control();
            btControl.Show();
        }
    }
}
