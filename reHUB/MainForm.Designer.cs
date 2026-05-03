namespace reHUB
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.panelNav = new System.Windows.Forms.Panel();
            this.btnProfile = new System.Windows.Forms.Button();
            this.btnDashboard = new System.Windows.Forms.Button();
            this.btnChat = new System.Windows.Forms.Button();
            this.btnFeed = new System.Windows.Forms.Button();
            this.panelContainer = new System.Windows.Forms.Panel();
            this.panelNav.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelNav
            // 
            this.panelNav.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panelNav.Controls.Add(this.btnProfile);
            this.panelNav.Controls.Add(this.btnDashboard);
            this.panelNav.Controls.Add(this.btnChat);
            this.panelNav.Controls.Add(this.btnFeed);
            this.panelNav.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panelNav.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.panelNav.Location = new System.Drawing.Point(0, 763);
            this.panelNav.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.panelNav.Name = "panelNav";
            this.panelNav.Size = new System.Drawing.Size(396, 82);
            this.panelNav.TabIndex = 0;
            // 
            // btnProfile
            // 
            this.btnProfile.AutoSize = true;
            this.btnProfile.FlatAppearance.BorderSize = 0;
            this.btnProfile.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnProfile.Font = new System.Drawing.Font("Microsoft YaHei UI", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnProfile.Image = global::reHUB.Properties.Resources.profile;
            this.btnProfile.Location = new System.Drawing.Point(297, 0);
            this.btnProfile.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.btnProfile.Name = "btnProfile";
            this.btnProfile.Size = new System.Drawing.Size(95, 81);
            this.btnProfile.TabIndex = 3;
            this.btnProfile.Text = "Profile";
            this.btnProfile.TextAlign = System.Drawing.ContentAlignment.BottomCenter;
            this.btnProfile.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.btnProfile.UseVisualStyleBackColor = true;
            this.btnProfile.Click += new System.EventHandler(this.btnProfile_Click);
            // 
            // btnDashboard
            // 
            this.btnDashboard.AutoSize = true;
            this.btnDashboard.FlatAppearance.BorderSize = 0;
            this.btnDashboard.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnDashboard.Font = new System.Drawing.Font("Microsoft YaHei UI", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnDashboard.Image = global::reHUB.Properties.Resources.home2;
            this.btnDashboard.Location = new System.Drawing.Point(0, 0);
            this.btnDashboard.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.btnDashboard.Name = "btnDashboard";
            this.btnDashboard.Size = new System.Drawing.Size(95, 81);
            this.btnDashboard.TabIndex = 3;
            this.btnDashboard.Text = "Home";
            this.btnDashboard.TextAlign = System.Drawing.ContentAlignment.BottomCenter;
            this.btnDashboard.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.btnDashboard.UseVisualStyleBackColor = true;
            this.btnDashboard.Click += new System.EventHandler(this.btnDashboard_Click);
            // 
            // btnChat
            // 
            this.btnChat.AutoSize = true;
            this.btnChat.FlatAppearance.BorderSize = 0;
            this.btnChat.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnChat.Font = new System.Drawing.Font("Microsoft YaHei UI", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnChat.Image = global::reHUB.Properties.Resources.chat;
            this.btnChat.Location = new System.Drawing.Point(198, -1);
            this.btnChat.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.btnChat.Name = "btnChat";
            this.btnChat.Size = new System.Drawing.Size(95, 81);
            this.btnChat.TabIndex = 3;
            this.btnChat.Text = "Chat";
            this.btnChat.TextAlign = System.Drawing.ContentAlignment.BottomCenter;
            this.btnChat.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.btnChat.UseVisualStyleBackColor = true;
            this.btnChat.Click += new System.EventHandler(this.btnChat_Click);
            // 
            // btnFeed
            // 
            this.btnFeed.AutoSize = true;
            this.btnFeed.FlatAppearance.BorderSize = 0;
            this.btnFeed.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnFeed.Font = new System.Drawing.Font("Microsoft YaHei UI", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnFeed.Image = global::reHUB.Properties.Resources.feed;
            this.btnFeed.Location = new System.Drawing.Point(99, 0);
            this.btnFeed.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.btnFeed.Name = "btnFeed";
            this.btnFeed.Size = new System.Drawing.Size(95, 81);
            this.btnFeed.TabIndex = 3;
            this.btnFeed.Text = "Feed";
            this.btnFeed.TextAlign = System.Drawing.ContentAlignment.BottomCenter;
            this.btnFeed.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.btnFeed.UseVisualStyleBackColor = true;
            this.btnFeed.Click += new System.EventHandler(this.btnFeed_Click);
            // 
            // panelContainer
            // 
            this.panelContainer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelContainer.Location = new System.Drawing.Point(0, 0);
            this.panelContainer.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.panelContainer.Name = "panelContainer";
            this.panelContainer.Size = new System.Drawing.Size(396, 763);
            this.panelContainer.TabIndex = 2;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(396, 845);
            this.Controls.Add(this.panelContainer);
            this.Controls.Add(this.panelNav);
            this.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.Name = "MainForm";
            this.ShowIcon = false;
            this.Text = "Main";
            this.panelNav.ResumeLayout(false);
            this.panelNav.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panelNav;
        private System.Windows.Forms.Button btnDashboard;
        private System.Windows.Forms.Button btnFeed;
        private System.Windows.Forms.Button btnProfile;
        private System.Windows.Forms.Button btnChat;
        private System.Windows.Forms.Panel panelContainer;
    }
}