/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Globalization;
using System.Diagnostics;

using Peg;

namespace Cat
{
    /// <summary>
    /// The CatParser constructs a typed AST representing Cat source code.
    /// This library is based on the PEG parsing library
    /// </summary>
    class CatParser
    {
        public static List<CatAstNode> Parse(string s)
        {
            Peg.Parser parser = new Peg.Parser(s);

            try
            {
                bool bResult = parser.Parse(CatGrammar.CatProgram());
                if (!bResult)
                    throw new Exception("failed to parse input");
            }
            catch (Exception e)
            {
                Output.WriteLine("Parsing error occured with message: " + e.Message);
                Output.WriteLine(parser.ParserPosition);
                throw e;
            }

            AstProgram tmp = new AstProgram(parser.GetAst());
            return tmp.mStatements;
        }
    }

    /// <summary>
    /// Used to identify / switch on the different types of nodes 
    /// </summary>
    public enum AstLabel
    {
        AstRoot,
        Def,
        Decl,
        Name,
        Param,
        Lambda,
        Quote,
        Char,
        String,
        Float,
        Int,
        Bin,
        Hex,
        Stack,
        FxnType,
        Arrow,
        TypeName,
        TypeVar,
        StackVar,
        MacroRule,
        MacroProp,
        MacroPattern,
        MacroQuote,
        MacroTypeVar,
        MacroStackVar,
        MacroTypeVarName,
        MacroStackVarName,
        MacroName,
        MetaDataContent,
        MetaDataLabel,
        MetaDataBlock,
        Unknown
    }

    /// <summary>
    /// An AstNode is used as a base class for a typed abstract syntax tree for Cat programs.
    /// CatAstNodes are created from a Peg.Ast. Apart from being typed, the big difference
    /// is the a CatAstNode can be modified. This makes rewriting algorithms much easier. 
    /// </summary>
    public abstract class CatAstNode
    {
        string msText;
        AstLabel mLabel;

        public CatAstNode(PegAstNode node)
        {
            if (node.GetLabel() != null)
                mLabel = (AstLabel)node.GetLabel();
            else
                mLabel = AstLabel.AstRoot;
            
            msText = node.ToString();
        }

        public CatAstNode(AstLabel label, string sText)
        {
            mLabel = label;
            msText = sText;
        }

        public static CatAstNode Create(PegAstNode node)
        {
            AstLabel label = (AstLabel)node.GetLabel();
            switch (label)
            {
                case AstLabel.AstRoot:
                    return new AstRoot(node);
                case AstLabel.Def:
                    return new AstDef(node);
                case AstLabel.Name:
                    return new AstName(node);
                case AstLabel.Param:
                    return new AstParam(node);
                case AstLabel.Lambda:
                    return new AstLambda(node);
                case AstLabel.Quote:
                    return new AstQuote(node);
                case AstLabel.Char:
                    return new AstChar(node);
                case AstLabel.String:
                    return new AstString(node);
                case AstLabel.Float:
                    return new AstFloat(node);
                case AstLabel.Int:
                    return new AstInt(node);
                case AstLabel.Bin:
                    return new AstBin(node);
                case AstLabel.Hex:
                    return new AstHex(node);
                case AstLabel.Stack:
                    return new AstStack(node);
                case AstLabel.FxnType:
                    return new AstFxnType(node);
                case AstLabel.TypeVar:
                    return new AstTypeVar(node);
                case AstLabel.TypeName:
                    return new AstSimpleType(node);
                case AstLabel.StackVar:
                    return new AstStackVar(node);
                case AstLabel.MacroRule:
                    return new AstMacro(node);
                case AstLabel.MacroProp:
                    return new AstMacro(node);
                case AstLabel.MacroPattern:
                    return new AstMacroPattern(node);
                case AstLabel.MacroQuote:
                    return new AstMacroQuote(node);
                case AstLabel.MacroTypeVar:
                    return new AstMacroTypeVar(node);
                case AstLabel.MacroStackVar:
                    return new AstMacroStackVar(node);
                case AstLabel.MacroName:
                    return new AstMacroName(node);
                case AstLabel.MetaDataContent:
                    return new AstMetaDataContent(node);
                case AstLabel.MetaDataLabel:
                    return new AstMetaDataLabel(node);
                case AstLabel.MetaDataBlock:
                    return new AstMetaDataBlock(node);
                default:
                    throw new Exception("unrecognized node type in AST tree: " + label);
            }
        }

