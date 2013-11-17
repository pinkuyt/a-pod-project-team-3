using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.Globalization;
using System.IO.Ports;
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
using System.Xml.Linq;
using System.Xml;
using AForge;
using AForge.Imaging;
using AForge.Imaging.Filters;
using AForge.Video;
using AForge.Video.DirectShow;
using APOD_Controller.APOD.Configuration;
using APOD_Controller.APOD.Communication;
using APOD_Controller.APOD.Input;
using APOD_Controller.APOD.Object_Tracking;
using APOD_Controller.APOD.Sequences;
using APOD_Keypad;

using Brush = System.Windows.Media.Brush;
using Color = System.Drawing.Color;
using Key = APOD_Keypad.Key;
using Pen = System.Drawing.Pen;
using Rectangle = System.Drawing.Rectangle;

namespace APOD_Controller
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow
    {
        /// <summary>
        /// Locker for all communication activities
        /// </summary>
        private bool IsLocked
        {
            get
            {
                bool result = ((SequencePlayer != null) && SequencePlayer.IsPlaying()) ||
                              (btnTrackingLock.IsChecked == true);
                return result;
            }
        }

        /// <summary>
        /// Bluetooth device connector
        /// </summary>
        private BluetoothDevice Bluetooth;

        /// <summary>
        /// Virtual button objects
        /// </summary>
        private Key[] VirtualButtons;

        /// <summary>
        /// gamepad device control
        /// </summary>
        private GamepadDevice GamePad;

        /// <summary>
        /// List of current sequence's states
        /// </summary>
        private MoveItemsCollection Sequence;

        /// <summary>
        /// Player 
        /// </summary>
        private Player SequencePlayer;

        private ObjectTracker Tracker;

        /// <summary>
        /// Local video devices array
        /// </summary>
        protected FilterInfoCollection LocalVideoDevices;

        /// <summary>
        /// Default constructor
        /// </summary>
        public MainWindow()
        {
            InitializeComponent();
            // init sequence
            Sequence = new MoveItemsCollection();
            tblSequences.ItemsSource = Sequence;
            
            // get local video device information
            LocalVideoDevices = new FilterInfoCollection(FilterCategory.VideoInputDevice);

            // initialize gamepad Control object
            GamePad = new GamepadDevice(navUp, navDown, navLeft, navRight, actTriangle, actCircle, actCross, actSquare,
                                       actL2, actR2, actL1, actR1, actSelect, actStart);


            // Organize virtual keypad
            VirtualButtons = new Key[14];
            Keypad_Init();
            Keypad_CommandMap();

            tabControl.Items.Remove(tabPlayer);
        }

        /**
         * User define method
         */
        #region Suport/Multipurposes Methods

        /// <summary>
        /// Keep tracking on virtual keypad
        /// </summary>
        private void Keypad_Init()
        {
            VirtualButtons[0] = actTriangle;
            VirtualButtons[1] = actCircle;
            VirtualButtons[2] = actCross;
            VirtualButtons[3] = actSquare;
            VirtualButtons[4] = actL2;
            VirtualButtons[5] = actR2;
            VirtualButtons[6] = actL1;
            VirtualButtons[7] = actR1;
            VirtualButtons[8] = actSelect;
            VirtualButtons[9] = actStart;
            VirtualButtons[10] = navUp;
            VirtualButtons[11] = navDown;
            VirtualButtons[12] = navRight;
            VirtualButtons[13] = navLeft;
        }

        /// <summary>
        /// Disable all virtual keypad
        /// </summary>
        void Keypad_Disable()
        {
            foreach (Key button in VirtualButtons)
            {
                button.Disabled = true;
            }
        }

        /// <summary>
        /// Enable all virtual keypad
        /// </summary>
        void Keypad_Enable()
        {
            foreach (Key button in VirtualButtons)
            {
                button.Disabled = false;
            }
        }

        /// <summary>
        /// register handler for mouse click effect
        /// </summary>
        void Keypad_MouseMap()
        {
            foreach (Key button in VirtualButtons)
            {
                button.MouseUp += KeyPad_Up;
                button.MouseDown += KeyPad_Down;
                button.MouseLeave += KeyPad_Leave;
            }
        }

        /// <summary>
        /// unregister handler for mouse click effect
        /// </summary>
        void Keypad_MouseUnmap()
        {
            foreach (Key button in VirtualButtons)
            {
                button.MouseUp -= KeyPad_Up;
                button.MouseDown -= KeyPad_Down;
                button.MouseLeave -= KeyPad_Leave;
            }
        }

        /// <summary>
        /// register handler for keyboard input
        /// </summary>
        void Keypad_KeyboardMap()
        {
            tabLiveControl.KeyDown += Keyboard_KeyDown;
            tabLiveControl.KeyUp += Keyboard_KeyUp;
        }

        /// <summary>
        /// unregister handler for keyboard input
        /// </summary>
        void Keypad_KeyboardUnmap()
        {
            tabLiveControl.KeyDown -= Keyboard_KeyDown;
            tabLiveControl.KeyUp -= Keyboard_KeyUp;
        }

        /// <summary>
        /// Register command sender
        /// </summary>
        void Keypad_CommandMap()
        {
            foreach (Key button in VirtualButtons)
            {
                button.PropertyChanged += OnCommand;
            }
        }

        /// <summary>
        /// Check for configuration
        /// </summary>
        /// <returns></returns>
        public bool CheckConfig() 
        {
            if (Configuration.Initiated) return true;
            MessageBoxResult result = MessageBox.Show("No Configuration was made. \nDo you want to config now?", "Configuration required", MessageBoxButton.YesNo,
                            MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
            {
                Configuration config = new Configuration();
                if (config.ShowDialog() == true)
                {
                    Bluetooth = new BluetoothDevice(Configuration.OutgoingPort, Configuration.OutgoingBaudrate);
                    //Bluetooth.ComPort.DataReceived += (sender, args) =>
                    //    {
                    //        MessageBox.Show(Bluetooth.ComPort.ReadByte().ToString());
                    //    };
                        
                    if (Bluetooth.Open() == 1)
                    {
                        return true;
                    }
                    MessageBox.Show("Bluetooth connetion fail.");
                    Configuration.Initiated = false;
                }
            }
            return false;
        }

        /// <summary>
        /// Open video source
        /// </summary>
        /// <param name="source">View source</param>
        private void OpenVideoSource(IVideoSource source)
        {
            // set busy cursor
            this.Cursor = Cursors.Wait;

            // stop current video source
            CloseCurrentVideoSource();

            // start new video source
            viewCam.VideoSource = source;
            viewCam.Start();

            // reset cursor
            this.Cursor = Cursors.Arrow;
        }

        /// <summary>
        /// Close video source if it is running
        /// </summary>
        private void CloseCurrentVideoSource()
        {
            if (viewCam.VideoSource != null)
            {
                viewCam.SignalToStop();

                // wait ~ 3 seconds
                for (int i = 0; i < 30; i++)
                {
                    if (!viewCam.IsRunning)
                        break;
                    System.Threading.Thread.Sleep(100);
                }

                if (viewCam.IsRunning)
                {
                    viewCam.Stop();
                }

                viewCam.VideoSource = null;
            }
        }

        /// <summary>
        /// Virtual button command mapping
        /// </summary>
        /// <param name="key">Virtual button</param>
        private void CommandMap(Key key)
        {
            if (key.Click)
            {
                int mode = 0;
                mode += (actL1.Click ? 1 : 0);
                mode += (actL2.Click ? 2 : 0);
                switch (key.Type)
                {
                    // Action key
                    case Key.Start:
                        if (actL1.Click && !actL2.Click)
                        {
                            //reset
                            Bluetooth.SendCommand(0x11);
                            break;
                        }
                        Bluetooth.SendCommand(Command.Start);
                        break;
                    case Key.Select:
                        if (actL1.Click && !actL2.Click)
                        {
                            //read distance
                            Bluetooth.SendCommand(0x13);
                            break;
                        }
                        Bluetooth.SendCommand(Command.Stop);
                        break;
                    case Key.NavigationUp:
                        Bluetooth.SendCommand(Command.Get(mode, 0));
                        break;
                    case Key.NavigationDown:
                        Bluetooth.SendCommand(Command.Get(mode, 1));
                        break;
                    case Key.NavigationLeft:
                        Bluetooth.SendCommand(Command.Get(mode, 2));
                        break;
                    case Key.NavigationRight:
                        Bluetooth.SendCommand(Command.Get(mode, 3));
                        break;
                    case Key.Triangle:
                        Bluetooth.SendCommand(Command.Get(mode, 4));
                        break;
                    case Key.Cross:
                        Bluetooth.SendCommand(Command.Get(mode, 5));
                        break;
                    case Key.Square:
                        Bluetooth.SendCommand(Command.Get(mode, 6));
                        break;
                    case Key.Circle:
                        Bluetooth.SendCommand(Command.Get(mode, 7));
                        break;
                    case Key.R1:
                        Bluetooth.SendCommand(Command.Get(mode, 8));
                        break;
                    case Key.R2:
                        Bluetooth.SendCommand(Command.Get(mode, 9));
                        break;
                }
            }
            else
            {
                Bluetooth.SendCommand(0xAA);
            }
        }

        #endregion

        /**
         * Live control execution
         */
        #region Live control

        /// <summary>
        /// Start streamming video
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Streaming_Trigger(object sender, RoutedEventArgs e)
        {
            if (!CheckConfig())
            {
                MessageBox.Show("Configuration is required to perform this task.", "Error", MessageBoxButton.OK,
                                MessageBoxImage.Error);
                return;
            }
            if (viewCam.VideoSource == null)
            {
                // get new source from IP
                string cameraUrl = "http://" + Configuration.CameraIp + ":80/mjpg/video.mjpg";
                //string cameraUrl = "http://192.168.2.101:80/mjpg/video.mjpg";
                MJPEGStream source = new MJPEGStream(cameraUrl)
                    {
                        Login = Configuration.Login,
                        Password = Configuration.Password
                    };

                //OpenVideoSource(new VideoCaptureDevice(LocalVideoDevices[0].MonikerString));
                OpenVideoSource(source);
                hostCam.Visibility = Visibility.Visible;
                imgSplash.Visibility = Visibility.Collapsed;
            }
            else
            {
                if (rdModeObjTracking.IsChecked == true)
                {
                    rdModeObjTracking.IsChecked = false;
                }
                
                CloseCurrentVideoSource();
                hostCam.Visibility = Visibility.Collapsed;
                imgSplash.Visibility = Visibility.Visible;
            }
        }

        #region Mode Selection
        
        #region Mode: Normal

        /// <summary>
        /// Direct input control mode selected
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeNormal_Checked(object sender, RoutedEventArgs e)
        {
            if (!CheckConfig())
            {
                MessageBox.Show("Configuration is required to perform this task.", "Error", MessageBoxButton.OK,
                                MessageBoxImage.Error);
                rdModeNormal.IsChecked = false;
                return;
            }
            // register handler for mouse click effect
            Keypad_MouseMap();
            Keypad_KeyboardMap();
            // update status text
            txtStatusValue.Text = "Normal";
            // undo highlight keypad control panel
            pnlNavigation.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlAction.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlFunction.BorderBrush = (Brush)FindResource("BorderBrushNormal");

        }

        /// <summary>
        /// Direct input control mode deselected
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeNormal_Unchecked(object sender, RoutedEventArgs e)
        {
            // unregister handler for mouse click effect
            Keypad_MouseUnmap();
            Keypad_KeyboardUnmap();
        }

        /// <summary>
        /// Mouse down handler for virtual keypad
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void KeyPad_Down(object sender, MouseButtonEventArgs e)
        {
            Key key = (Key) sender;
            key.Click = true;
        }

        /// <summary>
        /// Mouse Up handler for virtual keypad
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void KeyPad_Up(object sender, MouseButtonEventArgs e)
        {
            Key key = (Key)sender;
            key.Click = false;
        }

        /// <summary>
        /// Mouse leave handler for virtual keypad
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void KeyPad_Leave(object sender, MouseEventArgs e)
        {
            Key key = (Key)sender;
            if (e.LeftButton == MouseButtonState.Pressed)
            {
                key.Click = false;
            }
        }

        /// <summary>
        /// Keyboard input handler
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void Keyboard_KeyDown(object sender, KeyEventArgs e)
        {
            switch (e.Key)
            {
                case System.Windows.Input.Key.W:
                    navUp.Click = true;
                    break;
                case System.Windows.Input.Key.S:
                    navDown.Click = true;
                    break;
                case System.Windows.Input.Key.A:
                    navLeft.Click = true;
                    break;
                case System.Windows.Input.Key.D:
                    navRight.Click = true;
                    break;
                case System.Windows.Input.Key.Q:
                    actL1.Click = true;
                    break;
                case System.Windows.Input.Key.E:
                    actL2.Click = true;
                    break;
                case System.Windows.Input.Key.I:
                    actTriangle.Click = true;
                    break;
                case System.Windows.Input.Key.K:
                    actCross.Click = true;
                    break;
                case System.Windows.Input.Key.J:
                    actSquare.Click = true;
                    break;
                case System.Windows.Input.Key.L:
                    actCircle.Click = true;
                    break;
                case System.Windows.Input.Key.U:
                    actR1.Click = true;
                    break;
                case System.Windows.Input.Key.O:
                    actR2.Click = true;
                    break;
                case System.Windows.Input.Key.G:
                    actSelect.Click = true;
                    break;
                case System.Windows.Input.Key.H:
                    actStart.Click = true;
                    break;
            }
        }

        /// <summary>
        /// Keyboard release handler
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void Keyboard_KeyUp(object sender, KeyEventArgs e)
        {
            switch (e.Key)
            {
                case System.Windows.Input.Key.W:
                    navUp.Click = false;
                    break;
                case System.Windows.Input.Key.S:
                    navDown.Click = false;
                    break;
                case System.Windows.Input.Key.A:
                    navLeft.Click = false;
                    break;
                case System.Windows.Input.Key.D:
                    navRight.Click = false;
                    break;
                case System.Windows.Input.Key.Q:
                    actL1.Click = false;
                    break;
                case System.Windows.Input.Key.E:
                    actL2.Click = false;
                    break;
                case System.Windows.Input.Key.I:
                    actTriangle.Click = false;
                    break;
                case System.Windows.Input.Key.K:
                    actCross.Click = false;
                    break;
                case System.Windows.Input.Key.J:
                    actSquare.Click = false;
                    break;
                case System.Windows.Input.Key.L:
                    actCircle.Click = false;
                    break;
                case System.Windows.Input.Key.U:
                    actR1.Click = false;
                    break;
                case System.Windows.Input.Key.O:
                    actR2.Click = false;
                    break;
                case System.Windows.Input.Key.G:
                    actSelect.Click = false;
                    break;
                case System.Windows.Input.Key.H:
                    actStart.Click = false;
                    break;
            }
        }

        #endregion

        #region Mode: GamePad

        /// <summary>
        /// Keypad input control mode selected
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeKeypad_Checked(object sender, RoutedEventArgs e)
        {
            if (!CheckConfig())
            {
                MessageBox.Show("Configuration is required to perform this task.", "Error", MessageBoxButton.OK,
                                MessageBoxImage.Error);
                rdModeKeypad.IsChecked = false;
                return;
            }

            if (GamepadDevice.Scan().Count == 0)
            {
                MessageBox.Show("No Device Found! \nRe-Check if your device is connected.", "Error",
                    MessageBoxButton.OK, MessageBoxImage.Error);
                rdModeKeypad.IsChecked = false;
                return;
            }
            // update status text
            txtStatusValue.Text = "Keypad";
            // highlight keypad control panel
            pnlNavigation.BorderBrush = (Brush)FindResource("BorderBrushSelected");
            pnlAction.BorderBrush = (Brush)FindResource("BorderBrushSelected");
            pnlFunction.BorderBrush = (Brush)FindResource("BorderBrushSelected");

            // start scanning keypad devices
            GamePad.Start();
        }

        /// <summary>
        /// Keypad input control mode deselected
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeKeypad_Unchecked(object sender, RoutedEventArgs e)
        {
            // stop scanning
            GamePad.Stop();
        }

        #endregion

        #region Mode: Tracking

        /// <summary>
        /// Object tracking mode selected
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeObjTracking_Checked(object sender, RoutedEventArgs e)
        {
            // check camera first
            if (!viewCam.IsRunning)
            {
                // camera unadvalable
                MessageBox.Show("Video device hasn't been started.", "Warning",
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                // return to default mode
                rdModeObjTracking.IsChecked = false;
                return;
            }

            // update status text
            txtStatusValue.Text = "Object Tracking";
            // initial tracker
            Tracker = new ObjectTracker(Bluetooth,new Indicator());
            // get tracking template
            imgTrackingColor.Source = ObjectDetector.GetTrackingTemplate(viewCam.GetCurrentVideoFrame());
            if (imgTrackingColor.Source != null)
            {
                // open tracking panel
                pnlTrackingObject.IsEnabled = true;
                pnlTrackingObject.IsExpanded = true;
                // register tracking handler
                // Default method: color check
                viewCam.NewFrame += viewCam_NewFrame_ColorCheck;
                // Disable virtual key
                Keypad_Disable();
            }
            else
            {
                // User press cancel: no template selected
                MessageBox.Show("No template selected.");
                // return to default mode
                rdModeObjTracking.IsChecked = false;
            }
        }

        /// <summary>
        /// Exit tracking mode 
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeObjTracking_Unchecked(object sender, RoutedEventArgs e)
        {
            // close tracking panel
            pnlTrackingObject.IsEnabled = false;
            pnlTrackingObject.IsExpanded = false;

            // unregister tracking handler
            switch (cbTrackingMethod.SelectedIndex)
            {
                case 0:
                    viewCam.NewFrame -= viewCam_NewFrame_ColorCheck;
                    break;
                case 1:
                    viewCam.NewFrame -= viewCam_NewFrame_GlyphCheck;
                    break;
            }
            // enable virtual key
            Keypad_Enable();
        }

        /// <summary>
        /// Frame processing
        /// Color check algorithm
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="image">Frame to process</param>
        private void viewCam_NewFrame_ColorCheck(object sender, ref Bitmap image)
        {
            lock (this)
            {
                ImageStatistics statistics = new ImageStatistics(ObjectExtractorDialog.Value);
                BitmapData data = image.LockBits(new Rectangle(0, 0, image.Width, image.Height),
                    ImageLockMode.ReadOnly, image.PixelFormat);
                UnmanagedImage uImage = new UnmanagedImage(data);

                // unlock image
                image.UnlockBits(data);

                // process
                Rectangle rect = ObjectDetector.TemplateColorTracking(statistics, ref uImage);
                txtStatusValue.Dispatcher.Invoke(() =>
                    {
                        txtStatusValue.Text = rect.X + " -- " + rect.Y + " // "+ rect.Width;
                    });

                Tracker.Target.X = rect.X;
                Tracker.Target.Y = rect.Y;
                Tracker.Target.Width = rect.Width;

                if (!rect.IsEmpty)
                {

                    // draw rectangle around derected object
                    Graphics g = Graphics.FromImage(image);

                    using (Pen pen = new Pen(Color.Red, 4))
                    {
                        g.DrawRectangle(pen, rect);
                    }
                    g.Dispose();
                }
            }
        }

        /// <summary>
        /// Frame processing
        /// Glyphs check algorithm
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="image">Frame to process</param>
        private void viewCam_NewFrame_GlyphCheck(object sender, ref Bitmap image)
        {
            lock (this)
            {
                BitmapData data = image.LockBits(new Rectangle(0, 0, image.Width, image.Height),
                    ImageLockMode.ReadOnly, image.PixelFormat);
                UnmanagedImage uImage = new UnmanagedImage(data);

                // unlock image
                image.UnlockBits(data);

                // process
                List<Rectangle> list = new List<Rectangle>();
                ObjectDetector.GlyphsPotentialsTracking(ref uImage, ref list);

                if (list.Count > 0)
                {
                    // draw rectangle around derected object
                    Graphics g = Graphics.FromImage(image);

                    using (Pen pen = new Pen(Color.Red, 4))
                    {
                        foreach (Rectangle rectangle in list)
                        {
                            g.DrawRectangle(pen, rectangle);
                        }
                    }
                    g.Dispose();
                }
            }
        }

        /// <summary>
        /// Tracking target selection
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnTrackingChangeTarget_Click(object sender, RoutedEventArgs e)
        {
            BitmapSource source = ObjectDetector.GetTrackingTemplate(viewCam.GetCurrentVideoFrame());
            if (source != null)
            {
                imgTrackingColor.Source = source;
            }
        }

        /// <summary>
        /// Tracking method selection
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void cbTrackingMethod_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if ((imgTrackingGlyph == null) || (imgTrackingColor == null)) return;
            switch (cbTrackingMethod.SelectedIndex)
            {
                case 0:
                    imgTrackingGlyph.Visibility = Visibility.Collapsed;
                    imgTrackingColor.Visibility = Visibility.Visible;

                    viewCam.NewFrame -= viewCam_NewFrame_GlyphCheck;
                    viewCam.NewFrame += viewCam_NewFrame_ColorCheck;

                    btnTrackingChangeTarget.IsEnabled = true;
                    break;
                case 1:
                    imgTrackingGlyph.Visibility = Visibility.Visible;
                    imgTrackingColor.Visibility = Visibility.Collapsed;

                    viewCam.NewFrame -= viewCam_NewFrame_ColorCheck;
                    viewCam.NewFrame += viewCam_NewFrame_GlyphCheck;

                    btnTrackingChangeTarget.IsEnabled = false;
                    break;
            }
        }

        /// <summary>
        /// Start tracking
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnTrackingLock_Checked(object sender, RoutedEventArgs e)
        {
            Tracker.Start();
        }

        /// <summary>
        /// Exit tracking
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnTrackingLock_Unchecked(object sender, RoutedEventArgs e)
        {
            Tracker.Stop();
        }
        #endregion

        #endregion

        #region Command
        /// <summary>
        /// Send command
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void OnCommand(object sender, PropertyChangedEventArgs e)
        {
            if (IsLocked)
            {
                MessageBox.Show("This function is temporary locked down. Wait for other task to finish.", "Locked",
                                MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            Key key = (Key)sender;
            if ((e.PropertyName == "Click") && (IsLocked == false))
            {
                txtStatusValue.Text = key.Type + ": " + (key.Click ? "pressed" : "release");
                CommandMap(key);
            }
        }

        #endregion

        #endregion

        /**
         * Sequences control execution
         */
        #region Sequence Display
        /// <summary>
        /// Add a new state to current sequence
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnSequenceAdd_Click(object sender, RoutedEventArgs e)
        {
            int interval;
            if (int.TryParse(txtInterval.Text, out interval) && (interval < 10))
            {
                interval = int.Parse(txtInterval.Text);
                Sequence.Add(new MoveItem(Sequence.Count, cbDirection.Text, interval));
                tblSequences.Items.Refresh();
            }
        }

        /// <summary>
        /// Remove marked states from current sequence
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void StateRemove_Click(object sender, RoutedEventArgs e)
        {
            Sequence.Remove();
            // update layout
            tblSequences.Items.Refresh();
        }

        /// <summary>
        /// Mark a state as "to be deleted"
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void CheckBox_Checked(object sender, RoutedEventArgs e)
        {
            // get marked id
            CheckBox cb = (CheckBox)sender;
            int id = (int)cb.Content;
            // add to waiting list
            Sequence.MarkRemove(id);
        }

        /// <summary>
        /// Unmark a state as "to be deleted"
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void CheckBox_Unchecked(object sender, RoutedEventArgs e)
        {
            // get marked id
            CheckBox cb = (CheckBox)sender;
            int id = (int)cb.Content;
            // remove from waiting list
            Sequence.UnmarkRemove(id);
        }

        /// <summary>
        /// Export current sequences to file
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnExport_Click(object sender, RoutedEventArgs e)
        {
            //-------------------------------------------------------------------------------------
            /*----------------- Create XML document -----------------*/
            var doc = Sequence.Export();

            //-------------------------------------------------------------------------------------
            /*----------------- Create XML File -----------------*/

            // Configure save file dialog box
            var dlg = new Microsoft.Win32.SaveFileDialog {DefaultExt = ".xml", Filter = "XML documents |*.xml"};

            // Show save file dialog box
            bool? result = dlg.ShowDialog();

            // Process open file dialog box results
            if (result == true)
            {
                // out put document
                doc.Save(dlg.FileName);
            }
        }

        /// <summary>
        /// Import sequence from file
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnImport_Click(object sender, RoutedEventArgs e)
        {
            //-------------------------------------------------------------------------------------
            /*----------------- Get XML File -----------------*/
            // Configure open file dialog box
            var dlg = new Microsoft.Win32.OpenFileDialog {DefaultExt = ".xml", Filter = "Text documents |*.xml"};

            // Show open file dialog box
            bool? result = dlg.ShowDialog();

            // Process open file dialog box results
            if (result != true)
            {
                return;
            }

            string filename = dlg.FileName;

            //-------------------------------------------------------------------------------------
            /*----------------- Process XML data -----------------*/
            // load states from file
            Sequence = MoveItemsCollection.Import(filename);
            
            // update sequence view
            tblSequences.ItemsSource = Sequence;
            tblSequences.Items.Refresh();
        }

        /// <summary>
        /// Validate state input/ allow digit input only
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void txtInterval_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            if (!Char.IsDigit(e.Text, 0))
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Change propety base on selected move
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void cbDirection_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (txtInterval == null) return;
            if (cbDirection.SelectedIndex > 3)
            {
                txtInterval.Text = "0";
                txtInterval.IsEnabled = false;
            }
            else
            {
                txtInterval.Text = "";
                txtInterval.IsEnabled = true;
            }
        }

        /// <summary>
        /// Execute sequence
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnPlay_Click(object sender, RoutedEventArgs e)
        {
            if (!CheckConfig())
            {
                MessageBox.Show("Configuration is required to perform this task.", "Error", MessageBoxButton.OK,
                                MessageBoxImage.Error);
                rdModeKeypad.IsChecked = false;
                return;
            }
            if (IsLocked)
            {
                MessageBox.Show("This function is temporary locked down. Wait for other task to finish.", "Locked",
                                MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            SequencePlayer = new Player(Sequence, Bluetooth);
            SequencePlayer.Normalize();

            SequencePlayer.Start();
        }
        #endregion

        /**
         * Menu, Help, About, Tabs, Status...
         */
        #region General
        // Menu command execution
        #region Menu Control
        /// <summary>
        /// Enable/Set focus on Live Control tab
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void menuLive_Click(object sender, RoutedEventArgs e)
        {
            // if tab is currently closed
            if (!tabControl.Items.Contains(tabLiveControl))
            {
                tabControl.Items.Remove(tabPlayer);
                // reopen tab
                tabControl.Items.Add(tabLiveControl);
                tabLiveControl.Focus();
            }
        }

        /// <summary>
        /// Enable/Set focus on Player tab
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void menuPlayer_Click(object sender, RoutedEventArgs e)
        {
            // if tab is currently closed
            if (!tabControl.Items.Contains(tabPlayer))
            {
                tabControl.Items.Remove(tabLiveControl);
                // reopen tab
                tabControl.Items.Add(tabPlayer);
                tabPlayer.Focus();
                tblSequences.Items.Refresh();
            }
        }

        /// <summary>
        /// Enable/Set focus on Config tab
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void menuConfig_Click(object sender, RoutedEventArgs e)
        {
            Configuration config = new Configuration();
            if (config.ShowDialog() == true)
            {
                if (Bluetooth != null)
                {
                    Bluetooth.Close();
                }
                Bluetooth = new BluetoothDevice(Configuration.OutgoingPort, Configuration.OutgoingBaudrate);
                if (Bluetooth.Open() == 0)
                {
                    MessageBox.Show("Bluetooth connetion fail.");
                }
            }
        } 
        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void tabControl_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            // TODO: initiate some component
            if (tabControl.Items.Count == 1)
            {
                
            }
        }

        /// <summary>
        /// Clean up shit!
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void MetroWindow_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            // close connected devices
            GamePad.Stop();
            
            CloseCurrentVideoSource();
            // close serial port
            if (Bluetooth != null)
            {
                Bluetooth.Close(); 
            }
        }
        #endregion


        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Bitmap image = viewCam.GetCurrentVideoFrame();
            ImageStatistics statistics = new ImageStatistics(ObjectExtractorDialog.Value);

            // create filter
            EuclideanColorFiltering filter = new EuclideanColorFiltering();
            // set center colol and radius
            filter.CenterColor = new RGB((byte)statistics.Red.Median, (byte)statistics.Green.Median, (byte)statistics.Blue.Median);
            filter.Radius = 20;
            // apply the filter
            filter.ApplyInPlace(image);

            image = Grayscale.CommonAlgorithms.BT709.Apply(image);

            Blur blur = new Blur();
            blur.ApplyInPlace(image);

            OtsuThreshold otsu = new OtsuThreshold();
            otsu.ApplyInPlace(image);
            
            //DifferenceEdgeDetector edgeDetector = new DifferenceEdgeDetector();
            //edgeDetector.ApplyInPlace(image);
            //ColorFiltering colorFilter = new ColorFiltering(
            //    new IntRange(2, 255),
            //    new IntRange(0, 60), 
            //    new IntRange(0, 60));
            //colorFilter.ApplyInPlace(image);

            //// create filter
            //Threshold threshold = new Threshold(100);
            //// apply the filter
            //threshold.ApplyInPlace(image);


            using (image)
            {
                BitmapSource bitmapSource = System.Windows.Interop.Imaging.CreateBitmapSourceFromHBitmap(
                    image.GetHbitmap(),
                    IntPtr.Zero,
                    Int32Rect.Empty,
                    BitmapSizeOptions.FromEmptyOptions());

                //imgtest.Source = bitmapSource;
            }
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            Bluetooth.SendCommand(0xA1);
            if (IsLocked)
            {
                MessageBox.Show("lock");
            }
        }

    }
}
