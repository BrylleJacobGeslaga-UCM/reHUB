using System;
using System.Drawing;
using System.Windows.Forms;

namespace reHUB
{
    public partial class WelcomeForm : Form
    {
        Boolean Guest;
        public WelcomeForm(Boolean isGuest)
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
            if (isGuest) { Guest = true; }
             else { Guest = false; }
        }

        private void btnGetStarted_Click(object sender, EventArgs e)
        {
            if (Guest)
            {
                MainForm main = new MainForm(true);
                main.Show();
                this.Hide();
            }
            else
            {
                Interest interest = new Interest();
                interest.Show();
                this.Hide();
            }
        }
    }
}