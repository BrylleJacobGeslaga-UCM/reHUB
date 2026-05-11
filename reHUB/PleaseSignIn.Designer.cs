namespace reHUB
{
    partial class PleaseSignIn
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
            this.signinbtn = new System.Windows.Forms.Button();
            this.laterbtn = new System.Windows.Forms.LinkLabel();
            this.label1 = new System.Windows.Forms.Label();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // signinbtn
            // 
            this.signinbtn.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(113)))), ((int)(((byte)(196)))), ((int)(((byte)(140)))));
            this.signinbtn.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(113)))), ((int)(((byte)(196)))), ((int)(((byte)(140)))));
            this.signinbtn.FlatAppearance.BorderSize = 0;
            this.signinbtn.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.signinbtn.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.signinbtn.ForeColor = System.Drawing.SystemColors.ControlLightLight;
            this.signinbtn.Location = new System.Drawing.Point(71, 562);
            this.signinbtn.Name = "signinbtn";
            this.signinbtn.Size = new System.Drawing.Size(255, 40);
            this.signinbtn.TabIndex = 0;
            this.signinbtn.Text = "Sign in now";
            this.signinbtn.UseVisualStyleBackColor = false;
            this.signinbtn.Click += new System.EventHandler(this.signinbtn_click);
            // 
            // laterbtn
            // 
            this.laterbtn.AutoSize = true;
            this.laterbtn.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.laterbtn.ForeColor = System.Drawing.Color.DarkGreen;
            this.laterbtn.LinkColor = System.Drawing.Color.DarkGreen;
            this.laterbtn.Location = new System.Drawing.Point(161, 616);
            this.laterbtn.Name = "laterbtn";
            this.laterbtn.Size = new System.Drawing.Size(78, 16);
            this.laterbtn.TabIndex = 1;
            this.laterbtn.TabStop = true;
            this.laterbtn.Text = "Maybe later";
            this.laterbtn.VisitedLinkColor = System.Drawing.Color.FromArgb(((int)(((byte)(113)))), ((int)(((byte)(196)))), ((int)(((byte)(140)))));
            this.laterbtn.Click += new System.EventHandler(this.laterbtn_click);
            // 
            // label1
            // 
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(71, 496);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(255, 54);
            this.label1.TabIndex = 2;
            this.label1.Text = "Your are currently in guest mode. Sign in to unlock full features.";
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::reHUB.Properties.Resources._25c1637a_cf61_4121_b384_68bcf6f348d4;
            this.pictureBox1.Location = new System.Drawing.Point(36, 130);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(311, 345);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox1.TabIndex = 3;
            this.pictureBox1.TabStop = false;
            // 
            // PleaseSignIn
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Window;
            this.ClientSize = new System.Drawing.Size(396, 845);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.laterbtn);
            this.Controls.Add(this.signinbtn);
            this.Name = "PleaseSignIn";
            this.Text = "Sign In";
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button signinbtn;
        private System.Windows.Forms.LinkLabel laterbtn;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.PictureBox pictureBox1;
    }
}