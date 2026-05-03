using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Windows.Forms;

namespace reHUB
{
    public partial class SignIn : Form
    {
        string connectionString = "server=localhost;user id=root;password=;database=rehub;";

        public SignIn()
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

                    string query = "SELECT COUNT(*) FROM users WHERE email=@Email AND password=@Password";
                    MySqlCommand cmd = new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                    int count = Convert.ToInt32(cmd.ExecuteScalar());

                    if (count > 0)
                    {
                        MessageBox.Show("Login successful!");

                        WelcomeForm welcome = new WelcomeForm();
                        welcome.Show();
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
            WelcomeForm welcome = new WelcomeForm();
            welcome.Show();
            this.Hide();
        }

        private void lblSignUp_Click(object sender, EventArgs e)
        {
            SignUp reg = new SignUp();
            reg.Show();
            this.Hide();
        }
    }
}