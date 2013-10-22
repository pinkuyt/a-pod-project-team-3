using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace APOD_Controller.Sequences
{
    public class Preset
    {
        public String Name { get; set; }
        public MoveItemsCollection States { get; set; }

        public Preset(string name, MoveItemsCollection states)
        {
            Name = name;
            States = states;
        }

        public override string ToString()
        {
            return Name;
        }
    }
}
