
/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using System.Text;
using System.Text.RegularExpressions;

namespace Cat
{
    public class CatException : Exception
    {
        object data;

        public CatException(object o)
        {
            data = o;
        }

        public object GetObject()
        {
            return data;
        }
    }

    public class MetaCommands
    {
        public class Help : PrimitiveFunction
        {
            public Help()
                : base("#help", "( ~> )", "outputs a help message", "meta")
            { }

            public override void Eval(Executor exec)
            {
                Output.WriteLine("Some basic commands to get you started:");
                Output.WriteLine("  \"filename\" #load - loads a source file");
                Output.WriteLine("  [...] #trace - runs a function in trace mode");
                Output.WriteLine("  #test_all - runs all unit tests");
                Output.WriteLine("  [...] #type - shows the type of a function");
                Output.WriteLine("  [...] #metacat - optimizes a function by applying rewriting rules");
                Output.WriteLine("  #defs - lists all loaded commands");
                Output.WriteLine("  \"instruction\" #def - detailed help on an instruction");
                Output.WriteLine("  \"prefix\" #defmatch - describes all instructions starting with prefix");
                Output.WriteLine("  #exit - exits the Cat interpreter");
                Output.WriteLine("");
            }
        }

        public class MakeHelp : PrimitiveFunction
        {
            public MakeHelp()
                : base("#make_help", "( ~> )", "generates an HTML help file", "meta")
            { }

            void OutputTaggedTable(StreamWriter sw, string sTag, Executor exec)
            {
                sw.WriteLine("<table width='100%'>");
                int nRow = 0;
                foreach (Function f in exec.GetAllFunctions())
                {
                    if ((sTag.Length == 0 && f.GetRawTags().Length == 0) || (sTag.Length != 0 && f.GetRawTags().Contains(sTag)))
                    {
                        if (nRow % 5 == 0)
                            sw.WriteLine("<tr valign='top'>");                    
                        string sName = Util.ToHtml(f.GetName());
                        string s = "<td><a href='#" + sName + "'>" + sName + "</a></td>";
                        sw.WriteLine(s);
                        if (nRow++ % 5 == 4)
                            sw.WriteLine("</tr>");
                    }
                }
                if (nRow % 5 != 0) sw.WriteLine("</tr>");
                sw.WriteLine("</table>");
            }

            void OutputAllTable(StreamWriter sw, Executor exec)
            {
                sw.WriteLine("<table width='100%'>");
                int nRow = 0;
                foreach (Function f in exec.GetAllFunctions())
                {
                    if (nRow % 5 == 0)
                        sw.WriteLine("<tr valign='top'>");
                    string sName = Util.ToHtml(f.GetName());
                    string s = "<td><a href='#" + sName + "'>" + sName + "</a></td>";
                    sw.WriteLine(s);
                    if (nRow++ % 5 == 4)
                        sw.WriteLine("</tr>");
                }
                if (nRow % 5 != 0) sw.WriteLine("</tr>");
                sw.WriteLine("</table>");
            }

            public override void Eval(Executor exec)
            {
                string sHelpFile = MainClass.gsDataFolder + "\\help.html";
                StreamWriter sw = new StreamWriter(sHelpFile);
                sw.WriteLine("<html><head><title>Cat Help File</title></head><body>");

                /*
                sw.WriteLine("<h1><a name='level0prims'></a>Level 0 Primitives</h1>");
                OutputTable(sw, "level0", exec);
                sw.WriteLine("<h1><a name='level1prims'></a>Level 1 Primitives</h1>");
                OutputTable(sw, "level1", exec);               
                sw.WriteLine("<h1><a name='level2prims'></a>Level 2 Primitives</h1>");
                OutputTable(sw, "level2", exec);                
                sw.WriteLine("<h1><a name='otherprims'></a>Other Functions</h1>");
                OutputTable(sw, "", exec);
                 */

                sw.WriteLine("<h1>Instructions</h1>");
                OutputAllTable(sw, exec);

                sw.WriteLine("<h1>Definitions</h1>");
                sw.WriteLine("<pre>");
                foreach (Function f in exec.GetAllFunctions())
                {
                    sw.WriteLine(f.GetImplString(true));
                }
                sw.WriteLine("</pre>");
    
                sw.WriteLine("</body></html>");
                sw.Close();
                Output.WriteLine("saved help file to " + sHelpFile);
            }
        }

        public class DefTags : PrimitiveFunction
        {
            public DefTags()
                : base("#deftags", "( ~> )", "outputs a list of the different tags associated with the functions")
            { }

            public override void  Eval(Executor exec)
            {
                Dictionary<string, List<Function> > taggedFxns = exec.GetFunctionsByTag();
                List<string> tags = new List<string>();
                foreach (string s in taggedFxns.Keys)
                    tags.Add(s);
                tags.Sort();
                foreach (string s in tags)
                    Output.WriteLine(s);
            }
        }

        public class DefTag : PrimitiveFunction
        {
            public DefTag()
                : base("#deftag", "(string ~> )", "outputs a list of the functions associated with a tag")
            { }

            public override void Eval(Executor exec)
            {
                Dictionary<string, List<Function>> taggedFxns = exec.GetFunctionsByTag();
                string s = exec.PopString();
                if (!taggedFxns.ContainsKey(s))
                {
                    Output.WriteLine("no functions are tagged '" + s + "'");
                }
                else
                {
                    foreach (Function f in taggedFxns[s])
                        Output.Write(f.GetName() + "\t");
                    Output.WriteLine("");
                }
            }
        }

        public class Load : PrimitiveFunction
        {
            public Load()
                : base("#load", "(string ~> )", "loads and executes a source code file", "meta")
            { }

            public override void Eval(Executor exec)
            {
                exec.LoadModule(exec.PopString());
            }
        }

        public class Save : PrimitiveFunction
        {
            public Save()
                : base("#save", "(string ~> )", "saves a transcript of the session so far", "meta")
            { }

            public override void Eval(Executor exec)
            {
                MainClass.SaveTranscript(exec.PopString());
            }
        }

        public class TypeOf : PrimitiveFunction
        {
            public TypeOf()
                : base("#type", "(function -> function)", "displays the type of an expression", "meta")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction f = exec.TypedPeek<QuotedFunction>();
                bool bVerbose = Config.gbVerboseInference;
                bool bInfer = Config.gbTypeChecking;
                Config.gbVerboseInference = true;
                Config.gbTypeChecking = true;
                try
                {
                    CatFxnType ft = CatTypeReconstructor.Infer(f.GetSubFxns());
                    if (ft == null)
                        Output.WriteLine("type could not be inferred");
                }
                finally
                {
                    Config.gbVerboseInference = bVerbose;
                    Config.gbTypeChecking = bInfer;
                }
            }
        }

