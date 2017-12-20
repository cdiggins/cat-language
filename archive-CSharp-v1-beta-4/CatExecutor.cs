/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Reflection;
using System.Reflection.Emit;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Diagnostics;
using System.ComponentModel;
using System.Text.RegularExpressions;

namespace Cat
{
    public interface INameLookup
    {
        Function Lookup(string s);
        Function ThrowingLookup(string s);
    }

    public class Executor : INameLookup
    {
        public TextReader input = Console.In;
        public TextWriter output = Console.Out;
        private Dictionary<string, Function> dictionary = new Dictionary<string, Function>();
        INameLookup otherNames;
        List<Object> stack = new List<Object>();

        public int testCount = 0;
        public bool bTrace = false;

        public Executor()
        {
            RegisterType(typeof(MetaCommands));
            RegisterType(typeof(Primitives));
        }

        public Executor(INameLookup other)
        {
            otherNames = other;
        }
        
        public Object Peek()
        {
            if (stack.Count == 0)
                throw new Exception("stack underflow occured");
            return stack[stack.Count - 1];
        }

        public void Push(Object o)
        {
            stack.Add(o);
        }

        public Object Pop()
        {
            Object o = Peek();
            stack.RemoveAt(stack.Count - 1);
            return o;
        }

        public Object PeekBelow(int n)
        {
            if (stack.Count <= n)
                throw new Exception("stack underflow occured");
            return stack[stack.Count - 1 - n];
        }

        public int Count()
        {
            return stack.Count;
        }

        public Object[] GetStackAsArray()
        {
            return stack.ToArray();
        }

        public void Dup()
        {
            if (Peek() is CatList)
                Push((Peek() as CatList).Clone());
            else
                Push(Peek());
        }

        public void Swap()
        {
            if (stack.Count < 2)
                throw new Exception("stack underflow occured");
            Object tmp = stack[stack.Count - 2];
            stack[stack.Count - 2] = stack[stack.Count - 1];
            stack[stack.Count - 1] = tmp;
        }

        public bool IsEmpty()
        {
            return Count() == 0;
        }

        public void Clear()
        {
            stack.Clear();
        }

        public string StackToString()
        {
            if (IsEmpty()) return "_empty_";
            string s = "";
            int nMax = 5;
            if (Count() > nMax) s = "...";
            if (Count() < nMax) nMax = Count();
            for (int i = nMax - 1; i >= 0; --i)
            {
                Object o = PeekBelow(i);
                s += Output.ObjectToString(o) + " ";
            }
            return s;
        }

        public T TypedPop<T>()
        {
            T result = TypedPeek<T>();
            Pop();
            return result;
        }

        public T TypedPeek<T>()
        {
            Object o = Peek();

            if (!(o is T))
                throw new Exception("Expected type " + typeof(T).Name + " but instead found " + o.GetType().Name);

            return (T)o;
        }

        public void PushInt(int n)
        {
            Push(n);
        }

        public void PushBool(bool x)
        {
            Push(x);
        }

        public void PushString(string x)
        {
            Push(x);
        }

        public void PushFxn(Function x)
        {
            Push(x);
        }

        public int PopInt()
        {
            return TypedPop<int>();
        }

        public bool PopBool()
        {
            return TypedPop<bool>();
        }

        public QuotedFunction PopFxn()
        {
            return TypedPop<QuotedFunction>();
        }

        public String PopString()
        {
            return TypedPop<String>();
        }

        public CatList PopList()
        {
            return TypedPop<CatList>();
        }

        public Function PeekFxn()
        {
            return TypedPeek<Function>();
        }

        public String PeekString()
        {
            return TypedPeek<String>();
        }

        public int PeekInt()
        {
            return TypedPeek<int>();
        }

        public bool PeekBool()
        {
            return TypedPeek<bool>();
        }

        public CatList PeekList()
        {
            return TypedPeek<CatList>();
        }

        public void Import()
        {
            LoadModule(PopString());
        }

        public void LoadModule(string s)
        {
            bool b1 = Config.gbVerboseInference;
            bool b2 = Config.gbShowInferredType;
            Config.gbVerboseInference = Config.gbVerboseInferenceOnLoad;
            Config.gbShowInferredType = false;
            try
            {
                Execute(Util.FileToString(s));
            }
            catch (Exception e)
            {
                Output.WriteLine("Failed to load \"" + s + "\" with message: " + e.Message);
            }
            Config.gbVerboseInference = b1;
            Config.gbShowInferredType = b2;
        }

        public void Execute(string s)
        {
            List<CatAstNode> nodes = CatParser.Parse(s + "\n");
            Execute(nodes);
        }

        public void OutputStack()
        {
            Output.WriteLine("stack: " + StackToString());
        }

