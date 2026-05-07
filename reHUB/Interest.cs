using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Interest : Form
    {
        List<string> selectedInterests = new List<string>();

        public Interest()
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void ToggleSelection(string interest)
        {
            if (selectedInterests.Contains(interest))
            {
                selectedInterests.Remove(interest);
            }
            else
            {
                selectedInterests.Add(interest);
            }
        }
        private void highlightButton(Button btn)
        {
            if (btn.BackColor == Color.FromArgb(113, 196, 140))
            {
                btn.BackColor = SystemColors.Control;
                btn.ForeColor = SystemColors.ControlText;
            }
            else
            {
                btn.BackColor = Color.FromArgb(113, 196, 140);
                btn.ForeColor = Color.White;
            }
        }
        private void btnRides_Click(object sender, EventArgs e)
        {
            ToggleSelection("Rides");
            highlightButton((Button)sender);
        }

        private void btnGaming_Click(object sender, EventArgs e)
        {
            ToggleSelection("Gaming");
            highlightButton((Button)sender);
        }

        private void btnSports_Click(object sender, EventArgs e)
        {
            ToggleSelection("Sports");
            highlightButton((Button)sender);
        }

        private void btnHiking_Click(object sender, EventArgs e)
        {
            ToggleSelection("Hiking");
            highlightButton((Button)sender);
        }

        private void btnArt_Click(object sender, EventArgs e)
        {
            ToggleSelection("Art");
            highlightButton((Button)sender);
        }

        private void btnCooking_Click(object sender, EventArgs e)
        {
            ToggleSelection("Cooking");
            highlightButton((Button)sender);
        }

        private void btnMusic_Click(object sender, EventArgs e)
        {
            ToggleSelection("Music");
            highlightButton((Button)sender);
        }

        private void btnReading_Click(object sender, EventArgs e)
        {
            ToggleSelection("Reading");
            highlightButton((Button)sender);
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void btnContinue_Click(object sender, EventArgs e)
        {
            if (selectedInterests.Count == 0)
            {
                MessageBox.Show("Please select at least one interest.");
                return;
            }

            Goals goals = new Goals(selectedInterests);
            goals.Show();
            this.Hide();
        }
    }
}
