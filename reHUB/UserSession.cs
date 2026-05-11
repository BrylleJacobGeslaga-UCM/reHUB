using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace reHUB
{
    internal class UserSession
    {
        public static int UserID;
        public static List<string> Interests = new List<string>();

        public static List<string> Goals = new List<string>();

        public static bool IsGuest;
        public static string Username;
    }
}
