using MySql.Data.MySqlClient;
using System;
using System.Drawing;
using System.Windows.Forms;

namespace reHUB
{
    public partial class SignUp : Form
    {
        string connectionString = "server=localhost;user id=root;password=;database=rehub;";

        public SignUp()
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void btnSignUp_Click(object sender, EventArgs e)
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

                    // Check if email already exists
                    string checkQuery = "SELECT COUNT(*) FROM users WHERE email=@Email";
                    MySqlCommand checkCmd = new MySqlCommand(checkQuery, con);
                    checkCmd.Parameters.AddWithValue("@Email", txtEmail.Text);

                    int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (exists > 0)
                    {
                        MessageBox.Show("Email already exists!");
                        return;
                    }

                    // Insert user
                    string query = "INSERT INTO users (email, password) VALUES (@Email, @Password)";
                    MySqlCommand cmd = new MySqlCommand(query, con);

                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                    cmd.ExecuteNonQuery();

                    MessageBox.Show("Account created successfully!");

                    WelcomeForm welcome = new WelcomeForm();
                    welcome.Show();
                    this.Hide();
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }
        }

        private void lblSignIn_Click(object sender, EventArgs e)
        {
            SignIn login = new SignIn();
            login.Show();
            this.Hide();
        }
    }
}