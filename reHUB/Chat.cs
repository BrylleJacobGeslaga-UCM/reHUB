using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Chat : Form
    {
        // =========================
        // DATABASE
        // =========================

        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        public Chat()
        {
            InitializeComponent();
        }

        private void Chat_Load(object sender, EventArgs e)
        {
            // =========================
            // FLOWLAYOUT SETTINGS
            // =========================

            flowMessages.FlowDirection =
                FlowDirection.TopDown;

            flowMessages.WrapContents = false;

            flowMessages.AutoScroll = true;

            // =========================
            // LOAD HUBS
            // =========================

            LoadJoinedHubs();
        }

        // =========================
        // LOAD JOINED HUBS
        // =========================

        private void LoadJoinedHubs()
        {
            cmbHubs.Items.Clear();

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    string query =
                        "SELECT hub_name " +
                        "FROM joined_hubs " +
                        "WHERE user_id=@id";

                    MySqlCommand cmd =
                        new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    MySqlDataReader reader =
                        cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        cmbHubs.Items.Add(
                            reader["hub_name"].ToString()
                        );
                    }

                    reader.Close();

                    // =========================
                    // AUTO SELECT FIRST HUB
                    // =========================

                    if (cmbHubs.Items.Count > 0)
                    {
                        cmbHubs.SelectedIndex = 0;
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
        // LOAD MESSAGES
        // =========================

        private void LoadMessages()
        {
            flowMessages.Controls.Clear();

            if (cmbHubs.SelectedItem == null)
            {
                return;
            }

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    string query =
                        "SELECT users.username, " +
                        "messages.message, " +
                        "messages.user_id, " +
                        "messages.created_at " +

                        "FROM messages " +

                        "INNER JOIN users " +
                        "ON messages.user_id = users.id " +

                        "WHERE hub_name=@hub " +

                        "ORDER BY created_at ASC";

                    MySqlCommand cmd =
                        new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue(
                        "@hub",
                        cmbHubs.SelectedItem.ToString()
                    );

                    MySqlDataReader reader =
                        cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        string username =
                            reader["username"].ToString();

                        string message =
                            reader["message"].ToString();

                        int senderId =
                            Convert.ToInt32(
                                reader["user_id"]
                            );

                        DateTime time =
                            Convert.ToDateTime(
                                reader["created_at"]
                            );

                        bool isMine =
                            senderId ==
                            UserSession.UserID;

                        CreateMessageBubble(
                            username,
                            message,
                            time,
                            isMine
                        );
                    }

                    reader.Close();
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
        // CREATE MESSAGE BUBBLE
        // =========================

        private void CreateMessageBubble(
            string username,
            string message,
            DateTime time,
            bool isMine
        )
        {
            // =========================
            // CONTAINER
            // =========================

            Panel container =
                new Panel();

            container.Width = 372;

            container.Height = 90;

            container.BackColor =
                Color.Transparent;

            // =========================
            // MESSAGE PANEL
            // =========================

            Panel bubble =
                new Panel();

            bubble.AutoSize = false;

            bubble.Width = 260;

            bubble.Height = 75;

            bubble.Padding =
                new Padding(10);

            bubble.BackColor =
                isMine
                ? Color.FromArgb(214, 232, 225)
                : Color.Gainsboro;

            // ALIGN

            if (isMine)
            {
                bubble.Location =
                    new Point(145, 5);
            }
            else
            {
                bubble.Location =
                    new Point(5, 5);
            }

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
                    9,
                    FontStyle.Bold
                );

            lblUser.AutoSize = true;

            lblUser.Location =
                new Point(10, 8);

            // =========================
            // MESSAGE
            // =========================

            Label lblMessage =
                new Label();

            lblMessage.Text =
                message;

            lblMessage.MaximumSize =
                new Size(220, 0);

            lblMessage.AutoSize = true;

            lblMessage.Font =
                new Font(
                    "Segoe UI",
                    10
                );

            lblMessage.Location =
                new Point(10, 28);

            // =========================
            // TIME
            // =========================

            Label lblTime =
                new Label();

            lblTime.Text =
                time.ToString("hh:mm tt");

            lblTime.ForeColor =
                Color.Gray;

            lblTime.Font =
                new Font(
                    "Segoe UI",
                    8
                );

            lblTime.AutoSize = true;

            lblTime.Location =
                new Point(170, 55);

            // =========================
            // ADD CONTROLS
            // =========================

            bubble.Controls.Add(lblUser);

            bubble.Controls.Add(lblMessage);

            bubble.Controls.Add(lblTime);

            container.Controls.Add(bubble);

            flowMessages.Controls.Add(container);

            // =========================
            // AUTO SCROLL
            // =========================

            flowMessages.ScrollControlIntoView(
                container
            );
        }

        // =========================
        // SEND MESSAGE
        // =========================

        private void btnSend_Click(object sender, EventArgs e)
        {
            if (txtMessage.Text.Trim() == "")
            {
                return;
            }

            if (cmbHubs.SelectedItem == null)
            {
                MessageBox.Show(
                    "Please select a hub."
                );

                return;
            }

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    string query =
                        "INSERT INTO messages " +
                        "(user_id, hub_name, message) " +
                        "VALUES " +
                        "(@userId, @hub, @message)";

                    MySqlCommand cmd =
                        new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue(
                        "@userId",
                        UserSession.UserID
                    );

                    cmd.Parameters.AddWithValue(
                        "@hub",
                        cmbHubs.SelectedItem.ToString()
                    );

                    cmd.Parameters.AddWithValue(
                        "@message",
                        txtMessage.Text
                    );

                    cmd.ExecuteNonQuery();

                    txtMessage.Clear();

                    LoadMessages();
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
        // CHANGE HUB
        // =========================

        private void cmbHubs_SelectedIndexChanged(
            object sender,
            EventArgs e
        )
        {
            LoadMessages();
        }

        // =========================
        // HEADER
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