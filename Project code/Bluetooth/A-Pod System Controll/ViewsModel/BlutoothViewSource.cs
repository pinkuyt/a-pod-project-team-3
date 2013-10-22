using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace A_Pod_System_Controll
{
    class BlutoothViewSource
    {
        private string[] ports = ControlHelper.CheckPort();

        private int[] baudrates = new int[]{
            1200, 
            2400, 
            4800, 
            9600, 
            19200, 
            38400, 
            57600,
            115200
        };

        private string selectedPort;
        private int selectedBaudrate;

        public string[] Ports
        {
            get { return this.ports; }
        }
        public int[] Baudrates
        {
            get { return this.baudrates; }
        }

        public string SelectedPort
        {
            get { return selectedPort; }
            set
            {
                if (this.selectedPort != value)
                    this.selectedPort = value;
            }
        }

        public int SelectedBaudrates
        {
            get { return selectedBaudrate; }
            set
            {
                if (this.selectedBaudrate != value)
                    selectedBaudrate = value;
            }
        }

        public BlutoothViewSource()
        {
            if (ports != null)
            {
                this.SelectedPort = ports[0];
            }
            this.SelectedBaudrates = 9600;
        }
    }
}
