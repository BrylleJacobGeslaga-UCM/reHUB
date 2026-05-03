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
        public MainForm()
        {
            InitializeComponent();
            LoadForm(new Dashboard(this));
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
            LoadForm(new Dashboard(this));
        }

        private void panelContainer_Paint(object sender, PaintEventArgs e)
        {
        }

        private void btnFeed_Click(object sender, EventArgs e)
        {
            LoadForm(new Feed(this));
        }

        private void btnChat_Click(object sender, EventArgs e)
        {
            LoadForm(new Chat());
        }

        private void btnProfile_Click(object sender, EventArgs e)
        {
            LoadForm(new Profile());
        }
    }
}
