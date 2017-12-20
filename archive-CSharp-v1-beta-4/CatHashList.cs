/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    class HashList : ICatObject
    {
        HashList mNext;
        Dictionary<Object, Object> mDict = new Dictionary<object,object>();

        public HashList()
        {
            mNext = this;
        }

        private HashList(HashList list)
        {
            mDict = list.mDict;
            mNext = list.mNext;
            list.mNext = this;
        }

        private HashList MakeCopy()
        {
            HashList result = new HashList();
            result.mDict = new Dictionary<object, object>(mDict);

            HashList next = mNext;
            while (next != this)
            {
                // Remove "this" from the reference chain
                if (next.mNext == this)
                    next.mNext = this.mNext;
            }

            return result;
        }

        public HashList Add(Object key, Object value)
        {
            HashList result = this;
            if (result.mNext != result)
                result = MakeCopy();
            result.mDict.Add(key, value);
            return result;
        }

        public HashList Set(Object key, Object value)
        {
            HashList result = this;
            if (result.mNext != result)
                result = MakeCopy();
            result.mDict[key] = value;
            return result;
        }

        public Object Get(Object key)
        {
            Object result = mDict[key];
            return result;
        }

        public bool ContainsKey(Object key)
        {
            return mDict.ContainsKey(key);
        }

        public CatList ToArray()
        {
            CatList[] a = new CatList[mDict.Count];
            int i = 0;
            foreach (KeyValuePair<Object, Object> pair in mDict)
            {
                a[i++] = CatList.MakePair(pair.Value, pair.Key);
            }
            return new CatList(a);
        }

        public override string ToString()
        {
            return "hash_list";
        }

        #region ICatObject Members

        public void pop()
        {
        }

        ICatObject ICatObject.dup()
        {
            return new HashList(this);
        }

        public string str()
        {
            return ToString();
        }

        #endregion
    }
}
