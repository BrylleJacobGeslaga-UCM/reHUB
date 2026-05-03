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
    public partial class Chat : Form
    {
        public Chat()
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

        private void panelChat1_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor = Color.DarkGray; 
            int borderThickness = 1;

            using (Pen pen = new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(pen, 0, 0, panelChat1.Width - 1, panelChat1.Height - 1);
            }
        }

        private void panelChat2_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor = Color.DarkGray;
            int borderThickness = 1; 

            using (Pen pen = new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(pen, 0, 0, panelChat2.Width - 1, panelChat2.Height - 1);
            }
        }

        private void panelChat3_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor = Color.DarkGray; 
            int borderThickness = 1; 

            using (Pen pen = new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(pen, 0, 0, panelChat3.Width - 1, panelChat3.Height - 1);
            }
        }
    }
}
