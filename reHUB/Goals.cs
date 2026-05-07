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
    public partial class Goals : Form
    {
        List<string> selectedGoals = new List<string>();
        List<string> userInterests;

        public Goals(List<string> interests)
        {
            InitializeComponent();
            userInterests = interests;
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void ToggleGoal(string goal)
        {
            if (selectedGoals.Contains(goal))
            {
                selectedGoals.Remove(goal);
            }
            else
            {
                selectedGoals.Add(goal);

            }
        }
        private void highlightButton(Button btn)
        {
            if (btn.BackColor == Color.FromArgb(113, 196, 140))
            {
                btn.BackColor = SystemColors.Control;
                btn.ForeColor = SystemColors.ControlText;
            }
            else
            {
                btn.BackColor = Color.FromArgb(113, 196, 140);
                btn.ForeColor = Color.White;
            }
        }
        private void btnGoal1_Click(object sender, EventArgs e)
        {
            ToggleGoal("Stay consistent");
            highlightButton(btnGoal1);
        }

        private void btnGoal2_Click(object sender, EventArgs e)
        {
            ToggleGoal("Avoid relapse");
            highlightButton(btnGoal2);
        }

        private void btnGoal3_Click(object sender, EventArgs e)
        {
            ToggleGoal("Find support");
            highlightButton(btnGoal3);
        }

        private void btnGoal4_Click(object sender, EventArgs e)
        {
            ToggleGoal("Build community");
            highlightButton(btnGoal4);
        }

        private void btnContinue_Click(object sender, EventArgs e)
        {
            if (selectedGoals.Count == 0)
            {
                MessageBox.Show("Please select at least one goal.");
                return;
            }

            string interests = string.Join(", ", userInterests);
            string goals = string.Join(", ", selectedGoals);

            MessageBox.Show("Interests: " + interests + "\nGoals: " + goals);

            MainForm main = new MainForm();
            main.Show();
            this.Hide();
        }
    }
}
