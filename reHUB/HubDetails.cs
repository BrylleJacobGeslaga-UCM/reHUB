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
    public partial class HubDetails : Form
    {
        private MainForm mainForm;
        public HubDetails(
            MainForm form, 
            string hubName, 
            int members, 
            Image icon, 
            string about,
            string title, 
            string date,
            string location
        )
        {
            InitializeComponent();

            mainForm = form;

            lblHubName.Text = hubName;
            lblMembers.Text = members + " members";
            pictureBoxIcon.Image = icon;

            lblAbout.Text = about;
            lblTitle.Text = title;
            lblDate.Text = date;
            lblLocation.Text = location;
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

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(new Discover(mainForm));
        }
    }
}
