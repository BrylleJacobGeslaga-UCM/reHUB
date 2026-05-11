using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Checkin : Form
    {
        private MainForm mainForm;

        // =========================
        // DATABASE
        // =========================

        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        // =========================
        // SELECTED MOOD PANEL
        // =========================

        private Panel selectedMoodPanel = null;

        // =========================
        // SELECTED MOOD
        // =========================

        private string selectedMood = "";

        // =========================
        // COLORS
        // =========================

        Color selectedColor =
            Color.FromArgb(214, 232, 225);

        Color defaultColor =
            Color.White;

        public Checkin(MainForm form)
        {
            InitializeComponent();

            mainForm = form;

            // =========================
            // CLICK EVENTS
            // =========================

            panelGreat.Click += Mood_Click;
            panelOkay.Click += Mood_Click;
            panelStruggling.Click += Mood_Click;

            pictureBoxGreat.Click += Mood_Click;
            pictureBoxOkay.Click += Mood_Click;
            pictureBoxStruggling.Click += Mood_Click;

            lblGreat.Click += Mood_Click;
            lblOkay.Click += Mood_Click;
            lblStruggling.Click += Mood_Click;
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
        // MOOD SELECTION
        // =========================

        private void Mood_Click(
            object sender,
            EventArgs e
        )
        {
            // RESET OLD PANEL

            if (selectedMoodPanel != null)
            {
                selectedMoodPanel.BackColor =
                    defaultColor;
            }

            Control clicked =
                (Control)sender;

            // =========================
            // DETECT PANEL
            // =========================

            if (clicked.Parent is Panel)
            {
                selectedMoodPanel =
                    (Panel)clicked.Parent;
            }
            else
            {
                selectedMoodPanel =
                    (Panel)clicked;
            }

            // =========================
            // HIGHLIGHT PANEL
            // =========================

            selectedMoodPanel.BackColor =
                selectedColor;

            // =========================
            // SAVE MOOD
            // =========================

            if (selectedMoodPanel == panelGreat)
            {
                selectedMood = "Great";
            }
            else if (selectedMoodPanel == panelOkay)
            {
                selectedMood = "Okay";
            }
            else if (selectedMoodPanel ==
                     panelStruggling)
            {
                selectedMood = "Struggling";
            }
        }

        // =========================
        // SUBMIT CHECK-IN
        // =========================

        private void btnCheckIn_Click(
            object sender,
            EventArgs e
        )
        {
            // =========================
            // GUEST CHECK
            // =========================

            if (UserSession.IsGuest)
            {
                MessageBox.Show(
                    "Guests cannot check in."
                );

                return;
            }

            // =========================
            // CHECK MOOD
            // =========================

            if (selectedMood == "")
            {
                MessageBox.Show(
                    "Please select a mood."
                );

                return;
            }

            string journal =
                txtJournal.Text;

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // =========================
                    // CHECK IF ALREADY
                    // CHECKED IN TODAY
                    // =========================

                    string checkQuery =
                        "SELECT COUNT(*) " +
                        "FROM checkins " +
                        "WHERE user_id=@id " +
                        "AND DATE(created_at)=CURDATE()";

                    MySqlCommand checkCmd =
                        new MySqlCommand(
                            checkQuery,
                            con
                        );

                    checkCmd.Parameters.AddWithValue(
                        "@id",
                        UserSession.UserID
                    );

                    int alreadyCheckedIn =
                        Convert.ToInt32(
                            checkCmd.ExecuteScalar()
                        );

                    // =========================
                    // ALREADY CHECKED IN
                    // =========================

                    if (alreadyCheckedIn > 0)
                    {
                        MessageBox.Show(
                            "You already checked in today!"
                        );

                        return;
                    }

                    // =========================
                    // INSERT CHECK-IN
                    // =========================

                    string insertQuery =
                        "INSERT INTO checkins " +
                        "(user_id, mood, journal) " +
                        "VALUES " +
                        "(@userId, @mood, @journal)";

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
                        "@mood",
                        selectedMood
                    );

                    insertCmd.Parameters.AddWithValue(
                        "@journal",
                        journal
                    );

                    insertCmd.ExecuteNonQuery();

                    // =========================
                    // SUCCESS
                    // =========================

                    MessageBox.Show(
                        "Check-in completed!"
                    );

                    // =========================
                    // BACK TO DASHBOARD
                    // =========================

                    mainForm.LoadForm(
                        new Dashboard(mainForm)
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

        private void panelGreat_MouseHover(
            object sender,
            EventArgs e
        )
        {

        }
    }
}