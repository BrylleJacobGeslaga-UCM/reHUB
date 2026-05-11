namespace reHUB
{
    partial class Checkin
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
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.panelHeader = new System.Windows.Forms.Panel();
            this.label1 = new System.Windows.Forms.Label();
            this.panelGreat = new System.Windows.Forms.Panel();
            this.lblGreat = new System.Windows.Forms.Label();
            this.panelOkay = new System.Windows.Forms.Panel();
            this.lblOkay = new System.Windows.Forms.Label();
            this.panelStruggling = new System.Windows.Forms.Panel();
            this.lblStruggling = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.txtJournal = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.btnCheckIn = new System.Windows.Forms.Button();
            this.pictureBoxStruggling = new System.Windows.Forms.PictureBox();
            this.pictureBoxOkay = new System.Windows.Forms.PictureBox();
            this.pictureBoxGreat = new System.Windows.Forms.PictureBox();
            this.btnBack = new System.Windows.Forms.Button();
            this.panelHeader.SuspendLayout();
            this.panelGreat.SuspendLayout();
            this.panelOkay.SuspendLayout();
            this.panelStruggling.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxStruggling)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxOkay)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxGreat)).BeginInit();
            this.SuspendLayout();
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.BackColor = System.Drawing.Color.Transparent;
            this.label2.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.SystemColors.Control;
            this.label2.Location = new System.Drawing.Point(29, 73);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(233, 23);
            this.label2.TabIndex = 1;
            this.label2.Text = "How are you feeling today?";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.BackColor = System.Drawing.Color.Transparent;
            this.label3.Font = new System.Drawing.Font("Microsoft YaHei UI", 16.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.SystemColors.Control;
            this.label3.Location = new System.Drawing.Point(67, 22);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(205, 36);
            this.label3.TabIndex = 1;
            this.label3.Text = "Daily Check-in";
            // 
            // panelHeader
            // 
            this.panelHeader.Controls.Add(this.label2);
            this.panelHeader.Controls.Add(this.label3);
            this.panelHeader.Controls.Add(this.btnBack);
            this.panelHeader.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelHeader.Location = new System.Drawing.Point(0, 0);
            this.panelHeader.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelHeader.Name = "panelHeader";
            this.panelHeader.Size = new System.Drawing.Size(528, 140);
            this.panelHeader.TabIndex = 19;
            this.panelHeader.Paint += new System.Windows.Forms.PaintEventHandler(this.panelHeader_Paint);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.BackColor = System.Drawing.Color.Transparent;
            this.label1.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label1.Location = new System.Drawing.Point(15, 154);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(182, 27);
            this.label1.TabIndex = 20;
            this.label1.Text = "Select your mood";
            // 
            // panelGreat
            // 
            this.panelGreat.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panelGreat.Controls.Add(this.pictureBoxGreat);
            this.panelGreat.Controls.Add(this.lblGreat);
            this.panelGreat.Location = new System.Drawing.Point(15, 194);
            this.panelGreat.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelGreat.Name = "panelGreat";
            this.panelGreat.Size = new System.Drawing.Size(159, 160);
            this.panelGreat.TabIndex = 21;
            this.panelGreat.MouseHover += new System.EventHandler(this.panelGreat_MouseHover);
            // 
            // lblGreat
            // 
            this.lblGreat.AutoSize = true;
            this.lblGreat.BackColor = System.Drawing.Color.Transparent;
            this.lblGreat.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblGreat.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.lblGreat.Location = new System.Drawing.Point(48, 116);
            this.lblGreat.Name = "lblGreat";
            this.lblGreat.Size = new System.Drawing.Size(64, 27);
            this.lblGreat.TabIndex = 20;
            this.lblGreat.Text = "Great";
            // 
            // panelOkay
            // 
            this.panelOkay.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panelOkay.Controls.Add(this.pictureBoxOkay);
            this.panelOkay.Controls.Add(this.lblOkay);
            this.panelOkay.Location = new System.Drawing.Point(184, 194);
            this.panelOkay.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelOkay.Name = "panelOkay";
            this.panelOkay.Size = new System.Drawing.Size(159, 160);
            this.panelOkay.TabIndex = 21;
            // 
            // lblOkay
            // 
            this.lblOkay.AutoSize = true;
            this.lblOkay.BackColor = System.Drawing.Color.Transparent;
            this.lblOkay.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblOkay.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.lblOkay.Location = new System.Drawing.Point(51, 116);
            this.lblOkay.Name = "lblOkay";
            this.lblOkay.Size = new System.Drawing.Size(61, 27);
            this.lblOkay.TabIndex = 20;
            this.lblOkay.Text = "Okay";
            // 
            // panelStruggling
            // 
            this.panelStruggling.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panelStruggling.Controls.Add(this.pictureBoxStruggling);
            this.panelStruggling.Controls.Add(this.lblStruggling);
            this.panelStruggling.Location = new System.Drawing.Point(353, 194);
            this.panelStruggling.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panelStruggling.Name = "panelStruggling";
            this.panelStruggling.Size = new System.Drawing.Size(159, 160);
            this.panelStruggling.TabIndex = 21;
            // 
            // lblStruggling
            // 
            this.lblStruggling.AutoSize = true;
            this.lblStruggling.BackColor = System.Drawing.Color.Transparent;
            this.lblStruggling.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblStruggling.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.lblStruggling.Location = new System.Drawing.Point(25, 116);
            this.lblStruggling.Name = "lblStruggling";
            this.lblStruggling.Size = new System.Drawing.Size(112, 27);
            this.lblStruggling.TabIndex = 20;
            this.lblStruggling.Text = "Struggling";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.BackColor = System.Drawing.Color.Transparent;
            this.label7.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label7.Location = new System.Drawing.Point(15, 377);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(324, 27);
            this.label7.TabIndex = 20;
            this.label7.Text = "What\'s on your mind? (Optional)";
            // 
            // txtJournal
            // 
            this.txtJournal.Location = new System.Drawing.Point(15, 418);
            this.txtJournal.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.txtJournal.Multiline = true;
            this.txtJournal.Name = "txtJournal";
            this.txtJournal.Size = new System.Drawing.Size(497, 207);
            this.txtJournal.TabIndex = 22;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.BackColor = System.Drawing.Color.Transparent;
            this.label8.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label8.Location = new System.Drawing.Point(13, 629);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(308, 23);
            this.label8.TabIndex = 20;
            this.label8.Text = "Your thoughts are private and secure";
            // 
            // btnCheckIn
            // 
            this.btnCheckIn.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(113)))), ((int)(((byte)(196)))), ((int)(((byte)(140)))));
            this.btnCheckIn.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnCheckIn.ForeColor = System.Drawing.Color.White;
            this.btnCheckIn.Location = new System.Drawing.Point(15, 879);
            this.btnCheckIn.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnCheckIn.Name = "btnCheckIn";
            this.btnCheckIn.Size = new System.Drawing.Size(499, 44);
            this.btnCheckIn.TabIndex = 23;
            this.btnCheckIn.Text = "Complete Check-in";
            this.btnCheckIn.UseVisualStyleBackColor = false;
            this.btnCheckIn.Click += new System.EventHandler(this.btnCheckIn_Click);
            // 
            // pictureBoxStruggling
            // 
            this.pictureBoxStruggling.Image = global::reHUB.Properties.Resources.sad;
            this.pictureBoxStruggling.Location = new System.Drawing.Point(45, 33);
            this.pictureBoxStruggling.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.pictureBoxStruggling.Name = "pictureBoxStruggling";
            this.pictureBoxStruggling.Size = new System.Drawing.Size(67, 70);
            this.pictureBoxStruggling.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBoxStruggling.TabIndex = 0;
            this.pictureBoxStruggling.TabStop = false;
            // 
            // pictureBoxOkay
            // 
            this.pictureBoxOkay.Image = global::reHUB.Properties.Resources.neutral;
            this.pictureBoxOkay.Location = new System.Drawing.Point(37, 23);
            this.pictureBoxOkay.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.pictureBoxOkay.Name = "pictureBoxOkay";
            this.pictureBoxOkay.Size = new System.Drawing.Size(77, 89);
            this.pictureBoxOkay.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBoxOkay.TabIndex = 0;
            this.pictureBoxOkay.TabStop = false;
            // 
            // pictureBoxGreat
            // 
            this.pictureBoxGreat.Image = global::reHUB.Properties.Resources.icons8_smile_100;
            this.pictureBoxGreat.Location = new System.Drawing.Point(45, 33);
            this.pictureBoxGreat.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.pictureBoxGreat.Name = "pictureBoxGreat";
            this.pictureBoxGreat.Size = new System.Drawing.Size(67, 70);
            this.pictureBoxGreat.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBoxGreat.TabIndex = 0;
            this.pictureBoxGreat.TabStop = false;
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
            // Checkin
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(528, 1040);
            this.Controls.Add(this.btnCheckIn);
            this.Controls.Add(this.txtJournal);
            this.Controls.Add(this.panelStruggling);
            this.Controls.Add(this.panelOkay);
            this.Controls.Add(this.panelGreat);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.panelHeader);
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "Checkin";
            this.Text = "Checkin";
            this.panelHeader.ResumeLayout(false);
            this.panelHeader.PerformLayout();
            this.panelGreat.ResumeLayout(false);
            this.panelGreat.PerformLayout();
            this.panelOkay.ResumeLayout(false);
            this.panelOkay.PerformLayout();
            this.panelStruggling.ResumeLayout(false);
            this.panelStruggling.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxStruggling)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxOkay)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxGreat)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button btnBack;
        private System.Windows.Forms.Panel panelHeader;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Panel panelGreat;
        private System.Windows.Forms.Panel panelOkay;
        private System.Windows.Forms.Panel panelStruggling;
        private System.Windows.Forms.PictureBox pictureBoxGreat;
        private System.Windows.Forms.PictureBox pictureBoxOkay;
        private System.Windows.Forms.PictureBox pictureBoxStruggling;
        private System.Windows.Forms.Label lblGreat;
        private System.Windows.Forms.Label lblOkay;
        private System.Windows.Forms.Label lblStruggling;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txtJournal;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Button btnCheckIn;
    }
}