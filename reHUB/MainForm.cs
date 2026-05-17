using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace reHUB
{
    public partial class MainForm : Form
    {
        Boolean Guest;

        // =========================
        // CONSTRUCTOR (GUEST)
        // =========================

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

            this.StartPosition =
                FormStartPosition.CenterScreen;

            // =========================
            // DEFAULT ACTIVE NAV
            // =========================

            ActivateButton(btnDashboard);

            LoadForm(
                new Dashboard(this, true)
            );
        }

        // =========================
        // CONSTRUCTOR (NORMAL)
        // =========================

        public MainForm()
        {
            Guest =
                UserSession.IsGuest;

            InitializeComponent();

            this.StartPosition =
                FormStartPosition.CenterScreen;

            // =========================
            // DEFAULT ACTIVE NAV
            // =========================

            ActivateButton(btnDashboard);

            if (Guest)
            {
                LoadForm(
                    new Dashboard(this, true)
                );
            }
            else
            {
                LoadForm(
                    new Dashboard(this)
                );
            }
        }

        // =========================
        // LOAD FORM
        // =========================

        public void LoadForm(Form form)
        {
            panelContainer.Controls.Clear();

            form.TopLevel = false;

            form.FormBorderStyle =
                FormBorderStyle.None;

            form.Dock =
                DockStyle.Fill;

            panelContainer.Controls.Add(form);

            form.Show();
        }

        // =========================
        // RESET NAVIGATION
        // =========================

        private void ResetNavigation()
        {
            // DASHBOARD

            btnDashboard.BackColor =
                Color.White;

            btnDashboard.ForeColor =
                Color.Gray;

            btnDashboard.Image =
                Properties.Resources.home;

            // FEED

            btnFeed.BackColor =
                Color.White;

            btnFeed.ForeColor =
                Color.Gray;

            btnFeed.Image =
                Properties.Resources.feed;

            // CHAT

            btnChat.BackColor =
                Color.White;

            btnChat.ForeColor =
                Color.Gray;

            btnChat.Image =
                Properties.Resources.chat;

            // PROFILE

            btnProfile.BackColor =
                Color.White;

            btnProfile.ForeColor =
                Color.Gray;

            btnProfile.Image =
                Properties.Resources.profile;
        }

        // =========================
        // ACTIVATE BUTTON
        // =========================

        private void ActivateButton(Button btn)
        {
            ResetNavigation();

            btn.BackColor =
                Color.FromArgb(
                    214,
                    232,
                    225
                );

            btn.ForeColor =
                Color.FromArgb(
                    74,
                    157,
                    127
                );

            // =========================
            // ACTIVE ICONS
            // =========================

            if (btn == btnDashboard)
            {
                btnDashboard.Image =
                    Properties.Resources.home2;
            }

            else if (btn == btnFeed)
            {
                btnFeed.Image =
                    Properties.Resources.feed2;
            }

            else if (btn == btnChat)
            {
                btnChat.Image =
                    Properties.Resources.chat2;
            }

            else if (btn == btnProfile)
            {
                btnProfile.Image =
                    Properties.Resources.profile2;
            }
        }

        // =========================
        // DASHBOARD
        // =========================

        private void btnDashboard_Click(
            object sender,
            EventArgs e
        )
        {
            ActivateButton(btnDashboard);

            if (!Guest)
            {
                LoadForm(
                    new Dashboard(this)
                );
            }
            else
            {
                LoadForm(
                    new Dashboard(this, true)
                );
            }
        }

        // =========================
        // FEED
        // =========================

        private void btnFeed_Click(
            object sender,
            EventArgs e
        )
        {
            ActivateButton(btnFeed);

            if (!Guest)
            {
                LoadForm(
                    new Feed(this)
                );
            }
            else
            {
                LoadForm(
                    new PleaseSignIn(this)
                );
            }
        }

        // =========================
        // CHAT
        // =========================

        private void btnChat_Click(
            object sender,
            EventArgs e
        )
        {
            ActivateButton(btnChat);

            if (!Guest)
            {
                LoadForm(
                    new Chat()
                );
            }
            else
            {
                LoadForm(
                    new PleaseSignIn(this)
                );
            }
        }

        // =========================
        // PROFILE
        // =========================

        private void btnProfile_Click(
            object sender,
            EventArgs e
        )
        {
            ActivateButton(btnProfile);

            if (!Guest)
            {
                LoadForm(
                    new Profile(this)
                );
            }
            else
            {
                LoadForm(
                    new PleaseSignIn(this)
                );
            }
        }

        private void panelContainer_Paint(
            object sender,
            PaintEventArgs e
        )
        {

        }
    }
}