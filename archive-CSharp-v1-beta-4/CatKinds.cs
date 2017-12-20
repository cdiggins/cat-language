/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{    
    /// <summary>
    /// All CatKinds should be immutable. This avoids a lot of problems and confusion.
    /// </summary>
    abstract public class CatKind 
    {
        public static int gnId = 0;

        public static CatKind Create(AstType node)
        {
            if (node is AstSimpleType)
            {
                string s = node.ToString();
                Trace.Assert(s.Length > 0);
                if (s.Length > 1 && s[0] == '_')
                    return CatCustomKind.GetCustomKind(s);
                else 
                    return new CatSimpleTypeKind(s);
            }
            else if (node is AstTypeVar)
            {
                return new CatTypeVar(node.ToString());
            }
            else if (node is AstStackVar)
            {
                return new CatStackVar(node.ToString());
            }
            else if (node is AstFxnType)
            {
                return new CatFxnType(node as AstFxnType);
            }
            else
            {
                throw new Exception("unrecognized kind " + node.ToString());
            }
        }

        public CatKind()
        {
        }

        public override string ToString()
        {
            throw new Exception("ToString must be overridden");
        }

        public virtual string ToIdString()
        {
            return ToString();
        }

        public abstract bool Equals(CatKind k);

        public virtual bool IsSubtypeOf(CatKind k)
        {
            if (k.ToString().Equals("any")) 
                return true;
            return this.Equals(k);
        }

        public bool IsKindVar()
        {
            return (this is CatTypeVar) || (this is CatStackVar);
        }

        public static string TypeNameFromObject(Object o)
        {
            if (o is HashList) return "hash_list";
            if (o is CatList) return "list";
            if (o is Boolean) return "bool";
            if (o is int) return "int";
            if (o is Double) return "double";
            if (o is string) return "string";
            if (o is Byte) return "byte";
            if (o is Primitives.Bit) return "bit";
            if (o is Function) return (o as Function).GetFxnTypeString();
            if (o is Char) return "char";
            return "any";
        }

        public static string TypeToString(Type t)
        {
            // TODO: fix this up. I don't like where it is.
            switch (t.Name)
            {
                case ("HashList"): return "hash_list";
                case ("Int32"): return "int";
                case ("Double"): return "double";
                case ("FList"): return "list";
                case ("Object"): return "any";
                case ("Function"): return "fun";
                case ("Boolean"): return "bool";
                case ("String"): return "string";
                case ("Char"): return "char";
                default: return t.Name;
            }
        }

        public static CatKind GetKindFromObject(object o)
        {
            if (o is CatObject) return (o as CatObject).GetClass();
            if (o is Function) return (o as Function).GetFxnType();
            return new CatSimpleTypeKind(TypeNameFromObject(o));
        }

        public virtual bool IsAny()
        {
            return false;
        }

        public virtual bool IsDynFxn()
        {
            return false;
        }

        public abstract IEnumerable<CatKind> GetChildKinds();
        public abstract IEnumerable<CatKind> GetDescendantKinds();
    }

    /// <summary>
    /// Base class for the different Cat types
    /// </summary>
    public abstract class CatTypeKind : CatKind
    {
        public CatTypeKind() 
        { }
    }

    public class CatSimpleTypeKind : CatTypeKind
    {
        string msName;

        public CatSimpleTypeKind(string s)
        {            
            msName = s;
        }

        public override string ToString()
        {
            return msName;
        }

        public override bool Equals(CatKind k)
        {
            return (k is CatSimpleTypeKind) && (msName == k.ToString());
        }

        public override bool IsSubtypeOf(CatKind k)
        {
            if (Equals(k))
                return true;

            // meta_int is a subtype of int
            // and meta_bool is a subtype of bool
            // and so on.
            if (msName.IndexOf("meta_") == 0)
            {
                string s = k.ToString();
                if (s.Length == 0)
                    throw new Exception("missing type name");
                if (msName.IndexOf(s) == 5)
                    return true;
            }
            return false;
        }

        public override bool IsAny()
        {
            return msName.Equals("any");
        }

        public override bool IsDynFxn()
        {
            return msName.Equals("fun");
        }

        public override IEnumerable<CatKind> GetChildKinds()
        {
            yield return this;
        }

        public override IEnumerable<CatKind> GetDescendantKinds()
        {
            yield return this;
        }
    }

    public class CatTypeVar : CatTypeKind
    {
        string msName;

        public CatTypeVar(string s)
        {
            msName = s;
        }

        public override string ToString()
        {
            return "'" + msName;
        }

        public static CatTypeVar CreateUnique()
        {
            return new CatTypeVar("t$" + (gnId++).ToString());
        }

        public override bool Equals(CatKind k)
        {
            if (!(k is CatTypeVar))
                return false;
            return ToString().CompareTo(k.ToString()) == 0;
        }

        public override IEnumerable<CatKind> GetChildKinds()
        {
            yield return this;
        }

        public override IEnumerable<CatKind> GetDescendantKinds()
        {
            yield return this;
        }
    }

    public abstract class CatStackKind : CatKind
    {
    }

    public class CatTypeVector : CatStackKind
    {
        List<CatKind> mList;

        public CatTypeVector(AstStack node)
        {
            mList = new List<CatKind>();
            foreach (AstType tn in node.mTypes)
                mList.Add(Create(tn));
        }

        public CatTypeVector()
        {
            mList = new List<CatKind>();
        }

        public CatTypeVector(CatTypeVector k)
        {
            mList = new List<CatKind>(k.mList);
        }

        public CatTypeVector(List<CatKind> list)
        {
            mList = new List<CatKind>(list);
        }

        /// <summary>
        /// This is a reversed stack, position [0] is the bottom.
        /// </summary>
        public List<CatKind> GetKinds()
        {
            return mList;
        }

        public IEnumerable<CatKind> GetRevKinds()
        {
            for (int i = mList.Count - 1; i >= 0; --i)
                yield return mList[i];
        }

        public void Add(CatKind k)
        {
            Trace.Assert(k != null);
            if (k is CatTypeVector)
                mList.AddRange((k as CatTypeVector).GetKinds()); else
                mList.Add(k);
        }

        public void PushKindBottom(CatKind k)
        {
            Trace.Assert(k != null);
            if (k is CatTypeVector)
                mList.InsertRange(0, (k as CatTypeVector).GetKinds()); else
                mList.Insert(0, k);
        }

        public bool IsEmpty()
        {
            return mList.Count == 0;
        }
        
        public CatKind GetBottom()
        {
            if (mList.Count > 0)
                return mList[0]; else
                return null;
        }

        public CatKind GetTop()
        {
            if (mList.Count > 0)
                return mList[mList.Count - 1]; else
                return null;
        }

        public CatTypeVector GetRest()
        {
            return new CatTypeVector(mList.GetRange(0, mList.Count - 1));
        }

        public override string ToString()
        {
            string ret = "";
            foreach (CatKind k in mList)
                ret += " " + k.ToString();
            if (mList.Count > 0)
                return ret.Substring(1); else
                return "";
        }

        public override string ToIdString()
        {
            string ret = "";
            foreach (CatKind k in mList)
                ret += " " + k.ToIdString();
            if (mList.Count > 0)
                return ret.Substring(1); else
                return "";
        }

        public override bool Equals(CatKind k)
        {
            if (!(k is CatTypeVector))
                return false;
            CatTypeVector v1 = this;
            CatTypeVector v2 = k as CatTypeVector;
            while (!v1.IsEmpty() && !v2.IsEmpty())
            {
                CatKind t1 = v1.GetTop();
                CatKind t2 = v2.GetTop();
                if (!t1.Equals(t2)) 
                    return false;
                v1 = v1.GetRest();
                v2 = v2.GetRest();                
            }
            if (!v1.IsEmpty())
                return false;
            if (!v2.IsEmpty())
                return false;
            return true;
        }

        public override bool IsSubtypeOf(CatKind k)
        {
            if (k.IsAny())
                return true;
            if (k is CatStackVar)
                return true;
            if (!(k is CatTypeVector))
                return false;
            CatTypeVector v1 = this;
            CatTypeVector v2 = k as CatTypeVector;
            while (!v1.IsEmpty() && !v2.IsEmpty())
            {
                CatKind t1 = v1.GetTop();
                CatKind t2 = v2.GetTop();
                if (!t1.IsSubtypeOf(t2))
                    return false;
                v1 = v1.GetRest();
                v2 = v2.GetRest();
            }
            // v1 has to be at least as long to be a subtype
            if (v1.IsEmpty() && !v2.IsEmpty())
                return false;
            return true;
        }

        public CatTypeVector Clone()
        {
            CatTypeVector ret = new CatTypeVector();
            foreach (CatKind k in GetKinds())
                ret.Add(k);
            return ret;
        }

        public void RemoveBottom()
        {
            GetKinds().RemoveAt(0);            
        }

        public override IEnumerable<CatKind> GetChildKinds()
        {
            foreach (CatKind k in GetKinds())
                yield return k;
        }

        public override IEnumerable<CatKind> GetDescendantKinds()
        {
            foreach (CatKind k in GetKinds())
                foreach (CatKind j in k.GetDescendantKinds())
                    yield return j;
        }

        public bool IsValid()
        {
            foreach (CatKind k in GetKinds())
                if (k is CatTypeVector)
                    return false;
            return true;
        }
    }

    public class CatStackVar : CatStackKind
    {
        string msName;

        public CatStackVar(string s)
        {
            msName = s;
        }

        public override string ToString()
        {
            return "'" + msName;
        }

        public static CatStackVar CreateUnique()
        {
            return new CatStackVar("R$" + (gnId++).ToString());
        }

        public override bool Equals(CatKind k)
        {
            if (!(k is CatStackVar)) return false;
            return k.ToString() == this.ToString();
        }

        public override IEnumerable<CatKind> GetChildKinds()
        {
            yield return this;
        }

        public override IEnumerable<CatKind> GetDescendantKinds()
        {
            yield return this;
        }
    }

    public class CatCustomKind : CatKind
    {
        int mnId;
        static List<CatCustomKind> gpPool = new List<CatCustomKind>();

        public CatCustomKind()
        {
            mnId = gpPool.Count;
            gpPool.Add(this);
        }

        public int GetId()
        {
            return mnId;
        }

        public override string ToString()
        {
 	        return "_" + mnId.ToString();
        }

        public static CatCustomKind GetCustomKind(int n)
        {
            return gpPool[n];
        }

        public static CatCustomKind GetCustomKind(string s)
        {
            Trace.Assert(s.Length > 1);
            Trace.Assert(s[0] == '_');
            int n = Int32.Parse(s.Substring(1));
            return GetCustomKind(n);
        }

        public override bool Equals(CatKind k)
        {
            if (!(k is CatCustomKind))
                return false;
            if ((k as CatCustomKind).GetId() == GetId())
            {
                Trace.Assert(k == this);
                return true;
            }
            else
            {
                return false;
            }
        }

        public override IEnumerable<CatKind> GetChildKinds()
        {
            yield return this;
        }

        public override IEnumerable<CatKind> GetDescendantKinds()
        {
            yield return this;
        }
    }

    public class CatMetaValue<T> : CatCustomKind
    {
        T mData;
        CatSimpleTypeKind mpSuperType = new CatSimpleTypeKind(TypeToString(typeof(T)));

        public CatMetaValue(T x)
        {
            mData = x;
        }

        public T GetData()
        {
            return mData;
        }

        public override bool Equals(CatKind k)
        {
            if (k == this)
                return true;
            if (!(k is CatMetaValue<T>))
                return false;
            CatMetaValue<T> tmp = k as CatMetaValue<T>;
            return tmp.GetData().Equals(mData);
        }

        public CatKind GetSuperType()
        {
            return mpSuperType;
        }

        public override bool IsSubtypeOf(CatKind k)
        {
            if (k is CatSimpleTypeKind)
                return GetSuperType().IsSubtypeOf(k);               
            return this.Equals(k);
        }

        public override IEnumerable<CatKind> GetChildKinds()
        {
            yield return this;
        }

        public override IEnumerable<CatKind> GetDescendantKinds()
        {
            yield return this;
        }

        public override string ToString()
        {
            //return "meta_" + TypeToString(typeof(T));
            return mData.ToString();
        }
    }
}
