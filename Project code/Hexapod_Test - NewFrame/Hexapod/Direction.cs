using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Hexapod
{
    public class Direction
    {
        public String Name { get; set; }  

        public Direction( String name)
        {
            Name = name;
        }

        public static readonly Direction LEFT = new Direction("Left");
        public static readonly Direction RIGHT = new Direction("Right");
        public static readonly Direction FORWARD = new Direction("Forward");
        public static readonly Direction BACKWARD = new Direction("Backward");
        public static readonly Direction UP = new Direction("Up");
        public static readonly Direction DOWN = new Direction("Down");
    }
}
