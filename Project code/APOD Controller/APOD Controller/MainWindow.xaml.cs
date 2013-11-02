using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.Globalization;
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

using APOD_Controller.APOD.Object_Tracking;
using APOD_Controller.APOD.Sequences;

using Brush = System.Windows.Media.Brush;
using Color = System.Drawing.Color;
using Drawing = AForge.Imaging.Drawing;
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
        /// List of current sequence's states
        /// </summary>
        private MoveItemsCollection Sequence;

        /// <summary>
        /// List of preloaded Presets
        /// </summary>
        private List<Preset> Presets;

        /// <summary>
        /// Local video imput devices
        /// </summary>
        FilterInfoCollection VideoDevices;

        /// <summary>
        /// Camera IP for video stream
        /// </summary>
        private String CamIP = "http://192.168.2.3:80/mjpg/video.mjpg";

        /// <summary>
        /// Default constructor
        /// </summary>
        public MainWindow()
        {
            InitializeComponent();
            // init sequence
            Sequence = new MoveItemsCollection();
            tblSequences.ItemsSource = Sequence;

            VideoDevices = new FilterInfoCollection(FilterCategory.VideoInputDevice);
        }

        /**
         * User define method
         */
        #region Suport/Multipurposes Methods
        /// <summary>
        /// Load existing Presets
        /// </summary>
        private int LoadPreset()
        {
            // check existence of preset pool
            if (System.IO.Directory.Exists("Presets"))
            {
                MoveItemsCollection collection;
                // get all presets name
                string[] files = System.IO.Directory.GetFiles("Presets");
                // start loading states of each preset.
                foreach (string file in files)
                {
                    collection = MoveItemsCollection.Import(file);
                    // add only incorrupted data
                    if (collection != null)
                    {
                        Presets.Add(
                            new Preset(
                                file.Split(new[] {"Presets\\", ".xml"}, StringSplitOptions.RemoveEmptyEntries)[0],
                                collection));
                    }
                }
                return files.Length;
            }
            return 0;
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
        private void actStart_MouseUp(object sender, MouseButtonEventArgs e)
        {
            if (viewCam.VideoSource == null)
            {
                VideoCaptureDevice webcam = new VideoCaptureDevice("@device:pnp:\\\\?\\usb#vid_0c45&pid_6481&mi_00#7&2e61ff31&0&0000#{65e8773d-8f56-11d0-a3b9-00a0c9223196}\\global");
                // get new source from IP
                CamIP = "http://192.168.2.7:80/mjpg/video.mjpg";
                MJPEGStream source = new MJPEGStream(CamIP);
                source.Login = "admin";
                source.Password = "1234";

                OpenVideoSource(new VideoCaptureDevice(VideoDevices[0].MonikerString));
            }
            else
            {
                CloseCurrentVideoSource();
            }
        }
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
            if (int.TryParse(txtInterval.Text, out interval) & (interval != 0))
            {
                interval = int.Parse(txtInterval.Text);
                Sequence.Add(new MoveItem(Sequence.Count, cbDirection.Text, interval));
                tblSequences.Items.Refresh();

                if (chkUsePreset.IsChecked == true)
                {
                    chkUsePreset.IsChecked = false;
                }
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
            /** ---------------- Using LINQ ----------------
             * var xml = new XElement("MoveItems", Sequence.Select(x => new XElement("MoveItem",
             *                                     new XAttribute("Name", x.Name),
             *                                     new XAttribute("Interval", x.Interval))));                                    
             */

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
                MessageBox.Show("Invalid operation.");
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

            // Preset unsused
            if (chkUsePreset.IsChecked == true)
            {
                chkUsePreset.IsChecked = false;
            }
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

        /**
         * Preset control execution
         */
        #region Preset Manipulation
        /// <summary>
        /// Enable uses of Presets
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void chkUsePreset_Checked(object sender, RoutedEventArgs e)
        {
            // load preset if this is first use
            if (Presets == null)
            {
                Presets = new List<Preset>();
                if (LoadPreset() == 0)
                {
                    MessageBox.Show("Nothing to load.");
                    chkUsePreset.IsChecked = false;
                    return;
                }
                cbPreset.ItemsSource = Presets;
            }
            // reveal preset control panel
            pnlPreset.Visibility = Visibility.Visible;
            // set selectable
            cbPreset.IsEnabled = true;
        }

        /// <summary>
        /// Disable uses of Presets
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void chkUsePreset_Unchecked(object sender, RoutedEventArgs e)
        {
            // hide preset control panel
            pnlPreset.Visibility = Visibility.Collapsed;
            // set unselectable
            cbPreset.IsEnabled = false;
        }

        /// <summary>
        /// Change of selected preset
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void cbPreset_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (chkUsePreset.IsChecked == true)
            {
                Preset preset = (Preset)cbPreset.SelectedItem;
                Sequence = preset.States;
                tblSequences.ItemsSource = Sequence;
                tblSequences.Items.Refresh();
            }
        }
        #endregion

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
                // reopen tab
                tabControl.Items.Add(tabLiveControl);
            }
            // set focus
            tabLiveControl.Focus();
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
                // reopen tab
                tabControl.Items.Add(tabPlayer);
            }
            // set focus
            tabPlayer.Focus();
        }

        /// <summary>
        /// Enable/Set focus on Config tab
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void menuConfig_Click(object sender, RoutedEventArgs e)
        {
            // if tab is currently closed
            if (!tabControl.Items.Contains(tabConfig))
            {
                // reopen tab
                tabControl.Items.Add(tabConfig);
            }
            // set focus
            tabConfig.Focus();
        } 
        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void tabControl_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            // TODO: inittial some component
        }

        /// <summary>
        /// Clean up shit!
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void MetroWindow_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            // close serial port
            // close connected devices
            CloseCurrentVideoSource();
        }

        #endregion

        /// <summary>
        /// Direct input control mode
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeNormal_Checked(object sender, RoutedEventArgs e)
        {
            // update status text
            txtStatusValue.Text = "Normal";
            // undo highlight keypad control panel
            pnlNavigation.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlAction.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlFunction.BorderBrush = (Brush)FindResource("BorderBrushNormal");
        }

        /// <summary>
        /// Keypad input control mode
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeKeypad_Checked(object sender, RoutedEventArgs e)
        {
            // update status text
            txtStatusValue.Text = "Keypad";
            // highlight keypad control panel
            pnlNavigation.BorderBrush = (Brush) FindResource("BorderBrushSelected");
            pnlAction.BorderBrush = (Brush)FindResource("BorderBrushSelected");
            pnlFunction.BorderBrush = (Brush)FindResource("BorderBrushSelected");
        }

        /// <summary>
        /// Object tracking mode
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void rdModeObjTracking_Checked(object sender, RoutedEventArgs e)
        {
            // check camera first
            if (viewCam.IsRunning)
            {
                // update status text
                txtStatusValue.Text = "Object Tracking";
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
                }
                else
                {
                    // User press cancel: no template selected
                    MessageBox.Show("No template selected.");
                    // return to default mode
                    rdModeNormal.IsChecked = true;
                }
            }
            else
            {
                // camera unadvalable
                MessageBox.Show("No video device added.");
                // return to default mode
                rdModeNormal.IsChecked = true;
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

        private void btnTrackingChangeTarget_Click(object sender, RoutedEventArgs e)
        {
            BitmapSource source = ObjectDetector.GetTrackingTemplate(viewCam.GetCurrentVideoFrame());
            if (source != null)
            {
                imgTrackingColor.Source = source;
            }
        }

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

                imgtest.Source = bitmapSource;
            }
        }

    }
}
