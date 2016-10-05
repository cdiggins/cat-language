using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat
{
    public class CatMetaData : List<CatMetaData>
    {
        public string msLabel = "";
        public string msContent = "";
        public CatMetaData mpParent;
        public CatMetaData(string sName, CatMetaData pParent)
        {
            msLabel = sName;
            mpParent = pParent;
        }
        public void AddContent(string s)
        {
            msContent = msContent.Trim() + " " + s.Trim();
        }
        public CatMetaData NewChild(string sName)
        {
            CatMetaData ret = new CatMetaData(sName, this);
            Add(ret);
            return ret;
        }
        public CatMetaData GetParent()
        {
            return mpParent;
        }
        public CatMetaData Find(string s)
        {
            foreach (CatMetaData child in this)
                if (child.msLabel.Equals(s))
                    return child;
            return null;
        }
        public List<CatMetaData> FindAll(string s)
        {
            List<CatMetaData> ret = new List<CatMetaData>();
            foreach (CatMetaData child in this)
                if (child.msLabel.Equals(s))
                    ret.Add(child);
            return ret;
        }

        public string GetContent()
        {
            return msContent.Trim();
        }

        public CatList ToList()
        {
            CatList ret = new CatList();
            ret.Add(GetLabel());
            if (Count > 0)
            {
                foreach (CatMetaData child in this)
                    ret.Add(child);
            }
            else
            {
                ret.Add(GetContent());
            }
            return ret;
        }

        public override string ToString()
        {
            string ret = "";
            foreach (CatMetaData child in this)
                ret += child.ToIndentedString(1);
            return ret.TrimEnd();
        }

        public string GetLabel()
        {
            return msLabel;
        }

        public string ToIndentedString(int nIndent)
        {
            string sIndent = new String(' ', nIndent * 2);
            string ret = sIndent + msLabel + ":\n";
            if (GetContent().Length > 0)
                ret += sIndent + "  " + GetContent() + "\n";
            foreach (CatMetaData child in this)
                ret += child.ToIndentedString(nIndent + 1);
            return ret;
        }
    }

    public class CatMetaDataBlock : CatMetaData 
    {
        public static CatMetaDataBlock Create(string s)
        {
            s = "{{\n" + s + "\n}}\n";
            Peg.Parser parser = new Peg.Parser(s);
            bool bResult = parser.Parse(CatGrammar.MetaDataBlock());
            if (!bResult)
                throw new Exception("failed to parse meta-data block");
            Peg.PegAstNode tree = parser.GetAst();
            if (tree.GetNumChildren() == 0)
                return null;
            if (tree.GetNumChildren() != 1)
                throw new Exception("invalid number of child nodes in meta-data block node");
            AstMetaDataBlock node = new AstMetaDataBlock(tree.GetChild(0));
            CatMetaDataBlock ret = new CatMetaDataBlock(node);
            return ret;
        }

        public CatMetaDataBlock(AstMetaDataBlock node)
            : base("root", null)
        {
            CatMetaData cur = this;
            int nCurIndent = -1;
            
            for (int i=0; i < node.children.Count; ++i)
            {
                AstMetaData tmp = node.children[i];
                if (tmp is AstMetaDataLabel)
                {
                    int nIndent;
                    string sName; 
                    SplitLabel(tmp.ToString(), out nIndent, out sName);
                    
                    if (nIndent > nCurIndent)
                    {
                        cur = cur.NewChild(sName);
                    }
                    else if (nIndent == nCurIndent)
                    {
                        cur = cur.GetParent();
                        Trace.Assert(cur != null);
                        cur = cur.NewChild(sName);
                    }
                    else
                    {
                        cur = cur.GetParent();
                        Trace.Assert(cur != null);
                        cur = cur.GetParent();
                        Trace.Assert(cur != null);
                        cur = cur.NewChild(sName);
                    }
                    nCurIndent = nIndent;
                }
                else if (tmp is AstMetaDataContent)
                {
                    cur.AddContent(tmp.ToString());
                }
                else
                {
                    throw new Exception("invalid AstMetaDataBlock");
                }
            }
        }

        private void SplitLabel(string sIn, out int nIndent, out string sName)
        {
            nIndent = 0;
            for (int i = 0; i < sIn.Length; ++i)
            {
                if (sIn[i] == ' ' || sIn[i] == '\t')
                    nIndent++;
            }
            sName = sIn.Substring(nIndent);
            // check validity
            if ((sName.Length < 2) || (sName[sName.Length - 1] != ':'))
                throw new Exception("invalid meta-data label: " + sName);
            // strip the trailing ':'
            sName = sName.Substring(0, sName.Length - 1);
        }
    }
}
