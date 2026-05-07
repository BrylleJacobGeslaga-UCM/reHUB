using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace reHUB
{
    public partial class PleaseSignIn : Form
    {
        private MainForm mainForm;
        public PleaseSignIn(MainForm form)
        {
            InitializeComponent();
            mainForm = form;
        }
        private void signinbtn_click(object sender, EventArgs e)
        {
            SignIn signInForm = new SignIn();
            signInForm.Show();
            mainForm.Close();
            this.Close();
        }

        private void laterbtn_click(object sender, EventArgs e)
        {
            mainForm.LoadForm(new Dashboard(mainForm, true));
            this.Close();
        }
    }
}
