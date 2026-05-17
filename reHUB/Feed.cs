using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Feed : Form
    {
        private MainForm mainForm;

        // =========================
        // DATABASE
        // =========================

        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        // =========================
        // ACTIVE REACTION COLOR
        // =========================

        Color activeColor =
            Color.FromArgb(74, 157, 127);

        public Feed(MainForm form)
        {
            InitializeComponent();

            mainForm = form;
        }

        private void Feed_Load(object sender, EventArgs e)
        {
            // =========================
            // FLOWLAYOUT SETTINGS
            // =========================

            flowFeed.WrapContents = false;

            flowFeed.FlowDirection =
                FlowDirection.TopDown;

            flowFeed.AutoScroll = true;

            LoadFeed();
        }

        // =========================
        // LOAD FEED
        // =========================

        private void LoadFeed()
        {
            flowFeed.Controls.Clear();

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // =========================
                    // LOAD POSTS
                    // =========================

                    string query =
                        "SELECT updates.id, " +
                        "users.username, " +
                        "updates.hub_name, " +
                        "updates.content, " +
                        "updates.created_at, " +
                        "updates.is_anonymous " +

                        "FROM updates " +

                        "INNER JOIN users " +
                        "ON updates.user_id = users.id " +

                        "INNER JOIN joined_hubs " +
                        "ON updates.hub_name = joined_hubs.hub_name " +

                        "WHERE joined_hubs.user_id = @userId " +

                        "ORDER BY updates.created_at DESC";

                    MySqlCommand cmd =
                        new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue(
                        "@userId",
                        UserSession.UserID
                    );

                    MySqlDataReader reader =
                        cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        int postId =
                            Convert.ToInt32(
                                reader["id"]
                            );

                        bool isAnonymous =
                            Convert.ToBoolean(
                                reader["is_anonymous"]
                        );

                        string username;

                        if (isAnonymous)
                        {
                            username = "Anonymous";
                        }
                        else
                        {
                            username =
                                reader["username"].ToString();
                        }

                        string hub =
                            reader["hub_name"].ToString();

                        string content =
                            reader["content"].ToString();

                        DateTime time =
                            Convert.ToDateTime(
                                reader["created_at"]
                            );

                        // =========================
                        // CHECK REACTIONS
                        // =========================

                        bool supported =
                            HasReacted(
                                postId,
                                "Support"
                            );

                        bool proud =
                            HasReacted(
                                postId,
                                "Proud"
                            );

                        // =========================
                        // MAIN CARD
                        // =========================

                        Panel card =
                            new Panel();

                        card.Width = 372;

                        card.Height = 210;

                        card.BackColor =
                            Color.White;

                        card.Margin =
                            new Padding(0, 0, 0, 15);

                        // =========================
                        // PROFILE IMAGE
                        // =========================

                        PictureBox picProfile =
                            new PictureBox();

                        picProfile.Width = 45;

                        picProfile.Height = 45;

                        picProfile.Location =
                            new Point(15, 15);

                        picProfile.SizeMode =
                            PictureBoxSizeMode.Zoom;

                        picProfile.Image =
                            Properties.Resources.profile;

                        // =========================
                        // USERNAME
                        // =========================

                        Label lblUser =
                            new Label();

                        lblUser.Text =
                            username;

                        lblUser.Font =
                            new Font(
                                "Segoe UI",
                                11,
                                FontStyle.Bold
                            );

                        lblUser.AutoSize =
                            true;

                        lblUser.Location =
                            new Point(75, 15);

                        // =========================
                        // TIME
                        // =========================

                        Label lblTime =
                            new Label();

                        lblTime.Text =
                            "• " +
                            GetTimeAgo(time);

                        lblTime.ForeColor =
                            Color.Gray;

                        lblTime.Font =
                            new Font(
                                "Segoe UI",
                                10
                            );

                        lblTime.AutoSize =
                            true;

                        lblTime.Location =
                            new Point(170, 17);

                        // =========================
                        // HUB NAME
                        // =========================

                        Label lblHub =
                            new Label();

                        lblHub.Text =
                            hub;

                        lblHub.ForeColor =
                            Color.FromArgb(
                                113,
                                196,
                                140
                            );

                        lblHub.Font =
                            new Font(
                                "Segoe UI",
                                11
                            );

                        lblHub.AutoSize =
                            true;

                        lblHub.Location =
                            new Point(75, 42);

                        // =========================
                        // CONTENT
                        // =========================

                        Label lblContent =
                            new Label();

                        lblContent.Text =
                            content;

                        lblContent.MaximumSize =
                            new Size(330, 0);

                        lblContent.AutoSize =
                            true;

                        lblContent.Font =
                            new Font(
                                "Segoe UI",
                                11
                            );

                        lblContent.Location =
                            new Point(15, 85);

                        // =========================
                        // SUPPORT ICON
                        // =========================

                        PictureBox picSupport =
                            new PictureBox();

                        picSupport.Width = 22;

                        picSupport.Height = 22;

                        picSupport.Location =
                            new Point(15, 170);

                        picSupport.SizeMode =
                            PictureBoxSizeMode.Zoom;

                        picSupport.Image =
                            supported
                            ? Properties.Resources.heart2
                            : Properties.Resources.heart;

                        picSupport.Cursor =
                            Cursors.Hand;

                        // =========================
                        // SUPPORT LABEL
                        // =========================

                        Label lblSupport =
                            new Label();

                        lblSupport.Text =
                            "Support";

                        lblSupport.Font =
                            new Font(
                                "Segoe UI",
                                10,
                                supported
                                ? FontStyle.Bold
                                : FontStyle.Regular
                            );

                        lblSupport.ForeColor =
                            supported
                            ? activeColor
                            : Color.Black;

                        lblSupport.AutoSize =
                            true;

                        lblSupport.Location =
                            new Point(42, 171);

                        lblSupport.Cursor =
                            Cursors.Hand;

                        // =========================
                        // SUPPORT CLICK
                        // =========================

                        picSupport.Click +=
                            (s, e) =>
                            {
                                ToggleReaction(
                                    postId,
                                    "Support"
                                );

                                LoadFeed();
                            };

                        lblSupport.Click +=
                            (s, e) =>
                            {
                                ToggleReaction(
                                    postId,
                                    "Support"
                                );

                                LoadFeed();
                            };

                        // =========================
                        // PROUD ICON
                        // =========================

                        PictureBox picProud =
                            new PictureBox();

                        picProud.Width = 22;

                        picProud.Height = 22;

                        picProud.Location =
                            new Point(110, 170);

                        picProud.SizeMode =
                            PictureBoxSizeMode.Zoom;

                        picProud.Image =
                            proud
                            ? Properties.Resources.smile2
                            : Properties.Resources.smile;

                        picProud.Cursor =
                            Cursors.Hand;

                        // =========================
                        // PROUD LABEL
                        // =========================

                        Label lblProud =
                            new Label();

                        lblProud.Text =
                            "Proud";

                        lblProud.Font =
                            new Font(
                                "Segoe UI",
                                10,
                                proud
                                ? FontStyle.Bold
                                : FontStyle.Regular
                            );

                        lblProud.ForeColor =
                            proud
                            ? activeColor
                            : Color.Black;

                        lblProud.AutoSize =
                            true;

                        lblProud.Location =
                            new Point(137, 171);

                        lblProud.Cursor =
                            Cursors.Hand;

                        // =========================
                        // PROUD CLICK
                        // =========================

                        picProud.Click +=
                            (s, e) =>
                            {
                                ToggleReaction(
                                    postId,
                                    "Proud"
                                );

                                LoadFeed();
                            };

                        lblProud.Click +=
                            (s, e) =>
                            {
                                ToggleReaction(
                                    postId,
                                    "Proud"
                                );

                                LoadFeed();
                            };

                        // =========================
                        // ENCOURAGE ICON
                        // =========================

                        PictureBox picEncourage =
                            new PictureBox();

                        picEncourage.Width = 22;

                        picEncourage.Height = 22;

                        picEncourage.Location =
                            new Point(250, 170);

                        picEncourage.SizeMode =
                            PictureBoxSizeMode.Zoom;

                        picEncourage.Image =
                            Properties.Resources.encourage;

                        // =========================
                        // ENCOURAGE LABEL
                        // =========================

                        Label lblEncourage =
                            new Label();

                        lblEncourage.Text =
                            "Encourage";

                        lblEncourage.Font =
                            new Font(
                                "Segoe UI",
                                10
                            );

                        lblEncourage.AutoSize =
                            true;

                        lblEncourage.Location =
                            new Point(277, 171);

                        // =========================
                        // ADD CONTROLS
                        // =========================

                        card.Controls.Add(picProfile);

                        card.Controls.Add(lblUser);

                        card.Controls.Add(lblTime);

                        card.Controls.Add(lblHub);

                        card.Controls.Add(lblContent);

                        card.Controls.Add(picSupport);

                        card.Controls.Add(lblSupport);

                        card.Controls.Add(picProud);

                        card.Controls.Add(lblProud);

                        card.Controls.Add(picEncourage);

                        card.Controls.Add(lblEncourage);

                        flowFeed.Controls.Add(card);
                    }

                    reader.Close();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(
                        "Error: " +
                        ex.Message
                    );
                }
            }
        }

        // =========================
        // TOGGLE REACTION
        // =========================

        private void ToggleReaction(
            int postId,
            string reactionType
        )
        {
            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                con.Open();

                string checkQuery =
                    "SELECT COUNT(*) " +
                    "FROM reactions " +
                    "WHERE user_id=@userId " +
                    "AND update_id=@postId " +
                    "AND reaction_type=@type";

                MySqlCommand checkCmd =
                    new MySqlCommand(
                        checkQuery,
                        con
                    );

                checkCmd.Parameters.AddWithValue(
                    "@userId",
                    UserSession.UserID
                );

                checkCmd.Parameters.AddWithValue(
                    "@postId",
                    postId
                );

                checkCmd.Parameters.AddWithValue(
                    "@type",
                    reactionType
                );

                int exists =
                    Convert.ToInt32(
                        checkCmd.ExecuteScalar()
                    );

                // REMOVE REACTION

                if (exists > 0)
                {
                    string deleteQuery =
                        "DELETE FROM reactions " +
                        "WHERE user_id=@userId " +
                        "AND update_id=@postId " +
                        "AND reaction_type=@type";

                    MySqlCommand deleteCmd =
                        new MySqlCommand(
                            deleteQuery,
                            con
                        );

                    deleteCmd.Parameters.AddWithValue(
                        "@userId",
                        UserSession.UserID
                    );

                    deleteCmd.Parameters.AddWithValue(
                        "@postId",
                        postId
                    );

                    deleteCmd.Parameters.AddWithValue(
                        "@type",
                        reactionType
                    );

                    deleteCmd.ExecuteNonQuery();
                }

                // ADD REACTION

                else
                {
                    string insertQuery =
                        "INSERT INTO reactions " +
                        "(user_id, update_id, reaction_type) " +
                        "VALUES " +
                        "(@userId, @postId, @type)";

                    MySqlCommand insertCmd =
                        new MySqlCommand(
                            insertQuery,
                            con
                        );

                    insertCmd.Parameters.AddWithValue(
                        "@userId",
                        UserSession.UserID
                    );

                    insertCmd.Parameters.AddWithValue(
                        "@postId",
                        postId
                    );

                    insertCmd.Parameters.AddWithValue(
                        "@type",
                        reactionType
                    );

                    insertCmd.ExecuteNonQuery();
                }
            }
        }

        // =========================
        // CHECK IF REACTED
        // =========================

        private bool HasReacted(
            int postId,
            string reactionType
        )
        {
            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                con.Open();

                string query =
                    "SELECT COUNT(*) " +
                    "FROM reactions " +
                    "WHERE user_id=@userId " +
                    "AND update_id=@postId " +
                    "AND reaction_type=@type";

                MySqlCommand cmd =
                    new MySqlCommand(query, con);

                cmd.Parameters.AddWithValue(
                    "@userId",
                    UserSession.UserID
                );

                cmd.Parameters.AddWithValue(
                    "@postId",
                    postId
                );

                cmd.Parameters.AddWithValue(
                    "@type",
                    reactionType
                );

                return Convert.ToInt32(
                    cmd.ExecuteScalar()
                ) > 0;
            }
        }

        // =========================
        // TIME AGO
        // =========================

        private string GetTimeAgo(
            DateTime dateTime
        )
        {
            TimeSpan span =
                DateTime.Now - dateTime;

            if (span.TotalMinutes < 60)
            {
                return (int)span.TotalMinutes +
                    " minutes ago";
            }

            if (span.TotalHours < 24)
            {
                return (int)span.TotalHours +
                    " hours ago";
            }

            return (int)span.TotalDays +
                " days ago";
        }

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

        private void btnAdd_Click(
            object sender,
            EventArgs e
        )
        {
            mainForm.LoadForm(
                new Update(mainForm)
            );
        }
    }
}