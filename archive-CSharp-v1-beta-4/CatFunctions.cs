/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Reflection;
using System.Reflection.Emit;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;

namespace Cat
{
    /// <summary>
    /// The base class for all Cat functions. All functions can be invoked like one would 
    /// invoke a MethodInfo object. This is because each one contains its own private 
    /// executor;
    /// </summary>
    public abstract class Function : CatBase
    {
        public Function(string sName, string sDesc, string sTags)
        {
            msName = sName;
            msDesc = sDesc;
            msTags = sTags;
        }

        public Function(string sName, string sDesc)
            : this(sName, sDesc, "")
        {
        }
        
        public Function(string sName)
            : this(sName, "")
        {
        }

        #region Fields
        public string msName = "_unnamed_"; 
        public string msDesc = "";
        public string msTags = "";
        public CatFxnType mpFxnType;
        CatMetaDataBlock mpMetaData;
        #endregion

        public Function()
        {
        }
        public string GetDesc()
        {
            return msDesc;
        }
        public string GetName()
        {
            return msName;
        }
        public string GetRawTags()
        {
            return msTags;
        }
        public string[] GetTags()
        {
            return msTags.Split(new char[] { ',' });
        }
        public override string ToString()
        {
            return msName;
        }
        public string GetFxnTypeString()
        {
            if (GetFxnType() == null)
                return "untyped";
            else
                return GetFxnType().ToPrettyString();
        }
        public CatFxnType GetFxnType()
        {
            return mpFxnType;
        }
        public void SetMetaData(CatMetaDataBlock meta)
        {
            mpMetaData = meta;
            CatMetaData desc = meta.Find("desc");
            if (desc != null) 
            {
                msDesc = desc.msContent;
            }
            CatMetaData tags = meta.Find("tags");
            if (tags != null)
            {
                msTags = tags.msContent;
            }
        }
        public CatMetaDataBlock GetMetaData()
        {
            return mpMetaData;
        }

        public bool HasMetaData()
        {
            return ((mpMetaData != null) && (mpMetaData.Count > 0));
        }
  
        public void WriteTo(StreamWriter sw)
        {
            sw.Write("define ");
            sw.Write(msName);
            if (mpFxnType != null)
            {
                sw.Write(" : ");
                sw.Write(mpFxnType);
            }
            sw.WriteLine();
            if (mpMetaData != null)
            {
                sw.WriteLine("{{");
                sw.WriteLine(mpMetaData.ToString());
                sw.WriteLine("}}");
            }
            sw.WriteLine("{");
            sw.Write("  ");
            sw.WriteLine(ToString());
            sw.WriteLine("}");
        }

        #region virtual functions
        // TODO: rename to Execute
        public abstract void Eval(Executor exec);
        #endregion

        #region static functions
        public static Type GetReturnType(MethodBase m)
        {
            if (m is ConstructorInfo)
                return (m as ConstructorInfo).DeclaringType;
            if (!(m is MethodInfo))
                throw new Exception("Expected ConstructorInfo or MethodInfo");
            return (m as MethodInfo).ReturnType;
        }

        public static bool HasReturnType(MethodBase m)
        {
            Type t = GetReturnType(m);
            return (t != null) && (!t.Equals(typeof(void)));
        }

        public static bool HasThisType(MethodBase m)
        {
            if (m is ConstructorInfo)
                return false;
            return !m.IsStatic;
        }

        public static Type GetThisType(MethodBase m)
        {
            if (m is ConstructorInfo)
                return null;
            if (!(m is MethodInfo))
                throw new Exception("Expected ConstructorInfo or MethodInfo");
            if (m.IsStatic)
                return null;
            return (m as MethodInfo).DeclaringType;
        }

        public static string MethodToTypeString(MethodBase m)
        {
            string s = "('R ";

            if (HasThisType(m))
                s += CatKind.TypeToString(m.DeclaringType) + " ";

            foreach (ParameterInfo pi in m.GetParameters())
                s += CatKind.TypeToString(pi.ParameterType) + " ";

            s += "-> 'R";

            if (HasThisType(m))
                s += " this";

            if (HasReturnType(m))
                s += " " + CatKind.TypeToString(GetReturnType(m));

            s += ")";

            return s;
        }

        #endregion

        public virtual CatExpr GetSubFxns()
        {
            return null;
        }

        public IEnumerable<Function> GetDescendantFxns()
        {
            if (GetSubFxns() != null)
            {
                foreach (Function f in GetSubFxns())
                {
                    yield return f;
                    foreach (Function g in f.GetDescendantFxns())
                        yield return g;
                }
            }
        }

        public string GetImplString()
        {
            return GetImplString(false);
        }

