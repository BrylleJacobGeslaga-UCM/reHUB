using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Profile : Form
    {
        private MainForm mainForm;

        // =========================
        // DATABASE
        // =========================

        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        public Profile(MainForm form)
        {
            InitializeComponent();

            mainForm = form;
        }

        private void panelHeader_Paint(object sender, PaintEventArgs e)
        {
            LinearGradientBrush brush =
                new LinearGradientBrush(
                    panelHeader.ClientRectangle,
                    Color.FromArgb(113, 196, 140),
                    Color.FromArgb(54, 94, 67),
                    LinearGradientMode.Vertical
                );

            e.Graphics.FillRectangle(
                brush,
                panelHeader.ClientRectangle
            );
        }

        private void panelChild_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor =
                Color.FromArgb(113, 196, 140);

            int borderThickness = 1;

            using (Pen pen =
                new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(
                    pen,
                    0,
                    0,
                    panelChild.Width - 1,
                    panelChild.Height - 1
                );
            }
        }

        private void panelProgress_Paint(object sender, PaintEventArgs e)
        {
            Color borderColor =
                Color.DarkGray;

            int borderThickness = 1;

            using (Pen pen =
                new Pen(borderColor, borderThickness))
            {
                e.Graphics.DrawRectangle(
                    pen,
                    0,
                    0,
                    panelProgress.Width - 1,
                    panelProgress.Height - 1
                );
            }
        }

        private void btnLogOut_Click(object sender, EventArgs e)
        {
            UserSession.UserID = 0;

            UserSession.Username = "";

            UserSession.IsGuest = true;

            // =========================
            // GO TO LOGIN
            // =========================

        }

        private void Profile_Load(object sender, EventArgs e)
        {
            // =========================
            // CLEAR FLOWLAYOUTS
            // =========================

            flowInterests.Controls.Clear();
            flowCommunities.Controls.Clear();

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // =========================
                    // LOAD USER INTERESTS
                    // =========================

                    string query =
                        "SELECT interest " +
                        "FROM users " +
                        "WHERE id=@id";

                    MySqlCommand cmd =
                        new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    MySqlDataReader reader =
                        cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        string interests =
                            reader["interest"].ToString();

                        string[] interestList =
                            interests.Split(',');

                        foreach (string interest in interestList)
                        {
                            if (interest.Trim() == "")
                                continue;

                            Label tag = new Label();

                            tag.Text =
                                interest.Trim();

                            tag.AutoSize = true;

                            tag.BackColor =
                                Color.FromArgb(214, 232, 225);

                            tag.Padding =
                                new Padding(10, 5, 10, 5);

                            tag.Margin =
                                new Padding(5);

                            tag.Font =
                                new Font(
                                    "Segoe UI",
                                    9,
                                    FontStyle.Regular
                                );

                            flowInterests.Controls.Add(tag);
                        }
                    }

                    reader.Close();

                    // =========================
                    // LOAD CHECK-IN COUNT
                    // =========================

                    string countQuery =
                        "SELECT COUNT(*) FROM checkins " +
                        "WHERE user_id=@id";

                    MySqlCommand countCmd =
                        new MySqlCommand(countQuery, con);

                    countCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    int totalCheckins =
                        Convert.ToInt32(
                            countCmd.ExecuteScalar()
                        );

                    lblCheckins.Text =
                        totalCheckins.ToString();

                    // =========================
                    // DAILY CHECK-IN PROGRESS
                    // =========================

                    lblProgress.Text =
                        totalCheckins.ToString();

                    progressBar1.Maximum = 30;

                    if (totalCheckins > 30)
                    {
                        progressBar1.Value = 30;
                    }
                    else
                    {
                        progressBar1.Value = totalCheckins;
                    }

                    // =========================
                    // LOAD JOINED COMMUNITIES COUNT
                    // =========================

                    string communityCountQuery =
                        "SELECT COUNT(*) FROM joined_hubs " +
                        "WHERE user_id=@id";

                    MySqlCommand communityCountCmd =
                        new MySqlCommand(
                            communityCountQuery,
                            con
                        );

                    communityCountCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    int totalCommunities =
                        Convert.ToInt32(
                            communityCountCmd.ExecuteScalar()
                        );

                    lblCommunities.Text =
                        totalCommunities.ToString();

                    // =========================
                    // LOAD JOINED HUBS
                    // =========================

                    string joinedQuery =
                        "SELECT hub_name " +
                        "FROM joined_hubs " +
                        "WHERE user_id=@id";

                    MySqlCommand joinedCmd =
                        new MySqlCommand(joinedQuery, con);

                    joinedCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    MySqlDataReader joinedReader =
                        joinedCmd.ExecuteReader();

                    while (joinedReader.Read())
                    {
                        Label hubTag = new Label();

                        hubTag.Text =
                            joinedReader["hub_name"].ToString();

                        hubTag.AutoSize = true;

                        hubTag.BackColor =
                            Color.FromArgb(214, 232, 225);

                        hubTag.Padding =
                            new Padding(10, 5, 10, 5);

                        hubTag.Margin =
                            new Padding(5);

                        hubTag.Font =
                            new Font(
                                "Segoe UI",
                                9,
                                FontStyle.Regular
                            );

                        flowCommunities.Controls.Add(hubTag);
                    }

                    joinedReader.Close();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(
                        "Error: " + ex.Message
                    );
                }
            }
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void lblLogs_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new Logs(mainForm)
            );
        }
    }
}