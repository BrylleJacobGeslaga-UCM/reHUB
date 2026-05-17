namespace reHUB
{
    partial class LeaveGroup
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
            this.btnLeaveHub = new System.Windows.Forms.Button();
            this.lblHubName = new System.Windows.Forms.Label();
            this.panelHeader = new System.Windows.Forms.Panel();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.lblMembers = new System.Windows.Forms.Label();
            this.panelIcon1 = new System.Windows.Forms.Panel();
            this.pictureBoxIcon = new System.Windows.Forms.PictureBox();
            this.btnBack = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.lblLocation = new System.Windows.Forms.Label();
            this.lblDate = new System.Windows.Forms.Label();
            this.lblTitle = new System.Windows.Forms.Label();
            this.lblAbout = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.panelHeader.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.panelIcon1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxIcon)).BeginInit();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnLeaveHub
            // 
            this.btnLeaveHub.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.btnLeaveHub.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnLeaveHub.ForeColor = System.Drawing.Color.White;
            this.btnLeaveHub.Location = new System.Drawing.Point(11, 761);
            this.btnLeaveHub.Margin = new System.Windows.Forms.Padding(2);
            this.btnLeaveHub.Name = "btnLeaveHub";
            this.btnLeaveHub.Size = new System.Drawing.Size(374, 36);
            this.btnLeaveHub.TabIndex = 31;
            this.btnLeaveHub.Text = "Leave Hub";
            this.btnLeaveHub.UseVisualStyleBackColor = false;
            this.btnLeaveHub.Click += new System.EventHandler(this.LeaveHub);
            // 
            // lblHubName
            // 
            this.lblHubName.AutoSize = true;
            this.lblHubName.BackColor = System.Drawing.Color.Transparent;
            this.lblHubName.Font = new System.Drawing.Font("Microsoft YaHei UI", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblHubName.ForeColor = System.Drawing.SystemColors.Control;
            this.lblHubName.Location = new System.Drawing.Point(112, 58);
            this.lblHubName.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblHubName.Name = "lblHubName";
            this.lblHubName.Size = new System.Drawing.Size(160, 27);
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
            this.panelHeader.Margin = new System.Windows.Forms.Padding(2);
            this.panelHeader.Name = "panelHeader";
            this.panelHeader.Size = new System.Drawing.Size(396, 136);
            this.panelHeader.TabIndex = 30;
            this.panelHeader.Paint += new System.Windows.Forms.PaintEventHandler(this.panelHeader_Paint);
            // 
            // pictureBox1
            // 
            this.pictureBox1.BackColor = System.Drawing.Color.Transparent;
            this.pictureBox1.Image = global::reHUB.Properties.Resources.icons8_persons_18;
            this.pictureBox1.Location = new System.Drawing.Point(117, 88);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(20, 24);
            this.pictureBox1.TabIndex = 23;
            this.pictureBox1.TabStop = false;
            // 
            // lblMembers
            // 
            this.lblMembers.AutoSize = true;
            this.lblMembers.BackColor = System.Drawing.Color.Transparent;
            this.lblMembers.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblMembers.ForeColor = System.Drawing.SystemColors.Control;
            this.lblMembers.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblMembers.Location = new System.Drawing.Point(142, 89);
            this.lblMembers.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblMembers.Name = "lblMembers";
            this.lblMembers.Size = new System.Drawing.Size(27, 20);
            this.lblMembers.TabIndex = 22;
            this.lblMembers.Text = "96";
            // 
            // panelIcon1
            // 
            this.panelIcon1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(195)))), ((int)(((byte)(255)))), ((int)(((byte)(215)))));
            this.panelIcon1.Controls.Add(this.pictureBoxIcon);
            this.panelIcon1.Location = new System.Drawing.Point(31, 54);
            this.panelIcon1.Margin = new System.Windows.Forms.Padding(2);
            this.panelIcon1.Name = "panelIcon1";
            this.panelIcon1.Padding = new System.Windows.Forms.Padding(4);
            this.panelIcon1.Size = new System.Drawing.Size(62, 62);
            this.panelIcon1.TabIndex = 21;
            // 
            // pictureBoxIcon
            // 
            this.pictureBoxIcon.Image = global::reHUB.Properties.Resources.riders;
            this.pictureBoxIcon.Location = new System.Drawing.Point(4, 4);
            this.pictureBoxIcon.Margin = new System.Windows.Forms.Padding(2);
            this.pictureBoxIcon.Name = "pictureBoxIcon";
            this.pictureBoxIcon.Size = new System.Drawing.Size(54, 54);
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
            this.btnBack.Location = new System.Drawing.Point(9, 13);
            this.btnBack.Margin = new System.Windows.Forms.Padding(2);
            this.btnBack.Name = "btnBack";
            this.btnBack.Size = new System.Drawing.Size(36, 37);
            this.btnBack.TabIndex = 0;
            this.btnBack.UseVisualStyleBackColor = false;
            this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.lblLocation);
            this.panel1.Controls.Add(this.lblDate);
            this.panel1.Controls.Add(this.lblTitle);
            this.panel1.Location = new System.Drawing.Point(9, 362);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(377, 100);
            this.panel1.TabIndex = 26;
            // 
            // lblLocation
            // 
            this.lblLocation.AutoSize = true;
            this.lblLocation.BackColor = System.Drawing.Color.Transparent;
            this.lblLocation.Font = new System.Drawing.Font("Microsoft YaHei UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblLocation.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblLocation.Location = new System.Drawing.Point(9, 63);
            this.lblLocation.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblLocation.Name = "lblLocation";
            this.lblLocation.Size = new System.Drawing.Size(102, 19);
            this.lblLocation.TabIndex = 1;
            this.lblLocation.Text = "Pier 39 Parking";
            // 
            // lblDate
            // 
            this.lblDate.AutoSize = true;
            this.lblDate.BackColor = System.Drawing.Color.Transparent;
            this.lblDate.Font = new System.Drawing.Font("Microsoft YaHei UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblDate.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblDate.Location = new System.Drawing.Point(9, 40);
            this.lblDate.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblDate.Name = "lblDate";
            this.lblDate.Size = new System.Drawing.Size(111, 19);
            this.lblDate.TabIndex = 1;
            this.lblDate.Text = "Apr 26, 7:00 AM";
            // 
            // lblTitle
            // 
            this.lblTitle.AutoSize = true;
            this.lblTitle.BackColor = System.Drawing.Color.Transparent;
            this.lblTitle.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTitle.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.lblTitle.Location = new System.Drawing.Point(7, 10);
            this.lblTitle.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.Size = new System.Drawing.Size(164, 21);
            this.lblTitle.TabIndex = 1;
            this.lblTitle.Text = "Sunday Sunrise Ride";
            // 
            // lblAbout
            // 
            this.lblAbout.BackColor = System.Drawing.Color.Transparent;
            this.lblAbout.Font = new System.Drawing.Font("Microsoft YaHei UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblAbout.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblAbout.Location = new System.Drawing.Point(7, 228);
            this.lblAbout.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblAbout.Name = "lblAbout";
            this.lblAbout.Size = new System.Drawing.Size(374, 82);
            this.lblAbout.TabIndex = 27;
            this.lblAbout.Text = "Join us for peaceful morning rides through scenic routes. A supportive group focu" +
    "sed on mindfulness and the open road. All experience levels welcome.";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.BackColor = System.Drawing.Color.Transparent;
            this.label3.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label3.Location = new System.Drawing.Point(5, 328);
            this.label3.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(161, 21);
            this.label3.TabIndex = 28;
            this.label3.Text = "Upcoming Activities";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.BackColor = System.Drawing.Color.Transparent;
            this.label1.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label1.Location = new System.Drawing.Point(7, 201);
            this.label1.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(57, 21);
            this.label1.TabIndex = 29;
            this.label1.Text = "About";
            // 
            // LeaveGroup
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(396, 845);
            this.Controls.Add(this.btnLeaveHub);
            this.Controls.Add(this.panelHeader);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.lblAbout);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label1);
            this.Name = "LeaveGroup";
            this.Text = "Leave Hub";
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

        private System.Windows.Forms.Button btnLeaveHub;
        private System.Windows.Forms.Label lblHubName;
        private System.Windows.Forms.Panel panelHeader;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Label lblMembers;
        private System.Windows.Forms.Panel panelIcon1;
        private System.Windows.Forms.PictureBox pictureBoxIcon;
        private System.Windows.Forms.Button btnBack;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label lblLocation;
        private System.Windows.Forms.Label lblDate;
        private System.Windows.Forms.Label lblTitle;
        private System.Windows.Forms.Label lblAbout;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label1;
    }
}