        public Function LiteralToFunction(string name, AstLiteral literal)
        {
            switch (literal.GetLabel())
            {
                case AstLabel.Int:
                    {
                        AstInt tmp = literal as AstInt;
                        return new PushInt(tmp.GetValue());
                    }
                case AstLabel.Bin:
                    {
                        AstBin tmp = literal as AstBin;
                        return new PushInt(tmp.GetValue());
                    }
                case AstLabel.Char:
                    {
                        AstChar tmp = literal as AstChar;
                        return new PushValue<char>(tmp.GetValue());
                    }
                case AstLabel.String:
                    {
                        AstString tmp = literal as AstString;
                        return new PushValue<string>(tmp.GetValue());
                    }
                case AstLabel.Float:
                    {
                        AstFloat tmp = literal as AstFloat;
                        return new PushValue<double>(tmp.GetValue());
                    }
                case AstLabel.Hex:
                    {
                        AstHex tmp = literal as AstHex;
                        return new PushInt(tmp.GetValue());
                    }
                case AstLabel.Quote:
                    {
                        AstQuote tmp = literal as AstQuote;
                        CatExpr fxns = NodesToFxns(name, tmp.GetTerms());
                        if (Config.gbOptimizeQuotations)
                            MetaCat.ApplyMacros(this, fxns);
                        return new PushFunction(fxns);
                    }
                case AstLabel.Lambda:
                    {
                        AstLambda tmp = literal as AstLambda;
                        CatLambdaConverter.Convert(tmp);
                        CatExpr fxns = NodesToFxns(name, tmp.GetTerms());
                        if (Config.gbOptimizeLambdas) 
                            MetaCat.ApplyMacros(this, fxns);
                        return new PushFunction(fxns);
                    }
                default:
                    throw new Exception("unhandled literal " + literal.ToString());
            }
        }

        void Trace(string s)
        {
            if (bTrace) Output.WriteLine("trace: " + s);
        }
        
        /// <summary>
        /// This function is optimized to handle tail-calls with increasing the stack size.
        /// </summary>
        /// <param name="fxns"></param>
        public void Execute(CatExpr fxns)
        {
            int i = 0;
            while (i < fxns.Count)
            {
                Function f = fxns[i];
                
                // Check if this is a tail call
                // if so then we are going to avoid creating a new stack frame
                if (i == fxns.Count - 1 && f.GetSubFxns() != null)
                {
                    Trace("tail-call of '" + f.GetName() + "' function");
                    fxns = f.GetSubFxns();
                    i = 0;
                }                   
                else if (i == fxns.Count - 1 && f is Primitives.If)
                {
                    Trace("tail-call of 'if' function");
                    QuotedFunction onfalse = PopFxn();
                    QuotedFunction ontrue = PopFxn();

                    if (PopBool())
                        fxns = ontrue.GetSubFxns(); else
                        fxns = onfalse.GetSubFxns();

                    i = 0;
                }
                else if (i == fxns.Count - 1 && f is Primitives.ApplyFxn)
                {
                    Trace("tail-call of 'apply' function");
                    QuotedFunction q = PopFxn();
                    fxns = q.GetSubFxns();
                    i = 0;
                }
                else
                {
                    Trace(f.ToString());
                    f.Eval(this);
                    ++i;
                }
            }
        }

        public CatExpr NodesToFxns(string name, List<CatAstNode> nodes)
        {
            CatExpr result = new CatExpr(); 
            for (int i = 0; i < nodes.Count; ++i)
            {
                CatAstNode node = nodes[i];
                if (node.GetLabel().Equals(AstLabel.Name))
                {
                    string s = node.ToString();
                    if (s.Equals(name))
                        result.Add(new SelfFunction(name));
                    else
                        result.Add(ThrowingLookup(s));
                }
                else if (node is AstLiteral)
                {
                    result.Add(LiteralToFunction(name, node as AstLiteral));
                }
                else if (node is AstDef)
                {
                    MakeFunction(node as AstDef);
                }
                else if (node is AstMacro)
                {
                    MetaCat.AddMacro(node as AstMacro);
                }
                else
                {
                    throw new Exception("unable to convert node to function: " + node.ToString());
                }
            }
            return result;
        }
        
        public void Execute(List<CatAstNode> nodes)
        {
            Execute(NodesToFxns("self", nodes));
        }

        public void ClearTo(int n)
        {
            while (Count() > n)
                Pop();
        }

        public CatList GetStackAsList()
        {
            return new CatList(stack);
        }

        #region dictionary management
        public void RegisterType(Type t)
        {
            foreach (Type memberType in t.GetNestedTypes())
            {
                // Is is it a function object
                if (typeof(Function).IsAssignableFrom(memberType))
                {
                    ConstructorInfo ci = memberType.GetConstructor(new Type[] { });
                    Object o = ci.Invoke(null);
                    if (!(o is Function))
                        throw new Exception("Expected only function objects in " + t.ToString());
                    Function f = o as Function;
                    AddFunction(f);
                }
                else
                {
                    RegisterType(memberType);
                }
            }
            foreach (MemberInfo mi in t.GetMembers())
            {
                if (mi is MethodInfo)
                {
                    MethodInfo meth = mi as MethodInfo;
                    if (meth.IsStatic) {
                        Function f = AddMethod(null, meth);
                        if (f != null)
                            f.msTags = "level2";
                    }
                }
            }
        }

