using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Hexapod;

namespace Hexapod_Test
{
    public partial class Form1 : Form
    {
        private SerialPort port;
        private APod Bot; 
        public Form1()
        {
            InitializeComponent();
            port = new SerialPort("COM7", 115200, Parity.None, 8, StopBits.One)
                {
                    WriteTimeout = 1000,
                    ReadTimeout = 1000
                };
            try
            {
                port.Open();
            }
            catch (System.IO.IOException e)
            {
                MessageBox.Show(e.Message);
            }

            Bot = new APod(port);
            //Bot.Reset();

            cbADC.Items.Add('A');
            cbADC.Items.Add('B');
            cbADC.Items.Add('C');
            cbADC.Items.Add('D');
            cbADC.SelectedIndex = 0;
        }

        /// <summary>
        /// Tripod A Legs: Left Front (Servo 16, 17, 18), Right Center (Servo 4, 5, 6), Left Rear (Servo 24, 25, 26)
        /// </summary>
        #region Tripod A

        private const String TripodA_High = "#17P1200 #18P1200 #5P1800 #6P1800 #25P1200 #26P1200 ";
        private const String TripodA_Mid = "#17P1500 #18P1500 #5P1500 #6P1500 #25P1500 #26P1500 ";
        private const String TripodA_Low = "#17P1800 #18P1800 #5P1200 #6P1200 #25P1800 #26P1800 ";
        private const String TripodA_Rear = "#16P1700 #4P1300 #24P1700 ";
        private const String TripodA_Center = "#16P1500 #4P1500 #24P1500 ";
        private const String TripodA_Front = "#16P1300 #4P1700 #24P1300 ";

        private const String TripodA_Left = "#16P1700 #4P1700 #24P1700 ";
        private const String TripodA_Right = "#16P1300 #4P1300 #24P1300 ";
        #endregion

        /// <summary>
        /// Tripod Bot Legs: Right Front (Servo 0, 1, 2), Left Center (Servo 20, 21,22), Right Rear (Servo 8, 9, 10)
        /// </summary>
        #region Tripod B

        private const String TripodB_High = "#1P1800 #2P1800 #21P1200 #22P1200 #9P1800 #10P1800 ";
        private const String TripodB_Mid = "#1P1500 #2P1500 #21P1500 #22P1500 #9P1500 #10P1500 ";
        private const String TripodB_Low = "#1P1200 #2P1200 #21P1800 #22P1800 #9P1200 #10P1200 ";
        private const String TripodB_Rear = "#0P1300 #20P1700 #8P1300 ";
        private const String TripodB_Center = "#0P1500 #20P1500 #8P1500 ";
        private const String TripodB_Front = "#0P1700 #20P1300 #8P1700 ";

        private const String TripodB_Left = "#0P1700 #20P1700 #8P1700 ";
        private const String TripodB_Right = "#0P1300 #20P1300 #8P1300 ";
        #endregion

        /// <summary>
        /// Send command to hexapod
        /// </summary>
        /// <param name="movement">Movement command</param>
        /// <param name="time">Execution time</param>
        private int SendCommand(String cmd, int time)
        {
            if (!port.IsOpen)
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
            binaryCommand.Add(1);
            port.Write(binaryCommand.ToArray(), 0, binaryCommand.Count);

            return 1;
        }

        #region Direct Command

        private void button1_Click(object sender, EventArgs e)
        {
            String cmd = txtCMD.Text;
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
            //binaryCommand.Add(0x21);
            binaryCommand.Add((byte) 'T');
            binaryCommand.Add((byte) (chkSlow.Checked ? 1 : 0));
            port.Write(binaryCommand.ToArray(), 0, binaryCommand.Count);
        }


        private void button7_Click(object sender, EventArgs e)
        {
            String cmd = txtCMD2.Text;
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
            //binaryCommand.Add(0x21);
            binaryCommand.Add((byte)'T');
            binaryCommand.Add((byte)(chkSlow.Checked ? 1 : 0));
            port.Write(binaryCommand.ToArray(), 0, binaryCommand.Count);
        }

        private void button8_Click(object sender, EventArgs e)
        {
            String cmd = txtCMD3.Text;
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
            //binaryCommand.Add(0x21);
            binaryCommand.Add((byte)'T');
            binaryCommand.Add((byte)(chkSlow.Checked ? 1 : 0));
            port.Write(binaryCommand.ToArray(), 0, binaryCommand.Count);
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            byte[] arr = { (byte)'S', 1 };
            port.Write(arr, 0, 2);
        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            byte[] arr = { (byte)'S', 0 };
            port.Write(arr, 0, 2);
        }

