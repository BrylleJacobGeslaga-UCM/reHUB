using System;
using System.Drawing;
using System.Windows.Forms;

namespace reHUB
{
    public partial class WelcomeForm : Form
    {
        public WelcomeForm()
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void btnGetStarted_Click(object sender, EventArgs e)
        {
            Interest interest = new Interest();
            interest.Show();
            this.Hide();

        }
    }
}