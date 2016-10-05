/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{    
    public class CatClass : CatCustomKind
    {
        static CatClass gpNull = new CatClass();

        Dictionary<string, CatKind> mpFields = new Dictionary<string, CatKind>();

        public CatClass()
        {
        }

        public CatClass(CatClass o, string s, CatKind k)
        {
            foreach (KeyValuePair<string, CatKind> kvp in o.GetFields())
                mpFields.Add(kvp.Key, kvp.Value);

            mpFields.Add(s, k);
        }

        public Dictionary<string, CatKind> GetFields()
        {
            return mpFields;
        }

        public bool HasField(string s)
        {
            return GetFields().ContainsKey(s);
        }

        public CatKind GetFieldType(string s)
        {
            return GetFields()[s];
        }

        public CatClass AddFieldType(string s, CatKind k)
        {
            return new CatClass(this, s, k);
        }
       
        public static CatClass GetNullType()
        {
            return gpNull;
        }
    }

    public class CatObject
    {
        Dictionary<string, Object> mValues = new Dictionary<string, object>();
        CatClass mpClass;
        static CatObject gpNull = new CatObject(CatClass.GetNullType());

        public CatObject(CatClass x)
        {
            mpClass = x;
        }

        public Object GetField(string s)
        {
            if (!mValues.ContainsKey(s))
                throw new Exception("runtime type error: object does not support field " + s);
            return mValues[s];
        }

        public void SetField(string s, Object o, CatClass c)
        {
            Trace.Assert(c.HasField(s));
            mpClass = c;
            if (!mValues.ContainsKey(s))
                mValues.Add(s, o);
            else
                mValues[s] = o;
        }

        public void AddField(CatClass x, string s, Object o)
        {
            Trace.Assert(x.HasField(s));
            mpClass = x;
            mValues.Add(s, o);
        }

        public CatClass GetClass()
        {
            return mpClass;
        }

        public static CatObject GetNullObject()
        {
            return gpNull;
        }
    }
}