        public class Expand : PrimitiveFunction
        {
            public Expand()
                : base("#inline", "(('A -> 'B) ~> ('A -> 'B))", "performs inline expansion", "meta")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction qf = exec.PopFxn();
                exec.Push(Optimizer.ExpandInline(qf, 5));
            }
        }

        public class Expand1 : PrimitiveFunction
        {
            public Expand1()
                : base("#inline-step", "(('A -> 'B) -> ('A -> 'B))", "performs inline expansion", "meta")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction qf = exec.PopFxn();
                exec.Push(Optimizer.ExpandInline(qf, 1));
            }
        }

        public class ApplyMacros : PrimitiveFunction
        {
            public ApplyMacros()
                : base("#metacat", "(('A -> 'B) ~> ('A -> 'B))", "runs MetaCat rewriting rules", "meta")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction qf = exec.PopFxn();
                exec.Push(Optimizer.ApplyMacros(exec, qf));
            }
        }

        public class Clr : PrimitiveFunction
        {
            public Clr()
                : base("#clr", "('A ~> )", "removes all items from the stack", "meta")
            { }

            public override void Eval(Executor exec)
            {
                exec.Clear();
            }
        }

        public class MetaData : PrimitiveFunction
        {
            public MetaData()
                : base("#metadata", "(('A -> 'B) ~> ('A -> 'B) list)", "outputs the meta-data associated with a function", "meta")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction f = exec.TypedPeek<QuotedFunction>();

                if (f.GetMetaData() != null)
                    exec.Push(f.GetMetaData().ToList()); else
                    exec.Push(new CatList());
            }
        }

        public class Test : PrimitiveFunction
        {
            public Test()
                : base("#test", "(('A -> 'B) ~> ('A -> 'B))", "runs the unit tests associated with an instruction", "meta")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction f = exec.TypedPeek<QuotedFunction>();
                foreach (Function g in f.GetSubFxns())
                    if (exec.TestFunction(g))
                        Output.WriteLine("tests succeeded for " + g.GetName());                    
            }
        }

        public class TestAll : PrimitiveFunction
        {
            public TestAll()
                : base("#test_all", "( ~> )", "runs all unit tests associated with all instructions", "meta")
            { }

            public override void Eval(Executor exec)
            {
                exec.testCount = 0;
                int nFailCount = 0;
                foreach (Function f in exec.GetAllFunctions())
                    if (!exec.TestFunction(f))
                        nFailCount++;
                Output.WriteLine("ran " + exec.testCount + " unit tests with " + nFailCount + " failures");
            }
        }

        public class Defs : PrimitiveFunction
        {
            public Defs()
                : base("#defs", "( ~> )", "outputs a complete list of defined instructions ", "meta")
            {
            }

            public override void Eval(Executor exec)
            {
                foreach (Function f in exec.GetAllFunctions())
                    Output.Write(f.GetName() + "\t");
                Output.WriteLine("");
            }
        }

        public class DefMatch : PrimitiveFunction
        {
            public DefMatch()
                : base("#defmatch", "(string ~> )", "outputs a detailed description of all instructions starting with the name", "meta")
            {
            }

            public override void Eval(Executor exec)
            {
                string sName = exec.PopString();
                foreach (Function f in exec.GetAllFunctions())
                    if (f.GetName().IndexOf(sName) == 0)
                        Output.WriteLine(f.GetImplString());
            }
        }

        public class Def : PrimitiveFunction
        {
            public Def()
                : base("#def", "(string ~> )", "outputs a detailed description of the instruction", "meta")
            {
            }

            public override void Eval(Executor exec)
            {
                string sName = exec.PopString();
                Function f = exec.Lookup(sName);
                if (f == null)
                    Output.WriteLine("instruction '" + sName + "' was not found"); else
                    Output.WriteLine(f.GetImplString());
            }
        }

        public class Trace : PrimitiveFunction
        {
            public Trace()
                : base("#trace", "('A ('A -> 'B) ~> 'B)", "used to trace the execution of a function", "meta")
            { }

            public override void Eval(Executor exec)
            {
                Function f = exec.PopFxn();
                exec.bTrace = true;
                try
                {
                    f.Eval(exec);
                }
                finally
                {
                    exec.bTrace = false;
                }
            }
        }
    }

    public class Primitives
    {
        #region conversion functions
        public class EvalFun : PrimitiveFunction
        {
            public EvalFun()
                : base("eval", "(list string ~> list)", "evaluates a string as a function using the list as a stack", "level2,misc")
            { }

            public override void Eval(Executor exec)
            {
                string s = exec.PopString();

                Executor aux = new Executor(exec);
                aux.Execute(s);
                exec.Push(aux.GetStackAsList());
            }
        }

        public class Str : PrimitiveFunction
        {
            public Str()
                : base("str", "(any -> string)", "converts any value into a string representation.", "level2,strings")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(Output.ObjectToString(exec.Pop()));
            }
        }

        public class MakeByte : PrimitiveFunction
        {
            public MakeByte()
                : base("int_to_byte", "(int -> byte)", "converts an integer into a byte, throwing away sign and ignoring higher bits", "level1,math,conversion")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                byte b = (byte)n;
                exec.Push(b);
            }
        }
        public class BinStr : PrimitiveFunction
        {
            public BinStr()
                : base("bin_str", "(int -> string)", "converts a number into a binary string representation.", "level2,strings,math,conversion")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                string s = "";

                if (n == 0) s = "0";
                while (n > 0)
                {
                    if (n % 2 == 1)
                    {
                        s = "1" + s;
                    }
                    else
                    {
                        s = "0" + s;
                    }
                    n /= 2;
                }
                exec.PushString(n.ToString(s));
            }
        }

        public class HexStr : PrimitiveFunction
        {
            public HexStr()
                : base("hex_str", "(int -> string)", "converts a number into a hexadecimal string representation.", "level2,strings,math,conversion")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                exec.PushString(n.ToString("x"));
            }
        }

        #endregion 

        #region primitive function classes
        public class Halt : PrimitiveFunction
        {
            public Halt()
                : base("halt", "(int ~> )", "halts the program with an error code", "level2,application")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                throw new Exception("Program halted with error code " + n.ToString());
            }
                
        }

        public class Id : PrimitiveFunction
        {
            public Id()
                : base("id", "('a -> 'a)", "does nothing, but requires one item on the stack.", "level1,misc")
            { }

            public override void Eval(Executor exec)
            {                
            }
        }

        public class Eq : PrimitiveFunction
        {
            public Eq()
                : base("eq", "('a 'a -> bool)", "returns true if both items on stack have the same value", "level1,comparison")
            { }

            public override void Eval(Executor exec)
            {
                Object x = exec.Pop();
                Object y = exec.Pop();
                exec.PushBool(x.Equals(y));
            }
        }

        public class Dup : PrimitiveFunction
        {
            public Dup()
                : base("dup", "('a -> 'a 'a)", "duplicate the top item on the stack", "level0,stack")
            { }

            public override void Eval(Executor exec)
            {
                exec.Dup();
            }
        }

        public class Pop : PrimitiveFunction
        {
            public Pop()
                : base("pop", "('a -> )", "removes the top item from the stack", "level0,stack")
            { }

            public override void Eval(Executor exec)
            {
                exec.Pop();
            }
        }

        public class Swap : PrimitiveFunction
        {
            public Swap()
                : base("swap", "('a 'b -> 'b 'a)", "swap the top two items on the stack", "level0,stack")
            { }

            public override void Eval(Executor exec)
            {
                exec.Swap();
            }           
        }
        #endregion

        #region function functions
        public class ApplyFxn : PrimitiveFunction
        {
            public ApplyFxn()
                : base("apply", "('A ('A -> 'B) -> 'B)", "applies a function to the stack (i.e. executes an instruction)", "level0,functions")
            { }

            public override void Eval(Executor exec)
            {
                Function f = exec.TypedPop<Function>();
                f.Eval(exec);
            }
        }

        public class ApplyOneFxn : PrimitiveFunction
        {
            public ApplyOneFxn()
                : base("A", "('a ('a -> 'b) -> 'b)", "applies a unary function to its argument", "functions")
            { }

            public override void Eval(Executor exec)
            {
                Function f = exec.TypedPop<Function>();
                f.Eval(exec);
            }
        }

        public class PartialApplyFxn : PrimitiveFunction
        {
            public PartialApplyFxn()
                : base("papply", "('C 'a ('A 'a -> 'B) -> 'C ('A -> 'B))", "partial application: binds the top argument to the top value in the stack", "level0,functions")
            { }

            public override void Eval(Executor exec)
            {
                exec.Execute("swap quote swap compose");
            }
        }

        public class Dip : PrimitiveFunction
        {
            public Dip()
                : base("dip", "('A 'b ('A -> 'C) -> 'C 'b)", "evaluates a function, temporarily removing second item", "level0,functions")
            { }

            public override void Eval(Executor exec)
            {
                Function f = exec.TypedPop<Function>();
                Object o = exec.Pop();
                f.Eval(exec);
                exec.Push(o);
            }
        }

        public class Compose : PrimitiveFunction
        {
            public Compose()
                : base("compose", "(('A -> 'B) ('B -> 'C) -> ('A -> 'C))",
                    "creates a function by composing (concatenating) two existing functions", "level0,functions")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction right = exec.TypedPop<QuotedFunction>();
                QuotedFunction left = exec.TypedPop<QuotedFunction>();
                QuotedFunction f = new QuotedFunction(left, right);
                exec.PushFxn(f);
            }
        }

        public class Pull : PrimitiveFunction
        {
            public Pull()
                : base("pull", "(( -> 'A 'b) -> ( -> 'A) 'b)",
                    "deconstructs a function", "experimental")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction f = exec.TypedPeek<QuotedFunction>();
                
                int n = f.GetSubFxns().Count;
                Function g = f.GetSubFxns()[n - 1];
                if (((g is PushFunction) || (g is QuotedFunction) || (g is QuotedValue)) || (g is PushValueBase))
                {
                    f.GetSubFxns().RemoveAt(n - 1);
                    g.Eval(exec);
                }
                else if (g is PushStack)
                {
                    Executor e2 = (g as PushStack).GetStack();
                    exec.Push(e2.Pop());
                }
                else
                {
                    exec.Pop();
                    Executor e2 = new Executor();
                    f.Eval(e2);
                    Object o = e2.Pop();
                    Function h = new PushStack(e2);
                    exec.Push(h);
                    exec.Push(o);
                }
            }
        }

        public class Quote : PrimitiveFunction
        {
            public Quote()
                : base("quote", "('a -> ( -> 'a))",
                    "creates a constant generating function from the top value on the stack", "level0,functions")
            { }

            public override void Eval(Executor exec)
            {
                Object o = exec.Pop();
                QuotedValue q = new QuotedValue(o);
                exec.PushFxn(q);
            }
        }

        public class Dispatch1 : PrimitiveFunction
        {
            public Dispatch1()
                : base("dispatch1", "('a list -> any)", "dynamically dispatches a function depending on the type on top of the stack", "level1,functions")
            { }

            public override void Eval(Executor exec)
            {
                CatList fs = exec.TypedPop<CatList>();
                Object o = exec.Peek();
                for (int i = 0; i < fs.Count / 2; ++i)
                {
                    Type t = fs[i * 2 + 1] as Type;
                    Function f = fs[i * 2] as Function;
                    if (t.IsInstanceOfType(o))
                    {
                        f.Eval(exec);
                        return;
                    }
                }
                throw new Exception("could not dispatch function");
            }
        }

        public class Dispatch2 : PrimitiveFunction
        {
            public Dispatch2()
                : base("dispatch2", "('a 'b list -> any)", "dynamically dispatches a function depending on the type on top of the stack", "level1,functions")
            { }

            public override void Eval(Executor exec)
            {
                CatList fs = exec.TypedPop<CatList>();
                Object o = exec.Peek();
                for (int i = 0; i < fs.Count / 2; ++i)
                {
                    Type t = fs[i * 2 + 1] as Type;
                    Function f = fs[i * 2] as Function;
                    if (t.IsInstanceOfType(o))
                    {
                        f.Eval(exec);
                        return;
                    }
                }
                throw new Exception("could not dispatch function");
            }
        }
        #endregion

        #region reflection api
        public class Explode : PrimitiveFunction
        {
            public Explode()
                : base("explode", "('A -> 'B) -> list)",
                    "breaks a function up into a list of instructions", "level2,functions")
            { }

            public CatList FxnsToList(CatExpr fxns)
            {
                Object[] a = new Object[fxns.Count];
                int i = 0;
                foreach (Function f in fxns )
                {
                    if (f is QuotedFunction)
                    {
                        a[i++] = FxnsToList((f as QuotedFunction).GetSubFxns());
                    }
                    else if (f is PushFunction)
                    {
                        a[i++] = FxnsToList((f as PushFunction).GetSubFxns());
                    }
                    else 
                    {
                        a[i++] = f;
                    }
                }
                return new CatList(a);
            }

            public override void Eval(Executor exec)
            {
                QuotedFunction f = exec.TypedPop<QuotedFunction>();
                exec.Push(FxnsToList(f.GetSubFxns()));
            }
        }
        #endregion

        #region control flow primitives

        public class Default : PrimitiveFunction
        {
            public Default()
                : base("default", "('A -> 'B) -> ('A int -> 'B)", "used to construct a default 'case' statement", "level1,control,functions")
            { }

            public override void Eval(Executor exec)
            {
                QuotedFunction f = exec.TypedPop<QuotedFunction>();
                f.GetSubFxns().Insert(0, new Pop());
                JumpTable jt = new JumpTable(f);
                exec.Push(jt);
            }
        }

        public class Case : PrimitiveFunction
        {
            public Case()
                : base("case", "('A int -> 'B) ('A -> 'B) int -> ('A int -> 'B)", "used to construct a 'case' statement member of a switch statement", 
                    "level1,control,functions")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                Function f = exec.TypedPop<Function>();
                Function g = exec.TypedPeek<Function>();
                if (g is JumpTable)
                {
                    JumpTable jt = g as JumpTable;
                    jt.AddCase(n, f);                    
                }
                else
                {
                    exec.Pop(); 
                    JumpTable jt = new JumpTable(g);
                    exec.Push(jt);                        
                }
            }
        }

        /*
        public class CallCC : PrimitiveFunction
        {
            public CallCC()
                : base("callcc", "('A ('A ('B -> 'C) -> 'B) ~> 'B)", "calls a function with the current continuation", "experimental")
            { }

            public override void Eval(Executor exec)            
            {
                throw new Exception("unimplemented");
                // TODO: make a copy of the stack, and a pointer to the current instruction. 
                // this implies that I need to make a copy of the index stream.
            }
        }*/

        public class While : PrimitiveFunction
        {
            public While()
                : base("while", "('A ('A -> 'A) ('A -> 'A bool) -> 'A)",
                    "executes a block of code repeatedly until the condition returns true", "level1,control")
            { }

            public override void Eval(Executor exec)
            {
                Function cond = exec.TypedPop<Function>();
                Function body = exec.TypedPop<Function>();

                cond.Eval(exec);
                while ((bool)exec.Pop())
                {
                    body.Eval(exec);
                    cond.Eval(exec);
                }
            }
        }

        public class If : PrimitiveFunction
        {
            public If()
                : base("if", "('A bool ('A -> 'B) ('A -> 'B) -> 'B)",
                    "executes one predicate or another whether the condition is true", "level0,control")
            { }

            public override void Eval(Executor exec)
            {
                Function onfalse = exec.TypedPop<Function>();
                Function ontrue = exec.TypedPop<Function>();

                if ((bool)exec.Pop()) {
                    ontrue.Eval(exec);
                }
                else {
                    onfalse.Eval(exec);
                }
            }
        }

        public class BinRec : PrimitiveFunction
        {
            // The fact that it takes 'b instead of 'B is a minor optimization for untyped implementations
            // I may ignore it later on.
            public BinRec()
                : base("bin_rec", "('a ('a -> bool) ('a -> 'b) ('a -> 'C 'a 'a) ('C 'b 'b -> 'b) -> 'b)",
                    "execute a binary recursion process", "level1,control")
            { }

            public class BinRecHelper
            {
                Executor mExec;
                Function mResultRelation;
                Function mArgRelation;
                Function mBaseCase;
                Function mCondition;

                public BinRecHelper(Executor exec, Function fResultRelation, Function fArgRelation, Function fBaseCase, Function fCondition)
                {
                    mExec = exec;
                    mResultRelation = fResultRelation;
                    mArgRelation = fArgRelation;
                    mBaseCase = fBaseCase;
                    mCondition = fCondition;
                }

                public void LocalExec()
                {
                    mCondition.Eval(mExec);
                    if (mExec.PopBool())
                    {
                        mBaseCase.Eval(mExec);
                    }
                    else
                    {
                        mArgRelation.Eval(mExec);                        
                        Object o = mExec.Pop();
                        LocalExec();
                        mExec.Push(o);
                        LocalExec();
                        mResultRelation.Eval(mExec);
                    }                    
                }

                static public void LaunchThread(Object o)
                {
                    BinRecHelper h = o as BinRecHelper;
                    try
                    {
                        h.LocalExec();
                    }
                    finally
                    {
                        mWait.Set();
                    }
                }

                static EventWaitHandle mWait = new EventWaitHandle(false, EventResetMode.AutoReset);

                public void Exec()
                {
                    if (!Config.gbMultiThreadBinRec)
                    {
                        LocalExec();
                        return;
                    }
                    
                    mCondition.Eval(mExec);

                    if (mExec.PopBool())
                    {
                        mBaseCase.Eval(mExec);
                    }
                    else
                    {
                        mArgRelation.Eval(mExec);

                        Executor e2;
                        e2 = new Executor();
                        e2.Push(mExec.Pop());
                        BinRecHelper h2 = new BinRecHelper(e2, mResultRelation, mArgRelation, mBaseCase, mCondition);
                        Thread t = new Thread(new ParameterizedThreadStart(LaunchThread));
                        t.Start(h2);

                        LocalExec();
                        mWait.WaitOne();
                        mExec.Push(e2.Pop());
                        mResultRelation.Eval(mExec);
                    }
                }
            }

            public override void Eval(Executor exec)
            {
                Function fResultRelation = exec.PopFxn();
                Function fArgRelation = exec.PopFxn();
                Function fBaseCase = exec.PopFxn();
                Function fCondition = exec.PopFxn();

                BinRecHelper h = new BinRecHelper(exec, fResultRelation, fArgRelation, fBaseCase, fCondition);
                h.Exec();
            }
        }

        public class Throw : PrimitiveFunction
        {
            public Throw()
                : base("throw", "(any -> )", "throws an exception", "level2,control")
            { }

            public override void Eval(Executor exec)
            {
                object o = exec.Pop();
                throw new CatException(o);
            }
        }

        public class TryCatch : PrimitiveFunction
        {
            public TryCatch()
                : base("try_catch", "(( -> 'A) (exception -> 'A) -> 'A)", "evaluates a function, and catches any exceptions", "level2,control")
            { }

            public override void Eval(Executor exec)
            {
                Function c = exec.TypedPop<Function>();
                Function t = exec.TypedPop<Function>();
                int n = exec.Count();
                try
                {
                    t.Eval(exec);
                }
                catch (CatException e)
                {
                    exec.ClearTo(n);
                    Output.WriteLine("exception caught");

                    exec.Push(e.GetObject());
                    c.Eval(exec);
                }
            }
        }
        #endregion 

        #region boolean functions
        public class True : PrimitiveFunction
        {
            public True()
                : base("true", "( -> bool)", "pushes the boolean value true on the stack", "level0,boolean")
            { }

            public override void Eval(Executor exec)
            {
                exec.PushBool(true);
            }
        }

        public class False : PrimitiveFunction
        {
            public False()
                : base("false", "( -> bool)", "pushes the boolean value false on the stack", "level0,boolean")
            { }

            public override void Eval(Executor exec)
            {
                exec.PushBool(false);
            }
        }

        public class And : PrimitiveFunction
        {
            public And()
                : base("and", "(bool bool -> bool)", "returns true if both of the top two values on the stack are true", "level0,boolean")
            { }

            public override void Eval(Executor exec)
            {
                bool x = (bool)exec.Pop();
                bool y = (bool)exec.Pop();
                exec.PushBool(x && y);
            }
        }

        public class Or : PrimitiveFunction
        {
            public Or()
                : base("or", "(bool bool -> bool)", "returns true if either of the top two values on the stack are true", "level0,boolean")
            { }

            public override void Eval(Executor exec)
            {
                bool x = (bool)exec.Pop();
                bool y = (bool)exec.Pop();
                exec.PushBool(x || y);
            }
        }

        public class Not : PrimitiveFunction
        {
            public Not()
                : base("not", "(bool -> bool)", "returns true if the top value on the stack is false", "level0,boolean")
            { }

            public override void Eval(Executor exec)
            {
                exec.PushBool(!(bool)exec.Pop());
            }
        }
        #endregion

        #region type functions
        public class TypeName : PrimitiveFunction
        {
            public TypeName()
                : base("typename", "(any -> string)", "returns the name of the type of an object", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                Object o = exec.Pop();
                exec.PushString(CatKind.TypeNameFromObject(o));
            }
        }
        public class TypeId : PrimitiveFunction
        {
            public TypeId()
                : base("typeof", "(any -> any type)", "returns a type tag for an object", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                // TODO: fix this some day
                Object o = exec.Peek();
                if (o is CatList)
                {
                    // HACK: this is not the correct type! 
                    exec.Push(typeof(CatList));
                }
                else if (o is Function)
                {
                    // HACK: this is not the correct type! 
                    exec.Push((o as Function).GetFxnType());
                }
                else 
                {
                    // HACK: this is not the correct type! 
                    exec.Push(o.GetType());
                }
            }
        }
        public class TypeType : PrimitiveFunction
        {
            public TypeType()
                : base("type_type", "( -> type)", "pushes a value representing the type of a type", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(typeof(Type));
            }
        }
        public class IntType : PrimitiveFunction
        {
            public IntType()
                : base("int_type", "( -> type)", "pushes a value representing the type of an int", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(typeof(int));
            }
        }
        public class StrType : PrimitiveFunction
        {
            public StrType()
                : base("string_type", "( -> type)", "pushes a value representing the type of a string", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(typeof(string));
            }
        }
        public class DblType : PrimitiveFunction
        {
            public DblType()
                : base("double_type", "( -> type)", "pushes a value representing the type of a double", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(typeof(double));
            }
        }
        public class ByteType : PrimitiveFunction
        {
            public ByteType()
                : base("byte_type", "( -> type)", "pushes a value representing the type of a byte", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(typeof(byte));
            }
        }
        public class BitType : PrimitiveFunction
        {
            public BitType()
                : base("bit_type", "( -> type)", "pushes a value representing the type of a bit", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(typeof(Bit));
            }
        }
        public class BoolType : PrimitiveFunction
        {
            public BoolType()
                : base("bool_type", "( -> type)", "pushes a value representing the type of a boolean", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(typeof(Bit));
            }
        }
        public class TypeEq : PrimitiveFunction
        {
            public TypeEq()
                : base("type_eq", "(type type -> bool)", "returns true if either type is assignable to the other", "level1,types")
            { }

            public override void Eval(Executor exec)
            {
                Type t = exec.TypedPop<Type>();
                Type u = exec.TypedPop<Type>();
                exec.PushBool(t.Equals(u) || u.Equals(t));
            }
        }
        // TODO: complete the type functions
        #endregion 

        #region date-time functions
        public class Now : PrimitiveFunction
        {
            public Now() : base("now", "( ~> date_time)", "pushes a value representing the current date and time", "level2,datetime") { }
            public override void Eval(Executor exec) { exec.Push(DateTime.Now); }
        }
        public class SubTime : PrimitiveFunction
        {
            public SubTime() : base("sub_time", "(date_time date_time -> time_span)", "computes the time period between two dates", "level2,datetime") { }
            public override void Eval(Executor exec) { DateTime x = exec.TypedPop<DateTime>(); DateTime y = exec.TypedPop<DateTime>(); exec.Push(y - x); }
        }
        public class AddTime : PrimitiveFunction
        {
            public AddTime() : base("add_time", "(date_time time_span -> date_time)", "computes a date by adding a time period to a date", "level2,datetime") { }
            public override void Eval(Executor exec) { TimeSpan x = exec.TypedPop<TimeSpan>(); DateTime y = exec.TypedPop<DateTime>(); exec.Push(y + x); }
        }
        public class ToMsec : PrimitiveFunction
        {
            public ToMsec() : base("to_msec", "(time_span -> int)", "computes the length of a time span in milliseconds", "level2,datetime") { }
            public override void Eval(Executor exec) { exec.Push(exec.TypedPop<TimeSpan>().TotalMilliseconds); }
        }
        #endregion 

        #region int functions
        public class AddInt : PrimitiveFunction
        {
            public AddInt() : base("add_int", "(int int -> int)", "adds two integers", "level0,math") { }            
            public override void Eval(Executor exec) { exec.PushInt(exec.PopInt() + exec.PopInt()); }
        }
        public class MulInt : PrimitiveFunction
        {
            public MulInt() : base("mul_int", "(int int -> int)", "multiplies two integers", "level0,math") { }
            public override void Eval(Executor exec) { exec.PushInt(exec.PopInt() * exec.PopInt()); }
        }
        public class DivInt : PrimitiveFunction
        {
            public DivInt() : base("div_int", "(int int -> int)", "divides the top value (an integer) from the second value (an integer)", "level0,math") { }
            public override void Eval(Executor exec) { int x = exec.PopInt(); int y = exec.PopInt(); exec.PushInt(y / x); }
        }
        public class SubInt : PrimitiveFunction
        {
            public SubInt() : base("sub_int", "(int int -> int)", "subtracts the top value (an integer) from the second value (an integer)", "level0,math") { }
            public override void Eval(Executor exec) { int x = exec.PopInt(); int y = exec.PopInt(); exec.PushInt(y - x);  }
        }
        public class ModInt : PrimitiveFunction
        {
            public ModInt() : base("mod_int", "(int int -> int)", "computes the remainder of dividing the top value (an integer) from the second value (an integer)", "level0,math") { }
            public override void Eval(Executor exec) { int x = exec.PopInt(); int y = exec.PopInt(); exec.PushInt(y % x); }
        }
        public class NegInt : PrimitiveFunction
        {
            public NegInt() : base("neg_int", "(int -> int)", "negates the top value", "level0,math") { }
            public override void Eval(Executor exec) { exec.PushInt(-exec.PopInt()); }
        }
        public class ComplInt : PrimitiveFunction
        {
            public ComplInt() : base("compl_int", "(int -> int)", "performs a bitwise complement of the top value", "level0,math") { }
            public override void Eval(Executor exec) { exec.PushInt(~exec.PopInt()); }
        }
        public class ShlInt : PrimitiveFunction
        {
            public ShlInt() : base("shl_int", "(int int -> int)", "shifts the second value left by the number of bits indicated on the top of the stack", "level0,math") { }
            public override void Eval(Executor exec) { exec.Swap(); exec.PushInt(exec.PopInt() << exec.PopInt()); }
        }
        public class ShrInt : PrimitiveFunction
        {
            public ShrInt() : base("shr_int", "(int int -> int)", "shifts the second value left by the number of bits indicated on the top of the stack", "level0,math") { }
            public override void Eval(Executor exec) { exec.Swap(); exec.PushInt(exec.PopInt() >> exec.PopInt()); }
        }
        public class GtInt : PrimitiveFunction
        {
            public GtInt() : base("gt_int", "(int int -> bool)", "replaces the top two values (integers) with true, if the second value is greater than the top value, otherwise pushes false", "level0,math") { }
            public override void Eval(Executor exec) { exec.Swap(); exec.PushBool(exec.PopInt() > exec.PopInt()); }
        }
        public class LtInt : PrimitiveFunction
        {
            public LtInt() : base("lt_int", "(int int -> bool)", "replaces the top two values (integers) with true, if the second value is less than the top value, otherwise pushes false", "level0,math") { }
            public override void Eval(Executor exec) { exec.Swap(); exec.PushBool(exec.PopInt() < exec.PopInt()); }
        }
        public class GtEqInt : PrimitiveFunction
        {
            public GtEqInt() : base("gteq_int", "(int int -> bool)", "replaces the top two values (integers) with true, if the second value is greater than or equal to the top value, otherwise pushes false", "level0,math") { }
            public override void Eval(Executor exec) { exec.Swap(); exec.PushBool(exec.PopInt() >= exec.PopInt()); }
        }
        public class LtEqInt : PrimitiveFunction
        {
            public LtEqInt() : base("lteq_int", "(int int -> bool)", "replaces the top two values (integers) with true, if the second value is less than or equal to the top value, otherwise pushes false", "level0,math") { }
            public override void Eval(Executor exec) { exec.Swap();  exec.PushBool(exec.PopInt() <= exec.PopInt()); }
        }
        #endregion

        // Notice at this point I use static functions instead of declaring objects.
        // this is simply because I am lazy, and these few dozen operations don't really merit documentation. 
        #region byte functions
        public static byte add_byte(byte x, byte y) { return (byte)(x + y); }
        public static byte sub_byte(byte x, byte y) { return (byte)(x - y); }
        public static byte div_byte(byte x, byte y) { return (byte)(x / y); }
        public static byte mul_byte(byte x, byte y) { return (byte)(x * y); }
        public static byte mod_byte(byte x, byte y) { return (byte)(x % y); }
        public static byte compl_byte(byte x) { return (byte)(~x); }
        public static byte shl_byte(byte x, byte y) { return (byte)(x << y); }
        public static byte shr_byte(byte x, byte y) { return (byte)(x >> y); }
        public static bool gt_byte(byte x, byte y) { return x > y; }
        public static bool lt_byte(byte x, byte y) { return x < y; }
        public static bool gteq_byte(byte x, byte y) { return x >= y; }
        public static bool lteq_byte(byte x, byte y) { return x <= y; }
        #endregion

        #region char functions
        public static int char_to_int(char c) { return (int)c; }
        public static char int_to_char(int n) { return (char)n; }
        public static string char_to_str(char c) { return c.ToString(); }
        #endregion

        #region bit functions
        public struct Bit
        {
            public bool m;
            public Bit(int n) { m = n != 0; }
            public Bit(bool x) { m = x; }
            public Bit add(Bit x) { return new Bit(m ^ x.m); }
            public Bit sub(Bit x) { return new Bit(m && !x.m); }
            public Bit mul(Bit x) { return new Bit(m && !x.m); }
            public Bit div(Bit x) { return new Bit(m && !x.m); }
            public Bit mod(Bit x) { return new Bit(m && !x.m); }
            public bool lteq(Bit x) { return !m || x.m; }
            public bool eq(Bit x) { return m == x.m; }
            public override bool Equals(object obj)
            {
                return (obj is Bit) && (((Bit)obj).m == m);
            }
            public override int GetHashCode()
            {
                return m.GetHashCode();
            }
            public override string ToString()
            {
                return m ? "0b1" : "0b0";
            }
        }
        public static Bit add_bit(Bit x, Bit y) { return x.add(y); }
        public static Bit sub_bit(Bit x, Bit y) { return x.sub(y); }
        public static Bit mul_bit(Bit x, Bit y) { return x.mul(y); }
        public static Bit div_bit(Bit x, Bit y) { return x.div(y); }
        public static Bit mod_bit(Bit x, Bit y) { return x.mod(y); }
        public static Bit compl_bit(Bit x) { return new Bit(!x.m); }
        public static bool neq_bit(Bit x, Bit y) { return !x.eq(y); }
        public static bool gt_bit(Bit x, Bit y) { return !x.lteq(y); }
        public static bool lt_bit(Bit x, Bit y) { return !x.eq(y) && x.lteq(y); }
        public static bool gteq_bit(Bit x, Bit y) { return x.eq(y) || !x.lteq(y); }
        public static bool lteq_bit(Bit x, Bit y) { return x.lteq(y); }
        public static Bit min_bit(Bit x, Bit y) { return new Bit(x.m && y.m); }
        public static Bit max_bit(Bit x, Bit y) { return new Bit(x.m || y.m); }
        #endregion

        #region double functions
        public static double add_dbl(double x, double y) { return x + y; }
        public static double sub_dbl(double x, double y) { return x - y; }
        public static double div_dbl(double x, double y) { return x / y; }
        public static double mul_dbl(double x, double y) { return x * y; }
        public static double mod_dbl(double x, double y) { return x % y; }
        public static double inc_dbl(double x) { return x + 1; }
        public static double dec_dbl(double x) { return x - 1; }
        public static double neg_dbl(double x) { return -x; }
        public static bool gt_dbl(double x, double y) { return x > y; }
        public static bool lt_dbl(double x, double y) { return x < y; }
        public static bool gteq_dbl(double x, double y) { return x >= y; }
        public static bool lteq_dbl(double x, double y) { return x <= y; }
        public static double min_dbl(double x, double y) { return Math.Min(x, y); }
        public static double max_dbl(double x, double y) { return Math.Max(x, y); }
        public static double abs_dbl(double x) { return Math.Abs(x); }
        public static double pow_dbl(double x, double y) { return Math.Pow(x, y); }
        public static double sqr_dbl(double x) { return x * x; }
        public static double sin_dbl(double x) { return Math.Sin(x); }
        public static double cos_dbl(double x) { return Math.Cos(x); }
        public static double tan_dbl(double x) { return Math.Tan(x); }
        public static double asin_dbl(double x) { return Math.Asin(x); }
        public static double acos_dbl(double x) { return Math.Acos(x); }
        public static double atan_dbl(double x) { return Math.Atan(x); }
        public static double atan2_dbl(double x, double y) { return Math.Atan2(x, y); }
        public static double sinh_dbl(double x) { return Math.Sinh(x); }
        public static double cosh_dbl(double x) { return Math.Cosh(x); }
        public static double tanh_dbl(double x) { return Math.Tanh(x); }
        public static double sqrt_dbl(double x) { return Math.Sqrt(x); }
        public static double trunc_dbl(double x) { return Math.Truncate(x); }
        public static double round_dbl(double x) { return Math.Round(x); }
        public static double ceil_dbl(double x) { return Math.Ceiling(x); }
        public static double floor_dbl(double x) { return Math.Floor(x); }
        public static double log_dbl(double x, double y) { return Math.Log(x, y); }
        public static double log10_dbl(double x) { return Math.Log10(x); }
        public static double ln_dbl(double x) { return Math.Log(x); }
        public static double e() { return Math.E; }
        public static double pi() { return Math.PI; }
        public static string format_scientific(double x) { return x.ToString("E"); }
        public static string format_currency(double x) { return x.ToString("C"); }
        #endregion

        #region string functions
        public static bool gt_str(string x, string y) { return x.CompareTo(y) > 0; }
        public static bool lt_str(string x, string y) { return x.CompareTo(y) < 0; }
        public static bool gteq_str(string x, string y) { return x.CompareTo(y) >= 0; }
        public static bool lteq_str(string x, string y) { return x.CompareTo(y) <= 0; }
        public static string min_str(string x, string y) { return lteq_str(x, y) ? x : y; }
        public static string max_str(string x, string y) { return gteq_str(x, y) ? x : y; }
        public static string add_str(string x, string y) { return x + y; }
        public static string sub_str(string x, int i, int n) { return x.Substring(i, n); }
        public static string new_str(char c, int n) { return new string(c, n); }
        public static int index_of(string x, string y) { return x.IndexOf(y); }
        public static string replace_str(string x, string y, string z) { return x.Replace(y, z); }
        public static CatList str_to_list(string x) { return new CatList(x); }
        public static string list_to_str(CatList x) { string result = ""; foreach (Object o in x) result += o.ToString(); return result; }
        #endregion

        #region console functions
        public class Write : PrimitiveFunction
        {
            public Write()
                : base("write", "('a ~> )", "outputs the text representation of a value to the console","level1,console")
            { }

            public override void Eval(Executor exec)
            {
                Output.Write(exec.Pop());
            }
        }

        public class WriteLn : PrimitiveFunction
        {
            public WriteLn()
                : base("writeln", "('a ~> )", "outputs the text representation of a value to the console followed by a newline character","level1,console")
            { }

            public override void Eval(Executor exec)
            {
                Output.WriteLine(exec.Pop());
            }
        }

        public class ReadLn : PrimitiveFunction
        {
            public ReadLn()
                : base("readln", "( ~> string)", "inputs a string from the console", "level1,console")
            { }

            public override void Eval(Executor exec)
            {
                exec.PushString(Console.ReadLine());
            }
        }

        public class ReadKey : PrimitiveFunction
        {
            public ReadKey()
                : base("readch", "( ~> char)", "inputs a single character from the console", "level1,console")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(Console.ReadKey().KeyChar);
            }
        }
        #endregion

        #region i/o functions
        public class OpenFileReader : PrimitiveFunction
        {
            public OpenFileReader()
                : base("file_reader", "(string -> istream)", "creates an input stream from a file name","level2,streams")
            { }

            public override void Eval(Executor exec)
            {
                string s = exec.PopString();
                exec.Push(File.OpenRead(s));
            }
        }

        public class OpenWriter : PrimitiveFunction
        {
            public OpenWriter()
                : base("file_writer", "(string -> ostream)", "creates an output stream from a file name", "level2,streams")
            { }

            public override void Eval(Executor exec)
            {
                string s = exec.PopString();
                exec.Push(File.Create(s));
            }
        }

        public class FileExists : PrimitiveFunction
        {
            public FileExists()
                : base("file_exists", "(string -> string bool)", "returns a boolean value indicating whether a file or directory exists", "level2,streams")
            { }

            public override void Eval(Executor exec)
            {
                string s = exec.PeekString();
                exec.Push(Directory.Exists(s));
            }
        }

        public class TmpFileName : PrimitiveFunction
        {
            public TmpFileName()
                : base("temp_file", "( -> string)", "creates a unique temporary file", "level2,streams")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(Path.GetTempFileName());
            }
        }

        /* TODO: reimplement these functions
         * 
        public class ReadBytes : PrimitiveFunction
        {
            public ReadBytes()
                : base("read_bytes", "(istream int -> istream byte_block)", "reads a number of bytes into an array from an input stream")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                Stream f = exec.TypedPeek<Stream>();
                byte[] ab = new byte[n];
                f.Read(ab, 0, n);
                exec.Push(new MArray<byte>(ab)); 
            }
        }

        public class WriteBytes : PrimitiveFunction
        {
            public WriteBytes()
                : base("write_bytes", "(ostream byte_block -> ostream)", "writes a byte array to an output stream")
            { }

            public override void Eval(Executor exec)
            {
                MArray<byte> mb = exec.TypedPop<MArray<byte>>();
                Stream f = exec.TypedPeek<Stream>();
                f.Write(mb.m, 0, mb.Count());
            }
        }
        */

        public class CloseStream : PrimitiveFunction
        {
            public CloseStream()
                : base("close_stream", "(stream ~> )", "closes a stream", "level2,streams")
            { }

            public override void Eval(Executor exec)
            {
                Stream f = exec.TypedPop<Stream>();
                f.Flush();
                f.Close();
                f.Dispose();
            }
        }
        #endregion

        #region hash functions
        public class MakeHashList : PrimitiveFunction
        {
            public MakeHashList()
                : base("hash_list", "( -> hash_list)", "makes an empty hash list", "level2,hash")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(new HashList());
            }
        }

        public class HashGet : PrimitiveFunction
        {
            public HashGet()
                : base("hash_get", "(hash_list any -> hash_list any)", "gets a value from a hash list using a key", "level2,hash")
            { }

            public override void Eval(Executor exec)
            {
                Object key = exec.Pop();
                HashList hash = exec.TypedPeek<HashList>();
                Object value = hash.Get(key);
                exec.Push(value);
            }
        }

        public class HashSet : PrimitiveFunction
        {
            public HashSet()
                : base("hash_set", "(hash_list any any -> hash_list)", "associates the second value with a key (the top value) in a hash list", "level2,hash")
            { }

            public override void Eval(Executor exec)
            {
                Object key = exec.Pop();
                Object value = exec.Pop();
                HashList hash = exec.TypedPeek<HashList>();
                hash.Set(key, value);
            }
        }

        public class HashAdd : PrimitiveFunction
        {
            public HashAdd()
                : base("hash_add", "(hash_list any any -> hash_list)", "associates the second value with a key (the top value) in a hash list", "level2,hash")
            { }

            public override void Eval(Executor exec)
            {
                Object key = exec.Pop();
                Object value = exec.Pop();
                HashList hash = exec.TypedPeek<HashList>();
                hash.Add(key, value);
            }
        }

        public class HashContains : PrimitiveFunction
        {
            public HashContains()
                : base("hash_contains", "(hash_list any -> hash_list bool)", "returns true if hash list contains key", "level2,hash")
            { }

            public override void Eval(Executor exec)
            {
                Object key = exec.Pop();
                HashList hash = exec.TypedPeek<HashList>();
                exec.PushBool(hash.ContainsKey(key));
            }
        }

        public class HashToList : PrimitiveFunction
        {
            public HashToList()
                : base("hash_to_list", "(hash_list -> list)", "converts a hash_list to a list of pairs", "level2,hash")
            { }

            public override void Eval(Executor exec)
            {
                HashList hash = exec.TypedPop<HashList>();
                exec.Push(hash.ToArray());
            }
        }
        #endregion 

        #region list functions
        public class List : PrimitiveFunction
        {
            public List()
                : base("list", "(( -> 'A) -> list)", "creates a list from a function", "level0,lists")
            { }

            public override void Eval(Executor exec)
            {
                Function f = exec.TypedPop<Function>();
                Executor e2 = new Executor();
                f.Eval(e2);
                CatList list = e2.GetStackAsList();
                exec.Push(list);
            }
        }

        public class Map : PrimitiveFunction
        {
            public Map()
                : base("map", "(list ('a -> 'b) -> list)", "creates a list from another by transforming every value using the supplied function", "level0,lists")
            { }

            public override void Eval(Executor exec)
            {
                Function f = exec.TypedPop<Function>();
                CatList list = exec.TypedPeek<CatList>();

                int n = exec.Count();
                for (int i = 0; i < list.Count; ++i)
                {
                    exec.Push(list[i]);
                    f.Eval(exec);
                    if (exec.Count() != n + 1)
                        throw new Exception("dynamic type-checking error in map function");
                    list[i] = exec.Pop();
                }
            }
        }

        public class IsEmpty : PrimitiveFunction
        {
            public IsEmpty()
                : base("empty", "(list -> list bool)", "returns true if the list is empty", "level0,lists")
            { }

            public override void Eval(Executor exec)
            {
                CatList list = exec.TypedPeek<CatList>();
                exec.PushBool(list.IsEmpty());
            }
        }

        public class Count : PrimitiveFunction
        {
            public Count()
                : base("count", "(list -> list int)", "returns the number of items in a list", "level1,lists")
            { }

            public override void Eval(Executor exec)
            {
                CatList list = exec.TypedPeek<CatList>();
                exec.Push(list.Count);
            }
        }

        public class Nil : PrimitiveFunction
        {
            public Nil()
                : base("nil", "( -> list)", "creates an empty list", "level0,lists")
            { }

            public override void  Eval(Executor exec)
            {
 	            exec.Push(new CatList());
            }
        }

        public class Cons : PrimitiveFunction
        {
            public Cons()
                : base("cons", "(list 'a -> list)", "prepends an item to a list", "level0,lists")
            { }

            public override void Eval(Executor exec)
            {
                object x = exec.Pop();
                CatList list = exec.TypedPeek<CatList>();
                list.Add(x);
            }
        }

        public class Uncons : PrimitiveFunction
        {
            public Uncons()
                : base("uncons", "(list -> list any)", "returns the top of the list, and the rest of a list", "level0,lists")
            {}

            public override void Eval(Executor exec)
            {
                CatList list = exec.TypedPeek<CatList>();
                Object o = list[list.Count - 1];
                list.RemoveAt(list.Count - 1);
                exec.Push(o);
            }
        }

        public class Cat : PrimitiveFunction
        {
            public Cat()
                : base("cat", "(list list -> list)", "concatenates two lists", "level1,lists")
            { }

            public override void Eval(Executor exec)
            {
                CatList second = exec.TypedPop<CatList>();
                CatList first = exec.TypedPeek<CatList>();
                first.AddRange(second);
            }
        }

        public class GetAt : PrimitiveFunction
        {
            public GetAt()
                : base("get_at", "(list int -> list any)", "returns the nth item in a list", "level1,lists")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                CatList list = exec.TypedPeek<CatList>();
                exec.Push(list[list.Count - n - 1]);
            }
        }

        public class SetAt : PrimitiveFunction
        {
            public SetAt()
                : base("set_at", "(list 'a int -> list)", "sets an item in a list", "level1,lists")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                Object o = exec.Pop();
                CatList list = exec.TypedPeek<CatList>();
                list[n] = o;
            }
        }

        public class SwapAt : PrimitiveFunction
        {
            public SwapAt()
                : base("swap_at", "(list any int -> list any)", "swaps an item, with an item in the list", "level1,lists")
            { }

            public override void Eval(Executor exec)
            {
                int n = exec.PopInt();
                Object o = exec.Pop();
                CatList list = exec.TypedPeek<CatList>();
                Object x = list[n];
                list[n] = o;
                exec.Push(x);
            }
        }
        #endregion

        #region misc functions
        public class RandomInt : PrimitiveFunction
        {
            static Random mGen = new Random();

            public RandomInt()
                : base("rnd_int", "(int ~> int)", "creates a random integer between zero and some maximum value", "level1,misc")
            { }

            public override void Eval(Executor exec)
            {
                exec.PushInt(mGen.Next(exec.PopInt()));
            }
        }

        public class RandomDbl : PrimitiveFunction
        {
            static Random mGen = new Random();

            public RandomDbl()
                : base("rnd_dbl", "( ~> double)", "creates a random floating point number between zero and 1.0", "level1,misc")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(mGen.NextDouble());
            }
        }

        public class Null : PrimitiveFunction
        {
            public Null()
                : base("null", "( -> " + CatClass.GetNullType() + ")", "returns the default object with no fields")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(CatObject.GetNullObject());
            }
        }
        #endregion 

        #region casting functions
        public class AsVar : PrimitiveFunction
        {
            public AsVar()
                : base("as_var", "('a -> var)", "casts anything into a variant", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                // does nothing.
            }
        }

        public class AsBool : PrimitiveFunction
        {
            public AsBool()
                : base("as_bool", "(any -> bool)", "casts a variant to a bool", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                exec.PushBool(exec.PopBool());
            }
        }

        public class AsInt : PrimitiveFunction
        {
            public AsInt()
                : base("as_int", "(any -> int)", "casts a variant to an int", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                exec.PushInt(exec.PopInt());
            }
        }

        public class AsList : PrimitiveFunction
        {
            public AsList()
                : base("as_list", "(any -> list)", "casts a variant to a list", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(exec.TypedPop<CatList>());
            }
        }

        public class AsString : PrimitiveFunction
        {
            public AsString()
                : base("as_string", "(any -> string)", "casts a variant to a char", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                exec.PushString(exec.PopString());
            }
        }

        public class AsDbl : PrimitiveFunction
        {
            public AsDbl()
                : base("as_dbl", "(any -> double)", "casts a variant to a double", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(exec.TypedPop<double>());
            }
        }

        public class AsChar : PrimitiveFunction
        {
            public AsChar()
                : base("as_char", "(any -> char)", "casts a variant to a double", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(exec.TypedPop<double>());
            }
        }        

        public class ToInt : PrimitiveFunction
        {
            public ToInt()
                : base("to_int", "(any -> int)", "coerces any value to an integer", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                Object o = exec.Pop();
                if (o is int) { exec.Push(o); }
                else if (o is double) { exec.Push((int)(Double)o); }
                else if (o is char) { exec.Push((int)(Char)o); }
                else if (o is string) { exec.Push(Int32.Parse(o as String)); }
                else if (o is bool) { exec.Push((Boolean)o ? 1 : 0); }
                else if (o is Bit) { exec.Push(((Bit)(o)).m ? 1 : 0); }
                else if (o is Stack) { exec.Push((o as Stack).Count); }
                else { exec.PushInt(0); }
            }
        }

        public class ToStr : PrimitiveFunction
        {
            public ToStr()
                : base("to_str", "(any -> str)", "coerces any value to a string", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                Object o = exec.Pop();
                exec.Push(o.ToString());
            }
        }

        public class ToBool : PrimitiveFunction
        {
            public ToBool()
                : base("to_bool", "(any -> bool)", "coerces any value to a boolean", "level1,conversion")
            { }

            public override void Eval(Executor exec)
            {
                Object o = exec.Pop();
                if (o is int) { exec.Push(o); }
                else if (o is double) { exec.Push((Double)o != 0.0); }
                else if (o is char) { exec.Push((int)(Char)o != 0); }
                else if (o is string) { exec.Push(Boolean.Parse(o as String)); }
                else if (o is bool) { exec.Push(o); }
                else if (o is Bit) { exec.Push(((Bit)(o)).m); }
                else if (o is Stack) { exec.Push((o as Stack).Count == 0); }
                else { exec.PushBool(false); }
            }
        }
        #endregion

        #region graphics primitives 
