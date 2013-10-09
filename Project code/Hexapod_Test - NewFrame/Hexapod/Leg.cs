using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Hexapod
{
    public class Leg
    {
        /// <summary>
        /// Static Fields
        /// </summary>
        public static readonly int LEFT = -1;
        public static readonly int RIGHT = 1;

        public static readonly int DefaultLeft = 1200;
        public static readonly int DefaultRight = 1800;

        /// <summary>
        /// Weigh number for leg's side: left (-1), right (1)
        /// </summary>
        private int Side { get; set; }

        /// <summary>
        /// Horizontal Servo for this leg
        /// </summary>
        public Servo Horizontal { get; set; }

        /// <summary>
        /// Vertical Servo for this leg (knee)
        /// </summary>
        public Servo UpperVertical { get; set; }

        /// <summary>
        /// Vertical Servo for this leg (angkle)
        /// </summary>
        public Servo LowerVertical { get; set; }

        /// <summary>
        /// Set up leg's servos & information
        /// </summary>
        /// <param name="horizontal">Horizontal servo number and initial position</param>
        /// <param name="upperVertical">1st Vertical servo number and initial position</param>
        /// <param name="lowerVertical">2nd Vertical servo number and initial positio</param>
        /// <param name="side">Weigh number for leg's side: left: -1 (less than 0), right: 1 (atleast 0)</param>
        public Leg(Servo horizontal, Servo upperVertical, Servo lowerVertical, int side)
        {
            Side = (side < 0) ? -1 : 1;

            Horizontal = horizontal;
            UpperVertical = upperVertical;
            LowerVertical = lowerVertical;
        }

        public Boolean IsStretching()
        {
            return UpperVertical.Position != LowerVertical.Position;
        }

        /// <summary>
        /// Move leg to front
        /// </summary>
        /// <param name="interval">interval between two position</param>
        /// <returns>Command string</returns>
        public String Forward(int interval)
        {
            // Rotate Horizontal Servo
            Horizontal.Position += Side * interval;
            // Generate command String
            String cmd = "#" + Horizontal.Number + "P" + Horizontal.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Move leg to rear
        /// </summary>
        /// <param name="interval">Interval between two positions</param>
        /// <returns>Command string</returns>
        public String Backward(int interval)
        {
            // Rotate Horizontal Servo
            Horizontal.Position -= Side * interval;
            // Generate command String
            String cmd = "#" + Horizontal.Number + "P" + Horizontal.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Move leg to higher position
        /// </summary>
        /// <param name="interval">Interval between two positions</param>
        /// <returns>Command string</returns>
        public String Lift(int interval)
        {
            // Rotate Vertical Servos
            UpperVertical.Position += Side * interval;
            //LowerVertical.Position = UpperVertical.Position;
            // Generate command String
            String cmd = "#" + UpperVertical.Number + "P" + UpperVertical.Position + " ";
                         //"#" + LowerVertical.Number + "P" + LowerVertical.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Move leg to lower position
        /// </summary>
        /// <param name="interval">Interval between two positions</param>
        /// <returns>Command string</returns>
        public String Drop(int interval)
        {
            // Rotate Vertical ServosSide * step;
            UpperVertical.Position -= Side * interval;
            //LowerVertical.Position = UpperVertical.Position;
            // Generate command String
            String cmd = "#" + UpperVertical.Number + "P" + UpperVertical.Position + " ";
                         //"#" + LowerVertical.Number + "P" + LowerVertical.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Move lower leg to standing position
        /// </summary>
        /// <returns>Command string</returns>
        public String Stand()
        {
            // Rotate Vertical Servos: Side * step;
            LowerVertical.Position = UpperVertical.Position;
            // Generate command String
            String cmd = "#" + LowerVertical.Number + "P" + LowerVertical.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Stretch leg
        /// </summary>
        /// <param name="interval">Interval between two positions</param>
        /// <returns>Command string</returns>
        public String Stretch(int interval)
        {
            // Rotate Vertical Servos: Side * step;
            LowerVertical.Position -= Side * interval;
            // Generate command String
            String cmd = "#" + LowerVertical.Number + "P" + LowerVertical.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Bent leg
        /// </summary>
        /// <param name="interval">Interval between two positions</param>
        /// <returns>Command string</returns>
        public String Bent(int interval)
        {
            // Rotate Vertical Servos: Side * step;
            LowerVertical.Position += Side * interval;
            // Generate command String
            String cmd = "#" + LowerVertical.Number + "P" + LowerVertical.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Synchronize current position with harware
        /// </summary>
        /// <returns>Command String</returns>
        public String FixPosition()
        {
            // Generate command String
            String cmd = "#" + Horizontal.Number + "P" + Horizontal.Position + " " +
                         "#" + UpperVertical.Number + "P" + UpperVertical.Position + " " +
                         "#" + LowerVertical.Number + "P" + LowerVertical.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Synchronize position with harware with specific position
        /// </summary>
        /// <param name="hServo"></param>
        /// <param name="upperVServo"></param>
        /// <param name="lowerVServo"></param>
        /// <returns>Command String</returns>
        public String FixPosition(int hServo, int upperVServo, int lowerVServo)
        {
            Horizontal.Position = hServo;
            // Rotate Vertical Servos: Side * step;
            UpperVertical.Position = upperVServo;
            LowerVertical.Position = lowerVServo;
            // Generate command String
            String cmd = "#" + Horizontal.Number + "P" + Horizontal.Position + " " +
                         "#" + UpperVertical.Number + "P" + UpperVertical.Position + " " +
                         "#" + LowerVertical.Number + "P" + LowerVertical.Position + " ";
            return cmd;
        }

        /// <summary>
        /// Move leg to center position (Horizontal)
        /// </summary>
        /// <returns>Command string</returns>
        public String Center()
        {
            // Rotate Horizontal Servo
            Horizontal.Position = 1500;
            // Generate command String
            String cmd = "#" + Horizontal.Number + "P1500 ";
            return cmd;
        }

        /// <summary>
        /// Move leg to middle position (Vertical)
        /// </summary>
        /// <returns>Command string</returns>
        public String Middle(int offset)
        {
            // Rotate Vertical Servos
            UpperVertical.Position = offset;
            LowerVertical.Position = offset;
            // Generate command String
            String cmd = "#" + UpperVertical.Number + "P" + offset + "" +
                         "#" + LowerVertical.Number + "P" + offset + "";
            return cmd;
        }

        /// <summary>
        /// Reset leg state: center, middle
        /// </summary>
        /// <returns>Command string</returns>
        public String Reset(int vOffSet)
        {
            return Center() + Middle(vOffSet);
        }

    }
}
