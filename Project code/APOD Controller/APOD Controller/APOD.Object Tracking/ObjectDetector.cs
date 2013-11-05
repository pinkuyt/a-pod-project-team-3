using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media.Imaging;
using AForge;
using AForge.Imaging;
using AForge.Imaging.Filters;
using AForge.Math.Geometry;

namespace APOD_Controller.APOD.Object_Tracking
{
    class ObjectDetector
    {

        public static BitmapSource GetTrackingTemplate(Bitmap capture)
        {
            BitmapSource bitmapSource;
            ObjectExtractorDialog extractor = new ObjectExtractorDialog(capture);
            extractor.ShowDialog();

            // return null if user click cancel
            if (extractor.DialogResult == false)
            {
                return null;
            }

            Bitmap img = (Bitmap)ObjectExtractorDialog.Value.Clone();

            using (img)
            {
                bitmapSource = System.Windows.Interop.Imaging.CreateBitmapSourceFromHBitmap(
                    img.GetHbitmap(),
                    IntPtr.Zero,
                    Int32Rect.Empty,
                    BitmapSizeOptions.FromEmptyOptions());
            }
            return bitmapSource;
        }

        public static Rectangle TemplateColorTracking(ImageStatistics templateInfo, ref UnmanagedImage source)
        {
            UnmanagedImage image = source.Clone();
            // create filter
            EuclideanColorFiltering filter = new EuclideanColorFiltering();
            // set center colol and radius
            filter.CenterColor = new RGB(
                (byte)templateInfo.Red.Mean,
                (byte)templateInfo.Green.Mean,
                (byte)templateInfo.Blue.Mean);
            filter.Radius = 10;
            // apply the filter
            filter.ApplyInPlace(image);

            image = Grayscale.CommonAlgorithms.BT709.Apply(image);

            OtsuThreshold threshold = new OtsuThreshold();
            threshold.ApplyInPlace(image);

            BlobCounter blobCounter = new BlobCounter();
            blobCounter.ObjectsOrder = ObjectsOrder.Size;
            blobCounter.ProcessImage(image);

            Rectangle rect = blobCounter.ObjectsCount > 0 ? blobCounter.GetObjectsRectangles()[0] : Rectangle.Empty;
            return rect;
        }

        public static void GlyphsPotentialsTracking(ref UnmanagedImage image, ref List<Rectangle> lists)
        {
            // 1 - grayscaling
            UnmanagedImage grayImage = null;

            if (image.PixelFormat == PixelFormat.Format8bppIndexed)
            {
                grayImage = image;
            }
            else
            {
                grayImage = UnmanagedImage.Create(image.Width, image.Height,
                    PixelFormat.Format8bppIndexed);
                Grayscale.CommonAlgorithms.BT709.Apply(image, grayImage);
            }

            // 2 - Edge detection
            DifferenceEdgeDetector edgeDetector = new DifferenceEdgeDetector();
            UnmanagedImage edgesImage = edgeDetector.Apply(grayImage);

            // 3 - Threshold edges
            Threshold thresholdFilter = new Threshold(80);
            thresholdFilter.ApplyInPlace(edgesImage);

            //// ---------------- MILESTONE
            //image = edgesImage;
            //return;

            // create and configure blob counter
            BlobCounter blobCounter = new BlobCounter();

            blobCounter.MinHeight = 32;
            blobCounter.MinWidth = 32;
            blobCounter.FilterBlobs = true;
            blobCounter.ObjectsOrder = ObjectsOrder.Size;

            // 4 - find all stand alone blobs
            blobCounter.ProcessImage(edgesImage);
            Blob[] blobs = blobCounter.GetObjectsInformation();

            List<IntPoint> edgePoints = null;
            List<IntPoint> corners = null;
            SimpleShapeChecker shapeChecker = new SimpleShapeChecker();

            // 5 - check each blob
            for (int i = 0, n = blobs.Length; i < n; i++)
            {
                edgePoints = blobCounter.GetBlobsEdgePoints(blobs[i]);
                corners = null;

                // does it look like a quadrilateral ?
                if (shapeChecker.IsQuadrilateral(edgePoints, out corners))
                {
                    // get edge points on the left and on the right side
                    List<IntPoint> leftEdgePoints, rightEdgePoints;
                    blobCounter.GetBlobsLeftAndRightEdges(blobs[i],
                        out leftEdgePoints, out rightEdgePoints);

                    // calculate average difference between pixel values from outside of the
                    // shape and from inside
                    float diff = CalculateAverageEdgesBrightnessDifference(
                        leftEdgePoints, rightEdgePoints, grayImage);

                    // check average difference, which tells how much outside is lighter than
                    // inside on the average
                    if (diff > 5)
                    {
                        lists.Add(blobs[i].Rectangle);
                    }
                }
            }
        }

        private static float CalculateAverageEdgesBrightnessDifference(
            List<IntPoint> leftEdgePoints, 
            List<IntPoint> rightEdgePoints,
            UnmanagedImage image)
        {
            int stepSize = 3;
            // create list of points, which are a bit on the left/right from edges
            List<IntPoint> leftEdgePoints1 = new List<IntPoint>();
            List<IntPoint> leftEdgePoints2 = new List<IntPoint>();
            List<IntPoint> rightEdgePoints1 = new List<IntPoint>();
            List<IntPoint> rightEdgePoints2 = new List<IntPoint>();

            int tx1, tx2, ty;
            int widthM1 = image.Width - 1;

            for (int k = 0; k < leftEdgePoints.Count; k++)
            {
                tx1 = leftEdgePoints[k].X - stepSize;
                tx2 = leftEdgePoints[k].X + stepSize;
                ty = leftEdgePoints[k].Y;

                leftEdgePoints1.Add(new IntPoint(
                    (tx1 < 0) ? 0 : tx1, ty));
                leftEdgePoints2.Add(new IntPoint(
                    (tx2 > widthM1) ? widthM1 : tx2, ty));

                tx1 = rightEdgePoints[k].X - stepSize;
                tx2 = rightEdgePoints[k].X + stepSize;
                ty = rightEdgePoints[k].Y;

                rightEdgePoints1.Add(new IntPoint(
                    (tx1 < 0) ? 0 : tx1, ty));
                rightEdgePoints2.Add(new IntPoint(
                    (tx2 > widthM1) ? widthM1 : tx2, ty));
            }

            // collect pixel values from specified points
            byte[] leftValues1 = image.Collect8bppPixelValues(leftEdgePoints1);
            byte[] leftValues2 = image.Collect8bppPixelValues(leftEdgePoints2);
            byte[] rightValues1 = image.Collect8bppPixelValues(rightEdgePoints1);
            byte[] rightValues2 = image.Collect8bppPixelValues(rightEdgePoints2);

            // calculate average difference between pixel values from outside of
            // the shape and from inside
            float diff = 0;
            int pixelCount = 0;

            for (int k = 0; k < leftEdgePoints.Count; k++)
            {
                if (rightEdgePoints[k].X - leftEdgePoints[k].X > stepSize * 2)
                {
                    diff += (leftValues1[k] - leftValues2[k]);
                    diff += (rightValues2[k] - rightValues1[k]);
                    pixelCount += 2;
                }
            }
            return diff / pixelCount;
        }
    }
}
