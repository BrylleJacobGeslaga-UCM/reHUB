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

        private void btnRides_Click(object sender, EventArgs e)
        {
            ToggleSelection("Rides");
        }

        private void btnGaming_Click(object sender, EventArgs e)
        {
            ToggleSelection("Gaming");
        }

        private void btnSports_Click(object sender, EventArgs e)
        {
            ToggleSelection("Sports");
        }

        private void btnHiking_Click(object sender, EventArgs e)
        {
            ToggleSelection("Hiking");
        }

        private void btnArt_Click(object sender, EventArgs e)
        {
            ToggleSelection("Art");
        }

        private void btnCooking_Click(object sender, EventArgs e)
        {
            ToggleSelection("Cooking");
        }

        private void btnMusic_Click(object sender, EventArgs e)
        {
            ToggleSelection("Music");
        }

        private void btnReading_Click(object sender, EventArgs e)
        {
            ToggleSelection("Reading");
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
