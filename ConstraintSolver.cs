// Public domain by Christopher Diggins
// See: http://research.microsoft.com/Users/luca/Papers/BasicTypechecking.pdf

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    public class ConstraintSolver
    {
        public class TypeException : Exception
        {
            public TypeException(string s)
                : base(s)
            { }

            public TypeException(Constraint c1, Constraint c2)
                : this("constraint " + c1 + " is not compatible with " + c2)
            { }
        }

        #region fields
        List<ConstraintList> mConstraintList; // left null, because it is created upon request
        Dictionary<string, ConstraintList> mLookup = new Dictionary<string, ConstraintList>();
        List<Pair<Vector>> mConstraintQueue = new List<Pair<Vector>>();
        List<Relation> mGenericRenamingQueue = new List<Relation>();
        Dictionary<string, Var> mVarPool = new Dictionary<string, Var>();
        int mnId = 0;
        List<Pair<Constant>> mDeductions = new List<Pair<Constant>>();
        Dictionary<Relation, List<Relation>> mConstrainedRelations
            = new Dictionary<Relation, List<Relation>>();
        #endregion

        #region deduction functions
        public void AddDeduction(Constant c, Constant d)
        {
            Log("deduction " + c.ToString() + " = " + d.ToString());
            mDeductions.Add(new Pair<Constant>(c, d));
        }

        public List<Pair<Constant>> GetDeductions()
        {
            return mDeductions;
        }
        #endregion 

        #region utility functions
        public static T Last<T>(List<T> a)
        {
            return a[a.Count - 1];
        }

        public static Pair<Vector> VecPair(Vector v1, Vector v2)
        {
            return new Pair<Vector>(v1, v2);
        }

        public static void Err(string s)
        {
            throw new Exception(s);
        }

        public static void Check(bool b, string s)
        {
            if (!b)
                Err(s);
        }

        public static void Log(string s)
        {
            if (Config.gbVerboseInference)
                Output.WriteLine(s);
        }
        public bool IsRecursiveRelation(string s, Constraint c)
        {
            Relation rel = c as Relation;
            if (rel == null)
                return false;
            foreach (Constraint tmp in rel.GetLeft())
                if (tmp.EqualsVar(s))
                    return true;
            foreach (Constraint tmp in rel.GetRight())
                if (tmp.EqualsVar(s))
                    return true;
            return false;
        }
        #endregion

        #region constraint functions

        /// <summary>
        /// Currently only used to prevent recursive relations 
        /// from entering an infinite loop
        /// </summary>
        public bool IsRelationConstrained(Relation left, Relation right)
        {
            if (mConstrainedRelations.ContainsKey(left))
            {
                if (mConstrainedRelations[left].Contains(right))
                    return true;
            }
            return false;                
        }

        /// <summary>
        /// Currently only used to prevent recursive relations 
        /// from entering an infinite loop
        /// </summary>
        public void MarkRelationConstrained(Relation left, Relation right)
        {
            if (!mConstrainedRelations.ContainsKey(left))
                mConstrainedRelations.Add(left, new List<Relation>());
            if (!mConstrainedRelations[left].Contains(right))
                mConstrainedRelations[left].Add(right);

            if (!mConstrainedRelations.ContainsKey(right))
                mConstrainedRelations.Add(right, new List<Relation>());
            if (!mConstrainedRelations[right].Contains(left))
                mConstrainedRelations[right].Add(left);
        }

        public void AddTopLevelConstraints(Vector vLeft, Vector vRight)
        {
            AddVecConstraint(vLeft, vRight);
        }

        public void AddToConstraintQueue(Vector v1, Vector v2)
        {
            // Don't add redundnant things to the constraint queue
            foreach (Pair<Vector> pair in mConstraintQueue)
                if ((pair.First == v1) && (pair.Second == v2))
                    return;

            Log("adding to constraint queue: " + v1.ToString() + " = " + v2.ToString());
            mConstraintQueue.Add(new Pair<Vector>(v1, v2));
        }

        public void AddSubConstraints(Constraint c1, Constraint c2)
        {
            if (c1 == c2) return;
            if ((c1 is Vector) && (c2 is Vector))
            {
                AddToConstraintQueue(c1 as Vector, c2 as Vector);
            }
            else if ((c1 is Relation) && (c2 is Relation))
            {
                Relation r1 = c1 as Relation;
                Relation r2 = c2 as Relation;
                AddToConstraintQueue(r1.GetLeft(), r2.GetLeft());
                AddToConstraintQueue(r1.GetRight(), r2.GetRight());
            }
        }

        public void AddVarConstraint(Var v, Constraint c)
        {
            if (c is RecursiveRelation)
                return; 

            AddConstraintToList(c, GetConstraints(v.ToString()));
        }

        public void AddRelConstraint(Relation r1, Relation r2)
        { 
            if (IsRelationConstrained(r1, r2))
                return;
            MarkRelationConstrained(r1, r2);
            AddVecConstraint(r1.GetLeft(), r2.GetLeft());
            AddVecConstraint(r1.GetRight(), r2.GetRight());
        }

        public void AddVecConstraint(Vector v1, Vector v2)
        {
            if (v1 == v2) 
                return;

            if (v1.IsEmpty() && v2.IsEmpty())
                return;

            if (v1.IsEmpty())
                if (!(v2.GetFirst() is VectorVar))
                    Err("Only vector variables can be equal to empty vectors");

            if (v2.IsEmpty())
                if (!(v1.GetFirst() is VectorVar))
                    Err("Only vector variables can be equal to empty vectors");
            
            Log("Constraining vector: " + v1.ToString() + " = " + v2.ToString());

            if (v1.GetFirst() is VectorVar)
            {
                Check(v1.GetCount() == 1, 
                    "Vector variables can only occur in the last position of a vector");
                if ((v2.GetCount() > 0) && v2.GetFirst() is VectorVar)
                {
                    ConstrainVars(v1.GetFirst() as Var, v2.GetFirst() as Var);
                }
                else
                {
                    AddVarConstraint(v1.GetFirst() as VectorVar, v2);
                }
            }
            else if (v2.GetFirst() is VectorVar)
            {
                AddVarConstraint(v2.GetFirst() as VectorVar, v1);
            }
            else 
            {
                AddConstraint(v1.GetFirst(), v2.GetFirst());

                // Recursive call
                AddVecConstraint(v1.GetRest(), v2.GetRest());

                ConstrainQueuedItems();
            }
        }

        public void AddConstraintToList(Constraint c, ConstraintList a)
        {
            if (c is Var)
            {
                // Update the constraint list associated with this particular variable
                // to now be "a". 
                string sVar = c.ToString();
                Trace.Assert(mLookup.ContainsKey(sVar));
                ConstraintList list = mLookup[sVar];
                if (list == a)             
                    Err("Internal error, expected constraint list to contain constraint " + c.ToString());
                mLookup[sVar] = a;
            }
            if (a.Contains(c))
                return;
            foreach (Constraint k in a)
                AddSubConstraints(k, c);
            a.Add(c);
        }

        public void ConstrainVars(Var v1, Var v2)
        {
            Check(
                ((v1 is ScalarVar) && (v2 is ScalarVar)) ||
                ((v1 is VectorVar) && (v2 is VectorVar)),
                "Incompatible variable kinds " + v1.ToString() + " and " + v2.ToString());

            ConstrainVars(v1.ToString(), v2.ToString());
        }
        public void ConstrainVars(string s1, string s2)
        {
            if (s1.Equals(s2))
                return;
            ConstraintList a1 = GetConstraints(s1);
            ConstraintList a2 = GetConstraints(s2);
            if (a1 == a2)
                return;

            Trace.Assert(a1 != null);
            Trace.Assert(a2 != null);

            Log("Constraining var: " + s1 + " = " + s2);

            foreach (Constraint c in a2)
                AddConstraintToList(c, a1);

            ConstrainQueuedItems();
        }
        public void ConstrainQueuedItems()
        {
            // While we have items left in the queue to merge, we merge them
            while (mConstraintQueue.Count > 0)
            {
                Pair<Vector> p = mConstraintQueue[0];
                mConstraintQueue.RemoveAt(0);
                Log("Constraining queue item");
                AddVecConstraint(p.First, p.Second);
            }
        }
        public void CheckConstraintQueueEmpty()
        {
            Check(mConstraintQueue.Count == 0, "constraint queue is not empty");
        }

        ConstraintList GetConstraints(string s)
        {
            if (!mLookup.ContainsKey(s))
            {
                ConstraintList a = new ConstraintList();
                a.Add(CreateVar(s));
                mLookup.Add(s, a);
            }

            Trace.Assert(mLookup[s].ContainsVar(s));
            return mLookup[s];
        }
        public void AddConstraint(Constraint c1, Constraint c2)
        {
            if (c1 == c2)
                return;

            if ((c1 is Var) && (c2 is Var))
                ConstrainVars(c1 as Var, c2 as Var);
            else if (c1 is Var)
                AddVarConstraint(c1 as Var, c2);
            else if (c2 is Var)
                AddVarConstraint(c2 as Var, c1);
            else if ((c1 is Vector) && (c2 is Vector))
                AddVecConstraint(c1 as Vector, c2 as Vector);
            else if ((c1 is Relation) && (c2 is Relation))
                AddRelConstraint(c1 as Relation, c2 as Relation);
            else if (c1 is Relation) {
                // BUG: RecursiveRelations are not automatically compatible with other relations.
                if (!(c2.ToString().Equals("self")) && (!c2.ToString().Equals("any")))
                    throw new TypeException(c1, c2);
            }
            else if (c2 is Relation)
            {
                // BUG: RecursiveRelations are not automatically compatible with other relations.
                if (!(c1.ToString().Equals("self")) &&(!c1.ToString().Equals("any")))
                    throw new TypeException(c1, c2);
            }
            else if (c1 is Constant && c2 is Constant) {
                if (!c1.ToString().Equals(c2.ToString())
                    && !c1.ToString().Equals("any")
                    && !c2.ToString().Equals("any"))
                    throw new TypeException(c1, c2);
            }
            else if (c1 is RecursiveRelation || c2 is RecursiveRelation)
            {
                if (c1 is RecursiveRelation) 
                    if (!c2.ToString().Equals("any"))
                        throw new TypeException(c1, c2);
            }
            else
            {
                throw new TypeException("unhandled constraint scenario");
            }
        }

        /// <summary>
        /// Constructs the list of unique constraint lists
        /// </summary>
        public void ComputeConstraintLists()
        {
            mConstraintList = new List<ConstraintList>();
            foreach (ConstraintList list in mLookup.Values)
                if (!mConstraintList.Contains(list))
                    mConstraintList.Add(list);
        }

        public List<ConstraintList> GetConstraintLists()
        {
            if (mConstraintList == null)
                throw new Exception("constraint lists haven't been computed");
            return mConstraintList;
        }

        public IEnumerable<string> GetConstrainedVars()
        {
            return mLookup.Keys;
        }
        
        public void LogConstraints()
        {
            foreach (ConstraintList list in GetConstraintLists())
                Log(list.ToString());
        }

        public bool IsConstrained(string s)
        {
            return mLookup.ContainsKey(s);
        }
        #endregion

        #region vars and unifiers
        public IEnumerable<string> GetAllVars()
        {
            return mVarPool.Keys;
        }

        public string GetUniqueVarName(string s)
        {
            int n = s.IndexOf("$");
            if (n > 0)
                s = s.Substring(0, n);
            return s + "$" + mnId++.ToString();
        }

        public Var CreateUniqueVar(string s)
        {
            return CreateVar(GetUniqueVarName(s));
        }

        public Var CreateVar(string s)
        {
            Trace.Assert(s.Length > 0);
            if (!mVarPool.ContainsKey(s))
            {
                Var v = char.IsUpper(s[0])
                    ? new VectorVar(s) as Var
                    : new ScalarVar(s) as Var;
                mVarPool.Add(s, v);
                return v;
            }
            else
            {
                return mVarPool[s];
            }
        }

        public void ComputeUnifiers()
        {
            foreach (ConstraintList list in GetConstraintLists())
            {
                Trace.Assert(list.Count > 0);
                list.ComputeUnifier();
            }        
        }

        private void QueueForRenamingOfGenerics(Relation rel)
        {
            mGenericRenamingQueue.Add(rel);
        }

        public void RenameRelationsInQueue()
        {
            Log("Renaming generic variables of relations in queue");
            while (mGenericRenamingQueue.Count > 0)
            {
                RenameGenericVars(mGenericRenamingQueue[0]);
                mGenericRenamingQueue.RemoveAt(0);
            }
        }

        public void RenameGenericVars(Relation rel)
        {
            Dictionary<string, string> newNames = new Dictionary<string, string>();
            VarNameList generics = rel.GetGenericVars();

            Log("Generics of " + rel.ToString() + " are " + generics.ToString());
            
            // TODO: temp
            if (rel.GetParent() == null)
                Log(rel.ToString() + " has no parent"); else
                Log("Parent of " + rel.ToString() + " is " + rel.GetParent().ToString());

            foreach (string s in generics)
                newNames.Add(s, GetUniqueVarName(s));

            RenameVars(rel, newNames);
        }

        public Constraint GetUnifierFor(Var v)
        {
            Constraint ret = GetUnifierFor(v.ToString());
            if (ret == null) return v;
            return ret;
        }

        public Constraint GetUnifierFor(string s)
        {
            if (!IsConstrained(s))
                return null;
            return mLookup[s].GetUnifier().Clone();            
        }

        public Constraint GetResolvedUnifierFor(string s)
        {
            Constraint ret = GetUnifierFor(s);
            Check(ret != null, "internal error, no unifier found for " + s);
            ret = Resolve(ret, new Stack<Constraint>(), null);

            Log("Resolved unifier for " + s + " is " + ret.ToString());
            RenameRelationsInQueue();
            Log("After unique variable naming " + ret.ToString());

            return ret;
        }

        public void RenameVars(Relation rel, Dictionary<string, string> vars)
        {
            foreach (Var v in rel.GetAllVars())
                if (vars.ContainsKey(v.ToString()))
                    v.Rename(vars[v.ToString()]);
        }

        public IEnumerable<Constraint> GetUnifiers()
        {
            foreach (ConstraintList list in GetConstraintLists())
                yield return list.GetUnifier();
        }

        public IEnumerable<Relation> GetRelationUnifiers()
        {
            foreach (Constraint c in GetUnifiers())
                if (c is Relation)
                    yield return c as Relation;
        }
        #endregion

        #region resolve functions
        public Constraint ResolveRelationConstraint(Constraint c, Stack<Constraint> visited,
            Relation parent, VarNameList topVars, VarNameList allVars)
        {
            VarNameList nonGenerics = parent.GetNonGenericsForChildren();

            if (c is Var)
            {
                Var v = c as Var;
                Constraint u = Resolve(v, visited, parent);

                if (u is Relation)
                {
                    Relation r = u as Relation;
                    // Make sure we don't add variables to the non-generics
                    // list which occured in a duplicate.
                    if (!topVars.Contains(v))
                    {
                        VarNameList subVars = r.GetAllVarNames();
                        foreach (string s in subVars)
                            if (allVars.Contains(s))
                                nonGenerics.Add(s);
                        allVars.AddRange(subVars);
                    }
                    else
                    {
                        Log("duplicate of variable " + v.ToString() + ", with unifier " + r.ToString());
                        QueueForRenamingOfGenerics(r);
                    }
                }
                else if (u is Var)
                {
                    nonGenerics.Add(u as Var);
                }

                topVars.Add(v);
                return u;
            }
            else
            {
                Constraint u = Resolve(c, visited, parent);

                // non-vars should not resolve to vars
                Trace.Assert(!(u is Var));

                if (u is Relation)
                {
                    Relation r = u as Relation;
                    VarNameList subVars = r.GetAllVarNames();
                    foreach (string s in subVars)
                        if (allVars.Contains(s))
                            nonGenerics.Add(s);
                    allVars.AddRange(subVars);
                }

                return u;
            }
        }

        public Relation ResolveRelation(Relation r, Stack<Constraint> visited, Relation parent)
        {
            /// NOTES: It may become neccessary to resolve in stages, first resolve variables, then 
            /// resolve relations. This would make it easier to catch variables which are just 
            /// aliases for each other. I am not sure at this point, whether such a condition
            /// could arise. I may alternatively choose to simply rename all generics, but that 
            /// would have a significant computational cost.
            r.SetParent(parent);
            r.GetNonGenericsForChildren().AddRange(r.GetAllVarNames());
            Vector vLeft = new Vector();
            Vector vRight = new Vector();
            VarNameList allVars = new VarNameList();
            VarNameList topVars = new VarNameList();
            foreach (Constraint c in r.GetLeft())
                vLeft.Add(ResolveRelationConstraint(c, visited, r, topVars, allVars));
            foreach (Constraint c in r.GetRight())
                vRight.Add(ResolveRelationConstraint(c, visited, r, topVars, allVars));
            Relation ret = new Relation(vLeft, vRight);
            
            // Make sure we set the parent for the newly created relation as well
            ret.SetParent(parent);
            
            Log("Resolved relation " + r.ToString());
            Log("to " + ret.ToString());
            Log("non-generics = " + r.GetNonGenericsForChildren());

            return ret;
        }

        public Vector ResolveVector(Vector vec, Stack<Constraint> visited, Relation parent)
        {
            Vector ret = new Vector();
            foreach (Constraint c in vec)
                ret.Add(Resolve(c, visited, parent));
            return ret;
        }

        public Constraint ResolveVar(Var v, Stack<Constraint> visited, Relation parent)
        {
            Constraint ret = GetUnifierFor(v);
            if (ret == null)
            {
                ret = v;
            }
            else if (ret == v)
            {
                // do nothing
            }
            else if (ret is Var)
            {
                Trace.Assert((ret as Var) == ret);
            }
            else if (ret is Vector)
            {
                ret = Resolve(ret, visited, parent);
            }
            else if (ret is Relation)
            {
                ret = Resolve(ret, visited, parent);
            }
            else if (ret is Constant)
            {
                // do nothing
            }
            else if (ret is RecursiveRelation)
            {
                // do nothing
            }
            else
            {
                Err("Unhandled constraint " + ret.ToString());
            }
            //Log("Resolved var");
            //Log(c.ToString() + " to " + ret.ToString());
            return ret;
        }

        public Constraint GetRecursiveVar(Constraint c, Stack<Constraint> visited)
        {
            if (!(c is Var)) 
                return null;
            Var v = c as Var;
            Constraint[] a = visited.ToArray();
            Relation prevRelation = null;
            for (int i = 0; i < a.Length; ++i)
            {
                Constraint tmp = a[i];
                if (tmp is Var)
                {
                    Var v2 = tmp as Var;
                    if (v2.ToString().Equals(v.ToString()))
                    {
                        if (prevRelation == null)
                        {
                            // Recursive variable
                            Trace.Assert(c is VectorVar);
                            return c;
                        }
                        return new RecursiveRelation();
                    }
                }
                else if (tmp is Relation)
                {
                    prevRelation = tmp as Relation;
                }
            }
            return null;
        }

        /// <summary>
        /// This takes a unifier and replaces all variables with their unifiers.
        /// </summary>
        public Constraint Resolve(Constraint c, Stack<Constraint> visited, Relation parent)
        {
            Constraint rec = GetRecursiveVar(c, visited);
            if (rec != null) 
                return rec;

            visited.Push(c);
            Constraint ret;
            if (c is Var)
            {
                ret = ResolveVar(c as Var, visited, parent);
            }
            else if (c is Vector)
            {
                ret = ResolveVector(c as Vector, visited, parent);
            }
            else if (c is Relation)
            {
                ret = ResolveRelation(c as Relation, visited, parent);
            }
            else
            {
                ret = c;
            }
            visited.Pop();
            Trace.Assert(ret != null);
            return ret;
        }
        #endregion
    }
}
