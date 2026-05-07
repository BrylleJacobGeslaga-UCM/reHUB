using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Dashboard : Form
    {

        private MainForm mainForm;
        Boolean Guest;
        public Dashboard(MainForm form)
        {
            InitializeComponent();
            mainForm = form;
        }
        public Dashboard(MainForm form, Boolean isGuest)
        {
            InitializeComponent();
            if (isGuest) { Guest = true; }
            else { Guest = false; }
            mainForm = form;
        }

        private void btnCheckIn_Click(object sender, EventArgs e)
        {
            if (Guest)
            {
                mainForm.LoadForm(new PleaseSignIn(mainForm));
            }
            else
            {
                mainForm.LoadForm(new Checkin(mainForm));
            }
            
        }

        private void panelHeader_Paint(object sender, PaintEventArgs e)
        {
            LinearGradientBrush brush = new LinearGradientBrush(
            panelHeader.ClientRectangle,
            Color.FromArgb(113, 196, 140),  
            Color.FromArgb(54, 94, 67),    
            LinearGradientMode.Vertical    
            );

            e.Graphics.FillRectangle(brush, panelHeader.ClientRectangle);
        }

        private void btnExplore_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(new Discover(mainForm));
        }

        private void panelCheckIn_Paint(object sender, PaintEventArgs e)
        {
            LinearGradientBrush brush = new LinearGradientBrush(
            panelCheckIn.ClientRectangle,
            Color.FromArgb(111, 207, 151),   
            Color.FromArgb(39, 174, 96),    
            LinearGradientMode.Horizontal    
            );

            e.Graphics.FillRectangle(brush, panelCheckIn.ClientRectangle);
        }

        private void Dashboard_Load(object sender, EventArgs e)
        {

        }
    }
}
