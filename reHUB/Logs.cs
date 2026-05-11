using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Logs : Form
    {
        private MainForm mainForm;

        // =========================
        // DATABASE
        // =========================

        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        public Logs(MainForm form)
        {
            InitializeComponent();

            mainForm = form;
        }

        private void Logs_Load(object sender, EventArgs e)
        {
            LoadMoodCounts();

            LoadPastCheckins();
        }

        // =========================
        // LOAD MOOD COUNTS
        // =========================

        private void LoadMoodCounts()
        {
            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // GREAT

                    string greatQuery =
                        "SELECT COUNT(*) FROM checkins " +
                        "WHERE user_id=@id AND mood='Great'";

                    MySqlCommand greatCmd =
                        new MySqlCommand(greatQuery, con);

                    greatCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    lblGreat.Text =
                        Convert.ToInt32(
                            greatCmd.ExecuteScalar()
                        ).ToString();

                    // OKAY

                    string okayQuery =
                        "SELECT COUNT(*) FROM checkins " +
                        "WHERE user_id=@id AND mood='Okay'";

                    MySqlCommand okayCmd =
                        new MySqlCommand(okayQuery, con);

                    okayCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    lblOkay.Text =
                        Convert.ToInt32(
                            okayCmd.ExecuteScalar()
                        ).ToString();

                    // STRUGGLING

                    string strugglingQuery =
                        "SELECT COUNT(*) FROM checkins " +
                        "WHERE user_id=@id AND mood='Struggling'";

                    MySqlCommand strugglingCmd =
                        new MySqlCommand(strugglingQuery, con);

                    strugglingCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    lblStruggling.Text =
                        Convert.ToInt32(
                            strugglingCmd.ExecuteScalar()
                        ).ToString();

                    // TOTAL CHECK-INS

                    string totalQuery =
                        "SELECT COUNT(*) FROM checkins " +
                        "WHERE user_id=@id";

                    MySqlCommand totalCmd =
                        new MySqlCommand(totalQuery, con);

                    totalCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    lblCheckins.Text =
                        Convert.ToInt32(
                            totalCmd.ExecuteScalar()
                        ).ToString();
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
        // LOAD PAST CHECK-INS
        // =========================

        private void LoadPastCheckins()
        {
            flowLogs.Controls.Clear();

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    string query =
                        "SELECT mood, journal, created_at " +
                        "FROM checkins " +
                        "WHERE user_id=@id " +
                        "ORDER BY created_at DESC";

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
                        string mood =
                            reader["mood"].ToString();

                        string journal =
                            reader["journal"].ToString();

                        DateTime time =
                            Convert.ToDateTime(
                                reader["created_at"]
                            );

                        // =========================
                        // MAIN PANEL
                        // =========================

                        Panel card = new Panel();

                        card.Width = 372;
                        card.Height = 110;

                        card.BackColor = Color.White;

                        card.BorderStyle =
                            BorderStyle.FixedSingle;

                        card.Margin =
                            new Padding(0, 0, 0, 10);

                        // =========================
                        // MOOD IMAGE
                        // =========================

                        PictureBox picMood =
                            new PictureBox();

                        picMood.Width = 40;
                        picMood.Height = 40;

                        picMood.Location =
                            new Point(15, 15);

                        picMood.SizeMode =
                            PictureBoxSizeMode.Zoom;

                        // SET IMAGE

                        if (mood == "Great")
                        {
                            picMood.Image =
                                Properties.Resources.smile2;
                        }
                        else if (mood == "Okay")
                        {
                            picMood.Image =
                                Properties.Resources.neutral;
                        }
                        else
                        {
                            picMood.Image =
                                Properties.Resources.sad;
                        }

                        // =========================
                        // MOOD LABEL
                        // =========================

                        Label lblMood = new Label();

                        lblMood.Text = mood;

                        lblMood.Font =
                            new Font(
                                "Segoe UI",
                                11,
                                FontStyle.Bold
                            );

                        lblMood.AutoSize = true;

                        lblMood.Location =
                            new Point(70, 15);

                        // =========================
                        // TIME LABEL
                        // =========================

                        Label lblTime = new Label();

                        lblTime.Text =
                            time.ToString(
                                "MMM dd, yyyy - hh:mm tt"
                            );

                        lblTime.ForeColor =
                            Color.Gray;

                        lblTime.AutoSize = true;

                        lblTime.Location =
                            new Point(70, 40);

                        // =========================
                        // JOURNAL LABEL
                        // =========================

                        Label lblJournal =
                            new Label();

                        lblJournal.Text =
                            journal;

                        lblJournal.Font =
                            new Font(
                                "Segoe UI",
                                9
                            );

                        lblJournal.MaximumSize =
                            new Size(400, 0);

                        lblJournal.AutoSize = true;

                        lblJournal.Location =
                            new Point(15, 70);

                        // =========================
                        // ADD CONTROLS
                        // =========================

                        card.Controls.Add(picMood);

                        card.Controls.Add(lblMood);

                        card.Controls.Add(lblTime);

                        card.Controls.Add(lblJournal);

                        // =========================
                        // ADD TO FLOWLAYOUT
                        // =========================

                        flowLogs.Controls.Add(card);
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

        private void label6_Click(object sender, EventArgs e)
        {

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

        private void btnBack_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new Profile(mainForm)
            );
        }
    }
}