        public void CheckIsLeaf(PegAstNode node)
        {
            CheckChildCount(node, 0);
        }

        public void CheckLabel(AstLabel label)
        {
            if (!GetLabel().Equals(label))
                throw new Exception("Expected label " + label.ToString() + " but instead have label " + GetLabel().ToString());
        }

        public void CheckChildCount(PegAstNode node, int n)
        {
            if (node.GetNumChildren() != n)
                throw new Exception("expected " + n.ToString() + " children, instead found " + node.GetNumChildren().ToString());
        }

        public AstLabel GetLabel()
        {
            return mLabel;
        }

        public override string ToString()
        {
            return msText;
        }

        public void SetText(string s)
        {
            msText = s;
        }

        public string IndentedString(int nIndent, string s)
        {
            if (nIndent > 0)
                return new String('\t', nIndent) + s; else
                return s;
        }

        public virtual void Output(TextWriter writer, int nIndent)
        {
            writer.Write(ToString());
        }
    }

    public class AstRoot : CatAstNode
    {
        public List<AstDef> Defs = new List<AstDef>();

        public AstRoot(PegAstNode node)
            : base(node)
        {
            foreach (PegAstNode child in node.GetChildren())
                Defs.Add(new AstDef(child));
        }

        public override void Output(TextWriter writer, int nIndent)
        {
            foreach (AstDef d in Defs)
                d.Output(writer, nIndent);
        }
    }

    public class AstExpr : CatAstNode
    {
        public AstExpr(PegAstNode node) : base(node) { }
        public AstExpr(AstLabel label, string sText) : base(label, sText) { }

        public override void Output(TextWriter writer, int nIndent)
        {
            string sLine = ToString();
            writer.WriteLine(IndentedString(nIndent, sLine));
        }
    }

    public class AstDef : CatAstNode
    {
        public string mName;
        public AstFxnType mType;
        public AstMetaDataBlock mpMetaData;
        public List<AstParam> mParams = new List<AstParam>();
        public List<CatAstNode> mTerms = new List<CatAstNode>();

        public AstDef(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Def);

            if (node.GetNumChildren() == 0)
                throw new Exception("invalid function definition node");

            AstName name = new AstName(node.GetChild(0));
            mName = name.ToString();

            int n = 1;

            // Look to see if a type is defined
            if ((node.GetNumChildren() >= 2) && (node.GetChild(1).GetLabel().Equals(AstLabel.FxnType)))
            {
                mType = new AstFxnType(node.GetChild(1));
                ++n;
            }

            while (n < node.GetNumChildren())
            {
                PegAstNode child = node.GetChild(n);

                if (!child.GetLabel().Equals(AstLabel.Param))
                    break;

                mParams.Add(new AstParam(child));
                n++;
            }

            while (n < node.GetNumChildren())
            {
                PegAstNode child = node.GetChild(n);

                if (!child.GetLabel().Equals(AstLabel.Param))
                    break;

                mParams.Add(new AstParam(child));
                n++;
            }

            while (n < node.GetNumChildren())
            {
                PegAstNode child = node.GetChild(n);

                if (!child.GetLabel().Equals(AstLabel.MetaDataBlock))
                    break;

                mpMetaData = new AstMetaDataBlock(child);
                n++;
            }

            while (n < node.GetNumChildren())
            {
                PegAstNode child = node.GetChild(n);
                CatAstNode expr = Create(child);

                if (!(expr is AstExpr))
                    throw new Exception("expected expression node");

                mTerms.Add(expr as AstExpr);
                n++;
            }
        }

