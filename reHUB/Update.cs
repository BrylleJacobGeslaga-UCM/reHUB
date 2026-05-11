using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;
using MySql.Data.MySqlClient;

namespace reHUB
{
    public partial class Update : Form
    {
        private MainForm mainForm;

        // =========================
        // DATABASE CONNECTION
        // =========================

        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        public Update(MainForm form)
        {
            InitializeComponent();

            mainForm = form;
        }

        // =========================
        // LOAD FORM
        // =========================

        private void Update_Load(object sender, EventArgs e)
        {
            cmbHubs.Items.Clear();

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    string query =
                        "SELECT hub_name FROM joined_hubs " +
                        "WHERE user_id=@userId";

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
                        cmbHubs.Items.Add(
                            reader["hub_name"].ToString()
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
                new Feed(mainForm)
            );
        }

        // =========================
        // POST UPDATE
        // =========================

        private void btnPost_Click(object sender, EventArgs e)
        {
            if (cmbHubs.SelectedIndex == -1)
            {
                MessageBox.Show(
                    "Please select a hub."
                );

                return;
            }

            if (txtUpdate.Text.Trim() == "")
            {
                MessageBox.Show(
                    "Please write an update."
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
                        "INSERT INTO updates " +
                        "(user_id, hub_name, content) " +
                        "VALUES " +
                        "(@userId, @hub, @content)";

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
                        "@content",
                        txtUpdate.Text
                    );

                    cmd.ExecuteNonQuery();

                    MessageBox.Show(
                        "Update posted!"
                    );

                    mainForm.LoadForm(
                        new Feed(mainForm)
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
    }
}