/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{

    /// <summary>
    /// The renamer assigns new names to a set of variables either from a supplied 
    /// dictionary or by generating unique names.
    /// </summary>
    public class CatVarRenamer
    {
        int mnId = 0;

        CatTypeVarList mNames;

        #region constructors

        public CatVarRenamer()
        {
            mNames = new CatTypeVarList();
        }
        #endregion

        #region static functions
        public static bool IsStackVarName(string s)
        {
            Trace.Assert(s.Length > 0);
            Trace.Assert(s[0] == '\'');
            char c = s[1];
            if (char.IsLower(c))
                return false;
            else
                return true;
        }

        public CatKind GenerateNewVar(string s)
        {
            if (IsStackVarName(s))
                return new CatStackVar("S" + (mnId++).ToString());
            else
                return new CatTypeVar("t" + (mnId++).ToString());
        }
        #endregion

        /// <summary>
        /// This forgets previously generated names, but assures that new names generated will be unique.
        /// </summary>
        public void ResetNames()
        {
            mNames.Clear();
        }

        public static CatFxnType RenameVars(CatFxnType ft)
        {
            return (new CatVarRenamer()).Rename(ft);
        }

        public CatKind Rename(CatKind k)
        {
            if (k is CatFxnType)
                return Rename(k as CatFxnType);
            else if (k is CatTypeKind)
                return Rename(k as CatTypeKind);
            else if (k is CatStackVar)
                return Rename(k as CatStackVar);
            else if (k is CatTypeVector)
                return Rename(k as CatTypeVector);
            else if (k is CatCustomKind)
                return k;
            else if (k is CatRecursiveType)
                return k;
            else
                throw new Exception(k.ToString() + " is an unrecognized kind");
        }

        public CatFxnType Rename(CatFxnType f)
        {
            if (f == null)
                throw new Exception("Invalid null parameter to rename function");
            return new CatFxnType(Rename(f.GetCons()), Rename(f.GetProd()), f.HasSideEffects());
        }

        public CatTypeVector Rename(CatTypeVector s)
        {
            CatTypeVector ret = new CatTypeVector();
            foreach (CatKind k in s.GetKinds())
                ret.Add(Rename(k));
            return ret;
        }

        public CatStackKind Rename(CatStackVar s)
        {
            string sName = s.ToString();

            if (mNames.ContainsKey(sName))
            {
                CatKind tmp = mNames[sName];
                if (!(tmp is CatStackKind))
                    throw new Exception(sName + " is not a stack kind");
                return tmp as CatStackKind;
            }

            CatStackVar var = GenerateNewVar(sName) as CatStackVar;
            mNames.Add(sName, var);
            return var;
        }

        public CatTypeKind Rename(CatTypeKind t)
        {
            if (t == null)
                throw new Exception("Invalid null parameter to rename function");
            if (t is CatFxnType)
            {
                return Rename(t as CatFxnType);
            }
            else if (t is CatTypeVar)
            {
                string sName = t.ToString();
                if (mNames.ContainsKey(sName))
                {
                    CatTypeKind ret = mNames[sName] as CatTypeKind;
                    if (ret == null)
                        throw new Exception(sName + " is not a type kind");
                    return ret;
                }

                CatTypeVar var = GenerateNewVar(sName) as CatTypeVar;
                mNames.Add(sName, var);
                return var;
            }
            else
            {
                return t;
            }
        }
        public static bool DoesVarOccurIn(CatKind k, CatTypeVector vec, CatFxnType except)
        {
            foreach (CatKind tmp in vec.GetKinds())
            {
                if (tmp.IsKindVar() && tmp.Equals(k))
                    return true;

                if (tmp is CatFxnType)
                    if (DoesVarOccurIn(k, tmp as CatFxnType, except))
                        return true;
            }
            return false;
        }

        public static bool DoesVarOccurIn(CatKind k, CatFxnType ft, CatFxnType except)
        {
            if (!k.IsKindVar()) return false;
            if (k == except) return false;
            return DoesVarOccurIn(k, ft.GetCons(), except) || DoesVarOccurIn(k, ft.GetProd(), except);
        }

        public static bool IsFreeVar(CatKind k, CatFxnType left, CatFxnType right, CatFxnType except)
        {
            return !DoesVarOccurIn(k, left, except) && !DoesVarOccurIn(k, right, except);
        }

        public static CatFxnType RenameFreeVars(CatFxnType left, CatFxnType right, CatFxnType ft)
        {
            CatTypeVarList vars = ft.GetAllVars();
            foreach (string s in vars.Keys)
            {
                CatKind k = vars[s];
                if (IsFreeVar(k, left, right, ft))
                {
                    if (k is CatTypeVar)
                        vars[s] = CatTypeVar.CreateUnique();
                    else
                        vars[s] = CatStackVar.CreateUnique();
                }
            }
            return RenameVars(ft, vars);
        }

        static CatTypeVector RenameVars(CatTypeVector vec, CatTypeVarList vars)
        {
            CatTypeVector ret = new CatTypeVector();
            foreach (CatKind k in vec.GetKinds())
            {
                if (k.IsKindVar() && vars.ContainsKey(k.ToString()))
                    ret.Add(vars[k.ToString()]);
                else if (k is CatFxnType)
                    ret.Add(RenameVars(ret, vars));
                else if (k is CatTypeVector)
                    throw new Exception("unexpected type vector in function during renaming");
                else
                    ret.Add(k);
            }
            return ret;
        }

        static CatFxnType RenameVars(CatFxnType ft, CatTypeVarList vars)
        {
            return new CatFxnType(RenameVars(ft.GetCons(), vars), RenameVars(ft.GetProd(), vars), ft.HasSideEffects());
        }
    }
}