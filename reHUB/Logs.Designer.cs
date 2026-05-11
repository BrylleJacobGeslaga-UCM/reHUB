namespace reHUB
{
    partial class Logs
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
            this.panelHeader = new System.Windows.Forms.Panel();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.btnBack = new System.Windows.Forms.Button();
            this.label8 = new System.Windows.Forms.Label();
            this.lblCheckins = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.pictureBox2 = new System.Windows.Forms.PictureBox();
            this.pictureBox3 = new System.Windows.Forms.PictureBox();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.lblStruggling = new System.Windows.Forms.Label();
            this.lblOkay = new System.Windows.Forms.Label();
            this.lblGreat = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.flowLogs = new System.Windows.Forms.FlowLayoutPanel();
            this.panelHeader.SuspendLayout();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
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
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.BackColor = System.Drawing.Color.Transparent;
            this.label2.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.SystemColors.Control;
            this.label2.Location = new System.Drawing.Point(29, 73);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(196, 23);
            this.label2.TabIndex = 1;
            this.label2.Text = "Your journey over time";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.BackColor = System.Drawing.Color.Transparent;
            this.label3.Font = new System.Drawing.Font("Microsoft YaHei UI", 16.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.SystemColors.Control;
            this.label3.Location = new System.Drawing.Point(67, 22);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(236, 36);
            this.label3.TabIndex = 1;
            this.label3.Text = "Check-in History";
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
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.BackColor = System.Drawing.Color.Transparent;
            this.label8.Font = new System.Drawing.Font("Microsoft YaHei UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label8.Location = new System.Drawing.Point(17, 47);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(225, 23);
            this.label8.TabIndex = 2;
            this.label8.Text = "Total check-ins this month";
            // 
            // lblCheckins
            // 
            this.lblCheckins.AutoSize = true;
            this.lblCheckins.BackColor = System.Drawing.Color.Transparent;
            this.lblCheckins.Font = new System.Drawing.Font("Microsoft YaHei UI", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblCheckins.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.lblCheckins.Location = new System.Drawing.Point(16, 14);
            this.lblCheckins.Name = "lblCheckins";
            this.lblCheckins.Size = new System.Drawing.Size(42, 31);
            this.lblCheckins.TabIndex = 2;
            this.lblCheckins.Text = "12";
            this.lblCheckins.Click += new System.EventHandler(this.label6_Click);
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.pictureBox2);
            this.panel1.Controls.Add(this.pictureBox3);
            this.panel1.Controls.Add(this.pictureBox1);
            this.panel1.Controls.Add(this.lblStruggling);
            this.panel1.Controls.Add(this.lblOkay);
            this.panel1.Controls.Add(this.lblGreat);
            this.panel1.Controls.Add(this.label8);
            this.panel1.Controls.Add(this.lblCheckins);
            this.panel1.Location = new System.Drawing.Point(13, 166);
            this.panel1.Margin = new System.Windows.Forms.Padding(4);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(502, 148);
            this.panel1.TabIndex = 20;
            // 
            // pictureBox2
            // 
            this.pictureBox2.Image = global::reHUB.Properties.Resources.neutral;
            this.pictureBox2.Location = new System.Drawing.Point(198, 93);
            this.pictureBox2.Name = "pictureBox2";
            this.pictureBox2.Size = new System.Drawing.Size(45, 38);
            this.pictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox2.TabIndex = 3;
            this.pictureBox2.TabStop = false;
            // 
            // pictureBox3
            // 
            this.pictureBox3.Image = global::reHUB.Properties.Resources.sad;
            this.pictureBox3.Location = new System.Drawing.Point(389, 96);
            this.pictureBox3.Name = "pictureBox3";
            this.pictureBox3.Size = new System.Drawing.Size(38, 33);
            this.pictureBox3.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox3.TabIndex = 3;
            this.pictureBox3.TabStop = false;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::reHUB.Properties.Resources.smile2;
            this.pictureBox1.Location = new System.Drawing.Point(22, 96);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(38, 33);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox1.TabIndex = 3;
            this.pictureBox1.TabStop = false;
            // 
            // lblStruggling
            // 
            this.lblStruggling.AutoSize = true;
            this.lblStruggling.BackColor = System.Drawing.Color.Transparent;
            this.lblStruggling.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblStruggling.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblStruggling.Location = new System.Drawing.Point(424, 101);
            this.lblStruggling.Name = "lblStruggling";
            this.lblStruggling.Size = new System.Drawing.Size(49, 24);
            this.lblStruggling.TabIndex = 2;
            this.lblStruggling.Text = "num";
            // 
            // lblOkay
            // 
            this.lblOkay.AutoSize = true;
            this.lblOkay.BackColor = System.Drawing.Color.Transparent;
            this.lblOkay.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblOkay.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblOkay.Location = new System.Drawing.Point(239, 101);
            this.lblOkay.Name = "lblOkay";
            this.lblOkay.Size = new System.Drawing.Size(64, 24);
            this.lblOkay.TabIndex = 2;
            this.lblOkay.Text = "Okay: ";
            // 
            // lblGreat
            // 
            this.lblGreat.AutoSize = true;
            this.lblGreat.BackColor = System.Drawing.Color.Transparent;
            this.lblGreat.Font = new System.Drawing.Font("Microsoft YaHei UI", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblGreat.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblGreat.Location = new System.Drawing.Point(60, 101);
            this.lblGreat.Name = "lblGreat";
            this.lblGreat.Size = new System.Drawing.Size(66, 24);
            this.lblGreat.TabIndex = 2;
            this.lblGreat.Text = "Great: ";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.BackColor = System.Drawing.Color.Transparent;
            this.label10.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label10.Location = new System.Drawing.Point(12, 333);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(149, 27);
            this.label10.TabIndex = 21;
            this.label10.Text = "Past Check-ins";
            // 
            // flowLogs
            // 
            this.flowLogs.AutoScroll = true;
            this.flowLogs.Location = new System.Drawing.Point(13, 376);
            this.flowLogs.Name = "flowLogs";
            this.flowLogs.Size = new System.Drawing.Size(498, 596);
            this.flowLogs.TabIndex = 23;
            // 
            // Logs
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(528, 1040);
            this.Controls.Add(this.flowLogs);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.panelHeader);
            this.Name = "Logs";
            this.Text = "Logs";
            this.Load += new System.EventHandler(this.Logs_Load);
            this.panelHeader.ResumeLayout(false);
            this.panelHeader.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel panelHeader;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button btnBack;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label lblCheckins;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.PictureBox pictureBox2;
        private System.Windows.Forms.PictureBox pictureBox3;
        private System.Windows.Forms.Label lblStruggling;
        private System.Windows.Forms.Label lblOkay;
        private System.Windows.Forms.Label lblGreat;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.FlowLayoutPanel flowLogs;
    }
}