        /// <summary>
        /// Creates an ObjectBoundMethod for each public function in the object
        /// </summary>
        /// <param name="o"></param>
        public void RegisterObject(Object o)
        {
            foreach (MemberInfo mi in o.GetType().GetMembers())
            {
                if (mi is MethodInfo)
                {
                    MethodInfo meth = mi as MethodInfo;
                    AddMethod(o, meth);
                }
            }
        }

        #region INameLookup implementation
        public Function Lookup(string s)
        {
            if (s.Length < 1)
                throw new Exception("trying to lookup a function with no name");

            if (dictionary.ContainsKey(s))
                return dictionary[s];

            if (otherNames != null)
                return otherNames.Lookup(s);

            return null;
        }

        public Function ThrowingLookup(string s)
        {
            Function f = Lookup(s);
            if (f == null)
                throw new Exception("could not find function " + s);
            return f;
        }
        #endregion

        /// <summary>
        /// Methods allow overloading of function definitions.
        /// </summary>
        public Function AddMethod(Object o, MethodInfo mi)
        {
            // Does not add public methods. 
            if (!mi.IsPublic)
                return null;                

            if (mi.IsStatic)
                o = null;

            Method f = new Method(o, mi);
            AddFunction(f);
            return f;
        }

        public List<Function> GetAllFunctions()
        {
            List<Function> fxns = new List<Function>(dictionary.Values);
            fxns.Sort(delegate(Function x, Function y) { 
                return x.GetName().CompareTo(y.GetName()); 
            });
            return fxns;
        }

        public Dictionary<string, List<Function>> GetFunctionsByTag()
        {
            Dictionary<string, List<Function> > ret = new Dictionary<string, List<Function>>();
            foreach (Function f in GetAllFunctions()) 
            {
                foreach (string s in f.GetTags()) 
                {
                    string s2 = s.Trim();
                    if (s.Length > 0)
                    {
                        if (!ret.ContainsKey(s2))
                            ret.Add(s2, new List<Function>());
                        ret[s2].Add(f);
                    }
                }
            }
            return ret;
        }


        public bool TestFunction(Function f)
        {
            bool bRet = true;
            testCount += 1;
            CatMetaDataBlock md = f.GetMetaData();
            if (md != null)
            {
                List<CatMetaData> tests = md.FindAll("test");
                foreach (CatMetaData test in tests)
                {
                    CatMetaData input = test.Find("in");
                    CatMetaData output = test.Find("out");
                    if (input == null || output == null)
                    {
                        Output.WriteLine("ill-formed test in " + f.GetName());
                        return false;
                    }
                    try
                    {
                        Executor aux = new Executor(this);
                        aux.Execute(input.GetContent());
                        CatList listInput = aux.GetStackAsList();
                        aux.Clear();
                        aux.Execute(output.GetContent());
                        CatList listOutput = aux.GetStackAsList();
                        aux.Clear();
                        
                        if (!listInput.Equals(listOutput))
                        {
                            Output.WriteLine("failed test for instruction " + f.GetName());
                            Output.WriteLine("test input program = " + input.GetContent());
                            Output.WriteLine("test output program = " + output.GetContent());
                            Output.WriteLine("input program result = " + listInput.ToString());
                            Output.WriteLine("output program result = " + listOutput.ToString());
                            bRet = false;
                        }
                    }
                    catch (Exception e)
                    {
                        Output.WriteLine("failed test for instruction " + f.GetName());
                        Output.WriteLine("exception occured: " + e.Message);
                        bRet = false;
                    }
                }
            }
            return bRet;
        }

        public Function MakeFunction(AstDef def) 
        {
            bool bLambda = def.mParams.Count > 0;
            if (bLambda)
                CatLambdaConverter.Convert(def);
            CatExpr fxns = NodesToFxns(def.mName, def.mTerms);
            Function ret = new DefinedFunction(def.mName, fxns);
            if (def.mpMetaData != null) {
                ret.SetMetaData(new CatMetaDataBlock(def.mpMetaData));
            }
            if (bLambda && Config.gbOptimizeLambdas)
                MetaCat.ApplyMacros(this, fxns);

            AddFunction(ret);
            return ret;
        }

        public Function AddFunction(Function f)
        {
            string s = f.GetName();
            if (dictionary.ContainsKey(s))
            {
                if (!Config.gbAllowRedefines)
                    throw new Exception("can not overload functions " + s);
                dictionary[s] = f;
            }
            else
            {
                dictionary.Add(s, f);
            }
            return f;
        }

        #endregion
    }
}
