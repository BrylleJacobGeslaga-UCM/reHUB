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
    public partial class HubDetails : Form
    {
        Boolean Guest;

        private MainForm mainForm;

        string connectionString = "server=localhost;user id=root;password=;database=rehub;";

        string currentHub;

        public HubDetails(
            Boolean isGuest,
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
            if (isGuest)
            {
                Guest = true;
            }
            else
            {
                Guest = false;
            }
            InitializeComponent();

            mainForm = form;

            currentHub = hubName;

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

        private void btnJoinHub_Click(object sender, EventArgs e)
        {
            if (UserSession.IsGuest)
            {
                MessageBox.Show("Guests cannot join hubs.");
                return;
            }
            else
            {
                using (MySqlConnection con = new MySqlConnection(connectionString))
                {
                    try
                    {
                        con.Open();

                        string checkQuery =
                            "SELECT COUNT(*) FROM joined_hubs " +
                            "WHERE user_id=@userId AND hub_name=@hub";

                        MySqlCommand checkCmd = new MySqlCommand(checkQuery, con);

                        checkCmd.Parameters.AddWithValue("@userId", UserSession.UserID);
                        checkCmd.Parameters.AddWithValue("@hub", currentHub);

                        int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (exists > 0)
                        {
                            MessageBox.Show("Already joined this hub.");
                            return;
                        }

                        string insertQuery =
                            "INSERT INTO joined_hubs(user_id, hub_name) " +
                            "VALUES(@userId, @hub)";

                        MySqlCommand insertCmd = new MySqlCommand(insertQuery, con);

                        insertCmd.Parameters.AddWithValue("@userId", UserSession.UserID);
                        insertCmd.Parameters.AddWithValue("@hub", currentHub);

                        insertCmd.ExecuteNonQuery();

                        MessageBox.Show("Joined hub successfully!");

                        btnJoinHub.Text = "Joined";
                        btnJoinHub.Enabled = false;
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