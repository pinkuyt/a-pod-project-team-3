using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Hexapod
{
    public class Servo
    {
        /// <summary>
        /// Servo index
        /// </summary>
        public int Number { get; set; }

        /// <summary>
        /// Current position (P)
        /// </summary>
        public int Position { get; set; }

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="number"></param>
        /// <param name="position"></param>
        public Servo(int number, int position)
        {
            Number = number;
            Position = position;
        }

    }
}
