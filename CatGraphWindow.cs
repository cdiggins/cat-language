/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Text;
using System.Windows;
using System.Windows.Forms;
using System.Threading;
using System.Diagnostics;
using System.Reflection;

namespace Cat
{
    public partial class GraphWindow : Form
    {
#if (!NOGRAPHICS)
        List<GraphicCommand> mCmds = new List<GraphicCommand>();
        Mutex mMutex = new Mutex();
        
        public GraphWindow()
        {
            InitializeComponent();
        }

        public void ClearCmds()
        {
            mMutex.WaitOne();
            mCmds.Clear();
            mMutex.ReleaseMutex();

            // Tell the parent thread to invalidate
            MethodInvoker p = Invalidate;
            Invoke(p);
        }

        public void AddCmd(GraphicCommand c)
        {
            mMutex.WaitOne();
            try
            {
                mCmds.Add(c);
            }
            finally
            {
                mMutex.ReleaseMutex();
            }
        }

        public void SaveToFile(string s)
        {
            mMutex.WaitOne();

            try
            {
                Bitmap b = new Bitmap(Width, Height, CreateGraphics());
                WindowGDI.Initialize(Graphics.FromImage(b));
                foreach (GraphicCommand c in mCmds) {
                    WindowGDI.Draw(c);
                }
                b.Save(s);
            }
            finally 
            {
                mMutex.ReleaseMutex();
            }
        }

        public delegate void Proc();

        public void SafeClose()
        {
            if (InvokeRequired)
            {
                Proc p = SafeClose;
                Invoke(p, null);
            }
            else
            {
                Close();
            }
        }

        public void SafeShow()
        {
            if (InvokeRequired)
            {
                Proc p = SafeShow;
                Invoke(p, null);
            }
            else
            {
                Show();
            }
        }

        private void GraphWindow_Paint(object sender, PaintEventArgs e)
        {
            mMutex.WaitOne();
            try
            {
                Bitmap b = new Bitmap(Width, Height, CreateGraphics());
                WindowGDI.Initialize(Graphics.FromImage(b));
                foreach (GraphicCommand c in mCmds)
                    WindowGDI.Draw(c);
                if (Config.gbShowTurtle)
                    WindowGDI.DrawTurtle();
                // TODO: replace this call with a bit block transfer API call
                e.Graphics.DrawImageUnscaled(b, 0, 0);
            }
            finally
            {
                mMutex.ReleaseMutex();
            }           
        }

        private void GraphWindow_Resize(object sender, EventArgs e)
        {
            Invalidate();
        }

        private void GraphWindow_FormClosing(object sender, FormClosingEventArgs e)
        {
            WindowGDI.NullifyWindow();
        }
#endif
    }

#if (!NOGRAPHICS)
    public class WindowGDI
    {
        static GraphWindow mWindow;
        static EventWaitHandle mWait = new EventWaitHandle(false, EventResetMode.AutoReset);
        static Pen mPen = new Pen(Color.Black);
        static bool mbPenUp = false;
        static Pen turtlePen = new Pen(Color.Blue);
        static Brush turtleBrush = new SolidBrush(Color.DarkSeaGreen);
        static bool mbShowTurtle = true;
        static Graphics mg;

        public static void Initialize(Graphics g)
        {
            mg = g;
            //Point mOrigin = new Point(0, 0);
            mPen.LineJoin = LineJoin.Bevel;
            turtlePen.Width = 1;
            mg = g;
            mg.TranslateTransform(mWindow.Width / 2, mWindow.Height / 2);
        }

        private static void PrivateDraw(GraphicCommand c)
        {
            c.Invoke(null, typeof(WindowGDI));
        }

        public static void Draw(GraphicCommand c)
        {
            PrivateDraw(c);
        }

        public static void Render(GraphicCommand c)
        {
            if (mWindow == null)
                OpenWindow();

            mWindow.AddCmd(c);
        }

        public static void Invalidate()
        {
            if (mWindow != null)
                mWindow.Invalidate();
        }

        public static void Rotate(double x)
        {
            mg.RotateTransform((float)x);
        }

        public static void Line(double x1, double y1, double x2, double y2)
        {
            if (!mbPenUp)
                mg.DrawLine(mPen, (float)x1, (float)y1, (float)x2, (float)y2);
        }

        public static void Slide(double x, double y)
        {
            mg.TranslateTransform((float)(x), (float)(y));
        }

        public static void Scale(double x, double y)
        {
            mg.ScaleTransform((float)x, (float)y);
        }

        public static void SetPenUp(bool b)
        {
            mbPenUp = b;
        }

        public static bool IsPenUp()
        {
            return mbPenUp;
        }

