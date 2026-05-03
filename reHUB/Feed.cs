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
    public partial class Feed : Form
    {

        private MainForm mainForm;
        public Feed(MainForm form)
        {
            InitializeComponent();
            mainForm = form;
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

        private void Feed_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void label9_Click(object sender, EventArgs e)
        {

        }

        private void panelPost1_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor = Color.Black;
            int borderThickness = 2; 

            using (Pen pen = new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(pen, 0, 0, panelPost1.Width - 1, panelPost1.Height - 1);
            }
        }

        private void panelPost2_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor = Color.Black; 
            int borderThickness = 2;

            using (Pen pen = new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(pen, 0, 0, panelPost1.Width - 1, panelPost1.Height - 1);
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(new Update(mainForm));
        }

        private void button2_Click(object sender, EventArgs e)
        {

        }
    }
}
