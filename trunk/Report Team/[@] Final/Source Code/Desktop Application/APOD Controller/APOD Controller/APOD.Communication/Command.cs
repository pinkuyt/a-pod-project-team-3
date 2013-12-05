using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace APOD_Controller.APOD.Communication
{
    /// <summary>
    /// Token to send over Bluetooth
    /// </summary>
    class Command
    {
        // Mode commands
        public const byte Reset = 0x01;
        public const byte Fast = 0x32;
        public const byte Slow = 0x31;

        public const byte Start = 0x31;
        public const byte Stop = 0x32;
        // Moving Commands
        public const byte MoveForward = 0x33;
        public const byte MoveBackward = 0x34;
        public const byte TurnLeft = 0x35;
        public const byte TurnRight = 0x36;
        public const byte TowardFront = 0x37;
        public const byte TowardBack = 0x38;
        public const byte SqueezeLeft = 0x39;
        public const byte SqueezeRight = 0x40;
        public const byte StandLift = 0x41;
        public const byte StandDrop = 0x42;
        public const byte RotateHeadLeft = 0x45;
        public const byte RotateHeadRight = 0x46;
        public const byte TurnHeadLeft = 0x47;
        public const byte TurnHeadRight = 0x48;
        public const byte LiftHeadUp = 0x49;
        public const byte DropHeadDown = 0x50;
        public const byte Nip = 0x51;
        public const byte Release = 0x52;

        public const byte MoveForwardCont = 0x3A;
        public const byte MoveBackwardCont = 0x3B;
        public const byte TurnLeftCont = 0x3C;
        public const byte TurnRightCont = 0x3D;

        /// <summary>
        /// Mapping table for gamepad control
        /// </summary>
        private static byte[,] Table =
            {
                {MoveForwardCont, MoveBackwardCont, TurnLeftCont, TurnRightCont, Nip, Release,TurnLeft, TurnRight, 0, 0},
                {TowardFront, TowardBack, SqueezeLeft, SqueezeRight, 0, 0, 0, 0, StandLift, StandDrop},
                {LiftHeadUp, DropHeadDown, TurnHeadLeft, TurnHeadRight, 0, 0, RotateHeadLeft, RotateHeadRight, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
            };

        /// <summary>
        /// Get response command for gamepad button
        /// </summary>
        /// <param name="bank">Table X index</param>
        /// <param name="index">Table Y index</param>
        /// <returns></returns>
        public static byte Get(int bank, int index)
        {
            return Table[bank, index];
        }
    }
}
