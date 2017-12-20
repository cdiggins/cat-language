using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace Cat
{
    public class CatList : List<Object>
    {
        public CatList()
        { }

        public CatList(IEnumerable<Object> x)
            : base(x)
        { }

        public CatList(IEnumerable x)
            : base()
        {
            foreach (Object o in x)
                Add(o);
        }

        public static CatList MakeUnit(Object x)
        {
            CatList result = new CatList();
            result.Add(x);
            return result;
        }

        public static CatList MakePair(Object first, Object second)
        {
            CatList result = new CatList();
            result.Add(first);
            result.Add(second);
            return result;
        }

        public CatList(string x)
            : base(x.Length)
        {
            char[] a = x.ToCharArray();
            foreach (char c in a)
                Add(c);
        }

        public bool IsEmpty()
        {
            return Count == 0;
        }

        public Type[] GetTypeArray()
        {
            Type[] result = new Type[Count];
            for (int i = 0; i < Count; ++i)
                result[i] = this[i].GetType();
            return result;
        }

        public CatList Clone()
        {
            return new CatList(this);
        }

        public override string ToString()
        {
            string result = "(";
            for (int i=0; i < 10 && i < Count; ++i) {
                if (i > 0) result += " ";
                result += this[i].ToString();
            }
            if (Count > 10) result += " ...";
            result += ")";
            return result;
        }

        public override bool Equals(object obj)
        {
            if (!(obj is CatList))
                return false;
            CatList x = obj as CatList;
            if (Count != x.Count) return false;
            for (int i = 0; i < Count; ++i)
                if (!this[i].Equals(x[i]))
                    return false;
                
            return true;
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }
}
