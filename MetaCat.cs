/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    public static class MetaCat
    {        
        #region fields
        static Dictionary<string, List<AstMacro>> mMacros = new Dictionary<string, List<AstMacro>>();
        #endregion

        class MacroMatch
        {
            public AstMacro mMacro;
            public Dictionary<string, CatExpr> mCapturedVars = new Dictionary<string, CatExpr>();
            public int mnFxnIndex = -1;
            public int mnFxnCount = 0;

            public MacroMatch(AstMacro m)
            {
                mMacro = m;
            }

            public bool DoesTokenMatch(AstMacroTerm tkn, CatExpr x, out bool bRecoverable)
            {
                bRecoverable = true;

                if (tkn is AstMacroName)
                {
                    bRecoverable = false;
                    if (x.Count != 1)
                        return false;
                    Function f = x[0];
                    string sName = f.GetName();
                    return sName == tkn.ToString();
                }
                else if (tkn is AstMacroTypeVar)
                {
                    if (x.GetFxnType() == null)
                        return false;

                    if (!CatFxnType.CompareFxnTypes(x.GetFxnType(), CatFxnType.PushSomethingType))
                        return false;

                    mCapturedVars.Add(tkn.ToString(), x);
                    return true;
                }
                else if (tkn is AstMacroQuote)
                {
                    AstMacroQuote macroQuote = tkn as AstMacroQuote;
                    if (x.Count != 1)
                        return false;
                    PushFunction quote = x[0] as PushFunction;
                    if (quote == null)
                        return false; 

                    for (int i = 0; i < macroQuote.mTerms.Count; ++i)
                    {
                        // Are we are at a stack variable in the matching pattern 
                        // if so it must be the last token in the pattern
                        // e.g. [1 2 $A] is legal [1 $A 2] is not. 
                        if (macroQuote.mTerms[i] is AstMacroStackVar)
                        {
                            if (i != macroQuote.mTerms.Count - 1)
                                throw new Exception("within a quotation, expression variables can only be used in the right-most postition");
                            AstMacroStackVar v = macroQuote.mTerms[0] as AstMacroStackVar;
                            CatExpr expr = quote.GetChildren().GetRangeFrom(i);
                            mCapturedVars.Add(v.msName, expr);
                            return true;
                        }
                        else if (macroQuote.mTerms[i] is AstMacroName)
                        {
                            // Well this is just an ordinary name pattern 
                            AstMacroName name = macroQuote.mTerms[i] as AstMacroName;
                            if (quote.GetChildren().Count <= i)
                                return false;
                            Function f = quote.GetChildren()[i];
                            if (!f.GetName().Equals(name.ToString()))
                                return false;
                        }
                        else
                        {
                            return false;
                        }
                    }

                    // No stack variable was encountered in the pattern
                    // therefore the match must have been perfect, which means there are no
                    // more terms in the input
                    if (quote.GetChildren().Count != macroQuote.mTerms.Count)
                        return false;

                    return true;
                }
                else if (tkn is AstMacroStackVar)
                {
                    AstMacroStackVar v = tkn as AstMacroStackVar;

                    if (v.mType == null)
                        return false;

                    if (x.GetFxnType() == null)
                        return false;

                    if (!CatFxnType.CompareFxnTypes(x.GetFxnType(), v.mType))
                        return false;

                    mCapturedVars.Add(v.msName, x);
                    return true;
                }
                else
                {
                    throw new Exception("unrecognized macro term " + tkn.ToString());
                }
            }

            public CatExpr PatternToFxns(INameLookup names, List<AstMacroTerm> pattern)
            {
                CatExpr ret = new CatExpr();
                foreach (AstMacroTerm t in pattern)
                {
                    if (t is AstMacroTypeVar)
                    {
                        string s = t.ToString();
                        if (!mCapturedVars.ContainsKey(s))
                            throw new Exception("macro variable " + s + " was not captured");
                        CatExpr expr = mCapturedVars[s];
                        ret.AddRange(expr);
                    }
                    else if (t is AstMacroStackVar)
                    {
                        string s = (t as AstMacroStackVar).msName;
                        if (!mCapturedVars.ContainsKey(s))
                            throw new Exception("macro variable " + s + " was not captured");
                        CatExpr expr = mCapturedVars[s];
                        ret.AddRange(expr);
                    }
                    else if (t is AstMacroName)
                    {
                        string s = t.ToString();
                        if (s.Length < 1) 
                            throw new Exception("internal error: macro name is empty string");

                        Function f = names.ThrowingLookup(s);
                        
                        if (f == null)
                        {
                            if (Char.IsDigit(s[0]))
                            {
                                f = new PushInt(int.Parse(s));
                            }
                            else
                            {
                                throw new Exception("Could not find function " + s);
                            }
                        }
                        ret.Add(f);
                    }
                    else if (t is AstMacroQuote)
                    {
                        // TODO: handle typed terms within a quotation.
                        AstMacroQuote macroQuote = t as AstMacroQuote;
                        List<AstMacroTerm> localPattern = macroQuote.mTerms;
                        PushFunction q = new PushFunction(PatternToFxns(names, localPattern));
                        ret.Add(q);
                    }
                    else
                    {
                        throw new Exception("unrecognized macro term " + t.ToString());
                    }
                }
                return ret;
            }

            public void Replace(INameLookup names, CatExpr fxns, List<AstMacroTerm> pattern)
            {
                CatExpr pNewFxns = PatternToFxns(names, pattern);

                // For debugging purposes only
                if (Config.gbShowRewritingRuleApplications) 
                {
                    string sFrom = "";
                    for (int i=mnFxnIndex; i < mnFxnIndex + mnFxnCount; ++i)
                    {
                        if (i > mnFxnIndex) sFrom += " ";
                        sFrom += fxns[i].msName;
                    }
                    string sTo = "";
                    for (int i=0; i < pNewFxns.Count; ++i)
                    {
                        if (i > 0) sTo += " ";
                        sTo += pNewFxns[i].msName;
                    }
                    MainClass.WriteLine("Rewriting { " + sFrom + " } to { " + sTo + " }");
                }

                if (mnFxnIndex < fxns.Count)
                    fxns.RemoveRange(mnFxnIndex, mnFxnCount);

                fxns.InsertRange(mnFxnIndex, pNewFxns);
            }

            static public MacroMatch Create(AstMacro m, CatExpr fxns, int nPrevMatchPos, int nFxnIndex, int nSubExprSize)
            {
                if (nFxnIndex < 0) 
                    return null;
                if (nFxnIndex >= fxns.Count) 
                    return null;

                List<AstMacroTerm> pattern = m.mSrc.mPattern;

                MacroMatch match = new MacroMatch(m);
                               
                int nFirst = nFxnIndex;
                int nLast = nFxnIndex;
                                
                int nTokenIndex = pattern.Count - 1;
                               
                // Start at the end of the pattern and move backwards comparing expressions
                while (nFirst > nPrevMatchPos)
                {
                    Trace.Assert(nTokenIndex <= pattern.Count);
                    Trace.Assert(nFirst >= 0);
                    Trace.Assert(nLast >= nFirst);
                    Trace.Assert(nTokenIndex < pattern.Count);

                    // get the current sub-expression that we are evaluating 
                    CatExpr expr = fxns.GetRangeFromTo(nFirst, nLast);
                    
                    AstMacroTerm tkn = pattern[nTokenIndex];

                    bool bRecoverable = false;
                    if (match.DoesTokenMatch(tkn, expr, out bRecoverable))
                    {                          
                        // Check if we have matched the whole pattern 
                        if (nTokenIndex == 0)
                        {
                            match.mnFxnIndex = nFirst;
                            match.mnFxnCount = (nFxnIndex - nFirst) + 1;
                            return match;
                        }

                        // Go to the previous token
                        nTokenIndex -= 1;

                        // Adjust the sub-expression range
                        nFirst -= 1;
                        nLast = nFirst;
                    }
                    else
                    {
                        // Some failed matches (such as identifier names) can not be recovered from.
                        if (!bRecoverable)
                            return null;

                        // Widen the sub-expression. 
                        nFirst -= 1;

                        // Check if we have passed the limit of how big of a 
                        // sub-expression will be examined 
                        if (nLast - nFirst > nSubExprSize)
                            return null;
                    }
                }

                // The loop was finished and no match was found.
                return null;
            }
        }

        public static void AddMacro(AstMacro node)
        {
            int n = node.mSrc.mPattern.Count;
            if (n == 0) 
                throw new Exception("a macro has to have at least one token in the source pattern");
            string s = node.mSrc.mPattern[n - 1].ToString();
            if (s.Length < 1)
                throw new Exception("illegal token in source pattern");
            if (s[0] == '$')
                throw new Exception("last token in pattern can not be a variable");
            if (!mMacros.ContainsKey(s))
                mMacros.Add(s, new List<AstMacro>());
            mMacros[s].Add(node);
        }

        private static void ApplyMacrosInner(INameLookup names, CatExpr fxns)
        {            
            // Recursively apply macros for all quotations.
            for (int i=0; i < fxns.Count; ++i)
            {
                if (fxns[i] is PushFunction)
                {
                    PushFunction qf = fxns[i] as PushFunction;
                    CatExpr tmp = new CatExpr(qf.GetChildren());
                    ApplyMacros(names, tmp);
                    fxns[i] = new PushFunction(tmp);
                }
            }

            // This could be done multiple time
            List<MacroMatch> matches = new List<MacroMatch>();
            
            // The peephole is the maximum size of the range of functions that we will consider
            // for rewriting. This helps to reduces the overall complexity of the algorithm.
            //int nPeephole = 20;

            // This is the maximum size of the sub-expression that will be considered for matching.
            int nMaxSubExpr = 10;

            // Find matches
            int nLastMatchPos = -1;
            for (int nPos = 0; nPos < fxns.Count; ++nPos)
            {
                string s = fxns[nPos].msName;

                if (mMacros.ContainsKey(s))
                {
                    foreach (AstMacro m in mMacros[s])
                    {
                        MacroMatch match = MacroMatch.Create(m, fxns, nLastMatchPos, nPos, nMaxSubExpr);
                        if (match != null)
                        {
                            nLastMatchPos = nPos;
                            matches.Add(match);
                        }
                    }
                }
            }

            // Replace matches
            for (int i = matches.Count - 1; i >= 0; --i)
            {
                MacroMatch m = matches[i];
                List<AstMacroTerm> pattern = m.mMacro.mDest.mPattern;
                m.Replace(names, fxns, pattern);      
            }
        }

        public static void ApplyMacros(INameLookup names, CatExpr fxns)
        {            
            if (Config.gbShowRewritingRuleApplications)
            {
                Output.Write("Before rewriting: ");
                Output.WriteLine(fxns);
            }

            // repeat until a fix-point is reached (the algorithm converges)
            bool bDone = false;
            while (!bDone)
            {
                CatExpr original = fxns.Clone();
                ApplyMacrosInner(names, fxns);
                bDone = fxns.Equals(original);
            }

            if (Config.gbShowRewritingRuleApplications)
            {
                Output.Write("After rewriting: ");
                Output.WriteLine(fxns);
            }
        }
    }
}