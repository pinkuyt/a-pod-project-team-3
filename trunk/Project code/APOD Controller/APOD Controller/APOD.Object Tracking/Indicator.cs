﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace APOD_Controller.APOD.Object_Tracking
{
    class Indicator
    {
        public int X { get; set; }
        public int Y { get; set; }
        public int Width { get; set; }
        public bool Lost;

        public Indicator()
        {
            X = 0;
            Y = 0;
            Width = 0;
            Lost = true;
        }
    }
}
