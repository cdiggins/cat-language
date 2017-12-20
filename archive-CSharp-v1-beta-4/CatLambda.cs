/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    /// <summary>
    /// This class allwows us to convert Cat with named parameters,
    /// to Cat without.
    /// </summary>
    public static class CatLambdaConverter
    {
        public static int gnId = 0;

        public static void Convert(AstRoot p)
        {
            foreach (AstDef x in p.Defs)
                Convert(x);
        }

        public static string GenerateUniqueName(string sArg)
        {
            return sArg + "$" + gnId++.ToString();
        }

        public static void RenameFirstInstance(string sOld, string sNew, List<CatAstNode> terms)
        {
            for (int i = 0; i < terms.Count; ++i)
            {
                if (TermContains(terms[i], sOld))
                {
                    if (terms[i] is AstLambda)
                    {
                        AstLambda l = terms[i] as AstLambda;
                        RenameFirstInstance(sOld, sNew, l.mTerms);
                        return;
                    }
                    else if (terms[i] is AstQuote)
                    {
                        AstQuote q = terms[i] as AstQuote;
                        RenameFirstInstance(sOld, sNew, q.mTerms);
                        return;
                    }
                    else 
                    {
                        // Should never happen.
                        throw new Exception("expected either a lamda node or quote node");
                    }
                }
                else if (TermEquals(terms[i], sOld))
                {
                    terms[i] = new AstName(sNew);
                    return;
                }
            }
            throw new Exception(sOld + " was not found in the list of terms");
        }

        public static bool TermEquals(CatAstNode term, string var)
        {
            return term.ToString().Equals(var);
        }

        public static bool TermContains(CatAstNode term, string var)
        {
            if (term is AstQuote)
            {
                AstQuote q = term as AstQuote;
                foreach (CatAstNode child in q.mTerms)
                {
                    if (TermContainsOrEquals(child, var))
                        return true;
                }
                return false;
            }
            else if (term is AstLambda)
            {
                AstLambda l = term as AstLambda;
                foreach (CatAstNode child in l.mTerms)
                {
                    if (TermContainsOrEquals(child, var))
                        return true;
                }
                return false;
            }
            else
            {
                return false;
            }
        }

        public static int CountInstancesOf(string var, List<CatAstNode> terms)
        {
            int ret = 0;
            foreach (CatAstNode term in terms)
            {
                if (term is AstQuote)
                {
                    AstQuote q = term as AstQuote;
                    ret += CountInstancesOf(var, q.mTerms);
                }
                else if (term is AstLambda)
                {
                    AstLambda l = term as AstLambda;
                    ret += CountInstancesOf(var, l.mTerms);
                }
                else
                {
                    if (TermEquals(term, var))
                        ret += 1;
                }
            }
            return ret;
        }

        public static bool TermContainsOrEquals(CatAstNode term, string var)
        {
            return TermEquals(term, var) || TermContains(term, var);
        }

        public static void RemoveTerm(string var, List<CatAstNode> terms)
        {
            // Find the first term that either contains, or is equal to the 
            // free variable
            int i = 0;
            while (i < terms.Count)
            {
                if (TermContainsOrEquals(terms[i], var))
                    break;
                ++i;
            }

            if (i == terms.Count)
                throw new Exception("error in abstraction elimination algorithm");

            if (i > 0)
            {
                AstQuote q = new AstQuote(terms.GetRange(0, i));
                terms.RemoveRange(0, i);
                terms.Insert(0, q);
                terms.Insert(1, new AstName("dip"));
                i = 2;
            }
            else
            {
                i = 0;
            }

            if (TermEquals(terms[i], var))
            {
                terms[i] = new AstName("id");
                return;
            }
            else if (TermContains(terms[i], var))
            {
                if (terms[i] is AstQuote)
                {
                    AstQuote subExpr = terms[i] as AstQuote;
                    RemoveTerm(var, subExpr.mTerms);
                }
                else if (TermContains(terms[i], var))
                {
                    AstLambda subExpr = terms[i] as AstLambda;
                    RemoveTerm(var, subExpr.mTerms);
                }
                else
                {
                    throw new Exception("internal error: expected either a quotation or lambda term");
                }
                terms.Insert(i + 1, new AstName("papply"));
                return;
            }
            else
            {
                throw new Exception("error in abstraction elimination algorithm");
            }
        }

        /* DEBUG: 
        private static string VarsToString(List<string> vars)
        {
            string ret = "";
            foreach (string s in vars)
                ret += s + " ";
            return ret;
        }
         */

        /// <summary>
        /// Converts a list of terms to point-free form. 
        /// </summary>
        public static void ConvertTerms(List<string> vars, List<CatAstNode> terms)
        {
            for (int i = 0; i < terms.Count; ++i)
            {
                CatAstNode exp = terms[i];
                if (exp is AstLambda)
                    Convert(exp as AstLambda);
            }

            if (vars.Count == 0) 
                return;

            for (int i = 0; i < vars.Count; ++i)
            {
                string var = vars[i];

                if (CountInstancesOf(var, terms) == 0)
                {
                    // Remove unused arguments
                    terms.Insert(0, new AstName("pop"));
                }
                else
                {
                    int nDupCount = 0;
                    while (CountInstancesOf(var, terms) > 1)
                    {
                        // Create a new name for the used argument
                        string sNewVar = GenerateUniqueName(var);
                        RenameFirstInstance(var, sNewVar, terms);
                        RemoveTerm(sNewVar, terms);
                        nDupCount++;
                    }

                    RemoveTerm(var, terms);
                    
                    for (int j=0; j < nDupCount; ++j)
                        terms.Insert(0, new AstName("dup"));
                }
            }
        }

        public static void Convert(AstLambda l)
        {
            ConvertTerms(l.mIdentifiers, l.mTerms);            
            
            // We won't be needing the identifiers anymore and I don't want
            // to have the conversion algorithm get run potentially multiple 
            // times on each lambda term. 
            l.mIdentifiers.Clear();
        }

        /// <summary>
        /// This is known as an abstraction algorithm. It converts from 
        /// a form with named parameters to point-free form.
        /// </summary>
        /// <param name="sRightConsequent"></param>
        public static void Convert(AstDef d)
        {
            if (IsPointFree(d)) 
                return;

            List<string> args = new List<string>();
            foreach (AstParam p in d.mParams)
                args.Add(p.ToString());

            ConvertTerms(args, d.mTerms);           
        }

        public static bool IsPointFree(AstRoot p)
        {
            foreach (AstDef d in p.Defs)
                if (!IsPointFree(d))
                    return false;
            return true;
        }

        public static bool IsPointFree(AstDef d)
        {
            return d.mParams.Count == 0;
        }
    }
}
