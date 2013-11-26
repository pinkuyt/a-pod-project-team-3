using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
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

namespace APOD_Keypad
{
    /// <summary>
    /// Interaction logic for Key.xaml
    /// </summary>
    public partial class Key : INotifyPropertyChanged
    {
        // key type's name
        public const string NavigationUp = "Up";
        public const string NavigationDown = "Down";
        public const string NavigationLeft = "Left";
        public const string NavigationRight = "Right";
        public const string Circle = "Circle";
        public const string Cross = "Cross";
        public const string Square = "Square";
        public const string Triangle = "Triangle";
        public const string Select = "Select";
        public const string Start = "Start";
        public const string R1 = "R1";
        public const string R2 = "R2";
        public const string L1 = "L1";
        public const string L2 = "L2";

        /// <summary>
        /// is this control disabled
        /// </summary>
        private bool _disabled;

        /// <summary>
        /// Setter/getter for _disabled property
        /// </summary>
        public bool Disabled
        {
            get { return _disabled; }
            set
            {
                // if changed
                if (value != _disabled)
                {
                    // update value
                    _disabled = value;
                    // trigger event
                    OnPropertyChanged("Disabled");
                }
            }
        }

        /// <summary>
        /// is this control being clicked
        /// </summary>
        private bool _click;

        /// <summary>
        /// Setter/getter for _click property
        /// </summary>
        public bool Click
        {
            get { return _click; }
            set
            {
                // if changed
                if (value != _click)
                {
                    // update value
                    _click = value;
                    // trigger event
                    OnPropertyChanged("Click");
                }
            }
        }

        /// <summary>
        /// the type of image to be display
        /// </summary>
        private string _type;

        /// <summary>
        /// Setter/getter for _type property
        /// </summary>
        public string Type
        {
            get { return _type; }
            set
            {
                // if changed
                if (!_type.Equals(value))
                {
                    // update value
                    _type = value;
                    // trigger event
                    OnPropertyChanged("Type");
                }
            }
        }
        

        /// <summary>
        /// Default constructor
        /// </summary>
        public Key()
        {
            InitializeComponent();
            // default properties's values
            _type = "";
            _disabled = false;
            _click = false;

            // default image display
            ImgOn.Visibility = Visibility.Hidden;
            ImgOff.Visibility = Visibility.Visible;
            ImgInvi.Visibility = Visibility.Hidden;
            // register event handler
            PropertyChanged += PropertyVisualEffect;
        }

        /// <summary>
        /// Handler for a property changed event
        /// - add suitable visual effect
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void PropertyVisualEffect(object sender, PropertyChangedEventArgs e)
        {
            // visual effect for _disable value changed
            if (e.PropertyName == "Disabled")
            {
                if (_disabled)
                {
                    // disable effect
                    ImgOff.Visibility = Visibility.Hidden;
                    ImgInvi.Visibility = Visibility.Visible;
                }
                else
                {
                    // in-operation effect
                    ImgOff.Visibility = Visibility.Visible;
                    ImgInvi.Visibility = Visibility.Hidden;
                }
                ImgOn.Visibility = Visibility.Hidden;
            }
            // visual effect for _click value changed
            if (e.PropertyName == "Click" && !_disabled)
            {
                if (_click)
                {
                    ImgOn.Visibility = Visibility.Visible;
                    ImgOff.Visibility = Visibility.Hidden;
                    ImgInvi.Visibility = Visibility.Hidden; 
                }
                else
                {
                    ImgOn.Visibility = Visibility.Hidden;
                    ImgOff.Visibility = Visibility.Visible;
                    ImgInvi.Visibility = Visibility.Hidden; 
                }
            }
            // visual effect for _type value changed
            if (e.PropertyName == "Type")
            {
                // get icon sources
                ImgOn.Source =
                    new BitmapImage(new Uri("/Keypad;component/images/" + _type+ "_on.ico", UriKind.Relative));
                ImgOff.Source = new BitmapImage(new Uri("/Keypad;component/images/" + _type + ".ico", UriKind.Relative));
                ImgInvi.Source =
                    new BitmapImage(new Uri("/Keypad;component/images/" + _type + "_invi.ico", UriKind.Relative));
            }
        }

        /// <summary>
        /// "ON" State (mouse click)
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void UserControl_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (!_disabled)
            {
                Click = true;
            }
        }

        /// <summary>
        /// "OFF" state (mouse released)
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void UserControl_MouseUp(object sender, MouseButtonEventArgs e)
        {
            if (!_disabled)
            {
                Click = false;
            }
        }

        /// <summary>
        /// "OFF" state (mouse leave while pressing)
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void UserControl_MouseLeave(object sender, MouseEventArgs e)
        {
            if ((e.LeftButton == MouseButtonState.Pressed) && !_disabled)
            {
                Click = false;
            }
        }

        /// <summary>
        /// Event for a property changed
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        /// <summary>
        /// Default trigger for PropertyChanged event
        /// </summary>
        /// <param name="e">Event argument</param>
        protected void OnPropertyChanged(PropertyChangedEventArgs e)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
                handler(this, e);
        }

        /// <summary>
        /// Trigger for PropertyChanged event with property's name
        /// </summary>
        /// <param name="e">Event argument</param>
        protected void OnPropertyChanged(string propertyName)
        {
            OnPropertyChanged(new PropertyChangedEventArgs(propertyName));
        }

    }
}
