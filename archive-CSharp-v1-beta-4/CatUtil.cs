using System;
using System.Collections.Generic;
using System.Text;

namespace Cat
{
    public class Util
    {
        public static string FileToString(string sFileName)
        {
            // Read the file 
            System.IO.StreamReader file = new System.IO.StreamReader(sFileName);
            try
            {
                return file.ReadToEnd();
            }
            finally
            {
                file.Close();
            }
        }

        public static string ToHtml(string s)
        {
            StringBuilder sb = new StringBuilder();

            int nCol = 0;
            foreach (Char c in s)
            {
                if (c == '<')
                {
                    sb.Append("&lt;");
                }
                else if (c == '>')
                {
                    sb.Append("&gt;");
                }
                else if (c == '&')
                {
                    sb.Append("&amp;");
                }
                else if (c == '\n')
                {
                    sb.Append(c);
                    nCol = 0;
                }
                else
                {
                    if (nCol++ >= 80)
                    {
                        sb.Append('\n');
                        nCol = 1;
                    }
                    sb.Append(c);
                }
            }

            return sb.ToString();
        }
    }
}
