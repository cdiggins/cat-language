/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    public class Optimizer
    {
        /// <summary>
        /// This is a simple yet effective combination of optimizations.
        /// </summary>
        static public QuotedFunction Optimize(INameLookup names, QuotedFunction qf)
        {
            //qf = ApplyMacros(qf);
            //qf = ApplyMacros(qf);
            //qf = Expand(qf);
            //qf = ApplyMacros(qf);
            //qf = PartialEval(qf);
            //qf = Expand(qf);
            //qf = ReplaceSimpleQuotations(qf);
            qf = ApplyMacros(names, qf);
            qf = ExpandInline(qf, 4);
            qf = ApplyMacros(names, qf);
            return qf;
        }

        #region partial evaluation
        public static Function ValueToFunction(Object o)
        {
            if (o is Int32)
            {
                return new PushInt((int)o);
            }
            else if (o is Double)
            {
                return new PushValue<double>((double)o);
            }
            else if (o is String)
            {
                return new PushValue<string>((string)o);
            }
            else if (o is Boolean)
            {
                bool b = (bool)o;
                if (b)
                    return new Primitives.True();
                else
                    return new Primitives.False();
            }
            else if (o is CatList)
            {
                return new PushValue<CatList>(o as CatList);
            }
            else if (o is QuotedFunction)
            {
                QuotedFunction qf = o as QuotedFunction;
                CatExpr fxns = qf.GetSubFxns();
                PushFunction q = new PushFunction(fxns);
                return q;
            }
            else
            {
                throw new Exception("Partial evaluator does not yet handle objects of type " + o);
            }
        }

        /// <summary>
        /// This will reduce an expression by evaluating as much at compile-time as possible.
        /// </summary>
        public static QuotedFunction PartialEval(QuotedFunction qf)
        {
            Executor exec = new Executor();
            return new QuotedFunction(PartialEval(exec, qf.GetSubFxns()));
        }

        /// <summary>
        /// We attempt to execute an expression (list of functions) on an empty stack. 
        /// When no exception is raised we know that the subexpression can be replaced with anything 
        /// that generates the values. 
        /// </summary>
        static CatExpr PartialEval(Executor exec, CatExpr fxns)
        {
            // Recursively partially evaluate all quotations
            for (int i = 0; i < fxns.Count; ++i)
            {
                Function f = fxns[i];
                if (f is PushFunction)
                {
                    PushFunction q = f as PushFunction;
                    CatExpr tmp = PartialEval(new Executor(), q.GetSubFxns());
                    fxns[i] = new PushFunction(tmp);
                }
            }

            CatExpr ret = new CatExpr();
            object[] values = null;

            int j = 0;
            while (j < fxns.Count)
            {
                try
                {
                    Function f = fxns[j];

                    if (f is DefinedFunction)
                    {
                        f.Eval(exec);
                    }
                    else
                    {
                        if (f.GetFxnType() == null)
                            throw new Exception("no type availables");

                        if (f.GetFxnType().HasSideEffects())
                            throw new Exception("can't perform partial execution when an expression has side-effects");

                        f.Eval(exec);
                    }

                    // at each step, we have to get the values stored so far
                    // since they could keep changing and any exception
                    // will obliterate the old values.
                    values = exec.GetStackAsArray();
                }
                catch
                {
                    if (values != null)
                    {
                        // Copy all of the values from the previous good execution 
                        for (int k = values.Length - 1; k >= 0; --k)
                            ret.Add(ValueToFunction(values[k]));
                    }
                    ret.Add(fxns[j]);
                    exec.Clear();
                    values = null;
                }
                j++;
            }

            if (values != null)
                for (int l = values.Length - 1; l >= 0; --l)
                    ret.Add(ValueToFunction(values[l]));

            return ret;
        }
        #endregion

        #region inline expansion
        static public QuotedFunction ExpandInline(QuotedFunction f, int nMaxDepth)
        {
            CatExpr ret = new CatExpr();
            ExpandInline(ret, f, nMaxDepth);
            return new QuotedFunction(ret);
        }

        static void ExpandInline(CatExpr list, Function f, int nMaxDepth)
        {
            if (nMaxDepth == 0)
            {
                list.Add(f);
            }
            else if (f is PushFunction)
            {
                ExpandInline(list, f as PushFunction, nMaxDepth);
            }
            else if (f is QuotedFunction)
            {
                ExpandInline(list, f as QuotedFunction, nMaxDepth);
            }
            else if (f is DefinedFunction)
            {
                ExpandInline(list, f as DefinedFunction, nMaxDepth);
            }
            else
            {
                list.Add(f);
            }
        }

        static void ExpandInline(CatExpr fxns, PushFunction q, int nMaxDepth)
        {
            CatExpr tmp = new CatExpr();
            foreach (Function f in q.GetChildren())
                ExpandInline(tmp, f, nMaxDepth - 1);
            fxns.Add(new PushFunction(tmp));
        }

        static void ExpandInline(CatExpr fxns, QuotedFunction q, int nMaxDepth)
        {
            foreach (Function f in q.GetSubFxns())
                ExpandInline(fxns, f, nMaxDepth - 1);
        }

        static void ExpandInline(CatExpr fxns, DefinedFunction d, int nMaxDepth)
        {
            foreach (Function f in d.GetSubFxns())
                ExpandInline(fxns, f, nMaxDepth - 1);
        }
        #endregion

        #region apply macros
        static public QuotedFunction ApplyMacros(INameLookup names, QuotedFunction f)
        {
            CatExpr list = new CatExpr(f.GetSubFxns().ToArray());
            MetaCat.ApplyMacros(names, list);
            return new QuotedFunction(list);
        }
        #endregion
    }
}
