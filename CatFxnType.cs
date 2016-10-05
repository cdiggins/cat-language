using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    public class CatFxnType : CatTypeKind
    {
        #region fields
        protected CatTypeVector mProd;
        protected CatTypeVector mCons;
        bool mbSideEffects;
        CatFxnType mpParent;
        CatTypeVarList mpFreeVars = new CatTypeVarList();
        protected int mnId = gnId++;
        #endregion

        #region static functions 
        public static CatFxnType PushSomethingType = Create("( -> 'a)");
        public static CatFxnType AnyFxnType = Create("('A -> 'B)");
        public static CatFxnType PushAnythingType = Create("( -> 'A)");

        public static CatFxnType Create(string sType)
        {
            if (sType.Length == 0)
                return null;

            Peg.Parser p = new Peg.Parser(sType);
            try
            {
                if (!p.Parse(CatGrammar.FxnType()))
                    throw new Exception("no additional information");
            }
            catch (Exception e)
            {
                throw new Exception(sType + " is not a valid function type ", e);
            }

            Peg.PegAstNode ast = p.GetAst();
            if (ast.GetNumChildren() != 1)
                throw new Exception("invalid number of children in abstract syntax tree");
            AstFxnType node = new AstFxnType(ast.GetChild(0));
            CatFxnType ret = new CatFxnType(node);
            
            return ret;
        }

        public static CatFxnType ComposeFxnTypes(CatFxnType f, CatFxnType g)
        {
            CatFxnType ft = CatTypeReconstructor.ComposeTypes(f, g);
            return ft;
        }

        public static CatFxnType Unquote(CatFxnType ft)
        {
            if (ft == null)
                return null;
            if (ft.GetCons().GetKinds().Count > 0)
                throw new Exception("Can't unquote a function type with a consumption size greater than zero");
            if (ft.GetProd().GetKinds().Count != 1)
                throw new Exception("Can't unquote a function type which does not produce a single function");
            CatKind k = ft.GetProd().GetKinds()[0];
            if (!(k is CatFxnType))
                throw new Exception("Can't unquote a function type which does not produce a single function");
            return k as CatFxnType;
        }
        #endregion

        #region constructors
        public CatFxnType(CatTypeVector cons, CatTypeVector prod, bool bSideEffects)
        {
            mCons = new CatTypeVector(cons);
            mProd = new CatTypeVector(prod);
            mbSideEffects = bSideEffects;
            SetChildFxnParents();
            ComputeFreeVars();
        }

        public CatFxnType()
        {
            mbSideEffects = false;
            mCons = new CatTypeVector();
            mProd = new CatTypeVector();
            SetChildFxnParents();
            ComputeFreeVars();
        }

        public CatFxnType(AstFxnType node)
        {
            mbSideEffects = node.HasSideEffects();
            mCons = new CatTypeVector(node.mCons);
            mProd = new CatTypeVector(node.mProd);
            SetChildFxnParents();
            ComputeFreeVars();
        }
        #endregion

        #region variable functions
        private CatTypeVector AddImplicitRhoVariables(CatTypeVector v)
        {
            CatTypeVector ret = new CatTypeVector();
            foreach (CatKind k in v.GetKinds())
            {
                if (k is CatFxnType)
                    ret.Add((k as CatFxnType).AddImplicitRhoVariables());
                else if (k is CatTypeVector)
                    ret.Add(AddImplicitRhoVariables(k as CatTypeVector));
                else
                    ret.Add(k);                    
            }
            return ret;
        }

        public virtual CatFxnType AddImplicitRhoVariables()
        {
            CatTypeVector cons = AddImplicitRhoVariables(GetCons());
            CatTypeVector prod = AddImplicitRhoVariables(GetProd());            

            if (!(cons.GetBottom() is CatStackVar))
            {
                CatStackVar rho = CatStackVar.CreateUnique();
                cons.PushKindBottom(rho);
                prod.PushKindBottom(rho);
            }

            return new CatFxnType(cons, prod, HasSideEffects());
        }

        public void RemoveImplicitRhoVariables()
        {
            // TEMP: TODO: figure out whether or not to remove this. 
            // RemoveImplicitRhoVariables(this);
        }

        /// <summary>
        /// This function modifies the function
        /// </summary>
        public void RemoveImplicitRhoVariables(CatFxnType ft)
        {
            foreach (CatKind k in ft.GetChildKinds())
                if (k is CatFxnType)
                    RemoveImplicitRhoVariables(k as CatFxnType);

            if (!ft.GetCons().IsEmpty() && !ft.GetProd().IsEmpty())
            {
                CatKind k1 = ft.GetCons().GetBottom();
                CatKind k2 = ft.GetProd().GetBottom();
                
                // Does both consumption and production share the same
                // stack variable at the bottom, if so, then we might have 
                // an implicit Rho variables
                if (k1 is CatStackVar && k1.Equals(k2)) 
                {
                    // try removing the stack variable
                    ft.GetCons().GetKinds().RemoveAt(0);
                    ft.GetProd().GetKinds().RemoveAt(0);

                    // is the variable used anywhere else?
                    // if so, then we have to restore it
                    // otherwise we leave it taken away
                    if (DoesVarExist(k1))
                    {
                        ft.GetCons().GetKinds().Insert(0, k1);
                        ft.GetProd().GetKinds().Insert(0, k2);
                    }                
                }
            }
        }

        public bool DoesVarExist(CatKind k)
        {
            Trace.Assert(k.IsKindVar());
            foreach (CatKind tmp in GetDescendantKinds())
                if (tmp.Equals(k))
                    return true;
            return false;
        }

        public CatTypeVarList GetAllVars()
        {
            CatTypeVarList ret = new CatTypeVarList();
            GetAllVars(ret);
            return ret;
        }

        private void GetAllVars(CatTypeVarList vars)
        {
            foreach (CatKind k in GetChildKinds())
            {
                if (k is CatFxnType)
                {
                    (k as CatFxnType).GetAllVars(vars);
                }
                else if (k.IsKindVar())
                {
                    vars.Add(k);
                }
            }
        }

        /* TODO: LOWPRI: remove
        private CatTypeVarList GetVarsExcept(CatFxnType except)
        {
            CatTypeVarList ret = new CatTypeVarList();
            GetVarsExcept(except, ret);
            return ret;
        }

        private void GetVarsExcept(CatFxnType except, CatTypeVarList vars)
        {
            foreach (CatKind k in GetChildKinds())
            {
                if (k is CatFxnType)
                {
                    CatFxnType ft = k as CatFxnType;
                    if (ft != except)
                        ft.GetVarsExcept(except, vars);
                }
                else
                {
                    if (k.IsKindVar())
                        vars.Add(k);
                }
            }
        }
        */

        /// <summary>
        /// Every kind variable has a scope in which it is free. 
        /// This allows us to compute whether a variable is free or bound.
        /// The purpose of figuring whether a variable is free or bound, is so 
        /// that when we copy a function, we can make sure that any free variables
        /// are given new unique names. Basically we want to make new names, 
        /// but we can't always do that. 
        /// </summary>
        /// <param name="scopes"></param>
        private void ComputeVarScopes(CatVarScopes scopes, Stack<CatFxnType> visited)
        {
            if (visited.Contains(this))
                return;

            foreach (CatKind k in GetChildKinds())
            {
                if (k.IsKindVar())
                {
                    scopes.Add(k, this);
                }
                else if (k is CatFxnType)
                {
                    CatFxnType ft = k as CatFxnType;
                    visited.Push(ft);
                    ft.ComputeVarScopes(scopes, visited);
                    visited.Pop();
                }
            }
        }

        private CatVarScopes ComputeVarScopes()
        {
            CatVarScopes scopes = new CatVarScopes();
            ComputeVarScopes(scopes, new Stack<CatFxnType>());
            return scopes;
        }

        private void ComputeFreeVars()
        {
            CatVarScopes scopes = ComputeVarScopes();
            SetFreeVars(scopes, new Stack<CatFxnType>());

            // TODO:
            // Use the scopes to find out if a function type is well-formed or not.
            // i.e. CheckIsWellFormed(scopes);
        }

        private bool IsFreeVar(CatKind k, CatVarScopes scopes)
        {
            return scopes.IsFreeVar(this, k);
        }

        private void SetFreeVars(CatVarScopes scopes, Stack<CatFxnType> visited)
        {
            if (visited.Contains(this))
                return;
            foreach (CatKind k in GetDescendantKinds())
            {
                // iterate over the values
                if (IsFreeVar(k, scopes))
                    mpFreeVars.Add(k);
                else if (k is CatFxnType)
                {
                    visited.Push(this);
                    (k as CatFxnType).SetFreeVars(scopes, visited);
                    visited.Pop();
                }
            }
        }

        public bool IsFreeVar(CatKind var)
        {
            if (!var.IsKindVar())
                return false;
            return mpFreeVars.ContainsKey(var.ToString());
        }
        #endregion

        #region production and consumption
        public int GetMaxProduction()
        {
            int nCnt = 0;

            List<CatKind> list = mProd.GetKinds();
            for (int i = list.Count - 1; i >= 0; --i)
            {
                CatKind k = list[i];
                if (k is CatStackVar)
                {
                    if ((i == 0) && k.Equals(mCons.GetBottom()))
                        return nCnt;
                    else
                        return -1;
                }
                nCnt++;
            }

            return nCnt;
        }

        public int GetMaxConsumption()
        {
            int nCnt = 0;

            List<CatKind> list = mCons.GetKinds();
            for (int i = list.Count - 1; i >= 0; --i)
            {
                CatKind k = list[i];
                if (k is CatStackVar)
                {
                    if ((i == 0) && k.Equals(mProd.GetBottom()))
                        return nCnt;
                    else
                        return -1;
                }
                nCnt++;
            }

            return nCnt;
        }

        public CatTypeVector GetProd()
        {
            return mProd;
        }

        public CatTypeVector GetCons()
        {
            return mCons;
        }
        #endregion 

        #region string formatting
        public override string ToString()
        {
            if (mbSideEffects)
                return "(" + GetCons().ToString() + " ~> " + GetProd().ToString() + ")"; else
                return "(" + GetCons().ToString() + " -> " + GetProd().ToString() + ")";
        }

        public override string ToIdString()
        {
            string ret = "";
            if (mbSideEffects)
                ret = "(" + GetCons().ToIdString() + " ~> " + GetProd().ToIdString() + ")"; else
                ret = "(" + GetCons().ToIdString() + " -> " + GetProd().ToIdString() + ")";
            ret += "_" + mnId.ToString();
            return ret;
        }

        public static string IntToPrettyString(int n)
        {
            string s = "";
            if (n > 26) 
                s += IntToPrettyString(n / 26);
            char c = 'a';
            c += (char)(n % 26);
            s += c.ToString();
            return "'" + s;
        }

        public static string ToPrettyString(CatTypeVector vec, Dictionary<string, string> dic)
        {
            string s = "";
            for (int i=0; i < vec.GetKinds().Count; ++i)
            {
                if (i > 0) s += " ";
                CatKind k = vec.GetKinds()[i];
                if (k.IsKindVar())
                {
                    if (!dic.ContainsKey(k.ToString()))
                    {
                        string sNew = IntToPrettyString(dic.Count);
                        if (k is CatStackVar)
                            sNew = sNew.ToUpper();
                        dic.Add(k.ToString(), sNew);
                    }

                    s += dic[k.ToString()];                        
                }
                else if (k is CatFxnType)
                {
                    s += "(" + ToPrettyString(k as CatFxnType, dic) + ")";
                }
                else if (k is CatTypeVector)
                {
                    s += ToPrettyString(k as CatFxnType, dic);
                }
                else
                {
                    s += k.ToString();
                }
            }
            return s;
        }

        public virtual string ToPrettyString()
        {
            return "(" + ToPrettyString(this, new Dictionary<string, string>()) + ")";
        }

        public static string ToPrettyString(CatFxnType ft, Dictionary<string, string> dic)
        {
            // remove rho variables
            ft = ft.Clone();
            ft.RemoveImplicitRhoVariables();

            string s = ToPrettyString(ft.GetCons(), dic);                        
            if (ft.HasSideEffects())
                s += " ~> ";
            else
                s += " -> ";

            s += ToPrettyString(ft.GetProd(), dic);

            return s;
        }
        #endregion

        #region comparison functions
        /// <summary>
        /// This is a raw equivalency check: no normalization is done. 
        /// To comparse function type normally you would use CompareFxnTypes,
        /// which in turn calls this function.
        /// </summary>
        public override bool Equals(CatKind k)
        {
            if (!(k is CatFxnType)) return false;
            CatFxnType f = k as CatFxnType;
            return (GetCons().Equals(f.GetCons()) && GetProd().Equals(f.GetProd()) 
                && HasSideEffects() == f.HasSideEffects());
        }

        public override bool IsSubtypeOf(CatKind k)
        {
            if (k.IsAny() || k.IsDynFxn())
                return IsRuntimePolymorphic();
            if (k is CatTypeVar)
                return true;
            if (!(k is CatFxnType)) 
                return false;
            CatFxnType f = k as CatFxnType;
            bool ret = GetCons().IsSubtypeOf(f.GetCons()) && GetProd().IsSubtypeOf(f.GetProd());
            if (HasSideEffects())
                ret = ret && f.HasSideEffects();
            return ret;
        }

        /// <summary>
        /// Compares two function types, by first normalizing so that they each have 
        /// names of variables that correspond to the locations in the function
        /// </summary>
        public static bool CompareFxnTypes(CatFxnType f, CatFxnType g)
        {
            CatFxnType f2 = CatVarRenamer.RenameVars(f.AddImplicitRhoVariables());
            CatFxnType g2 = CatVarRenamer.RenameVars(g.AddImplicitRhoVariables());
            return f2.IsSubtypeOf(g2);
        }
        #endregion

        #region verifications
        public bool IsValidChildFxn(List<string> varNames, CatFxnType ft)
        {
            foreach (CatKind k in ft.GetCons().GetKinds())
            {
                if (k.IsKindVar())
                    varNames.Add(k.ToString());
            }
            return IsValidProduction(varNames, ft.GetProd());                    
        }

        public void GetConsVarNames(List<string> varNames, CatFxnType ft)
        {
            foreach (CatKind k in ft.GetCons().GetKinds())
            {
                if (k.IsKindVar())
                    varNames.Add(k.ToString());
                if (k is CatFxnType)
                    GetConsVarNames(varNames, k as CatFxnType); 
            }
        }

        public bool IsValidProduction(List<string> varNames, CatTypeVector prod)
        {
            foreach (CatKind k in prod.GetKinds())
                if (k is CatFxnType)
                    GetConsVarNames(varNames, k as CatFxnType);

            foreach (CatKind k in prod.GetKinds())
                if (k.IsKindVar())
                    if (!varNames.Contains(k.ToString()))
                        return false;

            return true;
        }

        public bool IsValid()
        {
            // TODO : rewrite this function
            return true;

            /*
            // TODO: check that if pure, none of the child functions are impure. 
            if (!GetCons().IsValid()) 
                return false;
            if (!GetProd().IsValid()) 
                return false;

            List<string> varNames = new List<string>();
            foreach (CatKind k in GetCons().GetDescendantKinds())
            {
                if (k.IsKindVar())
                {
                    string s = k.ToString();
                    if (!varNames.Contains(s))
                        varNames.Add(s);
                }
            }

            if (!IsValidProduction(varNames, GetProd()))
                return false;
            return true;
             */
        }
        #endregion  

        #region utility functions 
        public CatFxnType Clone()
        {
            return new CatFxnType(mCons, mProd, mbSideEffects);
        }

        public bool HasSideEffects()
        {
            return mbSideEffects;
        }

        /// <summary>
        /// Returns true if this function can be converted to either "any" or a "fxn".
        /// </summary>
        public bool IsRuntimePolymorphic()
        {
            return (GetCons().GetKinds().Count == 1) && (GetProd().GetKinds().Count == 1);
        }
        #endregion 

        #region parent / child functions
        public CatFxnType GetParent()
        {
            return mpParent;
        }

        public CatFxnType GetAncestor()
        {
            if (mpParent == null)
                return this;
            return mpParent.GetAncestor();
        }

        public bool DescendentOf(CatFxnType ft)
        {
            if (this == ft)
                return true;
            if (mpParent == null)
                return false;
            return mpParent.DescendentOf(ft);
        }

        public void SetParent(CatFxnType parent)
        {
            mpParent = parent;
        }

        private void SetChildFxnParents()
        {
            foreach (CatKind k in GetChildKinds())
            {
                if (k is CatFxnType)
                {
                    CatFxnType ft = k as CatFxnType;
                    ft.SetChildFxnParents();
                    ft.SetParent(this);
                }
            }
        }

        public override IEnumerable<CatKind> GetChildKinds()
        {
            foreach (CatKind k in mCons.GetChildKinds())
                yield return k;
            foreach (CatKind k in mProd.GetChildKinds())
                yield return k;
        }

        public override IEnumerable<CatKind> GetDescendantKinds()
        {
            foreach (CatKind k in mCons.GetDescendantKinds())
                yield return k;
            foreach (CatKind k in mProd.GetDescendantKinds())
                yield return k;
        }
        #endregion
    }

    public class CatQuotedType : CatFxnType
    {
        public CatQuotedType(CatKind k)
        {
            GetProd().Add(k);
        }
    }

    public class CatRecursiveType : CatKind
    {
        public CatRecursiveType()
        {
        }

        public override string ToString()
        {
            return "self";
        }

        public override bool Equals(CatKind k)
        {
            return k is CatRecursiveType;
        }

        public override IEnumerable<CatKind> GetChildKinds()
        {
            return new List<CatKind>();
        }

        public override IEnumerable<CatKind> GetDescendantKinds()
        {
            return new List<CatKind>();
        }
    }
}