        public override void Output(TextWriter writer, int nIndent)
        {
            string s = "define " + mName;
            if (mType != null)
            {
                s += " : " + mType.ToString();
            }
            if (mParams.Count > 0)
            {
                s += " // ( ";
                foreach (AstParam p in mParams)
                    s += p.ToString() + " ";
                s += ")";
            }
            writer.WriteLine(IndentedString(nIndent, s));
            writer.WriteLine(IndentedString(nIndent, "{"));
            foreach (AstExpr x in mTerms)
                x.Output(writer, nIndent + 1);
            writer.WriteLine(IndentedString(nIndent, "}"));
        }
    }

    /* // TODO: figure out why this is here.
    public class AstDeclare : CatAstNode
    {
        AstType mType;
        AstMetaData mMetaData;

        public AstDeclare(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Decl);
            if (node.GetNumChildren() == 0)
            {
                throw new Exception("Illegal declaration, missing type signature");
            }
            else if (node.GetNumChildren() == 1)
            {
                mType = new AstType(node.GetChild(0));
            }
            else if (node.GetNumChildren() == 2)
            {
                mType = new AstType(node.GetChild(0));
                mMetaData = new AstMetaData(node.GetChild(1));
            }
        }
    }
     */

    public class AstName : AstExpr
    {
        public AstName(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Name);
            CheckIsLeaf(node);
        }

        public AstName(string sOp)
            : base(AstLabel.Name, sOp)
        {
        }
    }

    public class AstParam : CatAstNode
    {
        public AstParam(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Param);
            CheckIsLeaf(node);
        }

        public override void Output(TextWriter writer, int nIndent)
        {
            throw new Exception("The method or operation is not implemented.");
        }
    }

    public class AstLiteral : AstExpr
    {
        public AstLiteral(PegAstNode node)
            : base(node)
        { }

        public AstLiteral(AstLabel label, string sText)
            : base(label, sText)
        { }

        public Object value;
    }

    public class AstLambda : AstLiteral
    {
        public List<string> mIdentifiers = new List<string>();
        public List<CatAstNode> mTerms = new List<CatAstNode>();

        public AstLambda(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Lambda);
            CheckChildCount(node, 2);

            AstParam name = new AstParam(node.GetChild(0));
            mIdentifiers.Add(name.ToString());
            CatAstNode tmp = Create(node.GetChild(1));

            // lambda nodes either contain quotes or other lambda nodes
            if (!(tmp is AstQuote))
            {
                if (!(tmp is AstLambda))
                    throw new Exception("expected lambda expression or quotation");
                AstLambda lambda = tmp as AstLambda;
                mIdentifiers.AddRange(lambda.mIdentifiers);

                // Take ownership of the terms from the child lambda expression
                mTerms = lambda.mTerms;
            }
            else
            {
                AstQuote q = tmp as AstQuote;

                // Take ownership of the terms from the quote
                mTerms = q.mTerms;
            }
        }

        public List<CatAstNode> GetTerms()
        {
            return mTerms;
        }
    }

    public class AstQuote : AstLiteral
    {
        public List<CatAstNode> mTerms = new List<CatAstNode>();

        public AstQuote(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Quote);
            foreach (PegAstNode child in node.GetChildren())
            {
                CatAstNode tmp = CatAstNode.Create(child);
                if (!(tmp is AstExpr))
                    throw new Exception("invalid child node " + child.ToString() + ", expected an expression node");
                mTerms.Add(tmp as AstExpr);
            }
        }

        public AstQuote(AstExpr expr)
            : base(AstLabel.Quote, "")
        {
            mTerms.Add(expr);
        }

        public AstQuote(List<CatAstNode> expr)
            : base(AstLabel.Quote, "")
        {
            mTerms.AddRange(expr);
        }

        public override void Output(TextWriter writer, int nIndent)
        {
            writer.WriteLine(IndentedString(nIndent, "["));
            foreach (AstExpr x in mTerms)
                x.Output(writer, nIndent + 1);
            writer.WriteLine(IndentedString(nIndent, "]"));
        }

        public List<CatAstNode> GetTerms()
        {
            return mTerms;
        }
    }

    public class AstInt : AstLiteral
    {
        public AstInt(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Int);
            CheckIsLeaf(node);
            value = int.Parse(ToString());
        }

        public AstInt(int n)
            : base(AstLabel.Int, n.ToString())
        {
            value = n;
        }

        public int GetValue()
        {
            return (int)value;
        }
    }

    public class AstBin : AstLiteral
    {
        public AstBin(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Bin);
            CheckIsLeaf(node);
            string s = ToString();
            int n = 0;
            int place = 1;
            for (int i = s.Length; i > 0; --i)
            {
                if (s[i - 1] == '1')
                {
                    n += place;
                }
                else
                {
                    if (s[i - 1] != '0')
                        throw new Exception("Invalid binary number");
                }
                place *= 2;
            }
            value = n;
        }

        public int GetValue()
        {
            return (int)value;
        }
    }

    public class AstHex : AstLiteral
    {
        public AstHex(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Hex);
            CheckIsLeaf(node);
            value = int.Parse(ToString(), NumberStyles.AllowHexSpecifier);
        }

        public int GetValue()
        {
            return (int)value;
        }
    }

    public class AstChar : AstLiteral
    {
        public AstChar(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Char);
            CheckIsLeaf(node);
            string s = ToString();
            s = s.Substring(1, s.Length - 2);
            switch (s)
            {
                case "\\t": value = '\t'; break;
                case "\\n": value = '\n'; break;
                case "\\'": value = '\''; break;
                case "\\\"": value = '\"'; break;
                case "\\r": value = '\r'; break;
                default: value = char.Parse(s); break;
            }
        }

        public char GetValue()
        {
            return (char)value;
        }
    }

    public class AstString : AstLiteral
    {
        public AstString(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.String);
            CheckIsLeaf(node);
            // strip quotes
            string s = ToString();
            value = s.Substring(1, s.Length - 2);
        }

        public string GetValue()
        {
            return (string)value;
        }
    }

    public class AstFloat : AstLiteral
    {
        public AstFloat(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Float);
            CheckIsLeaf(node);
            value = double.Parse(ToString());
        }

        public double GetValue()
        {
            return (double)value;
        }
    }

    public class AstType : CatAstNode
    {
        public AstType(PegAstNode node)
            : base(node)
        {
        }
    }

    public class AstStack : CatAstNode
    {
        public List<AstType> mTypes = new List<AstType>();

        public AstStack(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.Stack);
            foreach (PegAstNode child in node.GetChildren())
            {
                CatAstNode tmp = Create(child);
                if (!(tmp is AstType))
                    throw new Exception("stack AST node should only have type AST nodes as children");
                mTypes.Add(tmp as AstType);
            }
        }
    }

    public class AstTypeVar : AstType
    {
        public AstTypeVar(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.TypeVar);            
            CheckChildCount(node, 0);
        }
    }

    public class AstSimpleType : AstType
    {
        public AstSimpleType(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.TypeName);
            CheckChildCount(node, 0);
        }
    }

    public class AstStackVar : AstType
    {
        public AstStackVar(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.StackVar);
            CheckChildCount(node, 0);
        }
    }

    public class AstFxnType : AstType
    {
        public AstStack mProd;
        public AstStack mCons;
        bool mbSideEffects;

        public AstFxnType(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.FxnType);
            CheckChildCount(node, 3);
            mCons = new AstStack(node.GetChild(0));
            mbSideEffects = node.GetChild(1).ToString().Equals("~>");
            mProd = new AstStack(node.GetChild(2));
        }

        public bool HasSideEffects()
        {
            return mbSideEffects;
        }

    }

    public class AstMacro : CatAstNode 
    {
        public AstMacroPattern mSrc;
        public AstMacroPattern mDest;

        public AstMacro(PegAstNode node)
            : base(node)
        {
            CheckChildCount(node, 2);
            CheckLabel(AstLabel.MacroRule);
            mSrc = new AstMacroPattern(node.GetChild(0));
            mDest = new AstMacroPattern(node.GetChild(1));
        }
    }

    public class AstMacroProperty : AstMacro
    {
        public AstMacroProperty(PegAstNode node)
            : base(node)
        {
        }
    }

    public class AstMacroPattern : CatAstNode
    {
        public List<AstMacroTerm> mPattern = new List<AstMacroTerm>();

        public AstMacroPattern(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.MacroPattern);
            foreach (PegAstNode child in node.GetChildren())
            {
                AstMacroTerm tmp = CatAstNode.Create(child) as AstMacroTerm;
                if (tmp == null)
                    throw new Exception("invalid grammar: only macro terms can be children of an ast macro mPattern");
                mPattern.Add(tmp);
            }
        }
    }

    public class AstMacroTerm : CatAstNode
    {
        public AstMacroTerm(PegAstNode node)
            : base(node)
        {
        }
    }

    public class AstMacroQuote : AstMacroTerm
    {
        public List<AstMacroTerm> mTerms = new List<AstMacroTerm>();

        public AstMacroQuote(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.MacroQuote);
            foreach (PegAstNode child in node.GetChildren())
            {
                AstMacroTerm term = Create(child) as AstMacroTerm;
                if (term == null)
                    throw new Exception("internal grammar error: macro quotations can only contain macro terms");
                mTerms.Add(term);
            }
        }
    }

    public class AstMacroTypeVar : AstMacroTerm
    {
        public string msName;

        public AstMacroTypeVar(PegAstNode node)
            : base(node)
        {
            CheckChildCount(node, 1);
            msName = node.GetChild(0).ToString();
            CheckLabel(AstLabel.MacroTypeVar);
        }
    }

    public class AstMacroStackVar : AstMacroTerm
    {
        public CatFxnType mType = null;
        public string msName;

        public AstMacroStackVar(PegAstNode node)
            : base(node)
        {
            if (node.GetNumChildren() < 1)
                throw new Exception("invalid macro stack variable");

            if (node.GetNumChildren() > 2)
                throw new Exception("invalid macro stack variable");

            msName = node.GetChild(0).ToString();

            if (node.GetNumChildren() == 2)
            {
                AstFxnType typeNode = new AstFxnType(node.GetChild(1));
                mType = CatFxnType.Create(typeNode) as CatFxnType;
                if (mType == null) throw new Exception("expected function type " + typeNode.ToString());
            }

            CheckLabel(AstLabel.MacroStackVar);
        }
    }

    public class AstMacroName : AstMacroTerm
    {
        public AstMacroName(PegAstNode node)
            : base(node)
        {
            CheckChildCount(node, 0);
            CheckLabel(AstLabel.MacroName);
        }
    }

    #region AST nodes for representing meta data
    public class AstMetaData : CatAstNode
    {
        public List<AstMetaData> children = new List<AstMetaData>();

        public AstMetaData(PegAstNode node)
            : base(node)
        {
            foreach (PegAstNode child in node.GetChildren())
            {
                AstMetaData x = Create(child) as AstMetaData;
                if (x == null)
                    throw new Exception("Meta data-nodes can only have meta-data nodes as children");
                children.Add(x);
            }
        }
    }

    public class AstMetaDataContent : AstMetaData
    {
        public AstMetaDataContent(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.MetaDataContent);
        }
    }

    public class AstMetaDataLabel : AstMetaData
    {
        public AstMetaDataLabel(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.MetaDataLabel);
            CheckIsLeaf(node);
            Trace.Assert(children.Count == 0);
        }
    }

    public class AstMetaDataBlock : AstMetaData
    {
        public AstMetaDataBlock(PegAstNode node)
            : base(node)
        {
            CheckLabel(AstLabel.MetaDataBlock);
        }
    }

    /// <summary>
    /// A program consists of a sequence of statements 
    /// TODO: reintroduce declarations and macros
    /// </summary>
    public class AstProgram : CatAstNode
    {
        public List<CatAstNode> mStatements = new List<CatAstNode>();

        public AstProgram(Peg.PegAstNode node)
            : base(node)
        {
            foreach (Peg.PegAstNode child in node.GetChildren())
            {
                CatAstNode statement = CatAstNode.Create(child);
                mStatements.Add(statement);
            }
        }
    }
    #endregion
}

