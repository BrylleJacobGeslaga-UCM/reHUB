using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Windows.Forms;

namespace reHUB
{
    public partial class SignUp : Form
    {
        string connectionString =
            "server=localhost;user id=root;password=;database=rehub;";

        public SignUp()
        {
            InitializeComponent();

            this.StartPosition =
                FormStartPosition.CenterScreen;
        }

        private void btnSignUp_Click(object sender, EventArgs e)
        {
            // =========================
            // CHECK EMPTY FIELDS
            // =========================

            if (
                txtName.Text == "" ||
                txtEmail.Text == "" ||
                txtPassword.Text == ""
            )
            {
                MessageBox.Show(
                    "Please fill all fields"
                );

                return;
            }

            using (MySqlConnection con =
                new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // =========================
                    // CHECK IF EMAIL EXISTS
                    // =========================

                    string checkQuery =
                        "SELECT COUNT(*) FROM users " +
                        "WHERE email=@Email";

                    MySqlCommand checkCmd =
                        new MySqlCommand(checkQuery, con);

                    checkCmd.Parameters.AddWithValue(
                        "@Email",
                        txtEmail.Text
                    );

                    int exists =
                        Convert.ToInt32(
                            checkCmd.ExecuteScalar()
                        );

                    if (exists > 0)
                    {
                        MessageBox.Show(
                            "Email already exists!"
                        );

                        return;
                    }

                    // =========================
                    // INSERT USER
                    // =========================

                    string query =
                        "INSERT INTO users " +
                        "(username, email, password) " +
                        "VALUES " +
                        "(@Username, @Email, @Password)";

                    MySqlCommand cmd =
                        new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue(
                        "@Username",
                        txtName.Text
                    );

                    cmd.Parameters.AddWithValue(
                        "@Email",
                        txtEmail.Text
                    );

                    cmd.Parameters.AddWithValue(
                        "@Password",
                        txtPassword.Text
                    );

                    cmd.ExecuteNonQuery();

                    // =========================
                    // SAVE USER ID
                    // =========================

                    UserSession.UserID =
                        Convert.ToInt32(
                            cmd.LastInsertedId
                        );

                    UserSession.Username = txtName.Text;

                    // =========================
                    // USER IS NOT GUEST
                    // =========================

                    UserSession.IsGuest = false;

                    MessageBox.Show(
                        "Account created successfully!"
                    );

                    // =========================
                    // OPEN WELCOME
                    // =========================

                    WelcomeForm welcome =
                        new WelcomeForm(false);

                    welcome.Show();

                    this.Hide();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(
                        "Error: " + ex.Message
                    );
                }
            }
        }

        private void lblSignIn_Click(object sender, EventArgs e)
        {
            // Attempt to pass the MainForm owner if this SignUp was opened by it.
            // If Owner is not a MainForm this will pass null (safe if SignIn accepts a MainForm or null).
            MainForm parent = this.Owner as MainForm;

            SignIn login = new SignIn(parent);

            login.Show();

            this.Hide();
        }

        private void btnGuest_Click(object sender, EventArgs e)
        {
            // =========================
            // GUEST MODE
            // =========================

            UserSession.IsGuest = true;

            WelcomeForm welcome =
                new WelcomeForm(true);

            welcome.Show();

            this.Hide();
        }
    }
}