        #endregion

        #region Tripods Control

        private void btnHighTriA_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_High, 500);
        }

        private void btnMidTriA_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Mid, 500);
        }

        private void btnLowTriA_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Low, 500);
        }

        private void btnHighTriB_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_High, 500);
        }

        private void btnMidTriB_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Mid, 500);
        }

        private void btnLowTriB_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Low, 500);
        }

        private void btnRearTriA_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Rear, 500);
        }

        private void btnCenTriA_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Center, 500);
        }

        private void btnFrontTriA_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Front, 500);
        }

        private void btnRearTriB_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Rear, 500);
        }

        private void btnCenTriB_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Center, 500);
        }

        private void btnFrontTriB_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Front, 500);
        }

        private void btnLeftTriA_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Left, 500);
        }

        private void btnRightTriA_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Right, 500);
        }

        private void btnLeftTriB_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Left, 500);
        }

        private void btnRightTriB_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Right, 500);
        }

        #endregion

        #region Foward Steps

        private void btnInit_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Low + TripodA_Front + TripodB_Mid + TripodB_Rear, 500);
        }

        private void btnForward0_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Center + TripodB_High + TripodB_Center, 500);
        }

        private void btnForward1_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Rear + TripodB_Mid + TripodB_Front, 500);
        }

        private void btnForward2_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Low, 500);
        }

        private void btnForward3_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Mid, 500);
        }

        private void btnForward4_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_High + TripodA_Center + TripodB_Center, 500);
        }

        private void btnForward5_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Mid + TripodA_Front + TripodB_Rear, 500);
        }

        private void btnForward6_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Low, 500);
        }

        private void btnForward7_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Mid, 500);
        } 
        #endregion

        #region MiddleWare

        /// <summary>
        /// Initial position
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnApodInit_Click(object sender, EventArgs e)
        {
            Bot.Init();
        }

        private void btnShutdown_Click(object sender, EventArgs e)
        {
            Bot.Shutdown();
        }

        private void btnForward_Click(object sender, EventArgs e)
        {
            try
            {
                Bot.Forward(height: 200, width: 200, cycle: 3, time: 200);
            }
            catch (TimeoutException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnBackward_Click(object sender, EventArgs e)
        {
            try
            {
                Bot.Backward(height: 200, width: 200, cycle: 3, time: 200);
            }
            catch (TimeoutException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnLeanLeft_Click(object sender, EventArgs e)
        {
            //Bot.Lean(degree: 50, direction: -1, time: 200);
            Bot.Rotate(100, Direction.LEFT, 200);
        }

        private void btnLeanRight_Click(object sender, EventArgs e)
        {
            //Bot.Lean(degree: 50, direction: 1, time: 200);
            Bot.Rotate(100, Direction.RIGHT, 200);
        }

        private void btnTurnLeft_Click(object sender, EventArgs e)
        {
            Bot.TurnLeft(height: 200, width: 200, cycle: 1, time: 200);
        }

        private void btnTurnRight_Click(object sender, EventArgs e)
        {
            Bot.TurnRight(height: 200, width: 200, cycle: 1, time: 200);
        }

        private void btnHigher_Click(object sender, EventArgs e)
        {
            Bot.Push(100, Direction.UP, 200);
        }

        private void btnLower_Click(object sender, EventArgs e)
        {
            Bot.Push(100, Direction.DOWN, 200);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Bot.Push(100, Direction.FORWARD, 200);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Bot.Push(100, Direction.BACKWARD, 200);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            Bot.Push(100, Direction.LEFT, 200);
        }

        private void button5_Click(object sender, EventArgs e)
        {
            Bot.Push(100, Direction.RIGHT, 200);
        }

        private void btnLeanForward_Click(object sender, EventArgs e)
        {
            //Bot.LeanForward(100, 1, 300);
            Bot.Rotate(100, Direction.FORWARD, 200);
        }

        private void btnLeanBackward_Click(object sender, EventArgs e)
        {
            //Bot.LeanForward(-100, 1, 300);
            Bot.Rotate(100, Direction.BACKWARD, 200);
        }

        private void btnStrafeLeft_Click(object sender, EventArgs e)
        {
            Bot.StrafeLeft(200, 200, 2, 300);
        }

        private void btnHeadUp_Click(object sender, EventArgs e)
        {
            Bot.HeadTurn(100, Direction.UP, 200);
        }

        private void btnHeadDown_Click(object sender, EventArgs e)
        {
            Bot.HeadTurn(100, Direction.DOWN, 200);
        }

        private void btnHeadTurnLeft_Click(object sender, EventArgs e)
        {
            Bot.HeadTurn(100, Direction.LEFT, 200);
        }

        private void btnHeadTurnRight_Click(object sender, EventArgs e)
        {
            Bot.HeadTurn(100, Direction.RIGHT, 200);
        }

        private void btnHeadRotateLeft_Click(object sender, EventArgs e)
        {
            Bot.HeadRotate(100, Direction.LEFT, 200);
        }

        private void btnHeadRotateRight_Click(object sender, EventArgs e)
        {
            Bot.HeadRotate(100, Direction.RIGHT, 200);
        }


        private void btnGrip_Click(object sender, EventArgs e)
        {
            if (chkAuto.Checked)
            {
                Bot.Grip();
            }
            else
            {
                Bot.Grip(20,20);
            }
        }

        private void btnLoose_Click(object sender, EventArgs e)
        {
            if (chkAuto.Checked)
            {
                Bot.Loose();
            }
            else
            {
                Bot.Loose(20, 20);
            }
        }

        private void TripodsButton_Click(object sender, EventArgs e)
        {
            Button button = (Button) sender;
            String name = button.Name;
            String action = name.Substring(3, 7) + "_" + name.Substring(10);
            // MessageBox.Show(action);
            object[] arg = { 100, 200 };
            System.Reflection.MethodInfo methodInfo = typeof(APod).GetMethod(action);
            methodInfo.Invoke(Bot, arg);
        }
        #endregion

        #region Rotating Steps

        private void btnTurnInit_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Low + TripodA_Left + TripodB_Mid + TripodB_Right, 500);
        }

        private void btnTurn0_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Center + TripodB_High + TripodB_Center, 500);
        }

        private void btnTurn1_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Right + TripodB_Mid + TripodB_Left, 500);
        }

        private void btnTurn2_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Low, 500);
        }

        private void btnTurn3_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Mid, 500);
        }

        private void btnTurn4_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_High + TripodA_Center + TripodB_Center, 500);
        }

        private void btnTurn5_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Mid + TripodA_Left + TripodB_Right, 500);
        }

        private void btnTurn6_Click(object sender, EventArgs e)
        {
            SendCommand(TripodA_Low, 500);
        }

        private void btnTurn7_Click(object sender, EventArgs e)
        {
            SendCommand(TripodB_Mid, 500);
        } 
        #endregion

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (port.IsOpen)
            {
                port.Close();
            }
        }

        private void chkSim_CheckedChanged(object sender, EventArgs e)
        {
            if (chkSim.Checked)
            {
                port = new SerialPort("COM5", 38400, Parity.None, 8, StopBits.One)
                {
                    WriteTimeout = 1000,
                    ReadTimeout = 1000
                };
            }
            else
            {
                port = new SerialPort("COM7", 115200, Parity.None, 8, StopBits.One)
                {
                    WriteTimeout = 1000,
                    ReadTimeout = 1000
                };
            }
            Bot.SetPort(port);
            try
            {
                port.Open();
            }
            catch (System.IO.IOException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        
        private void StrafeButton_Click(object sender, EventArgs e)
        {
            String name = ((Button) sender).Text;
            String cmd = "";
            switch (name)
            {
                case "Init": // low, left || mid, right
                    cmd = // A
                        Bot.LeftFront.FixPosition(1500, 1400, 1400) +
                        Bot.RightCenter.FixPosition(1500, 1600, 1600) +
                        Bot.LeftRear.FixPosition(1500, 1400, 1400) +
                        // B
                        Bot.RightFront.FixPosition(1500, 2000, 2000) +
                        Bot.LeftCenter.FixPosition(1500, 1000, 1000) +
                        Bot.RightRear.FixPosition(1500, 2000, 2000);
                    break;
                case "Step 0": // low, center || high, center
                     cmd = // A
                        Bot.LeftFront.FixPosition(1500, 1400, 1400) +
                        Bot.RightCenter.FixPosition(1500, 1600, 1600) +
                        Bot.LeftRear.FixPosition(1500, 1400, 1400) +
                        // B
                        Bot.RightFront.FixPosition(1500, 2000, 2000) +
                        Bot.LeftCenter.FixPosition(1500, 1000, 1000) +
                        Bot.RightRear.FixPosition(1500, 2000, 2000);
                    break;
                case "Step 1": // low right || mid left
                    cmd = // A
                        Bot.LeftFront.FixPosition(1420, 1440, 1280) +
                        Bot.RightCenter.FixPosition(1500, 1560, 1400) +
                        Bot.LeftRear.FixPosition(1620, 1440, 1280) +
                        // B
                        Bot.RightFront.FixPosition(1580, 1760, 1720) +
                        Bot.LeftCenter.FixPosition(1500, 1240, 1600) +
                        Bot.RightRear.FixPosition(1380, 1760, 1720);
                    break;
                case "Step 2": // low right || low left
                    cmd = // A
                        Bot.LeftFront.FixPosition(1420, 1440, 1280) +
                        Bot.RightCenter.FixPosition(1500, 1560, 1400) +
                        Bot.LeftRear.FixPosition(1620, 1440, 1280) +
                        // B
                        Bot.RightFront.FixPosition(1580, 1560, 1720) +
                        Bot.LeftCenter.FixPosition(1500, 1440, 1600) +
                        Bot.RightRear.FixPosition(1380, 1560, 1720);
                    break;
                case "Step 3": // mid right || low left
                    cmd = // A
                        Bot.LeftFront.FixPosition(1420, 1240, 1280) +
                        Bot.RightCenter.FixPosition(1500, 1760, 1400) +
                        Bot.LeftRear.FixPosition(1620, 1240, 1280) +
                        // B
                        Bot.RightFront.FixPosition(1580, 1560, 1720) +
                        Bot.LeftCenter.FixPosition(1500, 1440, 1600) +
                        Bot.RightRear.FixPosition(1380, 1560, 1720);
                    break;
                case "Step 4": // high center || low center
                    cmd = // A
                        Bot.LeftFront.FixPosition(1500, 1000, 1000) +
                        Bot.RightCenter.FixPosition(1500, 2000, 2000) +
                        Bot.LeftRear.FixPosition(1500, 1000, 1000) +
                        // B
                        Bot.RightFront.FixPosition(1500, 1600, 1600) +
                        Bot.LeftCenter.FixPosition(1500, 1400, 1400) +
                        Bot.RightRear.FixPosition(1500, 1600, 1600);
                    break;
                case "Step 5": // mid left || low right
                    cmd = // A
                        Bot.LeftFront.FixPosition(1620, 1240, 1600) +
                        Bot.RightCenter.FixPosition(1500, 1760, 1720) +
                        Bot.LeftRear.FixPosition(1420, 1240, 1600) +
                        // B
                        Bot.RightFront.FixPosition(1380, 1560, 1400) +
                        Bot.LeftCenter.FixPosition(1500, 1440, 1280) +
                        Bot.RightRear.FixPosition(1580, 1560, 1400);
                    break;
                case "Step 6": // low left || low right
                    cmd = // A
                        Bot.LeftFront.FixPosition(1620, 1440, 1600) +
                        Bot.RightCenter.FixPosition(1500, 1560, 1720) +
                        Bot.LeftRear.FixPosition(1420, 1440, 1600) +
                        // B
                        Bot.RightFront.FixPosition(1380, 1560, 1400) +
                        Bot.LeftCenter.FixPosition(1500, 1440, 1280) +
                        Bot.RightRear.FixPosition(1580, 1560, 1400);
                    break;
                case "Step 7": // low left || mid right
                    cmd = // A
                        Bot.LeftFront.FixPosition(1620, 1440, 1600) +
                        Bot.RightCenter.FixPosition(1500, 1560, 1720) +
                        Bot.LeftRear.FixPosition(1420, 1440, 1600) +
                        // B
                        Bot.RightFront.FixPosition(1380, 1760, 1400) +
                        Bot.LeftCenter.FixPosition(1500, 1240, 1280) +
                        Bot.RightRear.FixPosition(1580, 1760, 1400);
                    break;
            }
            SendCommand(cmd, 200);
        }

        private void button6_Click(object sender, EventArgs e)
        {
            port.ReadExisting();
            char channel = cbADC.Text[0];
            byte[] val = { (byte)'V', (byte)channel };
            port.Write(val, 0, 2);
            try
            {
                System.Threading.Thread.Sleep(10);
                port.Read(val, 0, 2);
                txtADC.Text = (((int) val[0]) << 8) + val[1] + "";
            }
            catch (TimeoutException)
            {
                MessageBox.Show("Time out");
            }
        }


        

    }
}