        public string GetImplString(bool bHtml)
        {
            string sBegin = "define ";

            if (bHtml)
            {
                string sName = Util.ToHtml(GetName());
                sBegin += "<a href='#" + sName + "' name='" + sName + "'>" + sName + "</a>";
            }
            else
            {
                sBegin += GetName();
            }
            sBegin += " : " + GetFxnTypeString() + "\n";
            
            string s = "";
            if (GetMetaData() != null)
            {
                s += "{{\n";
                s += GetMetaData().ToString();
                s += "\n}}\n";
            }
            else if (GetDesc() != null)
            {
                s += "{{\n";
                if (GetDesc() != null && GetDesc().Length > 0)
                    s += "  desc:\n    " + GetDesc() + "\n";
                if (GetRawTags().Length > 0)
                    s += "  tags:\n    " + GetRawTags() + "\n";
                s += "}}\n";
            }

            s += "{\n  ";
            if (GetSubFxns() != null)
            {
                for (int i=0; i < GetSubFxns().Count; ++i) {
                    Function f = GetSubFxns()[i];
                    if (i >= 0) s += " ";
                    if (bHtml)
                        s += Util.ToHtml(f.ToString()); else
                        s += f.ToString();
                }
                s += "\n";
            }
            else
            {
                s += "_primitive_\n";
            }
            s += "}\n";
            
            if (bHtml) s = Util.ToHtml(s);
            return sBegin + s;
        }
    }

    /// <summary>
    /// Used to push stacks of values on a stack.
    /// Note: Not a PushValueBase subclass!
    /// This is used in the "pull" experimental function
    /// </summary>
    public class PushStack : Function 
    {
        Executor stk;
        
        public PushStack(Executor x)
        {
            stk = x;
        }

        public override void Eval(Executor exec)
        {
            foreach (object o in stk.GetStackAsArray())
                exec.Push(o);
        }

        public Executor GetStack()
        {
            return stk;
        }

        public override string ToString()
        {
            return "_stack_";
        }

        public override bool Equals(object obj)
        {
            return base.Equals(obj);
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }

    abstract public class PushValueBase : Function
    {
    }

    public class PushValue<T> : PushValueBase
    {
        CatMetaValue<T> mValue;
        string msValueType;
        
        public PushValue(T x)
        {
            mValue = new CatMetaValue<T>(x);
            msName = mValue.GetData().ToString();
            msValueType = CatKind.TypeNameFromObject(x);
            mpFxnType = CatFxnType.Create("( -> " + msValueType + ")");
        }
        public T GetValue()
        {
            return mValue.GetData();
        }

        public override string ToString()
        {
            return mValue.ToString();
        }

        #region overrides
        public override void Eval(Executor exec)
        {
            exec.Push(GetValue());
        }
        public override bool Equals(object obj)
        {
            if (!(obj is PushValue<T>))
                return false;
            return (obj as PushValue<T>).GetValue().Equals(GetValue());                
        }
        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
        #endregion
    }

    public class PushInt : PushValue<int>
    {
        public PushInt(int x)
            : base(x)
        { }

        #region overrides
        public override void Eval(Executor exec)
        {
            exec.PushInt(GetValue());
        }
        #endregion
    }

    public class PushBool : PushValue<bool>
    {
        public PushBool(bool x)
            : base(x)
        { }

        #region overrides
        public override void Eval(Executor exec)
        {
            exec.PushBool(GetValue());
        }
        #endregion
    }

    /// <summary>
    /// Represents a a function literal. In other words a function that pushes an anonymous function onto a stack.
    /// </summary>
    public class PushFunction : Function
    {
        CatExpr mSubFxns;
        QuotedFunction mQF;
        
        public PushFunction(CatExpr children)
        {
            mSubFxns = children.GetRange(0, children.Count);
            msDesc = "pushes an anonymous function onto the stack";
            msName = "_function_";

            if (Config.gbTypeChecking)
            {
                if (Config.gbVerboseInference)
                    Output.WriteLine("inferring type of quoted function " + msName);

                try
                {
                    // Quotations can be unclear?
                    CatFxnType childType = CatTypeReconstructor.Infer(mSubFxns);

                    // Honestly this should never be true.
                    if (childType == null)
                        throw new Exception("unknown type error");

                    mpFxnType = new CatQuotedType(childType);
                    mpFxnType = CatVarRenamer.RenameVars(mpFxnType);
                }
                catch (Exception e)
                {
                    Output.WriteLine("Could not type quotation: " + msName);
                    Output.WriteLine("Type error: " + e.Message);
                    mpFxnType = null;
                }
            }
            else
            {
                mpFxnType = null;
            }
        }

