using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using AForge.Video;
//using AForge.Video.DirectShow;

namespace demoDevExpress
{
    public partial class Form1 : DevExpress.XtraEditors.XtraForm
    {

        private Stopwatch stopWatch = null;
        public string[] URLs
        {
            set
            {
                cbURL.Items.AddRange(value);
            }
        }
       
        public Form1()
        {
            InitializeComponent();
            DevExpress.Skins.SkinManager.EnableFormSkins();
        }

        private void Form1_Closing(object sender, FormClosingEventArgs e)
        {
            CloseCurrentVideoSource();
        }

       

        private void Form1_Load(object sender, EventArgs e)
        {

        }
        /**/
        //Open Mjpeg url
        private void simpleButton1_Click(object sender, EventArgs e)
        {
            //sDevExpress.XtraEditors.XtraMessageBox.Show("Xin chao");
            //XtraForm1 form = new XtraForm1();

            //form.Description = "Nhap vao URL:";
            //form.URLs = new string[]
            //    {
            //      "http://192.168.1.3:80/mjpg/video.mjpg",
            //    };

            //if (form.ShowDialog(this) == DialogResult.OK)
            //{
            //    // create video source
            //    MJPEGStream mjpegSource = new MJPEGStream(form.URL);

            //    // open
            //    OpenVideoSource(mjpegSource);
            //}
            //cbURL.Items.AddRange(value);
            
            if (string.IsNullOrEmpty(cbURL.Text))
            {
                DevExpress.XtraEditors.XtraMessageBox.Show("Nhap URL camera vao!");
            }
            else
            {
                
                MJPEGStream mjpegSource = new MJPEGStream(cbURL.Text);
                OpenVideoSource(mjpegSource);
            }
        }

        // Open video source
        private void OpenVideoSource(IVideoSource source)
        {
            
            // set busy cursor
            this.Cursor = Cursors.WaitCursor;

            //stop current video source;
            CloseCurrentVideoSource();

            //Start new video source
            videoSourcePlayer1.VideoSource = source;
            videoSourcePlayer1.Start();

            // reset stop watch
            stopWatch = null;

            //Start timer
            timer.Start();

            this.Cursor = Cursors.Default;
        }

        // clode this video source if it is running
        private void CloseCurrentVideoSource()
        {
            //throw new NotImplementedException();
            if (videoSourcePlayer1.VideoSource != null)
            {
                videoSourcePlayer1.SignalToStop();

                //wait 3 second
                for (int i = 0; i < 30; i++)
                {
                    if (!videoSourcePlayer1.IsRunning)
                    {
                        break;
                    }
                    System.Threading.Thread.Sleep(100);
                }

                if (videoSourcePlayer1.IsRunning)
                {
                    videoSourcePlayer1.Stop();
                }

                videoSourcePlayer1.VideoSource = null;
            }
        }

        private void videoSourcePlayer1_NewFrame(object sender, ref Bitmap image)
        {
            DateTime now = DateTime.Now;
            Graphics g = Graphics.FromImage(image);

            //paint current time
            SolidBrush brush = new SolidBrush(Color.Red);
            g.DrawString(now.ToString(), this.Font, brush, new PointF(5,5));
            brush.Dispose();

            g.Dispose();

        }

        // On timer event - gather statistics
        private void timer_Tick (object sender, EventArgs e)
        {
            IVideoSource videoSource = videoSourcePlayer1.VideoSource;

            if (videoSource != null)
            {
                // get number of frames since the last timer tick
                int framesReceived = videoSource.FramesReceived;

                if (stopWatch == null)
                {
                    stopWatch = new Stopwatch();
                    stopWatch.Start();
                }
                else
                {
                    stopWatch.Stop();

                    float fps = 1000.0f*framesReceived/stopWatch.ElapsedMilliseconds;
                    fpsLabel.Text = fps.ToString("F2") + "fps";

                    stopWatch.Reset();
                    stopWatch.Start();
                }
            }
        }

        private void timer_Tick_1(object sender, EventArgs e)
        {

        }
        /**/
    }
}
