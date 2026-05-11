using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class SignIn : Form
    {
        string connectionString = "server=localhost;user id=root;password=;database=rehub;";

        public SignIn(MainForm form)
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void btnSignIn_Click(object sender, EventArgs e)
        {
            if (txtEmail.Text == "" || txtPassword.Text == "")
            {
                MessageBox.Show("Please fill all fields");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    string query = "SELECT * FROM users WHERE email=@Email AND password=@Password";

                    MySqlCommand cmd = new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                    MySqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // SAVE USER ID
                        UserSession.UserID = Convert.ToInt32(reader["id"]);

                        UserSession.Username = reader["username"].ToString();

                        MessageBox.Show("Login successful!");

                        MainForm main = new MainForm();

                        main.Show();

                        this.Hide();
                    }
                    else
                    {
                        MessageBox.Show("Invalid email or password");
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }
        }

        private void btnGuest_Click(object sender, EventArgs e)
        {
            UserSession.IsGuest = true;

            WelcomeForm welcome = new WelcomeForm(true);
            welcome.Show();
            this.Hide();
        }

        private void lblSignUp_Click(object sender, EventArgs e)
        {
            SignUp reg = new SignUp();
            reg.Show();
            this.Hide();
        }

        private void SignIn_Load(object sender, EventArgs e)
        {
        }
    }
}