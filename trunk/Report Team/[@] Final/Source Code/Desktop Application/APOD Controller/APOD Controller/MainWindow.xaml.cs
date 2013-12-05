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
using System.Windows.Forms;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Xml.Linq;
using System.Xml;
// External
using AForge.Imaging;
using AForge.Imaging.Filters;
using AForge.Video;
using AForge.Video.DirectShow;
// Local solution
using APOD_Controller.APOD.About;
using APOD_Controller.APOD.Configuration;
using APOD_Controller.APOD.Communication;
using APOD_Controller.APOD.Input;
using APOD_Controller.APOD.Object_Tracking;
using APOD_Controller.APOD.Sequences;
using APOD_Keypad;

using Brush = System.Windows.Media.Brush;
using CheckBox = System.Windows.Controls.CheckBox;
using Color = System.Drawing.Color;
using Cursors = System.Windows.Input.Cursors;
using Key = APOD_Keypad.Key;
using KeyEventArgs = System.Windows.Input.KeyEventArgs;
using MessageBox = System.Windows.MessageBox;
using MouseEventArgs = System.Windows.Input.MouseEventArgs;
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
        /// Moving speed
        /// </summary>
        private bool Slow;

        /// <summary>
        /// Locker for all communication activities
        /// </summary>
        private bool IsLocked
        {
            get
            {
                bool result = ((SequencePlayer != null) && SequencePlayer.IsPlaying()) ||
                              (Tracker.IsBusy);
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

        /// <summary>
        /// Local video devices array
        /// </summary>
        protected FilterInfoCollection LocalVideoDevices;

        private Indicator Target;
        private BackgroundWorker Tracker;
        private ObjectTracker ObjTracker;

        /// <summary>
        /// Default constructor
        /// </summary>
        public MainWindow()
        {
            InitializeComponent();
            Slow = false;
            // Initialize sequence
            Sequence = new MoveItemsCollection();
            tblSequences.ItemsSource = Sequence;
            // Initialize Moves
            cbDirection.ItemsSource = MoveItem.AvailableMoves;
            
            // get local video device information
            LocalVideoDevices = new FilterInfoCollection(FilterCategory.VideoInputDevice);

            // initialize gamepad Control object
            GamePad = new GamepadDevice(navUp, navDown, navLeft, navRight, actTriangle, actCircle, actCross, actSquare,
                                       actL2, actR2, actL1, actR1, actSelect, actStart);

            // Organize virtual keypad
            VirtualButtons = new Key[14];
            // Register keypad
            Keypad_Init();
            Keypad_CommandMap();


            // Initialize Tracker
            Tracker= new BackgroundWorker();
            Tracker.WorkerSupportsCancellation = true;

            Tracker.DoWork+= Tracking;
            Tracker.RunWorkerCompleted += TrackingTerminated;
            // initiate target
            Target = new Indicator();

            ObjTracker = new ObjectTracker(Bluetooth, Target);
            ObjTracker.Worker.RunWorkerCompleted += TrackingTerminated;

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
            bool result = true;
            if (!key.Click)
            {
                result = Bluetooth.SendCommand(0xAA);
            }
            else
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
                            result = Bluetooth.SendCommand(Command.Reset);
                            break;
                        }
                        result = Bluetooth.SendCommand(Command.Start);
                        break;
                    case Key.Select:
                        if (actL1.Click && !actL2.Click)
                        {
                            //read distance
                            byte[] t = {0};
                            Bluetooth.ClearPreviousResponse();
                            result = Bluetooth.SendCommand(0xDD);
                            System.Threading.Thread.Sleep(500);
                            Bluetooth.ComPort.Read(t, 0, 1);
                            MessageBox.Show(t[0].ToString());
                            break;
                        }
                        result = Bluetooth.SendCommand(Command.Stop);
                        break;
                    case Key.NavigationUp:
                        result = Bluetooth.SendCommand(Command.Get(mode, 0));
                        break;
                    case Key.NavigationDown:
                        result = Bluetooth.SendCommand(Command.Get(mode, 1));
                        break;
                    case Key.NavigationLeft:
                        result = Bluetooth.SendCommand(Command.Get(mode, 2));
                        break;
                    case Key.NavigationRight:
                        result = Bluetooth.SendCommand(Command.Get(mode, 3));
                        break;
                    case Key.Triangle:
                        result = Bluetooth.SendCommand(Command.Get(mode, 4));
                        break;
                    case Key.Cross:
                        result = Bluetooth.SendCommand(Command.Get(mode, 5));
                        break;
                    case Key.Square:
                        result = Bluetooth.SendCommand(Command.Get(mode, 6));
                        break;
                    case Key.Circle:
                        result = Bluetooth.SendCommand(Command.Get(mode, 7));
                        break;
                    case Key.R1:
                        result = Bluetooth.SendCommand(Command.Get(mode, 8));
                        break;
                    case Key.R2:
                        result = Bluetooth.SendCommand(Command.Get(mode, 9));
                        break;
                }
            }
            if (!result)
            {
                MessageBox.Show("Connection Lost", "Error");
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
            //if (!CheckConfig())
            //{
            //    MessageBox.Show("Configuration is required to perform this task.", "Error", MessageBoxButton.OK,
            //                    MessageBoxImage.Error);
            //    return;
            //}
            if (viewCam.VideoSource == null)
            {
                // get new source from IP
                string cameraUrl = "http://" + Configuration.CameraIp + ":" + Configuration.CameraPort + "/videostream.cgi";
                //string cameraUrl = "http://192.168.2.15:80/videostream.cgi";
                MJPEGStream source = new MJPEGStream(cameraUrl) 
                    {
                        Login = "admin",// Configuration.Login,
                        Password =""// Configuration.Passwordco
                    };

                OpenVideoSource(new VideoCaptureDevice(LocalVideoDevices[0].MonikerString));
                //OpenVideoSource(source);
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
            //txtStatusValue.Text = "Normal";
            // undo highlight keypad control panel
            pnlNavigation.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlAction.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlFunction.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlTriggers.BorderBrush = (Brush)FindResource("BorderBrushNormal");

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
            //txtStatusValue.Text = "Keypad";
            // highlight keypad control panel
            pnlNavigation.BorderBrush = (Brush)FindResource("BorderBrushSelected");
            pnlAction.BorderBrush = (Brush)FindResource("BorderBrushSelected");
            pnlFunction.BorderBrush = (Brush)FindResource("BorderBrushSelected");
            pnlTriggers.BorderBrush = (Brush)FindResource("BorderBrushSelected");
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
            //txtStatusValue.Text = "Object Tracking";

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

                Target.X = rect.X;
                Target.Y = rect.Y;
                Target.Width = rect.Width;
                Target.Lost = ((rect.Width < 10) || (rect.Width > 600));

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

                Rectangle rect = list[0];
                Target.X = rect.X;
                Target.Y = rect.Y;
                Target.Width = rect.Width;
                Target.Lost = ((rect.Width < 10) || (rect.Width > 600));

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
            if (IsLocked)
            {
                MessageBox.Show("This function is temporary locked down. Wait for other task to finish.", "Locked",
                                   MessageBoxButton.OK, MessageBoxImage.Warning);
                btnTrackingLock.IsChecked = false;
                return;
            }
            Indicator.LeftBoundary = 200;
            Indicator.RightBoundary = 400;
            Target.Found = false;
            if (!Bluetooth.SendCommand(Command.MoveForwardCont))
            {
                // Lost connection
                MessageBox.Show("Connection Lost", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            System.Threading.Thread.Sleep(2000);

            //ObjTracker.Start();
            Tracker.RunWorkerAsync();
        }

        /// <summary>
        /// Tracking executioner
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void Tracking(object sender, DoWorkEventArgs doWorkEventArgs)
        {
            BackgroundWorker worker = (BackgroundWorker)sender;
            bool result = true;
            while (!worker.CancellationPending)
            {
                // terminate token
                result = Bluetooth.SendCommand(0xAA);
                while (!Bluetooth.Read().Contains(".")) ;
                // lost sight
                if (Target.Lost)
                {
                    return;
                }

                // check distance
                Bluetooth.ClearPreviousResponse();
                result = Bluetooth.SendCommand(0xDD);
                System.Threading.Thread.Sleep(600);
                byte d = Bluetooth.ReadResponse();

                // reached the object
                if ( d <= 40 )
                {
                    // Set flag
                    Target.Found = true;
                    // continue adjust position until object in center region
                }
                // left region
                if (Target.X <= Indicator.LeftBoundary)
                {
                    result = Bluetooth.SendCommand(Command.TurnLeft);
                    System.Threading.Thread.Sleep(1000);
                }
                // right region
                else if (Target.X >= Indicator.RightBoundary)
                {
                    result = Bluetooth.SendCommand(Command.TurnRight);
                    System.Threading.Thread.Sleep(1000);
                }
                // middle region
                else
                {
                    // if object is found, no need to move forward
                    if (Target.Found) return;

                    result = Bluetooth.SendCommand(Command.MoveForwardCont);
                    System.Threading.Thread.Sleep(2000);
                }
                if (!result)
                {
                    return;
                }
            }
        }
        
        /// <summary>
        /// Done tracking
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void TrackingTerminated(object sender, RunWorkerCompletedEventArgs runWorkerCompletedEventArgs)
        {
            MessageBox.Show(Target.Found ? "Target Found" : "Target Lost", "Tracking terminated", MessageBoxButton.OK,
                MessageBoxImage.Information);
            btnTrackingLock.IsChecked = false;
        }

        /// <summary>
        /// Exit tracking
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnTrackingLock_Unchecked(object sender, RoutedEventArgs e)
        {
            //ObjTracker.Stop();
            if (Tracker.IsBusy)
            {
                Tracker.CancelAsync();
            }
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
            Key key = (Key)sender;
            if (e.PropertyName != "Click") return;
            if (IsLocked && key.Click)
            {
                MessageBox.Show("This function is temporary locked down. Wait for other task to finish.", "Locked",
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            CommandMap(key);
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
        /// Clean up junk
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void MetroWindow_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            CloseCurrentVideoSource();
            // close connected devices
            GamePad.Stop();

            if (SequencePlayer != null) SequencePlayer.Stop();
            if (ObjTracker != null) ObjTracker.Stop();
            if (Tracker != null) Tracker.CancelAsync();

            // waiting 3s
            System.Threading.Thread.Sleep(3000);
            // close serial port
            if (Bluetooth != null)
            {
                Bluetooth.Close(); 
            }
        }
        #endregion

        /// <summary>
        /// Auto Grip
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnAuto_Click(object sender, RoutedEventArgs e)
        {
            Bluetooth.SendCommand(0xA1);
        }

        /// <summary>
        /// Change Speed 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnSpeed_Click(object sender, RoutedEventArgs e)
        {
            Bluetooth.SendCommand((byte) (Slow ? 0x02 : 0x03));
            Slow = !Slow;
        }
        /// <summary>
        /// Show Information Dialog
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void MenuItem_Click(object sender, RoutedEventArgs e)
        {
            About aboutDialog = new About();
            aboutDialog.ShowDialog();
        }

    }
}
