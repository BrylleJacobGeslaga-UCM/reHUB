using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Dashboard : Form
    {
        private MainForm mainForm;

        Boolean Guest;

        // =========================
        // DATABASE
        // =========================

        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        public Dashboard(MainForm form)
        {
            InitializeComponent();

            mainForm = form;
        }

        public Dashboard(MainForm form, Boolean isGuest)
        {
            InitializeComponent();

            Guest = isGuest;

            mainForm = form;
        }

        private void Dashboard_Load(object sender, EventArgs e)
        {
            // =========================
            // GREETING
            // =========================

            if (UserSession.IsGuest)
            {
                lblGreeting.Text =
                    "Hello, Guest!";
            }
            else
            {
                lblGreeting.Text =
                    "Hello, " +
                    UserSession.Username +
                    "!";
            }

            // =========================
            // DATE
            // =========================

            lblDate.Text =
                DateTime.Now.ToString("dddd, MMM dd"
            );

            // =========================
            // FLOW SETTINGS
            // =========================

            flowGoals.FlowDirection =
                FlowDirection.TopDown;

            flowGoals.WrapContents =
                false;

            flowGoals.AutoScroll =
                false;

            // =========================
            // LOAD FEATURED GOAL
            // =========================

            if (!UserSession.IsGuest)
            {
                LoadFeaturedGoal();
            }
        }

        // =========================
        // LOAD MOST PROGRESSED GOAL
        // =========================

        private void LoadFeaturedGoal()
        {
            flowGoals.Controls.Clear();

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // =========================
                    // GET USER GOALS
                    // =========================

                    string query =
                        "SELECT goals " +
                        "FROM users " +
                        "WHERE id=@id";

                    MySqlCommand cmd =
                        new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    string goals =
                        cmd.ExecuteScalar()?.ToString();

                    if (string.IsNullOrEmpty(goals))
                    {
                        lblShowAll.Visible = false;
                        return;
                    }

                    string[] goalList =
                        goals.Split(',');

                    // =========================
                    // SHOW/HIDE SHOW ALL
                    // =========================

                    lblShowAll.Visible =
                        goalList.Length > 1;

                    // =========================
                    // COUNTS
                    // =========================

                    int totalCheckins = 0;

                    int joinedHubs = 0;

                    int totalPosts = 0;

                    // =========================
                    // CHECKINS
                    // =========================

                    string checkinQuery =
                        "SELECT COUNT(*) FROM checkins " +
                        "WHERE user_id=@id";

                    MySqlCommand checkinCmd =
                        new MySqlCommand(checkinQuery, con);

                    checkinCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    totalCheckins =
                        Convert.ToInt32(
                            checkinCmd.ExecuteScalar()
                        );

                    // =========================
                    // HUBS
                    // =========================

                    string hubQuery =
                        "SELECT COUNT(*) FROM joined_hubs " +
                        "WHERE user_id=@id";

                    MySqlCommand hubCmd =
                        new MySqlCommand(hubQuery, con);

                    hubCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    joinedHubs =
                        Convert.ToInt32(
                            hubCmd.ExecuteScalar()
                        );

                    // =========================
                    // POSTS
                    // =========================

                    string postQuery =
                        "SELECT COUNT(*) FROM updates " +
                        "WHERE user_id=@id";

                    MySqlCommand postCmd =
                        new MySqlCommand(postQuery, con);

                    postCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    totalPosts =
                        Convert.ToInt32(
                            postCmd.ExecuteScalar()
                        );

                    // =========================
                    // BEST GOAL VARIABLES
                    // =========================

                    string bestGoal = "";

                    int bestProgress = -1;

                    string bestProgressText = "";

                    // =========================
                    // CHECK ALL GOALS
                    // =========================

                    foreach (string item in goalList)
                    {
                        string goal =
                            item.Trim();

                        int progress = 0;

                        string progressText = "";

                        // =========================
                        // STAY CONSISTENT
                        // =========================

                        if (goal ==
                            "Stay consistent")
                        {
                            progress =
                                totalCheckins * 10;

                            if (progress > 100)
                            {
                                progress = 100;
                            }

                            progressText =
                                totalCheckins +
                                " / 10 check-ins";
                        }

                        // =========================
                        // AVOID RELAPSE
                        // =========================

                        else if (goal ==
                            "Avoid relapse")
                        {
                            progress =
                                totalCheckins * 10;

                            if (progress > 100)
                            {
                                progress = 100;
                            }

                            progressText =
                                totalCheckins +
                                " day streak";
                        }

                        // =========================
                        // FIND SUPPORT
                        // =========================

                        else if (goal ==
                            "Find support")
                        {
                            progress =
                                joinedHubs * 33;

                            if (progress > 100)
                            {
                                progress = 100;
                            }

                            progressText =
                                joinedHubs +
                                " / 3 hubs joined";
                        }

                        // =========================
                        // BUILD COMMUNITY
                        // =========================

                        else if (goal ==
                            "Build community")
                        {
                            progress =
                                totalPosts * 20;

                            if (progress > 100)
                            {
                                progress = 100;
                            }

                            progressText =
                                totalPosts +
                                " / 5 posts shared";
                        }

                        // =========================
                        // SAVE HIGHEST PROGRESS
                        // =========================

                        if (progress > bestProgress)
                        {
                            bestGoal =
                                goal;

                            bestProgress =
                                progress;

                            bestProgressText =
                                progressText;
                        }
                    }

                    // =========================
                    // CREATE BEST GOAL CARD
                    // =========================

                    CreateGoalCard(
                        bestGoal,
                        bestProgress,
                        bestProgressText
                    );
                }
                catch (Exception ex)
                {
                    MessageBox.Show(
                        "Error: " + ex.Message
                    );
                }
            }
        }

        // =========================
        // CREATE GOAL CARD
        // =========================

        private void CreateGoalCard(
            string goalName,
            int progress,
            string progressText
        )
        {
            Panel card =
                new Panel();

            card.Width = 372;

            card.Height = 100;

            card.BackColor =
                Color.White;

            card.BorderStyle =
                BorderStyle.FixedSingle;

            card.Margin =
                new Padding(0, 0, 0, 10);

            // =========================
            // GOAL TITLE
            // =========================

            Label lblGoal =
                new Label();

            lblGoal.Text =
                "🎯 " + goalName;

            lblGoal.Font =
                new Font(
                    "Segoe UI",
                    11,
                    FontStyle.Bold
                );

            lblGoal.AutoSize =
                true;

            lblGoal.Location =
                new Point(15, 12);

            // =========================
            // PROGRESS TEXT
            // =========================

            Label lblProgress =
                new Label();

            lblProgress.Text =
                progressText;

            lblProgress.Font =
                new Font(
                    "Segoe UI",
                    9
                );

            lblProgress.ForeColor =
                Color.Gray;

            lblProgress.AutoSize =
                true;

            lblProgress.Location =
                new Point(15, 38);

            // =========================
            // PROGRESS BAR
            // =========================

            ProgressBar progressBar =
                new ProgressBar();

            progressBar.Width = 300;

            progressBar.Height = 18;

            progressBar.Location =
                new Point(15, 65);

            progressBar.Value =
                progress;

            // =========================
            // PERCENT LABEL
            // =========================

            Label lblPercent =
                new Label();

            lblPercent.Text =
                progress + "%";

            lblPercent.Font =
                new Font(
                    "Segoe UI",
                    9,
                    FontStyle.Bold
                );

            lblPercent.AutoSize =
                true;

            lblPercent.Location =
                new Point(320, 64);

            // =========================
            // ADD CONTROLS
            // =========================

            card.Controls.Add(lblGoal);

            card.Controls.Add(lblProgress);

            card.Controls.Add(progressBar);

            card.Controls.Add(lblPercent);

            // =========================
            // ADD TO FLOW
            // =========================

            flowGoals.Controls.Add(card);
        }

        // =========================
        // SHOW ALL GOALS
        // =========================

        private void lblShowAll_Click(
            object sender,
            EventArgs e
        )
        {
            mainForm.LoadForm(
                new TrackGoal(mainForm)
            );
        }

        // =========================
        // HEADER PAINT
        // =========================

        private void panelHeader_Paint(
            object sender,
            PaintEventArgs e
        )
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

        // =========================
        // EXPLORE BUTTON
        // =========================

        private void btnExplore_Click(
            object sender,
            EventArgs e
        )
        {
            mainForm.LoadForm(
                new Discover(mainForm)
            );
        }

        // =========================
        // HUB CARD 1
        // =========================

        private void panelCard1_Click(
            object sender,
            EventArgs e
        )
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Morning Riders",
                    53,
                    pictureBox1.Image,
                    "Join us for peaceful morning rides through scenic routes.",
                    "Sunday Sunrise Ride",
                    "Apr 26, 7:00 AM",
                    "Pier 39 Parking"
                )
            );
        }

        // =========================
        // HUB CARD 2
        // =========================

        private void panelCard2_Click(
            object sender,
            EventArgs e
        )
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Couch Gamers",
                    96,
                    pictureBox2.Image,
                    "Casual gaming sessions in a judgment-free space.",
                    "Late Night Ranked",
                    "Apr 25, 9:00 PM",
                    "Online"
                )
            );
        }

        // =========================
        // HUB CARD 3
        // =========================

        private void panelCard3_Click(
            object sender,
            EventArgs e
        )
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Trail Seekers",
                    32,
                    pictureBox3.Image,
                    "Explore nature trails and build connections.",
                    "Forest Hike",
                    "Apr 26, 6:00 AM",
                    "Green Trail"
                )
            );
        }

        private void panelCheckin_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new Checkin(mainForm)
            );
        }

        private void panelCheckin_MouseHover(object sender, EventArgs e)
        {
            panelCheckin.BackColor =
                Color.FromArgb(
                74,
                157,
                127
            );

        }

        private void panelCheckin_MouseLeave(object sender, EventArgs e)
        {
            panelCheckin.BackColor =
                Color.FromArgb(
                113, 196, 140
            );
        }

        private void pictureBoxCheckin_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new Checkin(mainForm)
            );
        }
    }
}
