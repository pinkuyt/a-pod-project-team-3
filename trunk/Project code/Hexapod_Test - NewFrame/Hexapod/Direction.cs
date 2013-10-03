using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Hexapod
{
    public class Direction
    {
        public int Weight { get; set; }
        public String Name { get; set; }  
        public Direction(int weight, String name)
        {
            Weight = weight;
            Name = name;
        }

        public static readonly Direction LEFT = new Direction(-1, "Left");
        public static readonly Direction RIGHT = new Direction(1, "Right");
        public static readonly Direction FORWARD = new Direction(-1, "Forward");
        public static readonly Direction BACKWARD = new Direction(1, "Backward");
        public static readonly Direction UP = new Direction(-1, "Up");
        public static readonly Direction DOWN = new Direction(1, "Down");
    }
}