        public static void Ellipse(double x, double y, double w, double h)
        {
            if (!mbPenUp)
                mg.DrawEllipse(mPen, (float)x, (float)y, (float)w, (float)h);
        }

        public static void DrawTurtleFoot(int x, int y)
        {
            int footSize = 10;
            Rectangle rect = new Rectangle(x - (footSize / 2), y - (footSize / 2), footSize, footSize);            
            mg.FillEllipse(turtleBrush, rect);
            mg.DrawEllipse(turtlePen, rect);
        }

        public static void SetTurtleVisibility(bool b)
        {
            mbShowTurtle = b;
        }

        public static bool GetTurtleVisibility()
        {
            return mbShowTurtle;
        }

        public static void DrawTurtle()
        {
            if (!mbShowTurtle)
                return;

            int w = 26; 
            int h = 26;

            // draw feet
            int x = (h / 2) - 3;
            int y = (w / 2) - 3;
            DrawTurtleFoot(-x, y);
            DrawTurtleFoot(-x, -y);
            DrawTurtleFoot(x, y);
            DrawTurtleFoot(x, -y);

            // draw head 
            DrawTurtleFoot(w / 2 + 3, 0);

            // draw eyes
            Rectangle eye1 = new Rectangle(w / 2 + 4, 2, 1, 1);
            Rectangle eye2 = new Rectangle(w / 2 + 4, -3, 1, 1);
            mg.DrawRectangle(turtlePen, eye1);
            mg.DrawRectangle(turtlePen, eye2);

            // draw tail
            Rectangle rect = new Rectangle(-(w/2) - 6, -2, 12, 4);
            mg.FillEllipse(turtleBrush, rect);
            mg.DrawEllipse(turtlePen, rect);
           
            // draw body
            rect = new Rectangle(-w / 2, -h / 2, w, h);
            mg.FillEllipse(turtleBrush, rect);
            mg.DrawEllipse(turtlePen, rect);
            
            // clip everything else to the body
            GraphicsPath clipPath = new GraphicsPath();
            clipPath.AddEllipse(rect);
            mg.SetClip(clipPath);

            // stripe the body
            turtlePen.Width = 2;
            mg.DrawLine(turtlePen, 0, -h/2, 0, h/2);

            int curvature = w / 2;
            mg.DrawEllipse(turtlePen, 7, -h/2, curvature, h);
            mg.DrawEllipse(turtlePen, -(curvature + 7), -h / 2, curvature, h);
            mg.ResetClip();
        }

        public static void SetPenColor(Color x)
        {
            mPen.Color = x;
        }

        public static void SetPenWidth(int x)
        {
            mPen.Width = x;
        }

        public static void SetSolidFill(Color x)
        {
            mPen.Brush = new SolidBrush(x);
        }

        public static void ClearFill()
        {
            mPen.Brush = null;
        }

        #region color functions
        static public Color Rgb(int r, int g, int b) { return Color.FromArgb(r, g, b); }
        #endregion

        #region public functions
        static public void OpenWindow()
        {
            if (mWindow != null) return;
            Thread t = new Thread(new ThreadStart(LaunchWindow));
            t.Start();
            mWait.WaitOne();   
        }

        static public void NullifyWindow()
        {
            mWindow = null;
        }

        static public void CloseWindow()
        {
            if (mWindow == null) return;
            mWindow.SafeClose();
        }

        static public void ClearWindow()
        {
            mWindow.ClearCmds();
        }

        static public void SaveToFile(string s)
        {
            mWindow.SaveToFile(s);
        }
        #endregion 

        static private void LaunchWindow()
        {
            mWindow = new GraphWindow();
            mWait.Set();
            Application.Run(mWindow);
        }
    }

    public class GraphicCommand
    {
        public GraphicCommand(string sCmd, Object[] args)
        {
            msCommand = sCmd;
            maArgs = args;
            maArgTypes = new Type[maArgs.Length];
            for (int i = 0; i < maArgs.Length; ++i)
                maArgTypes[i] = maArgs[i].GetType();
        }
        public MethodInfo GetMethod(Type t)
        {
            MethodInfo ret = t.GetMethod(msCommand);
            if (ret == null)
            {
                ret = t.GetMethod(msCommand, GetArgTypes());
                if (ret == null)
                    throw new Exception("Could not find method " + msCommand + " on type " + t.ToString() + " with matching types");
            }
            return ret;
        }
        public Type[] GetArgTypes()
        {
            return maArgTypes;
        }
        public string GetMethodName()
        {
            return msCommand;
        }
        public Object[] GetArgs()
        {
            return maArgs;
        }
        string msCommand;
        Object[] maArgs;
        Type[] maArgTypes;

        public void Invoke(Object o, Type t)
        {
            MethodInfo mi = GetMethod(t);
            mi.Invoke(o, maArgs);
        }
    }
#endif
}

 