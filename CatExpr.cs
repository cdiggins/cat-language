using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    public class CatExpr : List<Function>
    {
        CatFxnType mpFxnType;

        public CatExpr(CatExpr expr)
            : base(expr)
        {
        }

        public CatExpr()
            : base()
        {
        }

        public CatExpr(IEnumerable<Function> fxns)
            : base(fxns)
        { }

        public override bool Equals(object obj)
        {
            if (!(obj is CatExpr))
                return false;
            CatExpr expr = obj as CatExpr;
            if (expr.Count != this.Count)
                return false;
            for (int i = 0; i < Count; ++i)
            {
                Function f = this[i];
                Function g = expr[i];
                if (!f.Equals(g)) 
                    return false;
            }
            return true;
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }

        public CatExpr Clone()
        {
            return new CatExpr(this);
        }

        public new CatExpr GetRange(int index, int count)
        {
            return new CatExpr(base.GetRange(index, count));
        }

        public override string ToString()
        {
            string result = "";
            for (int i = 0; i < Count; ++i)
            {
                if (i > 0) result += " ";
                result += this[i].ToString();
            }
            return result;
        }

        public CatFxnType GetFxnType()
        {
            if (mpFxnType == null)
                mpFxnType = CatTypeReconstructor.Infer(this);
            Trace.Assert(mpFxnType != null);
            return mpFxnType;
        }

        public bool IsSimpleNullaryFunction()
        {
            if (Count == 0)
                return false;
            return HasSingleProduction() && HasNoConsumption();
        }

        public bool HasSingleProduction()
        {
            return GetFxnType().GetMaxProduction() == 1;
        }

        public bool HasNoConsumption()
        {
            return GetFxnType().GetMaxConsumption() == 0;
        }

        public CatExpr GetRangeFrom(int i)
        {
            return GetRange(i, Count - i);
        }

        public CatExpr GetRangeFromTo(int i, int j)
        {
            return GetRange(i, j - i + 1);
        }

        public IEnumerable<Function> Flatten()
        {
            foreach (Function f in this) {
                yield return f;
                foreach (Function g in f.GetDescendantFxns())
                    yield return g;
            }
        }
    }
}
