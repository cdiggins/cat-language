/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Text;
using System.IO;
using System.Collections.Generic;

namespace Cat
{
    public class Output
    {
        public delegate void OutputCallBack(string s);

        static StringWriter gpOutput = new StringWriter();
        static OutputCallBack gpCallBack;

        public static void SetCallBack(OutputCallBack cb)
        {            
            gpCallBack = cb;
        }

        public static void LogLine(string s)
        {
            gpOutput.WriteLine(s);
            if (gpCallBack != null)
                gpCallBack(s + "\n");
        }

        public static void Write(object o)
        {
            if (o is String)
                Write(o as String);
            else
                Write(ObjectToString(o));
        }
        public static void WriteLine(object o)
        {
            if (o is String)
                WriteLine(o as String);
            else
                WriteLine(ObjectToString(o));
        }
        public static void Write(string s)
        {
            Console.Write(s);
            gpOutput.Write(s);
            
            if (gpCallBack != null)
                gpCallBack(s);
        }

        public static void WriteLine(string s)
        {
            Console.WriteLine(s);
            gpOutput.WriteLine(s);
            
            if (gpCallBack != null)
                gpCallBack(s + "\n");
        }

        public static string ObjectToString(object o)
        {
            if (o is string)
            {
                return "\"" + ((string)o) + "\"";
            }
            else if (o is char)
            {
                return "'" + ((char)o) + "'";
            }
            else if (o is CatList)
            {
                return (o as CatList).ToString();
            }
            else if (o is Byte)
            {
                byte b = (byte)o;
                return "0x" + b.ToString("x2");
            }
            else if (o is Double)
            {
                double d = (double)o;
                return d.ToString("F");
            }
            else if (o == null)
            {
                return "null";
            }
            else
            {
                return o.ToString();
            }
        }
        public static void Prompt()
        {
            Write(">> ");
        }
        public static void SaveTranscript(string sTranscript)
        {
            try
            {
                StreamWriter sw = new StreamWriter(sTranscript);
                gpOutput.Flush();
                sw.Write(gpOutput.ToString());
                sw.Close();
                WriteLine("A transcript of your session has been saved to the file " + sTranscript);
            }
            catch (Exception e)
            {
                WriteLine("Error occured while attempting to write transcript: " + e.Message);
            }
        }
    }
}