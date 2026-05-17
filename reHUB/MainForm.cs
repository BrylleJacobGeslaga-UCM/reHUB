using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing.Drawing2D;

namespace reHUB
{
    public partial class MainForm : Form
    {
        Boolean Guest;
        public MainForm(Boolean isGuest)
        {
            if (isGuest)
            {
                Guest = true;
            }
            else
            {
                Guest = false;
            }
            InitializeComponent();
            LoadForm(new Dashboard(this, true));
            this.StartPosition = FormStartPosition.CenterScreen;
        }
        public MainForm()
        {
            Guest = UserSession.IsGuest;
            InitializeComponent();
            if (Guest)
            {
                LoadForm(new Dashboard(this, true));
            }
            else
            {
                LoadForm(new Dashboard(this));
            }
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        public void LoadForm(Form form)
        {
            panelContainer.Controls.Clear();

            form.TopLevel = false;
            form.FormBorderStyle = FormBorderStyle.None;
            form.Dock = DockStyle.Fill;

            panelContainer.Controls.Add(form);
            form.Show();
        }

        private void btnDashboard_Click(object sender, EventArgs e)
        {
            if (!Guest)
            {
                LoadForm(new Dashboard(this));
            }
            else
            {
                LoadForm(new Dashboard(this, true));
            }
        }

        private void panelContainer_Paint(object sender, PaintEventArgs e)
        {
        }

        private void btnFeed_Click(object sender, EventArgs e)
        {
            if (!Guest)
            {
                LoadForm(new Feed(this));
            }
            else
            {
                LoadForm(new PleaseSignIn(this));
            }
        }

        private void btnChat_Click(object sender, EventArgs e)
        {
            if (!Guest)
            {
                LoadForm(new Chat());
            }
            else
            {
                LoadForm(new PleaseSignIn(this));
            }
        }

        private void btnProfile_Click(object sender, EventArgs e)
        {
            if (!Guest)
            {
                LoadForm(new Profile(this));
            }
            else
            {
                LoadForm(new PleaseSignIn(this));
            }
        }
    }
}
