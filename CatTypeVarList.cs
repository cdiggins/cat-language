using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    public class CatTypeVarList : Dictionary<string, CatKind> 
    {
        public CatTypeVarList()
            : base()
        { }

        public CatTypeVarList(CatTypeVarList list)
            : base(list)
        { }

        public void Add(CatKind k)
        {
            if (ContainsKey(k.ToString()))
                return;
            Trace.Assert(k.IsKindVar());
            base.Add(k.ToString(), k);
        }

        public override string ToString()
        {
            string ret = "";
            foreach (KeyValuePair<string, CatKind> kvp in this)
                ret += kvp.Key + " = " + kvp.Value + "; ";
            return ret;
        }
    }
}