        public QuotedFunction GetQuotedFxn()
        {
            // An important optimization: this can be very slow.
            if (mQF == null)
                mQF = new QuotedFunction(mSubFxns, CatFxnType.Unquote(mpFxnType));
            return mQF;
        }

        public override void Eval(Executor exec)
        {
            exec.Push(GetQuotedFxn());
        }

        public CatExpr GetChildren()
        {
            return mSubFxns;
        }

        public override string ToString()
        {
            string ret = "[";
            for (int i = 0; i < mSubFxns.Count; ++i)
            {
                if (i > 0) ret += " ";
                ret += mSubFxns[i].ToString();
            }
            return ret + "]";
        }

        public override bool Equals(object obj)
        {
            if (!(obj is PushFunction))
                return false;
            return (obj as PushFunction).GetChildren().Equals(mSubFxns);
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }

    /// <summary>
    /// Represents a function that is on the stack.
    /// </summary>
    public class QuotedFunction : Function
    {
        CatExpr mSubFxns;
        
        public QuotedFunction(CatExpr children, CatFxnType pFxnType)
        {
            mSubFxns = new CatExpr(children.ToArray());
            msDesc = "anonymous function";
            msName = "_anonymous_";
            mpFxnType = new CatQuotedType(pFxnType);
        }

        public QuotedFunction(CatExpr children)
            : this(children, CatTypeReconstructor.Infer(children))
        {
        }

        public QuotedFunction()
        {
            mSubFxns = new CatExpr();
        }

        /*
        public CatFxnType GetUnquotedFxnType()
        {
            CatKind k = GetUnquotedKind();
            if (!(k is CatFxnType))
                throw new Exception("illegal type for a quoted function, should produce a single function : " + mpFxnType.ToString());
            return k as CatFxnType;
        }
         */

        public CatKind GetUnquotedKind()
        {
            if (mpFxnType.GetCons().GetKinds().Count != 0)
                throw new Exception("illegal type for a quoted function, should have no consumption : " + mpFxnType.ToString());
            if (mpFxnType.GetProd().GetKinds().Count != 1)
                throw new Exception("illegal type for a quoted function, should have a single production : " + mpFxnType.ToString());
            CatKind k = mpFxnType.GetProd().GetKinds()[0];
            return k;
        }

        public QuotedFunction(QuotedFunction first, QuotedFunction second)
        {
            mSubFxns = new CatExpr(first.GetSubFxns().ToArray());
            mSubFxns.AddRange(second.GetSubFxns().ToArray());

            msDesc = "anonymous composed function";
            msName = "";
            for (int i = 0; i < mSubFxns.Count; ++i)
            {
                if (i > 0) msName += " ";
                msName += mSubFxns[i].GetName();
            }

            try
            {
                mpFxnType = new CatQuotedType(CatTypeReconstructor.ComposeTypes(first.GetFxnType(), second.GetFxnType()));
                // TODO: remove once everythign tests okay.
                //mpFxnType = new CatQuotedType(CatTypeReconstructor.ComposeTypes(first.GetUnquotedFxnType(), second.GetUnquotedFxnType()));
            }
            catch (Exception e)
            {
                Output.WriteLine("unable to type quotation: " + ToString());
                Output.WriteLine("type error: " + e.Message);
                mpFxnType = null;
            }
        }

        public override void Eval(Executor exec)
        {
            exec.Execute(mSubFxns);
        }

        public override string ToString()
        {
            string ret = "[";
            for (int i = 0; i < mSubFxns.Count; ++i)
            {
                if (i > 0) ret += " ";
                ret += mSubFxns[i].ToString();
            }
            ret += "]";
            return ret;
        }

        public override CatExpr GetSubFxns()
        {
            return mSubFxns;
        }

        public override bool Equals(object obj)
        {
            if (!(obj is QuotedFunction))
                return false;
            return (obj as QuotedFunction).GetSubFxns().Equals(mSubFxns);
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }


    /// <summary>
    /// This class represents a dynamically created function, 
    /// e.g. the result of calling the quote function.
    /// </summary>
    public class QuotedValue : QuotedFunction
    {
        Function mFxn; 
        public QuotedValue(Object x)
        {
            mFxn = new PushValue<Object>(x);
            msName = x.ToString();
            if (mFxn.GetFxnType() != null)
                mpFxnType = mFxn.GetFxnType();
            GetSubFxns().Add(mFxn);
        }

        public override string ToString()
        {
            return "[" + msName + "]";
        }

        public Function GetFxn()
        {
            return mFxn;
        }

        public override void Eval(Executor exec)
        {
            mFxn.Eval(exec);
        }

        public override bool Equals(object obj)
        {
            if (!(obj is QuotedValue))
                return false;
            return (obj as QuotedValue).GetFxn().Equals(GetFxn());
                
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }

