using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;
using AForge.Controls;
using APOD_Keypad;

namespace APOD_Controller.APOD.Input
{
    public class GamepadDevice
    {
        public bool IsScanning
        {
            get { return Scanner.IsBusy; }
        }
        private BackgroundWorker Scanner;

        private Key Up;
        private Key Down;
        private Key Left;
        private Key Right;

        private Key[] Buttons;

        public GamepadDevice(Key up, Key down, Key left, Key right,
            Key button0, Key button1, Key button2, Key button3, Key button4,
            Key button5, Key button6, Key button7, Key button8, Key button9)
        {
            Up = up;
            Down = down;
            Left = left;
            Right = right;

            Buttons = new Key[10];

            Buttons[0] = button0;
            Buttons[1] = button1;
            Buttons[2] = button2;
            Buttons[3] = button3;
            Buttons[4] = button4;
            Buttons[5] = button5;
            Buttons[6] = button6;
            Buttons[7] = button7;
            Buttons[8] = button8;
            Buttons[9] = button9;

            Scanner = new BackgroundWorker();
            Scanner.WorkerSupportsCancellation = true;
            Scanner.DoWork += Scan;
        }

        public void Start()
        {
            Scanner.RunWorkerAsync();
        }

        public void Stop()
        {
            Scanner.CancelAsync();
        }

        private void Scan(object sender, DoWorkEventArgs e)
        {
            Joystick joystick = new Joystick(0);
            Joystick.Status status;
            String buttons = "";
            BackgroundWorker worker = (BackgroundWorker) sender;
            while (!worker.CancellationPending)
            {
                status = joystick.GetCurrentStatus();
                buttons = status.Buttons.ToString();
                // action button
                if (buttons != "0")
                {
                    List<string> inputs = buttons.Split(new[] { "Button", ", " }, StringSplitOptions.RemoveEmptyEntries).ToList();

                    SetClickCallBack callBack = SetClick;
                    for (int i = 0; i < Buttons.Length; i++)
                    {
                        Buttons[i].Dispatcher.Invoke(callBack,
                            new object[] {i.ToString(), 
                                inputs.Contains((i+1).ToString())});
                    }
                }
                else
                {
                    SetClickCallBack callBack = SetClick;
                    for (int i = 0; i < Buttons.Length; i++)
                    {
                        Buttons[i].Dispatcher.Invoke(callBack,
                            new object[] {i.ToString(), false});
                    }
                }

                try
                {
                    // navigation button
                    switch ((int)status.XAxis)
                    {
                        case -1:
                            Left.Dispatcher.Invoke(() =>
                                {
                                    Left.Click = true;
                                }
                                );
                            break;
                        case 1:
                            Left.Dispatcher.Invoke(() =>
                                {
                                    Right.Click = true;
                                }
                                );
                            break;
                        default:
                            Left.Dispatcher.Invoke(() =>
                                {
                                    Left.Click = false;
                                }
                                );
                            Left.Dispatcher.Invoke(() =>
                                {
                                    Right.Click = false;
                                }
                                );
                            break;
                    }
                    switch ((int)status.YAxis)
                    {
                        case -1:
                            Up.Dispatcher.Invoke(() =>
                                {
                                    Up.Click = true;
                                }
                                );
                            break;
                        case 1:
                            Down.Dispatcher.Invoke(() =>
                                {
                                    Down.Click = true;
                                }
                                );
                            break;
                        default:
                            Up.Dispatcher.Invoke(() =>
                                {
                                    Up.Click = false;
                                }
                                );
                            Down.Dispatcher.Invoke(() =>
                                {
                                    Down.Click = false;
                                }
                                );
                            break;
                    }
                }
                catch (TaskCanceledException )
                {
                    break;
                }

            }
        }

        public delegate void SetClickCallBack(string id, bool clicked);

        void SetClick(string id, bool clicked)
        {
            Buttons[int.Parse(id)].Click = clicked;
        }

        
    }
}
