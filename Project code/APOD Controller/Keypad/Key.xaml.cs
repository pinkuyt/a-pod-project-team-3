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

namespace Keypad
{
    /// <summary>
    /// Interaction logic for Key.xaml
    /// </summary>
    public partial class Key : INotifyPropertyChanged
    {
        // key type's name
        public static readonly string NavigationUp = "Up";
        public static readonly string NavigationDown = "Down";
        public static readonly string NavigationLeft = "Left";
        public static readonly string NavigationRight = "Right";
        public static readonly string Circle = "Circle";
        public static readonly string Cross = "Cross";
        public static readonly string Square = "Square";
        public static readonly string Triangle = "Triangle";
        public static readonly string Select = "Select";
        public static readonly string Start = "Start";
        public static readonly string R1 = "R1";
        public static readonly string R2 = "R2";
        public static readonly string L1 = "L1";
        public static readonly string L2 = "L2";

        /// <summary>
        /// is this control disabled
        /// </summary>
        private bool _disabled;
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
        /// Setter/getter for _disabled property
        /// </summary>
        public bool Disabled {
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
        /// Default constructor
        /// </summary>
        public Key()
        {
            InitializeComponent();
            // default properties's values
            _type = "";
            _disabled = false;

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
            // visual effect for _disable value
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
            // visual effect for _type value
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
        /// "ON" State
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void UserControl_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (!_disabled)
            {
                ImgOn.Visibility = Visibility.Visible;
                ImgOff.Visibility = Visibility.Hidden;
                ImgInvi.Visibility = Visibility.Hidden; 
            }
        }

        /// <summary>
        /// "OFF" state
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void UserControl_MouseUp(object sender, MouseButtonEventArgs e)
        {
            if (!_disabled)
            {
                ImgOn.Visibility = Visibility.Hidden;
                ImgOff.Visibility = Visibility.Visible;
                ImgInvi.Visibility = Visibility.Hidden; 
            }
        }

        /// <summary>
        /// "OFF" state
        /// </summary>
        /// <param name="sender">Event source</param>
        /// <param name="e">Event arguments</param>
        private void UserControl_MouseLeave(object sender, MouseEventArgs e)
        {
            if (!_disabled)
            {
                ImgOn.Visibility = Visibility.Hidden;
                ImgOff.Visibility = Visibility.Visible;
                ImgInvi.Visibility = Visibility.Hidden;
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
