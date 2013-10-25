using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
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
using AForge.Video;
using AForge.Video.DirectShow;
using AForge.Vision.Motion;
using APOD_Controller.Object_Tracking;
using APOD_Controller.Sequences;
using Brush = System.Windows.Media.Brush;

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
        private MoveItemsCollection States;

        /// <summary>
        /// List of preloaded Presets
        /// </summary>
        private List<Preset> Presets;

        /// <summary>
        /// Camera IP for video stream
        /// </summary>
        private const String CamIP = "http://192.168.2.3:80/mjpg/video.mjpg";

        /// <summary>
        /// Default constructor
        /// </summary>
        public MainWindow()
        {
            InitializeComponent();

            States = new MoveItemsCollection();

            tblSequences.ItemsSource = States;
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
                    collection = ImportSequence(file);
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
        /// Export current sequence to XML
        /// </summary>
        /// <returns>XMLDocument instane contain states of sequence</returns>
        private XmlDocument ExportSequence()
        {
            /*----------------- Create XML document -----------------*/
            var doc = new XmlDocument();
            //root
            XmlNode root = doc.CreateElement("Moves");
            doc.AppendChild(root);

            foreach (MoveItem item in States)
            {
                // single move tag
                XmlNode move = doc.CreateElement("Move");
                // Name property
                XmlAttribute attribute = doc.CreateAttribute("Name");
                attribute.Value = item.Name;
                move.Attributes.Append(attribute);
                // Interval property
                attribute = doc.CreateAttribute("Interval");
                attribute.Value = item.Interval.ToString(CultureInfo.InvariantCulture);
                move.Attributes.Append(attribute);

                root.AppendChild(move);
            }
            return doc;
        }

        /// <summary>
        /// Import states of existed sequence
        /// </summary>
        /// <param name="filename">File path</param>
        /// <returns>Collection of states</returns>
        private MoveItemsCollection ImportSequence(string filename)
        {
            MoveItemsCollection states = new MoveItemsCollection();
            XmlDocument doc = new XmlDocument();
            doc.Load(filename);

            XmlNodeList moves = doc.GetElementsByTagName("Move");
            int count = 0;
            int value = 0;
            bool incorrupted;

            foreach (XmlNode move in moves)
            {
                // check data integrity
                incorrupted = (move.Attributes != null) && (int.TryParse(move.Attributes["Interval"].Value, out value));
                // if damaged return null
                if (!incorrupted) return null;
                // else keep processing
                states.Add(new MoveItem(count, move.Attributes["Name"].Value,
                                        value));
                count++;
            }
            return states;
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
                MJPEGStream source = new MJPEGStream(CamIP);
                source.Login = "admin";
                source.Password = "1234";

                OpenVideoSource(webcam);
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
                States.Add(new MoveItem(States.Count, cbDirection.Text, interval));
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
            States.Remove();
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
            States.RemoveList.Add(id);
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
            States.RemoveList.Remove(id);
        }

        /// <summary>
        /// Export current sequences to file
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void btnExport_Click(object sender, RoutedEventArgs e)
        {
            /** ---------------- Using LINQ ----------------
             * var xml = new XElement("MoveItems", States.Select(x => new XElement("MoveItem",
             *                                     new XAttribute("Name", x.Name),
             *                                     new XAttribute("Interval", x.Interval))));                                    
             */

            //-------------------------------------------------------------------------------------
            /*----------------- Create XML document -----------------*/
            var doc = ExportSequence();

            //-------------------------------------------------------------------------------------
            /*----------------- Create XML File -----------------*/

            // Configure save file dialog box
            var dlg = new Microsoft.Win32.SaveFileDialog();
            dlg.DefaultExt = ".xml"; // Default file extension
            dlg.Filter = "XML documents |*.xml"; // Filter files by extension

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
            var dlg = new Microsoft.Win32.OpenFileDialog();
            dlg.DefaultExt = ".xml"; // Default file extension
            dlg.Filter = "Text documents |*.xml"; // Filter files by extension

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
            States = ImportSequence(filename);
            
            // update sequence view
            tblSequences.ItemsSource = States;
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
                States = preset.States;
                tblSequences.ItemsSource = States;
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

        }
        
        #endregion

        /// <summary>
        /// Clean up shit!
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void MetroWindow_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            // close serial port
            // close connected devices
            CloseCurrentVideoSource();
        }

        private void rdModeNormal_Checked(object sender, RoutedEventArgs e)
        {
            txtStatusValue.Text = "Normal";
            pnlNavigation.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlAction.BorderBrush = (Brush)FindResource("BorderBrushNormal");
            pnlFunction.BorderBrush = (Brush)FindResource("BorderBrushNormal");
        }

        private void rdModeKeypad_Checked(object sender, RoutedEventArgs e)
        {
            txtStatusValue.Text = "Keypad";
            pnlNavigation.BorderBrush = (Brush) FindResource("BorderBrushSelected");
            pnlAction.BorderBrush = (Brush)FindResource("BorderBrushSelected");
            pnlFunction.BorderBrush = (Brush)FindResource("BorderBrushSelected");
        }

        private void rdModeObjTracking_Checked(object sender, RoutedEventArgs e)
        {
            if (viewCam.IsRunning)
            {
                txtStatusValue.Text = "Object Tracking";
                Bitmap capture = viewCam.GetCurrentVideoFrame();
                ObjectExtractorDialog extractor = new ObjectExtractorDialog(capture);
                extractor.Owner = this;
                extractor.ShowDialog();

                Bitmap img = ObjectExtractorDialog.Value;

                using (img)
                {
                    BitmapSource bitmapSource = System.Windows.Interop.Imaging.CreateBitmapSourceFromHBitmap(
                        img.GetHbitmap(),
                        IntPtr.Zero,
                        Int32Rect.Empty,
                        BitmapSizeOptions.FromEmptyOptions());

                    imgTrackingObject.Source = bitmapSource;
                }
                pnlTrackingObject.IsEnabled = true;
                pnlTrackingObject.IsExpanded = true;
            }
            else
            {
                MessageBox.Show("No video device added.");
                rdModeNormal.IsChecked = true;
            }
        }

        private void rdModeObjTracking_Unchecked(object sender, RoutedEventArgs e)
        {
            pnlTrackingObject.IsEnabled = false;
            pnlTrackingObject.IsExpanded = false;
        }


    }
}
