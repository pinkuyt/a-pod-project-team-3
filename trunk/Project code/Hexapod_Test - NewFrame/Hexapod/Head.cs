using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Hexapod
{
    class Head
    {
        /// <summary>
        /// Static Fields
        /// </summary>
        public static readonly int DefaultLeft = 1500;
        public static readonly int DefaultRight = 1500;

        public int ForceSensor;

        public Servo LeftMandible { get; set; }
        public Servo RightMandible { get; set; }
        public Servo NeckVertical { get; set; }
        public Servo NeckHorizontal { get; set; }
        public Servo NeckBalance { get; set; }

        public Head(Servo neckRotate, Servo neckHorizontal, Servo neckVertical, Servo rightMandible, Servo leftMandible)
        {
            NeckBalance = neckRotate;
            NeckHorizontal = neckHorizontal;
            NeckVertical = neckVertical;
            RightMandible = rightMandible;
            LeftMandible = leftMandible;
        }

        public String Turn(int interval, Direction direction)
        {
            String cmd = "";
            switch (direction.Name)
            {
                case "Left": //left
                    NeckHorizontal.Position += interval;
                    cmd = "#" + NeckHorizontal.Number + "P" + NeckHorizontal.Position + " ";
                    break;
                case "Right": //right
                    NeckHorizontal.Position -= interval;
                    cmd = "#" + NeckHorizontal.Number + "P" + NeckHorizontal.Position + " ";
                    break;
                case "Up": // Head Up
                    NeckVertical.Position -= interval;
                    cmd = "#" + NeckVertical.Number + "P" + NeckVertical.Position + " ";
                    break;
                case "Down": // Head Down
                    NeckVertical.Position += interval;
                    cmd = "#" + NeckVertical.Number + "P" + NeckVertical.Position + " ";
                    break;
            }
            return cmd;
        }

        public String Grip(int interval)
        {
            LeftMandible.Position -= interval;
            RightMandible.Position += interval;
            String cmd = "#" + LeftMandible.Number + "P" + LeftMandible.Position + " " +
                         "#" + RightMandible.Number + "P" + RightMandible.Position + " ";
            return cmd;
        }

        public String Loose(int interval)
        {
            LeftMandible.Position += interval;
            RightMandible.Position -= interval;
            String cmd = "#" + LeftMandible.Number + "P" + LeftMandible.Position + " " +
                         "#" + RightMandible.Number + "P" + RightMandible.Position + " ";
            return cmd;
        }
        public String Rotate(int interval, Direction direction)
        {
            String cmd = "";
            switch (direction.Name)
            {
                case "Left": //left
                    NeckBalance.Position += interval;
                    cmd = "#" + NeckBalance.Number + "P" + NeckBalance.Position + " ";
                    break;
                case "Right": //right
                    NeckBalance.Position -= interval;
                    cmd = "#" + NeckBalance.Number + "P" + NeckBalance.Position + " ";
                    break;
            }
            return cmd;
        }

        public String Reset()
        {
            // rotate position: balance
            NeckBalance.Position = 1500;
            // Horizontal position: center
            NeckHorizontal.Position = 1500;
            // Vertical Position: middle
            NeckVertical.Position = 1500;
            // Mandibles position: half width
            RightMandible.Position = 1500;
            LeftMandible.Position = 1500;

            // Generate command String
            String cmd = "#" + NeckBalance.Number + "P1500" +
                         "#" + NeckHorizontal.Number + "P1500" +
                         "#" + NeckVertical.Number + "P1500" +
                         "#" + RightMandible.Number + "P1500" +
                         "#" + LeftMandible.Number + "P1500";
            return cmd;
        }
    }
}
