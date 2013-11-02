using System;
using System.Collections.Generic;
using System.Drawing;
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
using System.Windows.Shapes;
using AForge;
using AForge.Imaging;
using AForge.Imaging.Filters;
using AForge.Math;
using Color = System.Drawing.Color;
using Pen = System.Drawing.Pen;
using Point = System.Drawing.Point;
using Rectangle = System.Drawing.Rectangle;

namespace APOD_Controller.APOD.Object_Tracking
{
    /// <summary>
    /// Interaction logic for ObjectExtractorDialog.xaml
    /// </summary>
    public partial class ObjectExtractorDialog
    {
        public static ImageStatistics Statistics;

        public static Bitmap Value;
        public  Bitmap Source;

        private bool IsDrawing;

        private Point Start;
        private Point End;

        private Rectangle Target;
        
        public ObjectExtractorDialog()
        {
            InitializeComponent();
            IsDrawing = false;
        }

        public ObjectExtractorDialog(Bitmap image)
        {
            InitializeComponent();
            IsDrawing = false;

            Start = new Point(0,0);
            End = new Point(0,0);

            Source = image;
            Target = Rectangle.Empty;

            pnlCapture.BackgroundImage = image;
        }

        private void pnlCapture_MouseDown(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                Target = Rectangle.Empty;
                IsDrawing = true;
                Start.X = e.X;
                Start.Y = e.Y;
            }
        }
        private void pnlCapture_MouseMove(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            if (IsDrawing)
            {
                End.X = e.X;
                End.Y = e.Y;
            }
        }
        private void pnlCapture_MouseUp(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            IsDrawing = false;
            End.X = e.X;
            End.Y = e.Y;

            WrapUpPoint(ref Start); 
            WrapUpPoint(ref End);
            NormalizePoints(ref Start, ref End);
            Target = new Rectangle(Start.X - 1, Start.Y - 1, End.X - Start.X + 1, End.Y - Start.Y + 1);
            pnlCapture.Invalidate();
        }

        private void pnlCapture_Paint(object sender, PaintEventArgs e)
        {
            Graphics graphics = pnlCapture.CreateGraphics();

            using (Pen pen = new Pen(Color.Yellow, 2))
            {
                graphics.DrawRectangle(pen,Target);
            }
        }

        // Normalize points, so the first point will keep smaller coordinates
        private void NormalizePoints(ref Point start, ref Point end)
        {
            Point t1 = start;
            Point t2 = end;

            start.X = Math.Min(t1.X, t2.X);
            start.Y = Math.Min(t1.Y, t2.Y);
            end.X = Math.Max(t1.X, t2.X);
            end.Y = Math.Max(t1.Y, t2.Y);
        }

        private void WrapUpPoint( ref Point point )
        {
            if ( point.X < 0 )
            {
                point.X = 2;
            }
            if ( point.Y < 0 )
            {
                point.Y = 2;
            }
            if ( point.X > 639)
            {
                point.X = 639;
            }
            if ( point.Y > 479)
            {
                point.Y = 479;
            }
        }

        private void btnOK_Click(object sender, RoutedEventArgs e)
        {
            if (Target != Rectangle.Empty)
            {
                Value = Source.Clone(Target, Source.PixelFormat);
                Statistics = new ImageStatistics(Value);
                DialogResult = true;
                Close();
            }
        }

        private void btnESC_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
        }

    }
}
