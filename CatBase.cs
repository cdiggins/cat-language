/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Reflection;

namespace Cat
{
    /// <summary>
    /// Not used much yet. I am playing with the idea of forcing every class to implement this. 
    /// I am not yet 100% convinced that it would be a good idea. 
    /// </summary>
    public interface ICatObject
    {
        void pop();
        ICatObject dup();
        string str();
    }
    
    /// <summary>
    /// By inheriting from this class, there are some utility functions
    /// which are provided and can be called using an unqualified name. 
    /// </summary>
    public class CatBase
    {        
        /// <summary>
        /// If the condition is false, an exception is thrown. This represents
        /// an internal error, such as a violated assumption. 
        /// </summary>
        public static void Assert(bool b, string s)
        {
            if (!b)
            {
                throw new Exception("internal error " + s);
            }
        }

        public static void Assert(bool b)
        {
            if (!b)
            {
                throw new Exception("internal error");
            }
        }

        public static void Throw(string s)
        {
            throw new Exception(s);
        }

        public static bool AreObjectsEqual(Object x, Object y)
        {
            if (x == y) 
                return true;

            if (x is ArrayList)
            {
                if (!(y is ArrayList))
                    return false;
                ArrayList a = x as ArrayList;
                ArrayList b = y as ArrayList;
                if (a.Count != b.Count)
                {
                    return false;
                }
                else
                {
                    for (int i=0; i < a.Count; ++i)
                    {
                        if (!AreObjectsEqual(a[i], b[i]))
                            return false;
                    }
                    return true;
                }
            }
            else
            {
                return x.Equals(y);
            }
        }

        public static int Min(int x, int y)
        {
            return x < y ? y : x;
        }
    }
}
