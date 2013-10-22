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

        private bool _disabled;
        private string _type;

        public string Type
        {
            get { return _type; }
            set
            {
                if (!_type.Equals(value))
                {
                    _type = value;
                    OnPropertyChanged("Type");
                }
            }
        }
        public bool Disabled {
            get { return _disabled; }
            set
            {
                if (value != _disabled)
                {
                    _disabled = value;
                    OnPropertyChanged("Disabled");
                }
            }
        }

        public Key()
        {
            InitializeComponent();
            _type = "";
            _disabled = false;

            ImgOn.Visibility = Visibility.Hidden;
            ImgOff.Visibility = Visibility.Visible;
            ImgInvi.Visibility = Visibility.Hidden;
            PropertyChanged += PropertyVisualEffect;
        }


        private void PropertyVisualEffect(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == "Disabled")
            {
                if (_disabled)
                {
                    ImgOff.Visibility = Visibility.Hidden;
                    ImgInvi.Visibility = Visibility.Visible;
                }
                else
                {
                    ImgOff.Visibility = Visibility.Visible;
                    ImgInvi.Visibility = Visibility.Hidden;
                }
                ImgOn.Visibility = Visibility.Hidden;
            }

            if (e.PropertyName == "Type")
            {
                ImgOn.Source =
                    new BitmapImage(new Uri("/Keypad;component/images/" + _type+ "_on.ico", UriKind.Relative));
                ImgOff.Source = new BitmapImage(new Uri("/Keypad;component/images/" + _type + ".ico", UriKind.Relative));
                ImgInvi.Source =
                    new BitmapImage(new Uri("/Keypad;component/images/" + _type + "_invi.ico", UriKind.Relative));

            }
        }
        private void UserControl_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (!_disabled)
            {
                ImgOn.Visibility = Visibility.Visible;
                ImgOff.Visibility = Visibility.Hidden;
                ImgInvi.Visibility = Visibility.Hidden; 
            }
        }

        private void UserControl_MouseUp(object sender, MouseButtonEventArgs e)
        {
            if (!_disabled)
            {
                ImgOn.Visibility = Visibility.Hidden;
                ImgOff.Visibility = Visibility.Visible;
                ImgInvi.Visibility = Visibility.Hidden; 
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(PropertyChangedEventArgs e)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
                handler(this, e);
        }

        protected void OnPropertyChanged(string propertyName)
        {
            OnPropertyChanged(new PropertyChangedEventArgs(propertyName));
        }
    }
}
