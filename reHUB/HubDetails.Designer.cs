namespace reHUB
{
    partial class HubDetails
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
            this.btnJoinHub = new System.Windows.Forms.Button();
            this.lblHubName = new System.Windows.Forms.Label();
            this.panelHeader = new System.Windows.Forms.Panel();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.lblMembers = new System.Windows.Forms.Label();
            this.panelIcon1 = new System.Windows.Forms.Panel();
            this.pictureBoxIcon = new System.Windows.Forms.PictureBox();
            this.btnBack = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.lblAbout = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.lblLocation = new System.Windows.Forms.Label();
            this.lblDate = new System.Windows.Forms.Label();
            this.lblTitle = new System.Windows.Forms.Label();
            this.panelHeader.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.panelIcon1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxIcon)).BeginInit();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnJoinHub
            // 
            this.btnJoinHub.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(113)))), ((int)(((byte)(196)))), ((int)(((byte)(140)))));
            this.btnJoinHub.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnJoinHub.ForeColor = System.Drawing.Color.White;
            this.btnJoinHub.Location = new System.Drawing.Point(15, 879);
            this.btnJoinHub.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnJoinHub.Name = "btnJoinHub";
            this.btnJoinHub.Size = new System.Drawing.Size(499, 44);
            this.btnJoinHub.TabIndex = 25;
            this.btnJoinHub.Text = "Join Hub";
            this.btnJoinHub.UseVisualStyleBackColor = false;
            this.btnJoinHub.Click += new System.EventHandler(this.btnJoinHub_Click);
            // 
            // lblHubName
            // 
            this.lblHubName.AutoSize = true;
            this.lblHubName.BackColor = System.Drawing.Color.Transparent;
            this.lblHubName.Font = new System.Drawing.Font("Microsoft YaHei UI", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblHubName.ForeColor = System.Drawing.SystemColors.Control;
            this.lblHubName.Location = new System.Drawing.Point(149, 71);
            this.lblHubName.Name = "lblHubName";
            this.lblHubName.Size = new System.Drawing.Size(199, 32);
            this.lblHubName.TabIndex = 1;
            this.lblHubName.Text = "Morning Riders";
            // 
            // panelHeader
            // 
            this.panelHeader.Controls.Add(this.pictureBox1);
            this.panelHeader.Controls.Add(this.lblMembers);
            this.panelHeader.Controls.Add(this.panelIcon1);
            this.panelHeader.Controls.Add(this.lblHubName);
            this.panelHeader.Controls.Add(this.btnBack);
            this.panelHeader.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelHeader.Location = new System.Drawing.Point(0, 0);
            this.panelHeader.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelHeader.Name = "panelHeader";
            this.panelHeader.Size = new System.Drawing.Size(528, 167);
            this.panelHeader.TabIndex = 24;
            this.panelHeader.Paint += new System.Windows.Forms.PaintEventHandler(this.panelHeader_Paint);
            // 
            // pictureBox1
            // 
            this.pictureBox1.BackColor = System.Drawing.Color.Transparent;
            this.pictureBox1.Image = global::reHUB.Properties.Resources.icons8_persons_18;
            this.pictureBox1.Location = new System.Drawing.Point(156, 108);
            this.pictureBox1.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(27, 30);
            this.pictureBox1.TabIndex = 23;
            this.pictureBox1.TabStop = false;
            this.pictureBox1.Click += new System.EventHandler(this.pictureBox1_Click);
            // 
            // lblMembers
            // 
            this.lblMembers.AutoSize = true;
            this.lblMembers.BackColor = System.Drawing.Color.Transparent;
            this.lblMembers.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblMembers.ForeColor = System.Drawing.SystemColors.Control;
            this.lblMembers.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblMembers.Location = new System.Drawing.Point(189, 110);
            this.lblMembers.Name = "lblMembers";
            this.lblMembers.Size = new System.Drawing.Size(32, 24);
            this.lblMembers.TabIndex = 22;
            this.lblMembers.Text = "96";
            // 
            // panelIcon1
            // 
            this.panelIcon1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(195)))), ((int)(((byte)(255)))), ((int)(((byte)(215)))));
            this.panelIcon1.Controls.Add(this.pictureBoxIcon);
            this.panelIcon1.Location = new System.Drawing.Point(41, 66);
            this.panelIcon1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelIcon1.Name = "panelIcon1";
            this.panelIcon1.Padding = new System.Windows.Forms.Padding(5, 5, 5, 5);
            this.panelIcon1.Size = new System.Drawing.Size(83, 76);
            this.panelIcon1.TabIndex = 21;
            // 
            // pictureBoxIcon
            // 
            this.pictureBoxIcon.Image = global::reHUB.Properties.Resources.riders;
            this.pictureBoxIcon.Location = new System.Drawing.Point(5, 5);
            this.pictureBoxIcon.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.pictureBoxIcon.Name = "pictureBoxIcon";
            this.pictureBoxIcon.Size = new System.Drawing.Size(72, 66);
            this.pictureBoxIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBoxIcon.TabIndex = 0;
            this.pictureBoxIcon.TabStop = false;
            // 
            // btnBack
            // 
            this.btnBack.BackColor = System.Drawing.Color.Transparent;
            this.btnBack.FlatAppearance.BorderSize = 0;
            this.btnBack.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnBack.Image = global::reHUB.Properties.Resources.back;
            this.btnBack.Location = new System.Drawing.Point(12, 16);
            this.btnBack.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnBack.Name = "btnBack";
            this.btnBack.Size = new System.Drawing.Size(48, 46);
            this.btnBack.TabIndex = 0;
            this.btnBack.UseVisualStyleBackColor = false;
            this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.BackColor = System.Drawing.Color.Transparent;
            this.label1.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label1.Location = new System.Drawing.Point(9, 190);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(71, 27);
            this.label1.TabIndex = 1;
            this.label1.Text = "About";
            // 
            // lblAbout
            // 
            this.lblAbout.BackColor = System.Drawing.Color.Transparent;
            this.lblAbout.Font = new System.Drawing.Font("Microsoft YaHei UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblAbout.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblAbout.Location = new System.Drawing.Point(9, 223);
            this.lblAbout.Name = "lblAbout";
            this.lblAbout.Size = new System.Drawing.Size(499, 101);
            this.lblAbout.TabIndex = 1;
            this.lblAbout.Text = "Join us for peaceful morning rides through scenic routes. A supportive group focu" +
    "sed on mindfulness and the open road. All experience levels welcome.";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.BackColor = System.Drawing.Color.Transparent;
            this.label3.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label3.Location = new System.Drawing.Point(7, 346);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(202, 27);
            this.label3.TabIndex = 1;
            this.label3.Text = "Upcoming Activities";
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.lblLocation);
            this.panel1.Controls.Add(this.lblDate);
            this.panel1.Controls.Add(this.lblTitle);
            this.panel1.Location = new System.Drawing.Point(12, 388);
            this.panel1.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(502, 123);
            this.panel1.TabIndex = 0;
            // 
            // lblLocation
            // 
            this.lblLocation.AutoSize = true;
            this.lblLocation.BackColor = System.Drawing.Color.Transparent;
            this.lblLocation.Font = new System.Drawing.Font("Microsoft YaHei UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblLocation.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblLocation.Location = new System.Drawing.Point(12, 78);
            this.lblLocation.Name = "lblLocation";
            this.lblLocation.Size = new System.Drawing.Size(131, 23);
            this.lblLocation.TabIndex = 1;
            this.lblLocation.Text = "Pier 39 Parking";
            // 
            // lblDate
            // 
            this.lblDate.AutoSize = true;
            this.lblDate.BackColor = System.Drawing.Color.Transparent;
            this.lblDate.Font = new System.Drawing.Font("Microsoft YaHei UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblDate.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblDate.Location = new System.Drawing.Point(12, 49);
            this.lblDate.Name = "lblDate";
            this.lblDate.Size = new System.Drawing.Size(141, 23);
            this.lblDate.TabIndex = 1;
            this.lblDate.Text = "Apr 26, 7:00 AM";
            // 
            // lblTitle
            // 
            this.lblTitle.AutoSize = true;
            this.lblTitle.BackColor = System.Drawing.Color.Transparent;
            this.lblTitle.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTitle.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.lblTitle.Location = new System.Drawing.Point(9, 12);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.Size = new System.Drawing.Size(206, 27);
            this.lblTitle.TabIndex = 1;
            this.lblTitle.Text = "Sunday Sunrise Ride";
            // 
            // HubDetails
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(528, 1040);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.btnJoinHub);
            this.Controls.Add(this.panelHeader);
            this.Controls.Add(this.lblAbout);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label1);
            this.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.Name = "HubDetails";
            this.Text = "HubDetails";
            this.panelHeader.ResumeLayout(false);
            this.panelHeader.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.panelIcon1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxIcon)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnJoinHub;
        private System.Windows.Forms.Label lblHubName;
        private System.Windows.Forms.Button btnBack;
        private System.Windows.Forms.Panel panelHeader;
        private System.Windows.Forms.Panel panelIcon1;
        private System.Windows.Forms.PictureBox pictureBoxIcon;
        private System.Windows.Forms.Label lblMembers;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblAbout;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label lblLocation;
        private System.Windows.Forms.Label lblDate;
        private System.Windows.Forms.Label lblTitle;
        private System.Windows.Forms.PictureBox pictureBox1;
    }
}