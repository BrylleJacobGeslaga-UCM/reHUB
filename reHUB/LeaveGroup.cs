using MySql.Data.MySqlClient;
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
    public partial class LeaveGroup : Form
    {
        private string hubName;
        private MainForm mainForm;
        private Profile profileForm;
        string connectionString = "server=localhost;user id=root;password=;database=rehub;";

        public LeaveGroup(string hubName, MainForm mainForm, Profile profileForm)
        {
            InitializeComponent();
            this.hubName = hubName;
            this.mainForm = mainForm;
            this.profileForm = profileForm;
            this.StartPosition = FormStartPosition.CenterScreen;
            lblHubName.Text = hubName;
            SetHubIcon();
        }

        private void SetHubIcon()
        {
            // Set icon and colors based on hub name
            switch (hubName)
            {
                case "Morning Riders":
                    pictureBoxIcon.Image = Properties.Resources.riders;
                    break;
                case "Couch Gamers":
                    pictureBoxIcon.Image = Properties.Resources.gaming;
                    break;
                case "Trail Seekers":
                    pictureBoxIcon.Image = Properties.Resources.hiking;
                    break;
                case "Football Warriors":
                    pictureBoxIcon.Image = Properties.Resources.sports;
                    break;
                case "Creative Circle":
                    pictureBoxIcon.Image = Properties.Resources.art;
                    break;
                case "Mountain Climbers":
                    pictureBoxIcon.Image = Properties.Resources.img_icons823;
                    break;
                default:
                    // Default icon if hub not found
                    pictureBoxIcon.Image = Properties.Resources.riders;
                    break;
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

        private void btnBack_Click(object sender, EventArgs e)
        {
            profileForm.Show();
            this.Close();
        }

        private void LeaveHub(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show(
                "Are you sure you want to leave this hub?",
                "Leave Hub",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question
            );

            if (result == DialogResult.Yes)
            {
                using (MySqlConnection con = new MySqlConnection(connectionString))
                {
                    try
                    {
                        con.Open();

                        // Delete from joined_hubs table
                        string deleteQuery = "DELETE FROM joined_hubs WHERE user_id=@userId AND hub_name=@hubName";
                        MySqlCommand deleteCmd = new MySqlCommand(deleteQuery, con);
                        deleteCmd.Parameters.AddWithValue("@userId", UserSession.UserID);
                        deleteCmd.Parameters.AddWithValue("@hubName", hubName);
                        deleteCmd.ExecuteNonQuery();

                        MessageBox.Show("You have successfully left the hub!");

                        // Refresh Profile and return
                        profileForm.RefreshHubs();
                        profileForm.Show();
                        this.Close();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Error: " + ex.Message);
                    }
                }
            }
        }
    }
}
