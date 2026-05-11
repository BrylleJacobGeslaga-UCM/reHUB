using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class TrackGoal : Form
    {
        private MainForm mainForm;

        // =========================
        // DATABASE
        // =========================

        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        public TrackGoal(MainForm form)
        {
            InitializeComponent();

            mainForm = form;
        }

        private void TrackGoal_Load(
            object sender,
            EventArgs e
        )
        {
            // =========================
            // FLOW SETTINGS
            // =========================

            flowGoals.FlowDirection =
                FlowDirection.TopDown;

            flowGoals.WrapContents =
                false;

            flowGoals.AutoScroll =
                true;

            // =========================
            // LOAD ALL GOALS
            // =========================

            LoadAllGoals();
        }

        // =========================
        // LOAD ALL GOALS
        // =========================

        private void LoadAllGoals()
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
                        return;
                    }

                    string[] goalList =
                        goals.Split(',');

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
                    // CREATE GOAL CARDS
                    // =========================

                    foreach (string goal in goalList)
                    {
                        string trimmedGoal =
                            goal.Trim();

                        int progress = 0;

                        string progressText = "";

                        // =========================
                        // STAY CONSISTENT
                        // =========================

                        if (trimmedGoal ==
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

                        else if (trimmedGoal ==
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

                        else if (trimmedGoal ==
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

                        else if (trimmedGoal ==
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
                        // CREATE CARD
                        // =========================

                        CreateGoalCard(
                            trimmedGoal,
                            progress,
                            progressText
                        );
                    }
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
            // =========================
            // MAIN CARD
            // =========================

            Panel card =
                new Panel();

            card.Width = 372;

            card.Height = 100;

            card.BackColor =
                Color.White;

            card.BorderStyle =
                BorderStyle.FixedSingle;

            card.Margin =
                new Padding(0, 0, 0, 12);

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
        // BACK BUTTON
        // =========================

        private void btnBack_Click(
            object sender,
            EventArgs e
        )
        {
            mainForm.LoadForm(
                new Dashboard(mainForm)
            );
        }

        // =========================
        // HEADER DESIGN
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
    }
}