    /// <summary>
    /// Represents a function defined by the user
    /// </summary>
    public class DefinedFunction : Function
    {
        CatExpr mFunctions = new CatExpr();
        bool mbExplicitType = false;
        bool mbTypeError = false;

        public DefinedFunction(string s, CatExpr fxns)
        {
            msName = s;
            AddFunctions(fxns);
            ReplaceSelfFunctions(fxns);
        }

        private void ReplaceSelfFunctions(CatExpr fxns)
        {
            for (int i = 0; i < fxns.Count; ++i)
            {
                Function f = fxns[i];
                if (f is SelfFunction)
                    fxns[i] = this;
                if (f is PushFunction)
                    ReplaceSelfFunctions((f as PushFunction).GetChildren());
            }
        }

        public void AddFunctions(CatExpr fxns)
        {
            mFunctions.AddRange(fxns);
            msDesc = "";

            if (Config.gbVerboseInference && Config.gbTypeChecking)
            {
                Output.WriteLine("");
                Output.WriteLine("inferring type of " + msName);
                Output.WriteLine("===");
            }

            try
            {
                mpFxnType = CatTypeReconstructor.Infer(mFunctions);
            }
            catch (Exception e)
            {
                Output.WriteLine("type error in function " + msName);
                Output.WriteLine(e.Message);
                mpFxnType = null;
            }
        }

        public override void Eval(Executor exec)
        {
            exec.Execute(mFunctions);
        }

        public override CatExpr GetSubFxns()
        {
            return mFunctions;
        }

        public override string ToString()
        {
            return msName;
        }

        public bool IsTypeExplicit()
        {
            return mbExplicitType;
        }

        public bool HasTypeError()
        {
            return mbTypeError;
        }

        public void SetTypeExplicit()
        {
            mbExplicitType = true;
        }
        
        public void SetTypeError()
        {
            mbTypeError = true;
        }
    }

    public class Method : Function
    {
        MethodInfo mMethod;
        Object mObject;

        public Method(Object o, MethodInfo mi)
            : base(mi.Name, "undocumented method from CLR")
        {
            mMethod = mi;
            mObject = o;
            string sType = MethodToTypeString(mi);
            mpFxnType = CatFxnType.Create(sType);
            mpFxnType = CatVarRenamer.RenameVars(mpFxnType);
        }

        public override void Eval(Executor exec)
        {
            int n = mMethod.GetParameters().Length;
            Object[] a = new Object[n];
            for (int i = 0; i < n; ++i)
            {
                Object o = exec.Pop();
                a[n - i - 1] = o;
            }
            Object ret = mMethod.Invoke(mObject, a);
            if (!mMethod.ReturnType.Equals(typeof(void)))
                exec.Push(ret);
        }

        public Object GetObject()
        {
            return mObject;
        }

        public MethodInfo GetMethodInfo()
        {
            return mMethod;
        }

       public override string ToString()
       {
           return msName;
       }

        public int Count
        {
            get { return GetMethodInfo().GetParameters().Length; }
        }

        public Type GetType(int n)
        {
            return GetMethodInfo().GetParameters()[n].ParameterType;
        }
    }

    public abstract class PrimitiveFunction : Function
    {
        public PrimitiveFunction(string sName, string sType, string sDesc)
            : this(sName, sType, sDesc, "")
        {
        }

        public PrimitiveFunction(string sName, string sType, string sDesc, string sTags)
            : base(sName, sDesc, sTags)
        {
            mpFxnType = CatFxnType.Create(sType);
            mpFxnType = CatVarRenamer.RenameVars(mpFxnType);
        }

        public override string ToString()
        {
            return msName;
        }
    }

    /// <summary>
    /// This is a place holder function. 
    /// </summary>
    public class SelfFunction : Function
    {
        public SelfFunction(string name)
            : base(name)
        {
            mpFxnType = CatFxnType.Create("('A -> 'B)");
        }

        public override void Eval(Executor exec)
        {
            throw new Exception("self functions are supposed to be replaced during a function construction");
        }
    }

    public class JumpTable : Function
    {
        Function defaultFun;
        Dictionary<int, Function> cases = new Dictionary<int, Function>();

        public JumpTable(Function d)
        {
            defaultFun = d;
            msName = "_jump_table_";
        }

        public override void Eval(Executor exec)
        {
            int n = exec.PopInt();
            if (cases.ContainsKey(n))
            {
                Function f = cases[n];
                f.Eval(exec);
            }
            else
            {
                exec.PushInt(n);
                defaultFun.Eval(exec);
            }
        }

        public void AddCase(int n, Function f)
        {
            cases.Add(n, f);
        }
    }
}
