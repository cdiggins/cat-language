// Public domain by Christopher Diggins
// See: http://research.microsoft.com/Users/luca/Papers/BasicTypechecking.pdf

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    public class Pair<T>
    {
        public T First;
        public T Second;
        public Pair(T first, T second)
        {
            First = first;
            Second = second;
        }
    }

    public class VarNameList : List<String>
    {
        public new void Add(string s)
        {
            if (Contains(s))
                return;
            base.Add(s);
        }

        public void Add(Var v)
        {
            Add(v.ToString());
        }

        public bool Contains(Var v)
        {
            return base.Contains(v.ToString());
        }

        public new void AddRange(IEnumerable<string> strings)
        {
            foreach (string s in strings)
                Add(s);
        }

        public override string ToString()
        {
            string ret = "";
            foreach (string s in this)
                ret += s + ";";
            return ret;
        }
    }

    public class VarNameMap : Dictionary<string, string>
    {
        public bool AreVarsEqual(Var x, Var y)
        {
            string s = x.ToString();
            if (ContainsKey(s))
                return this[s].Equals(y.ToString());
            else
            {
                Add(s, y.ToString());
                return true;
            }
        }
    }

    public class VarList : List<Var>
    {
        public VarList(VarList x)
            : base(x)
        { }

        public VarList(IEnumerable<Var> x)
            : base(x)
        { }

        public VarList()
        { }

        public new void Add(Var v)
        {
            if (!Contains(v))
                base.Add(v);
        }

        public new void AddRange(IEnumerable<Var> list)
        {
            foreach (Var v in list)
                this.Add(v);
        }

        public override string ToString()
        {
            string ret = "";
            foreach (Var v in this)
                ret += v.ToString() + ";";
            return ret;
        }
    }

    public abstract class Constraint
    {
        public virtual IEnumerable<Constraint> GetSubConstraints()
        {
            yield return this;
        }

        public bool EqualsVar(string s)
        {
            if (!(this is Var))
                return false;
            return ToString().Equals(s);
        }

        public VarNameList GetAllVarNames()
        {
            VarNameList vars = new VarNameList();
            foreach (Constraint c in GetSubConstraints())
                if (c is Var)
                    vars.Add(c as Var);
            return vars;
        }

        public VarList GetAllVars()
        {
            VarList vars = new VarList();
            foreach (Constraint c in GetSubConstraints())
                if (c is Var)
                    vars.Add(c as Var);
            return vars;
        }

        public abstract Constraint Clone();
        public abstract bool Equals(Constraint c, VarNameMap vars);
    }

    public abstract class Var : Constraint
    {
        protected string m;

        public Var(string s)
        {
            m = s;
        }

        public override string ToString()
        {
            return m;
        }

        public void Rename(string s)
        {
            m = s;
        }

        public override bool Equals(Constraint c, VarNameMap vars)
        {
            if (!(c is Var))
                return false;
            return vars.AreVarsEqual(this, c as Var);
        }
    }

    public class ScalarVar : Var
    {
        public ScalarVar(string s)
            : base(s)
        {
        }

        public override Constraint Clone()
        {
            return new ScalarVar(m);
        }
    }

    public class VectorVar : Var
    {
        public VectorVar(string s)
            : base(s)
        {
        }

        public override Constraint Clone()
        {
            return new VectorVar(m);
        }
    }

    public class Constant : Constraint
    {
        string m;
        public Constant(string s)
        {
            m = s;
        }
        public override string ToString()
        {
            return m;
        }
        public override Constraint Clone()
        {
            return new Constant(m);
        }
        public override bool Equals(Constraint c, VarNameMap vars)
        {
            if (!(c is Constant)) 
                return false;
            return ToString().Equals(c.ToString());
        }
    }

    public class RecursiveRelation : Constraint
    {
        public RecursiveRelation()
        {
        }
        public override Constraint Clone()
        {
            return this;
        }
        public override bool Equals(Constraint c, VarNameMap vars)
        {
            return c is RecursiveRelation;
        }
    }

    public class Relation : Constraint
    {
        Vector mLeft;
        Vector mRight;
        VarNameList mGenerics;
        Relation mParent = null;
        VarNameList mChildNonGenerics = new VarNameList();

        public Relation(Vector left, Vector right)
        {
            mLeft = left;
            mRight = right;
        }

        public void UnrollRecursiveRelations()
        {
            foreach (Relation r in GetChildRelations())
                r.UnrollRecursiveRelations();

            for (int i=0; i < GetLeft().GetCount(); ++i)
                if (GetLeft().GetConstraint(i) is RecursiveRelation)
                    GetLeft().ReplaceConstraint(i, Clone());

            for (int i=0; i < GetRight().GetCount(); ++i)
                if (GetRight().GetConstraint(i) is RecursiveRelation)
                    GetRight().ReplaceConstraint(i, Clone());
        }

        private bool CanRollupRelation(Constraint child)
        {
            VarNameMap map = new VarNameMap();

            if (!(child is Relation))
                return false;

            Relation childRel = child as Relation;

            int n = GetLeft().GetCount();
            if (n != childRel.GetLeft().GetCount())
                return false;
            for (int i = 0; i < n; ++i)
            {
                Constraint tmp = GetLeft(i);
                Constraint childTmp = childRel.GetLeft(i);
                
                if (tmp != child)
                {
                    if (!tmp.Equals(childTmp, map))
                        return false;
                }
                else
                {
                    if (!(childTmp is RecursiveRelation))
                        return false;
                }
            }
            n = GetRight().GetCount();
            if (n != childRel.GetRight().GetCount())
                return false;
            for (int i = 0; i < n; ++i)
            {
                Constraint tmp = GetRight(i);
                Constraint childTmp = childRel.GetRight(i);

                if (tmp != child)
                {
                    if (!tmp.Equals(childTmp, map))
                        return false;
                }
                else
                {
                    if (!(childTmp is RecursiveRelation))
                        return false;
                }
            }
            return true;
        }

        /// <summary>
        /// We want to compact any recursive relations as much as possible, for example:
        /// ('A ('A self -> 'B) -> 'B) should become ('A self -> 'B)
        /// This process is called rolling up the recursion. 
        /// This way we can compare the relations to see if they are the same.
        /// </summary>
        public void RollupRecursiveRelations()
        {
            foreach (Relation r in GetChildRelations())
                r.RollupRecursiveRelations();

            for (int i = 0; i < GetLeft().GetCount(); ++i)
                if (CanRollupRelation(GetLeft().GetConstraint(i)))
                    GetLeft().ReplaceConstraint(i, new RecursiveRelation());

            for (int i = 0; i < GetRight().GetCount(); ++i)
                if (CanRollupRelation(GetRight().GetConstraint(i)))
                    GetRight().ReplaceConstraint(i, new RecursiveRelation());
        }

        public Vector GetLeft()
        {
            return mLeft;
        }

        public Vector GetRight()
        {
            return mRight;
        }

        public Constraint GetLeft(int n)
        {
            return mLeft.GetConstraint(n);
        }

        public Constraint GetRight(int n)
        {
            return mRight.GetConstraint(n);
        }

        public override string ToString()
        {
            return mLeft.ToString() + "->" + mRight.ToString();
        }

        public IEnumerable<Relation> GetChildRelations()
        {
            foreach (Constraint c in GetChildConstraints())
                if (c is Relation)
                    yield return c as Relation;
        }

        public IEnumerable<Constraint> GetChildConstraints()
        {
            foreach (Constraint c in mLeft)
            {
                Trace.Assert(!(c is Vector));
                yield return c;
            }
            foreach (Constraint c in mRight)
            {
                Trace.Assert(!(c is Vector));
                yield return c;
            }
        }

        public override IEnumerable<Constraint> GetSubConstraints()
        {
            foreach (Constraint c in mLeft.GetSubConstraints())
                yield return c;
            foreach (Constraint c in mRight.GetSubConstraints())
                yield return c;
        }

        /// <summary>
        /// This has to be called after all of their parent pointers have been set.
        /// </summary>
        public void ComputeGenericVars()
        {
            Trace.Assert(mChildNonGenerics != null);
            Trace.Assert(mGenerics == null);
            mGenerics = new VarNameList();
            foreach (Constraint c in GetSubConstraints())
            {
                if (c is Var)
                {
                    Var v = c as Var;
                    if (!IsNonGenericVar(v))
                        mGenerics.Add(v);
                }
            }
        }

        public bool IsNonGenericVar(Var v)
        {
            if (mParent == null)
                return false;
            if (mParent.mChildNonGenerics.Contains(v))
                return true;
            return mParent.IsNonGenericVar(v);
        }

        public bool IsSubRelation(Relation r)
        {
            foreach (Constraint c in GetSubConstraints())
                if (c == r)
                    return true;
            return false;
        }

        public VarNameList GetGenericVars()
        {
            ComputeGenericVars();
            return mGenerics;
        }

        public override Constraint Clone()
        {
            return new Relation(mLeft.Clone() as Vector, mRight.Clone() as Vector);
        }

        public VarNameList GetNonGenericsForChildren()
        {
            return mChildNonGenerics;
        }

        public void SetParent(Relation parent)
        {
            Trace.Assert(mParent == null);
            mParent = parent;
        }

        public Relation GetParent()
        {
            return mParent;
        }

        public override bool Equals(Constraint c, VarNameMap vars)
        {
            if (!(c is Relation))
                return false;
            Relation r = c as Relation;
            return mLeft.Equals(r.mLeft, vars) && mRight.Equals(r.mRight, vars);
        }

        public static bool AreRelationsEqual(Relation r1, Relation r2)
        {
            return r1.Equals(r2, new VarNameMap());
        }
    }

    public class Vector : Constraint
    {
        List<Constraint> mList;

        public Vector(IEnumerable<Constraint> list)
        {
            mList = new List<Constraint>(list);
        }

        public Vector(List<Constraint> list)
        {
            mList = list;
        }

        public Vector()
        {
            mList = new List<Constraint>();
        }

        public Constraint GetFirst()
        {
            return mList[0];
        }

        public int IndexOf(Constraint c)
        {
            return mList.IndexOf(c);
        } 

        public Vector GetRest()
        {
            return new Vector(mList.GetRange(1, mList.Count - 1));
        }

        public override string ToString()
        {
            string ret = "(";
            for (int i = mList.Count - 1; i >= 0; --i)
            {
                if (i < mList.Count - 1) ret += " ";
                ret += mList[i].ToString();
            }
            ret += ")";
            return ret;
        }

        public bool IsEmpty()
        {
            return mList.Count == 0;
        }

        public int GetCount()
        {
            return mList.Count;
        }

        public override IEnumerable<Constraint> GetSubConstraints()
        {
            foreach (Constraint c in mList)
                foreach (Constraint d in c.GetSubConstraints())
                    yield return d;
        }

        public int GetSubConstraintCount()
        {
            int ret = 0;
            foreach (Constraint c in GetSubConstraints())
            {
                // artificial check to remove unused variable warning.
                if (c != null) ++ret;
            }
            return ret;
        }

        public void Add(Constraint c)
        {
            if (c is Vector)
            {
                Vector vec = c as Vector;
                foreach (Constraint child in vec)
                    mList.Add(child);
            }
            else
            {
                mList.Add(c);
            }
        }

        public IEnumerator<Constraint> GetEnumerator()
        {
            return mList.GetEnumerator();
        }

        public void Insert(int n, Constraint constraint)
        {
            mList.Insert(n, constraint);
        }

        public override Constraint Clone()
        {
            List<Constraint> tmp = new List<Constraint>();
            foreach (Constraint c in this)
                tmp.Add(c.Clone());
            return new Vector(tmp);
        }
    
        public Constraint GetConstraint(int i)
        {
 	        return mList[i];
        }

        public void ReplaceConstraint(int i, Constraint constraint)
        {
 	        mList[i] = constraint;
        }

        public override bool Equals(Constraint c, VarNameMap vars)
        {
            if (!(c is Vector))
                return false;
            Vector v = c as Vector;
            int n = v.GetCount();
            if (n != GetCount()) 
                return false;
            for (int i = 0; i < n; ++i)
            {
                Constraint c1 = GetConstraint(i);
                Constraint c2 = v.GetConstraint(i);
                if (!c1.Equals(c2, vars))
                    return false;
            }
            return true;
        }
    }

    public class ConstraintList : List<Constraint>
    {
        Constraint mUnifier;

        public ConstraintList(IEnumerable<Constraint> a)
            : base(a)
        { }

        public ConstraintList()
            : base()
        { }

        public override string ToString()
        {
            string ret = "";
            for (int i = 0; i < Count; ++i)
            {
                if (i > 0) ret += " = ";
                ret += this[i].ToString();
            }
            if (mUnifier != null)
                ret += "; unifier = " + mUnifier.ToString();
            return ret;
        }

        public Vector ChooseBetterVectorUnifier(Vector v1, Vector v2)
        {
            if (v1.GetCount() > v2.GetCount())
            {
                return v1;
            }
            else if (v1.GetCount() < v2.GetCount())
            {
                return v2;
            }
            else if (v1.GetSubConstraintCount() >= v2.GetSubConstraintCount())
            {
                return v1;
            }
            else
            {
                return v2;
            }
        }

        public Constraint ChooseBetterUnifier(Constraint c1, Constraint c2)
        {
            Trace.Assert(c1 != null);
            Trace.Assert(c2 != null);
            Trace.Assert(c1 != c2);

            if (c1 is RecursiveRelation)
            {
                return c1;
            }
            else if (c2 is RecursiveRelation)
            {
                return c2;
            }
            else if (c1 is Var)
            {
                return c2;
            }
            else if (c2 is Var)
            {
                return c1;
            }
            else if (c1 is Constant)
            {
                return c1;
            }
            else if (c2 is Constant)
            {
                return c2;
            }
            else if ((c1 is Vector) && (c2 is Vector))
            {
                return ChooseBetterVectorUnifier(c1 as Vector, c2 as Vector);
            }
            else
            {
                return c1;
            }
        }

        public void ComputeUnifier()
        {
            if (Count == 0)
                throw new Exception("Can not compute unifier for an empty list");
            mUnifier = this[0];
            for (int i = 1; i < Count; ++i)
                mUnifier = ChooseBetterUnifier(mUnifier, this[i]);
        }

        public Constraint GetUnifier()
        {
            if (mUnifier == null)
                throw new Exception("Unifier hasn't been computed yet");
            return mUnifier;
        }

        public bool ContainsVar(string s)
        {
            foreach (Constraint c in this)
                if (c.EqualsVar(s))
                    return true;
            return false;
        }

    }
}