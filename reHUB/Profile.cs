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
    public partial class Profile : Form
    {
        public Profile()
        {
            InitializeComponent();
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

        private void panelChild_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor = Color.FromArgb(113, 196, 140);
            int borderThickness = 1;

            using (Pen pen = new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(pen, 0, 0, panelChild.Width - 1, panelChild.Height - 1);
            }
        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void panelProgress_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor = Color.DarkGray; 
            int borderThickness = 1; 

            using (Pen pen = new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(pen, 0, 0, panelProgress.Width - 1, panelProgress.Height - 1);
            }
        }

        private void btnLogOut_Click(object sender, EventArgs e)
        {

        }

        private void lblActivities_Click(object sender, EventArgs e)
        {

        }

        private void label7_Click(object sender, EventArgs e)
        {

        }
    }
}
