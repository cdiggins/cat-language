/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Reflection;
using System.Reflection.Emit;
using System.Timers;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using System.Diagnostics;
using System.Drawing;

namespace Cat
{
    public class MainClass
    {
        static List<string> gsInputFiles = new List<string>();
        static Executor exec = new Executor();
        
        public static string gsDataFolder = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) + "\\cat";
        
        // TODO: LOWPRI: reintroduce sessions 
        //static string gsSessionFile = gsDataFolder + "\\session.cat";

        static void Main(string[] a)
        {
            if (Config.gbShowWelcome)
            {
                WriteLine("Welcome to the Cat programming language =^,,^=");
                WriteLine("version " + Config.gsVersion);
                WriteLine("by Christopher Diggins");
                WriteLine("licensed under the MIT License 1.0");
                WriteLine("http://www.cat-language.com");                
                WriteLine("");
                WriteLine("for help, type in #help followed by the enter key");
                WriteLine("to exit, type in #exit followed by the enter key");
                WriteLine("");
            }

            if (!Directory.Exists(gsDataFolder))
            {
                try
                {
                    DirectoryInfo di = Directory.CreateDirectory(gsDataFolder);
                    if (di == null)
                        throw new Exception("Failed to create directory");
                }
                catch (Exception e)
                {
                    WriteLine("Failed to create application folder: " + e.Message);
                    WriteLine("I will be unable to save session data or compiled output");
                }
            }

            try
            {
                exec.LoadModule("everything.cat");

                foreach (string s in a)
                    exec.LoadModule(s);

                // main execution loop
                while (true)
                {
                    Prompt();
                    string s = Console.ReadLine();
                    if (s.Trim().Equals("#exit") || s.Trim().Equals("#x"))
                        break;
                    Output.LogLine(s);
                    if (s.Length > 0)
                    {
                        DateTime begin = DateTime.Now;

                        try
                        {
                            exec.Execute(s + '\n');
                            TimeSpan elapsed = DateTime.Now - begin;
                            if (Config.gbOutputTimeElapsed)
                                WriteLine("Time elapsed in msec " + elapsed.TotalMilliseconds.ToString("F"));
                            // Politely ask graphics window to redraw if needed
                        }
                        catch (Exception e)
                        {
                            WriteLine("exception occurred: " + e.Message);
                        }
                        if (Config.gbOutputStack)
                            exec.OutputStack();

#if (!NOGRAPHICS)
                        WindowGDI.Invalidate();                        
#endif
                    }
                }
            }
            catch (Exception e)
            {
                WriteLine("exception: " + e.Message);
            }

            SaveTranscript(Path.GetTempFileName());

            WriteLine("Press any key to exit ...");
            Console.ReadKey();
        }

        // These functions were added after the fact. If I am bored some day I should 
        // remove them and redirect all calls directly to "Output"
        #region console/loggging output function        
        public static void Write(object o)
        {
            Output.Write(o);
        }
        public static void WriteLine(object o)
        {
            Output.WriteLine(o);
        }
        public static void Write(string s)
        {
            Output.Write(s);
        }
        public static void WriteLine(string s)
        {
            Output.WriteLine(s);
        }
        public static void Prompt()
        {
            Output.Write(">> ");
        }
        public static void SaveTranscript(string sTranscript)
        {
            Output.SaveTranscript(sTranscript);
        }
        #endregion
   }
}