#if (!NOGRAPHICS)
        public class OpenWindow : PrimitiveFunction
        {
            public OpenWindow()
                : base("open_window", "( ~> )", "opens a drawing window", "level2,graphics")
            { }

            public override void Eval(Executor exec)
            {
                WindowGDI.OpenWindow();
            }
        }

        public class SaveWindow  : PrimitiveFunction
        {
            public SaveWindow()
                : base("save_window", "(string ~> )", "saves a bitmap of the viewport", "level2,graphics")
            { }

            public override void Eval(Executor exec)
            {
                WindowGDI.SaveToFile(exec.TypedPop<string>());
            }
        }

        public class CloseWindow : PrimitiveFunction
        {
            public CloseWindow()
                : base("close_window", "( ~> )", "close a drawing window", "level2,graphics")
            { }

            public override void Eval(Executor exec)
            {
                WindowGDI.CloseWindow();
            }
        }

        public class ClearWindow : PrimitiveFunction
        {
            public ClearWindow()
                : base("clear", "( ~> )", "clears the drawing window", "level2,graphics")
            { }

            public override void Eval(Executor exec)
            {
                WindowGDI.ClearWindow();
            }
        }

        public class Render : PrimitiveFunction
        {
            public Render()
                : base("render", "(list string ~> )", "sends a drawing instruction to the graphics device", "level2,graphics")
            { }

            public override void Eval(Executor exec)
            {
                string s = exec.TypedPop<string>();
                CatList f = exec.TypedPop<CatList>();
                Object[] args = f.ToArray();
                GraphicCommand c = new GraphicCommand(s, args);
                WindowGDI.Render(c);
            }
        }
