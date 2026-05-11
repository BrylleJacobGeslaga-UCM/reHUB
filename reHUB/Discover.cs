using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace reHUB
{
    public partial class Discover : Form
    {
        private MainForm mainForm;
        public Discover(MainForm form)
        {
            InitializeComponent();
            mainForm = form;
        }

        private void panelHeader_Paint(object sender, PaintEventArgs e)
        {
            LinearGradientBrush brush = new LinearGradientBrush(
            panelHeader.ClientRectangle,
            Color.FromArgb(113, 196, 140), 
            Color.FromArgb(54, 94, 67),   
            LinearGradientMode.Vertical 
            );

            e.Graphics.FillRectangle(brush, panelHeader.ClientRectangle);
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(new Dashboard(mainForm));
        }

        private void panelCard1_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Morning Riders",
                    53,
                    pictureBox1.Image,
                    "Join us for peaceful morning rides through scenic routes. A supportive  group focused on mindfulness and the open road. All experience levels  welcome.",
                    "Sunday Sunrise Ride",
                    "Apr 26, 7:00 AM",
                    "Pier 39 Parking"
                )
            );
        }

        private void panelCard2_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Couch Gamers",
                    96,
                    pictureBox2.Image,
                    "Casual gaming sessions in a judgment-free space. Play together, support  each other, and have fun. No competitive pressure, just good vibes.",
                    "Late Night Ranked",
                    "Apr 25, 9:00 PM",
                    "Online"
                )
            );
        }

        private void panelCard3_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Trail Seekers",
                    32,
                    pictureBox3.Image,
                    "Explore nature trails and build connections. Every hike is a step  forward on your journey. We focus on the experience, not the  destination.",
                    "Forest Hike",
                    "Apr 26, 6:00 AM",
                    "Green Trail"
                )
            );
        }

        private void panelCard4_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Football Warriors",
                    67,
                    pictureBox4.Image,
                    "Friendly matches and training for all skill levels. Stay active, improve your game, and enjoy team play. Competitive or casual, you choose.",
                    "Friendly Match",
                    "Apr 26, 4:00 PM",
                    "City Field"
                )
            );
        }

        private void panelCard5_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Creative Circle",
                    104,
                    pictureBox5.Image,
                    "A relaxed space for artists and creators. Share ideas, experiment freely, and inspire each other. No pressure, just creativity flowing.",
                    "Art Jam",
                    "Apr 26, 2:00 PM",
                    "Studio Room"
                )
            );
        }

        private void panelCard6_Click(object sender, EventArgs e)
        {
            mainForm.LoadForm(
                new HubDetails(
                    isGuest: UserSession.IsGuest,
                    mainForm,
                    "Mountain Climbers",
                    97,
                    pictureBox6.Image,
                    "Take on new heights with a supportive group. Build strength, confidence, and trust along the way. Challenge yourself, safely and steadily.",
                    "Summit Climb",
                    "Apr 26, 5:00 AM",
                    "Base Camp"
                )
            );
        }

        private void panelCard3_Paint(object sender, PaintEventArgs e)
        {

        }
    }
}
