namespace reHUB
{
    partial class Dashboard
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
            this.label1 = new System.Windows.Forms.Label();
            this.btnExplore = new System.Windows.Forms.Button();
            this.lblDate = new System.Windows.Forms.Label();
            this.lblGreeting = new System.Windows.Forms.Label();
            this.panelHeader = new System.Windows.Forms.Panel();
            this.panelCheckIn = new System.Windows.Forms.Panel();
            this.btnCheckIn = new System.Windows.Forms.Button();
            this.panelCard1 = new System.Windows.Forms.Panel();
            this.panelIcon1 = new System.Windows.Forms.Panel();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.panelCard2 = new System.Windows.Forms.Panel();
            this.panelIcon2 = new System.Windows.Forms.Panel();
            this.pictureBox2 = new System.Windows.Forms.PictureBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.flowGoals = new System.Windows.Forms.FlowLayoutPanel();
            this.label2 = new System.Windows.Forms.Label();
            this.panelCard3 = new System.Windows.Forms.Panel();
            this.panelIcon3 = new System.Windows.Forms.Panel();
            this.pictureBox3 = new System.Windows.Forms.PictureBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.lblShowAll = new System.Windows.Forms.Label();
            this.panelHeader.SuspendLayout();
            this.panelCheckIn.SuspendLayout();
            this.panelCard1.SuspendLayout();
            this.panelIcon1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.panelCard2.SuspendLayout();
            this.panelIcon2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).BeginInit();
            this.panelCard3.SuspendLayout();
            this.panelIcon3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(13, 480);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(154, 24);
            this.label1.TabIndex = 2;
            this.label1.Text = "Supportive Hubs";
            // 
            // btnExplore
            // 
            this.btnExplore.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(113)))), ((int)(((byte)(196)))), ((int)(((byte)(140)))));
            this.btnExplore.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnExplore.ForeColor = System.Drawing.Color.White;
            this.btnExplore.Location = new System.Drawing.Point(13, 863);
            this.btnExplore.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnExplore.Name = "btnExplore";
            this.btnExplore.Size = new System.Drawing.Size(496, 44);
            this.btnExplore.TabIndex = 16;
            this.btnExplore.Text = "Explore more hubs";
            this.btnExplore.UseVisualStyleBackColor = false;
            this.btnExplore.Click += new System.EventHandler(this.btnExplore_Click);
            // 
            // lblDate
            // 
            this.lblDate.AutoSize = true;
            this.lblDate.BackColor = System.Drawing.Color.Transparent;
            this.lblDate.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblDate.ForeColor = System.Drawing.SystemColors.Control;
            this.lblDate.Location = new System.Drawing.Point(29, 73);
            this.lblDate.Name = "lblDate";
            this.lblDate.Size = new System.Drawing.Size(150, 23);
            this.lblDate.TabIndex = 1;
            this.lblDate.Text = "Monday, April 27";
            // 
            // lblGreeting
            // 
            this.lblGreeting.AutoSize = true;
            this.lblGreeting.BackColor = System.Drawing.Color.Transparent;
            this.lblGreeting.Font = new System.Drawing.Font("Microsoft YaHei UI", 16.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblGreeting.ForeColor = System.Drawing.SystemColors.Control;
            this.lblGreeting.Location = new System.Drawing.Point(27, 20);
            this.lblGreeting.Name = "lblGreeting";
            this.lblGreeting.Size = new System.Drawing.Size(222, 36);
            this.lblGreeting.TabIndex = 1;
            this.lblGreeting.Text = "Good Morning!";
            // 
            // panelHeader
            // 
            this.panelHeader.Controls.Add(this.lblDate);
            this.panelHeader.Controls.Add(this.lblGreeting);
            this.panelHeader.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelHeader.Location = new System.Drawing.Point(0, 0);
            this.panelHeader.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelHeader.Name = "panelHeader";
            this.panelHeader.Size = new System.Drawing.Size(514, 140);
            this.panelHeader.TabIndex = 17;
            this.panelHeader.Paint += new System.Windows.Forms.PaintEventHandler(this.panelHeader_Paint);
            // 
            // panelCheckIn
            // 
            this.panelCheckIn.Controls.Add(this.btnCheckIn);
            this.panelCheckIn.Location = new System.Drawing.Point(15, 158);
            this.panelCheckIn.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelCheckIn.Name = "panelCheckIn";
            this.panelCheckIn.Size = new System.Drawing.Size(499, 118);
            this.panelCheckIn.TabIndex = 19;
            this.panelCheckIn.Paint += new System.Windows.Forms.PaintEventHandler(this.panelCheckIn_Paint);
            // 
            // btnCheckIn
            // 
            this.btnCheckIn.BackColor = System.Drawing.Color.Transparent;
            this.btnCheckIn.FlatAppearance.BorderSize = 0;
            this.btnCheckIn.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnCheckIn.Font = new System.Drawing.Font("Microsoft YaHei UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnCheckIn.ForeColor = System.Drawing.SystemColors.Control;
            this.btnCheckIn.Image = global::reHUB.Properties.Resources.checkmark;
            this.btnCheckIn.Location = new System.Drawing.Point(0, 0);
            this.btnCheckIn.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnCheckIn.Name = "btnCheckIn";
            this.btnCheckIn.Padding = new System.Windows.Forms.Padding(25, 0, 0, 0);
            this.btnCheckIn.Size = new System.Drawing.Size(496, 118);
            this.btnCheckIn.TabIndex = 18;
            this.btnCheckIn.Text = "Daily Check-in\r\n\r\nHow are you feeling today?";
            this.btnCheckIn.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnCheckIn.TextImageRelation = System.Windows.Forms.TextImageRelation.TextBeforeImage;
            this.btnCheckIn.UseVisualStyleBackColor = false;
            this.btnCheckIn.Click += new System.EventHandler(this.btnCheckIn_Click);
            // 
            // panelCard1
            // 
            this.panelCard1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panelCard1.Controls.Add(this.panelIcon1);
            this.panelCard1.Controls.Add(this.label4);
            this.panelCard1.Controls.Add(this.label5);
            this.panelCard1.Cursor = System.Windows.Forms.Cursors.Hand;
            this.panelCard1.Location = new System.Drawing.Point(15, 519);
            this.panelCard1.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panelCard1.Name = "panelCard1";
            this.panelCard1.Size = new System.Drawing.Size(495, 107);
            this.panelCard1.TabIndex = 20;
            this.panelCard1.Click += new System.EventHandler(this.panelCard1_Click);
            // 
            // panelIcon1
            // 
            this.panelIcon1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(195)))), ((int)(((byte)(255)))), ((int)(((byte)(215)))));
            this.panelIcon1.Controls.Add(this.pictureBox1);
            this.panelIcon1.Location = new System.Drawing.Point(16, 14);
            this.panelIcon1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelIcon1.Name = "panelIcon1";
            this.panelIcon1.Padding = new System.Windows.Forms.Padding(5, 5, 5, 5);
            this.panelIcon1.Size = new System.Drawing.Size(76, 76);
            this.panelIcon1.TabIndex = 20;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBox1.Image = global::reHUB.Properties.Resources.riders;
            this.pictureBox1.Location = new System.Drawing.Point(5, 5);
            this.pictureBox1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(66, 66);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.BackColor = System.Drawing.Color.Transparent;
            this.label4.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label4.Image = global::reHUB.Properties.Resources.persons2;
            this.label4.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.label4.Location = new System.Drawing.Point(117, 54);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(57, 24);
            this.label4.TabIndex = 1;
            this.label4.Text = "     53";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.BackColor = System.Drawing.Color.Transparent;
            this.label5.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label5.Location = new System.Drawing.Point(115, 22);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(160, 27);
            this.label5.TabIndex = 1;
            this.label5.Text = "Morning Riders";
            // 
            // panelCard2
            // 
            this.panelCard2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panelCard2.Controls.Add(this.panelIcon2);
            this.panelCard2.Controls.Add(this.label6);
            this.panelCard2.Controls.Add(this.label7);
            this.panelCard2.Cursor = System.Windows.Forms.Cursors.Hand;
            this.panelCard2.Location = new System.Drawing.Point(15, 634);
            this.panelCard2.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panelCard2.Name = "panelCard2";
            this.panelCard2.Size = new System.Drawing.Size(495, 107);
            this.panelCard2.TabIndex = 21;
            this.panelCard2.Click += new System.EventHandler(this.panelCard2_Click);
            // 
            // panelIcon2
            // 
            this.panelIcon2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(195)))), ((int)(((byte)(255)))), ((int)(((byte)(215)))));
            this.panelIcon2.Controls.Add(this.pictureBox2);
            this.panelIcon2.Location = new System.Drawing.Point(16, 14);
            this.panelIcon2.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelIcon2.Name = "panelIcon2";
            this.panelIcon2.Padding = new System.Windows.Forms.Padding(5, 5, 5, 5);
            this.panelIcon2.Size = new System.Drawing.Size(76, 76);
            this.panelIcon2.TabIndex = 20;
            // 
            // pictureBox2
            // 
            this.pictureBox2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBox2.Image = global::reHUB.Properties.Resources.gaming;
            this.pictureBox2.Location = new System.Drawing.Point(5, 5);
            this.pictureBox2.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.pictureBox2.Name = "pictureBox2";
            this.pictureBox2.Size = new System.Drawing.Size(66, 66);
            this.pictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox2.TabIndex = 0;
            this.pictureBox2.TabStop = false;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.BackColor = System.Drawing.Color.Transparent;
            this.label6.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label6.Image = global::reHUB.Properties.Resources.persons2;
            this.label6.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.label6.Location = new System.Drawing.Point(117, 54);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(57, 24);
            this.label6.TabIndex = 1;
            this.label6.Text = "     96";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.BackColor = System.Drawing.Color.Transparent;
            this.label7.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label7.Location = new System.Drawing.Point(115, 22);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(151, 27);
            this.label7.TabIndex = 1;
            this.label7.Text = "Couch Gamers";
            // 
            // flowGoals
            // 
            this.flowGoals.FlowDirection = System.Windows.Forms.FlowDirection.TopDown;
            this.flowGoals.Location = new System.Drawing.Point(15, 327);
            this.flowGoals.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.flowGoals.Name = "flowGoals";
            this.flowGoals.Size = new System.Drawing.Size(496, 132);
            this.flowGoals.TabIndex = 23;
            this.flowGoals.WrapContents = false;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(13, 290);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(117, 24);
            this.label2.TabIndex = 2;
            this.label2.Text = "Goal Tracker";
            // 
            // panelCard3
            // 
            this.panelCard3.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panelCard3.Controls.Add(this.panelIcon3);
            this.panelCard3.Controls.Add(this.label3);
            this.panelCard3.Controls.Add(this.label8);
            this.panelCard3.Cursor = System.Windows.Forms.Cursors.Hand;
            this.panelCard3.Location = new System.Drawing.Point(15, 750);
            this.panelCard3.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panelCard3.Name = "panelCard3";
            this.panelCard3.Size = new System.Drawing.Size(495, 107);
            this.panelCard3.TabIndex = 24;
            this.panelCard3.Click += new System.EventHandler(this.panelCard3_Click);
            // 
            // panelIcon3
            // 
            this.panelIcon3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(195)))), ((int)(((byte)(255)))), ((int)(((byte)(215)))));
            this.panelIcon3.Controls.Add(this.pictureBox3);
            this.panelIcon3.Location = new System.Drawing.Point(16, 14);
            this.panelIcon3.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelIcon3.Name = "panelIcon3";
            this.panelIcon3.Padding = new System.Windows.Forms.Padding(5, 5, 5, 5);
            this.panelIcon3.Size = new System.Drawing.Size(76, 76);
            this.panelIcon3.TabIndex = 20;
            // 
            // pictureBox3
            // 
            this.pictureBox3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBox3.Image = global::reHUB.Properties.Resources.hiking;
            this.pictureBox3.Location = new System.Drawing.Point(5, 5);
            this.pictureBox3.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.pictureBox3.Name = "pictureBox3";
            this.pictureBox3.Size = new System.Drawing.Size(66, 66);
            this.pictureBox3.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox3.TabIndex = 0;
            this.pictureBox3.TabStop = false;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.BackColor = System.Drawing.Color.Transparent;
            this.label3.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label3.Image = global::reHUB.Properties.Resources.persons2;
            this.label3.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.label3.Location = new System.Drawing.Point(117, 54);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(57, 24);
            this.label3.TabIndex = 1;
            this.label3.Text = "     32";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.BackColor = System.Drawing.Color.Transparent;
            this.label8.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label8.Location = new System.Drawing.Point(115, 22);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(131, 27);
            this.label8.TabIndex = 1;
            this.label8.Text = "Trail Seekers";
            // 
            // lblShowAll
            // 
            this.lblShowAll.AutoSize = true;
            this.lblShowAll.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblShowAll.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(74)))), ((int)(((byte)(157)))), ((int)(((byte)(127)))));
            this.lblShowAll.Location = new System.Drawing.Point(415, 290);
            this.lblShowAll.Name = "lblShowAll";
            this.lblShowAll.Size = new System.Drawing.Size(84, 24);
            this.lblShowAll.TabIndex = 2;
            this.lblShowAll.Text = "Show All";
            this.lblShowAll.Click += new System.EventHandler(this.lblShowAll_Click);
            // 
            // Dashboard
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.ClientSize = new System.Drawing.Size(528, 846);
            this.Controls.Add(this.panelCard3);
            this.Controls.Add(this.lblShowAll);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.flowGoals);
            this.Controls.Add(this.panelCard2);
            this.Controls.Add(this.panelCard1);
            this.Controls.Add(this.panelCheckIn);
            this.Controls.Add(this.panelHeader);
            this.Controls.Add(this.btnExplore);
            this.Controls.Add(this.label1);
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "Dashboard";
            this.ShowIcon = false;
            this.Text = "Dashboard";
            this.Load += new System.EventHandler(this.Dashboard_Load);
            this.panelHeader.ResumeLayout(false);
            this.panelHeader.PerformLayout();
            this.panelCheckIn.ResumeLayout(false);
            this.panelCard1.ResumeLayout(false);
            this.panelCard1.PerformLayout();
            this.panelIcon1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.panelCard2.ResumeLayout(false);
            this.panelCard2.PerformLayout();
            this.panelIcon2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).EndInit();
            this.panelCard3.ResumeLayout(false);
            this.panelCard3.PerformLayout();
            this.panelIcon3.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnExplore;
        private System.Windows.Forms.Label lblDate;
        private System.Windows.Forms.Label lblGreeting;
        private System.Windows.Forms.Panel panelHeader;
        private System.Windows.Forms.Button btnCheckIn;
        private System.Windows.Forms.Panel panelCheckIn;
        private System.Windows.Forms.Panel panelCard1;
        private System.Windows.Forms.Panel panelIcon1;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Panel panelCard2;
        private System.Windows.Forms.Panel panelIcon2;
        private System.Windows.Forms.PictureBox pictureBox2;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.FlowLayoutPanel flowGoals;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Panel panelCard3;
        private System.Windows.Forms.Panel panelIcon3;
        private System.Windows.Forms.PictureBox pictureBox3;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label lblShowAll;
    }
}