#endif
        #endregion

        #region .NET (CLR) reflection API
        public class Invoke : PrimitiveFunction
        {
            public Invoke()
                : base("clr_invoke", "(list string any -> any any)", "calls a method on a .NET object", "clr")
            { }

            public override void Eval(Executor exec)
            {
                Object self = exec.Pop();
                string s = exec.TypedPop<string>();
                CatList a = exec.TypedPop<CatList>();
                MethodInfo m = self.GetType().GetMethod(s, a.GetTypeArray());
                if (m == null)
                    throw new Exception("could not find method " + s + " on object of type " + self.GetType().ToString() + " with matching types");
                Object o = m.Invoke(self, a.ToArray());
                exec.Push(o);
                exec.Push(self);
            }
        }

        public class SetField : PrimitiveFunction
        {
            public SetField()
                : base("clr_set_field", "(any string any -> any)", "assigns a value to a field of a .NET object", "clr")
            { }

            public override void Eval(Executor exec)
            {
                Object self = exec.Pop();
                string s = exec.TypedPop<string>();
                Object val = exec.Pop();
                FieldInfo fi = self.GetType().GetField(s);
                if (fi == null)
                    throw new Exception("could not find field " + s + " on object of type " + self.GetType().ToString());
                fi.SetValue(self, val);
                exec.Push(self);
            }
        }

        public class GetField : PrimitiveFunction
        {
            public GetField()
                : base("clr_get_field", "(string any -> any any)", "retrieves the value of a field from a .NET object", "clr")
            { }

            public override void Eval(Executor exec)
            {
                Object self = exec.Pop();
                string s = exec.TypedPop<string>();
                FieldInfo fi = self.GetType().GetField(s);
                if (fi == null)
                    throw new Exception("could not find field " + s + " on object of type " + self.GetType().ToString());
                exec.Push(fi.GetValue(self));
                exec.Push(self);
            }
        }

        public class ListFields : PrimitiveFunction
        {
            public ListFields()
                : base("clr_list_fields", "(any -> list any)", "retrieves a list of field names from a .NET object", "clr")
            { }

            public override void Eval(Executor exec)
            {
                Object self = exec.Pop();
                List<string> list = new List<string>();
                FieldInfo[] fis = self.GetType().GetFields();
                foreach (FieldInfo fi in fis)
                    list.Add(fi.Name);
                string[] a = list.ToArray();
                exec.Push(new CatList(a));
                exec.Push(self);
            }
        }

        public class ListMethods : PrimitiveFunction
        {
            public ListMethods()
                : base("clr_list_methods", "(any -> list any)", "retrieves a list of field names from a .NET object", "clr")
            { }

            public override void Eval(Executor exec)
            {
                Object self = exec.Peek();
                List<string> list = new List<string>();
                FieldInfo[] fis = self.GetType().GetFields();
                foreach (FieldInfo fi in fis)
                    list.Add(fi.Name);
                string[] a = list.ToArray();
                exec.Push(new CatList(a));
            }
        }

        public class New : PrimitiveFunction
        {
            public New()
                : base("clr_new", "(list string -> any)", "constructs a new .NET object", "clr")
            { }

            public override void Eval(Executor exec)
            {
                string s = exec.TypedPop<string>();
                CatList a = exec.TypedPop<CatList>();
                Type t = Type.GetType(s);
                if (t == null)
                    throw new Exception("could not find type " + s);
                ConstructorInfo c = t.GetConstructor(a.GetTypeArray());
                if (c == null)
                    throw new Exception("could not find constructor for object of type " + t.ToString() + " with matching types");
                Object o = c.Invoke(a.ToArray());
                if (o == null)
                    throw new Exception(s + " object could not be constructed");
                exec.Push(o);
            }
        }

        public class ClrEnumerableToList : PrimitiveFunction
        {
            public ClrEnumerableToList()
                : base("clr_enumerable_to_list", "(any -> list)", "converts a .NET IEnumerable object into a list", "clr")
            { }

            public override void Eval(Executor exec)
            {
                IEnumerable e = exec.TypedPop<IEnumerable>();
                exec.Push(new CatList(e));
            }
        }
        #endregion

        #region regular expressions
        public class MakeRegex : PrimitiveFunction
        {
            public MakeRegex()
                : base("regex", "(string -> regex)", "constructs a regular expression matcher", "clr")
            { }

            public override void Eval(Executor exec)
            {   
                exec.Push(new Regex(exec.TypedPop<string>()));
            }
        }

        public class ReMatch : PrimitiveFunction
        {
            public ReMatch()
                : base("re_match", "(string regex -> list)", "matches the regular expression", "clr")
            { }

            public override void Eval(Executor exec)
            {
                Regex re = exec.TypedPop<Regex>();
                string s = exec.TypedPop<string>();
                List<string> list = new List<string>();
                foreach (Match m in re.Matches(s))
                    list.Add(m.Value);
                CatList f = new CatList(list);
                exec.Push(f);
            }
        }

        public class ReFind : PrimitiveFunction
        {
            public ReFind()
                : base("re_find", "(string regex -> string int)", "finds the regular expression", "clr")
            { }

            public override void Eval(Executor exec)
            {
                Regex re = exec.TypedPop<Regex>();
                string s = exec.TypedPeek<string>();
                Match m = re.Match(s);
                if (m == null)
                    exec.Push(-1);
                else
                    exec.Push(m.Index);
            }
        }
        #endregion

        #region references 
        public class Ref
        {
            Object val;
            public Ref(Object o) { val = o; }
            public Object GetVal() { return val; }
            public Ref SetVal(Object o) { val = o; return this; }            
        }

        public class MakeRef : PrimitiveFunction
        {
            public MakeRef()
                : base("ref", "('a -> ref)", "creates a reference", "level2,ref")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(new Ref(exec.Pop()));
            }
        }

        public class GetVal : PrimitiveFunction
        {
            public GetVal()
                : base("getval", "(ref ~> ref any)", "gets value associated with reference", "level2,ref")
            { }

            public override void Eval(Executor exec)
            {
                exec.Push(exec.TypedPop<Ref>().GetVal());
            }
        }
        
        public class SetVal : PrimitiveFunction
        {
            public SetVal()
                : base("setval", "(ref any ~> ref)", "sets a reference to a new value", "level2,ref")
            { }

            public override void Eval(Executor exec)
            {
                Object o = exec.Pop();
                exec.TypedPeek<Ref>().SetVal(o);
            }
        }
        #endregion
    }
}
