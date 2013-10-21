using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;

namespace demoDevExpress
{
    public partial class XtraForm1 : DevExpress.XtraEditors.XtraForm
    {
        private string url;

        // Selected  URL
        public string URL
        {
            get { return url; }
        }

        //URLs to display in combobox
        public string[] URLs
        {
            set
            {
                comboBoxURL.Items.AddRange(value);
            }
        }

        // Description of the dialog
        public string Description
        {
            get { return descriptionLabel.Text; }
            set { descriptionLabel.Text = value; }

        }

        public XtraForm1()
        {
            InitializeComponent();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            
        }

        private void cbURL_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void XtraForm1_Load(object sender, EventArgs e)
        {

        }

        private void comboBoxURL_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            url = comboBoxURL.Text;
        }
    }
}