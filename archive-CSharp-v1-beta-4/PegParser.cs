/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Peg
{
    /// <summary>
    /// Takes a string as input and constructs an abstract syntax tree. 
    /// </summary>
    public class Parser
    {
        int mIndex;
        string mData;
        PegAstNode mTree;
        PegAstNode mCur;

        public Parser(string s)
        {
            mIndex = 0;
            mData = s;
            mTree = new PegAstNode(0, mData, null, null);
            mCur = mTree;
        }

        public bool AtEnd()
        {
            return mIndex >= mData.Length;
        }

        public int GetPos()
        {
            return mIndex;
        }

        public string CurrentLine
        {
            get
            {
                return mData.Substring(mIndex, 20);
            }
        }

        public string ParserPosition
        {
            get
            {
                string ret = "";
                int nLine = 0;
                int nLastLineChar = 0;
                for (int i = 0; i < mIndex; ++i)
                {
                    if (mData[i].Equals('\n'))
                    {
                        nLine++;
                        nLastLineChar = i;
                    }
                }
                int nCol = mIndex - nLastLineChar;
                ret += "CatProgram " + nLine.ToString() + ", Column " + nCol + "\n";

                int nNextLine = mIndex;
                while (nNextLine < mData.Length && !mData[nNextLine].Equals('\n'))
                    nNextLine++;

                ret += mData.Substring(nLastLineChar, nNextLine - nLastLineChar) + "\n";
                ret += new String(' ', nCol);
                ret += "^";
                return ret;
            }
        }

        public void SetPos(int pos)
        {
            mIndex = pos;
        }

        public void GotoNext()
        {
            if (AtEnd())
            {
                throw new Exception("passed the end of input");
            }
            mIndex++;
        }

        public char GetChar()
        {
            if (AtEnd())
            {
                throw new Exception("passed end of input");
            }
            return mData[mIndex];
        }

        public PegAstNode CreateNode(Object label)
        {
            Trace.Assert(mCur != null);
            mCur = mCur.Add(this, label);
            Trace.Assert(mCur != null);
            return mCur;
        }

        public void AbandonNode()
        {
            Trace.Assert(mCur != null);
            PegAstNode tmp = mCur;
            mCur = mCur.GetParent();
            Trace.Assert(mCur != null);
            mCur.Remove(tmp);
        }

        public void CompleteNode()
        {
            Trace.Assert(mCur != null);
            mCur.Complete(this);
            mCur = mCur.GetParent();
            Trace.Assert(mCur != null);
        }

        public PegAstNode GetAst()
        {
            return mTree;
        }

        public bool Parse(Grammar.Rule rule)
        {
            bool b = false;
            b = rule.Match(this);

            if (b)
            {
                if (mCur != mTree)
                    throw new Exception("internal error: parse tree and parse node do not match after parsing");
                mCur.Complete(this);
            }

            return b;
        }
    }
    
    /// <summary>
    /// A node in an abstract syntax tree.  
    /// </summary>
    public class PegAstNode
    {
        int mnBegin;
        int mnCount;
        Object mLabel;
        String msText;
        PegAstNode mpParent;
        List<PegAstNode> mChildren = new List<PegAstNode>();

        public PegAstNode(int n, String text, PegAstNode p, Object label)
        {
            msText = text;
            mnBegin = n;
            mnCount = -1;
            mpParent = p;
            mLabel = label;
        }

        public PegAstNode Add(Parser p, Object label)
        {
            PegAstNode ret = new PegAstNode(p.GetPos(), msText, this, label);
            mChildren.Add(ret);
            return ret;
        }

        public void Complete(Parser p)
        {
            mnCount = p.GetPos() - mnBegin;
        }

        public PegAstNode GetParent()
        {
            return mpParent;
        }

        public void Remove(PegAstNode x)
        {
            mChildren.Remove(x);
        }

        public override string ToString()
        {
            return msText.Substring(mnBegin, mnCount);
        }

        public List<PegAstNode> GetChildren()
        {
            return mChildren;
        }

        public int GetNumChildren()
        {
            return mChildren.Count;
        }

        public PegAstNode GetChild(int n)
        {
            return mChildren[n];
        }

        public Object GetLabel()
        {
            return mLabel;
        }
    }
   
    /// <summary>
    /// A grammar is a set of rules which define a language. Grammar rules in the context 
    /// of a recursive descent parsing library correspond to pattern matches which are also known
    /// somewhat confusingly as "parsers". 
    /// </summary>
    public class Grammar
    {
        /// <summary>
        /// Used with RuleDelay to make cicrcular rule references
        /// </summary>
        /// <returns></returns>
        public delegate Rule RuleDelegate();

        /// <summary>
        /// A rule class corresponds a PEG grammar production rule. 
        /// A production rule describes how to generate valid syntactic
        /// phrases in a programming language. A production rule also
        /// corresponds to a pattern matcher in a recursive-descent parser. 
        /// 
        /// Each instance of a Rule class has a Match function which 
        /// has the responsibility to look at the current input 
        /// (which is managed by a Parser object) and return true or false, 
        /// depending on whether the current input corresponds
        /// to the rule. The Match function will increment the parsers internal
        /// pointer as it successfully matches characters, but will also 
        /// restore the pointer if it fails. 
        /// 
        /// Some rules have extra responsibilities above and beyond matchin (
        /// such as throwing exceptions, or creating an AST) which are described below.
        /// </summary>
        public abstract class Rule
        {
            public abstract bool Match(Parser p);

            public override string ToString()
            {
                return "";
            }
        }

        /// <summary>
        /// This associates a rule with a node in the abstract syntax tree (AST). 
        /// Even though one could automatically associate each production rule with
        /// an AST node it is very cumbersome and inefficient to create and parse. 
        /// In otherwords the grammar tree is not expected to correspond directly to 
        /// the syntax tree since much of the grammar is noise (e.g. whitespace).
        /// </summary>
        public class AstNodeRule : Rule
        {
            Rule mRule;
            Object mLabel;

            public AstNodeRule(Object label, Rule r)
            {
                Trace.Assert(r != null);
                mLabel = label;
                mRule = r;
            }

            public override bool Match(Parser p)
            {
                p.CreateNode(mLabel);
                bool result = mRule.Match(p);
                if (result)
                {
                    p.CompleteNode();
                }
                else
                {
                    p.AbandonNode();
                }
                return result;
            }

            public override string ToString()
            {
                return mLabel.ToString();
            }
        }

        /// <summary>
        /// This rule is neccessary allows you to make recursive references in the grammar.
        /// If you don't use this rule in a cyclical rule reference (e.g. A ::= B C, B ::== A D)
        /// then you will end up with an infinite loop during grammar generation.
        /// </summary>
        public class DelayRule : Rule
        {
            RuleDelegate mDeleg;

            public DelayRule(RuleDelegate deleg)
            {
                Trace.Assert(deleg != null);
                mDeleg = deleg;
            }

            public override bool Match(Parser p)
            {
                return mDeleg().Match(p);
            }

            public override string ToString()
            {
                // WARNING: this can generate an infinite loops if you have cyclical 
                // rule references. To break any loops you must either return an empty 
                // string or make sure that in the cyclical reference is a call to 
                // AstNodeRule. AstNodeRule.ToString() returns a label.
                return mDeleg().ToString();
            }
        }

        /// <summary>
        /// This causes a rule to throw an exception with a particular error message if 
        /// it fails to match. You would use this rule in a grammar, once you know clearly what 
        /// you are trying to parse, and failure is clearly an error. In other words you are saying 
        /// that back-tracking is of no use. 
        /// </summary>
        public class NoFailRule : Rule
        {
            Rule mRule;
            string msMsg;

            public NoFailRule(Rule r, string s)
            {
                Trace.Assert(r != null);
                mRule = r;
                msMsg = s;
            }

            public override bool Match(Parser p)
            {
                // TODO: make a more descriptive error message.
                if (!mRule.Match(p))
                    throw new Exception(msMsg);
                return true;
            }
        }

        /// <summary>
        /// This corresponds to a sequence operator in a PEG grammar. This tries 
        /// to match a series of rules in order, if one rules fails, then the entire 
        /// group fails and the parser index is returned to the original state.
        /// </summary>
        public class SeqRule : Rule
        {
            public SeqRule(Rule[] xs)
            {
                foreach (Rule r in xs)
                    Trace.Assert(r != null);
                mRules = xs;
            }

            public override bool Match(Parser p)
            {
                int iter = p.GetPos();
                foreach (Rule r in mRules)
                {
                    if (!r.Match(p))
                    {
                        p.SetPos(iter);
                        return false;
                    }
                }
                return true;
            }

            public override string ToString()
            {
                string result = "(";
                if (mRules.Length > 0)
                {
                    result += mRules[0].ToString();
                    foreach (Rule r in mRules)
                    {
                        result += " , " + r.ToString();
                    }
                }
                return result + ")";
            }

            Rule[] mRules;
        }

        /// <summary>
        /// This rule corresponds to a choice operator in a PEG grammar. This rule 
        /// is successful if any of the matching rules are successful. The ordering of the 
        /// rules imply precedence. This means that the grammar will be unambiguous, and 
        /// differentiates the grammar as a PEG grammar from a context free grammar (CFG). 
        /// </summary>
        public class ChoiceRule : Rule
        {
            public ChoiceRule(Rule[] xs)
            {
                foreach (Rule r in xs)
                    Trace.Assert(r != null);
                mRules = xs;
            }

            public override bool Match(Parser p)
            {
                foreach (Rule r in mRules)
                {
                    if (r.Match(p))
                        return true;
                }
                return false;
            }

            public override string ToString()
            {
                string result = "(";
                if (mRules.Length > 0)
                {
                    result += mRules[0].ToString();
                    foreach (Rule r in mRules)
                    {
                        result += " | " + r.ToString();
                    }
                }
                return result + ")";
            }

            Rule[] mRules;
        }

        /// <summary>
        /// This but attempts to match a optional rule. It always succeeds 
        /// whether the underlying rule succeeds or not.
        /// </summary>
        public class OptRule : Rule
        {
            public OptRule(Rule r)
            {
                Trace.Assert(r != null);
                mRule = r;
            }

            public override bool Match(Parser p)
            {
                mRule.Match(p);
                return true;
            }

            public override string ToString()
            {
                return mRule.ToString() + "?";
            }

            Rule mRule;
        }

        /// <summary>
        /// This attempts to match a rule 0 or more times. It will always succeed,
        /// and will match the rule as often as possible. Unlike the * operator 
        /// in PERL regular expressions, partial backtracking is not possible. 
        /// </summary>
        public class StarRule : Rule
        {
            public StarRule(Rule r)
            {
                Trace.Assert(r != null);
                mRule = r;
            }

            public override bool Match(Parser p)
            {
                while (mRule.Match(p))
                { }
                return true;
            }

            public override string ToString()
            {
                return mRule.ToString() + "*";
            }

            Rule mRule;
        }

        /// <summary>
        /// This is similar to the StarRule except it matches a rule 1 or more times. 
        /// </summary>
        public class PlusRule : Rule
        {
            public PlusRule(Rule r)
            {
                Trace.Assert(r != null);
                mRule = r;
            }

            public override bool Match(Parser p)
            {
                if (!mRule.Match(p))
                    return false;
                while (mRule.Match(p))
                { }
                return true;
            }

            public override string ToString()
            {
                return mRule.ToString() + "+";
            }

            Rule mRule;
        }

        /// <summary>
        /// Asssures that no more input exists
        /// </summary>
        public class EndOfInputRule : Rule
        {
            public override bool Match(Parser p)
            {
                return p.AtEnd();
            }

            public override string ToString()
            {
                return "_eof_";
            }
        }

        /// <summary>
        /// This returns true if a rule can not be matched.
        /// It never advances the parser.
        /// </summary>
        public class NotRule : Rule
        {
            public NotRule(Rule r)
            {
                Trace.Assert(r != null);
                mRule = r;
            }

            public override bool Match(Parser p)
            {
                int pos = p.GetPos();
                if (mRule.Match(p))
                {
                    p.SetPos(pos);
                    return false;
                }
                Trace.Assert(p.GetPos() == pos);
                return true;
            }

            public override string ToString()
            {
                return "!" + mRule.ToString();
            }

            Rule mRule;
        }

        /// <summary>
        /// Attempts to match a specific character.
        /// </summary>
        public class SingleCharRule : Rule
        {
            public SingleCharRule(char x)
            {
                mData = x;
            }

            public override bool Match(Parser p)
            {
                if (p.AtEnd()) return false;
                if (p.GetChar() == mData)
                {
                    p.GotoNext();
                    return true;
                }
                return false;
            }

            public override string ToString()
            {
                return "";
                //return mData.ToString();
            }

            char mData;
        }

        /// <summary>
        /// Attempts to match a sequence of characters.
        /// </summary>
        public class CharSeqRule : Rule
        {
            public CharSeqRule(string x)
            {
                mData = x;
            }

            public override bool Match(Parser p)
            {
                if (p.AtEnd()) return false;
                int pos = p.GetPos();
                foreach (char c in mData)
                {
                    if (p.GetChar() != c)
                    {
                        p.SetPos(pos);
                        return false;
                    }
                    p.GotoNext();
                }
                return true;
            }

            public override string ToString()
            {
                return "[" + mData + "]";
            }

            string mData;
        }

        /// <summary>
        /// Matches any character and advances the parser, unless it is 
        /// at the end of the input.
        /// </summary>
        public class AnyCharRule : Rule
        {
            public override bool Match(Parser p)
            {
                if (!p.AtEnd())
                {
                    p.GotoNext();
                    return true;
                }
                return false;
            }

            public override string ToString()
            {
                return ".";
            }
        }

        /// <summary>
        /// Returns true and advances the parser if the current character matches any 
        /// member of a specific set of characters.
        /// </summary>
        public class CharSetRule : Rule
        {
            public CharSetRule(string s)
            {
                mData = s;
            }

            public override bool Match(Parser p)
            {
                if (p.AtEnd())
                    return false;
                foreach (char c in mData)
                {
                    if (c == p.GetChar())
                    {
                        p.GotoNext();
                        return true;
                    }
                }
                return false;
            }

            public override string ToString()
            {
                return "[" + mData + "]";
            }

            string mData;
        }

        /// <summary>
        /// Returns true and advances the parser if the current character matches any 
        /// member of a specific range of characters.
        /// </summary>
        public class CharRangeRule : Rule
        {
            public CharRangeRule(char first, char last)
            {
                mFirst = first;
                mLast = last;
                Trace.Assert(mFirst < mLast);
            }

            public override bool Match(Parser p)
            {
                if (p.AtEnd()) return false;
                if (p.GetChar() >= mFirst && p.GetChar() <= mLast)
                {
                    p.GotoNext();
                    return true;
                }
                return false;
            }

            public override string ToString()
            {
                return "[" + mFirst.ToString() + ".." + mLast.ToString() + "]";
            }

            char mFirst;
            char mLast;
        }

        /// <summary>
        /// Matches a rule over and over until a terminating rule can be 
        /// successfully matched. 
        /// </summary>
        public class WhileNotRule : Rule
        {
            public WhileNotRule(Rule elem, Rule term)
            {
                mElem = elem;
                mTerm = term;
            }

            public override bool Match(Parser p)
            {
                int pos = p.GetPos();
                while (!mTerm.Match(p))
                {
                    if (!mElem.Match(p))
                    {
                        p.SetPos(pos);
                        return false;
                    }
                }
                return true;
            }

            public override string ToString()
            {
                return "(" + mElem.ToString() + "* !" + mTerm.ToString() + ")";
            }

            Rule mElem;
            Rule mTerm;
        }

        public static Rule EndOfInput() { return new EndOfInputRule(); }
        public static Rule Delay(RuleDelegate r) { return new DelayRule(r); }
        public static Rule SingleChar(char c) { return new SingleCharRule(c); }
        public static Rule CharSeq(string s) { return new CharSeqRule(s); }
        public static Rule AnyChar() { return new AnyCharRule(); }
        public static Rule NotChar(char c) { return Seq(Not(SingleChar(c)), AnyChar()); }
        public static Rule CharSet(string s) { return new CharSetRule(s); }
        public static Rule CharRange(char first, char last) { return new CharRangeRule(first, last); }
        public static Rule AstNode(Object label, Rule x) { return new AstNodeRule(label, x); }
        public static Rule NoFail(Rule r, string s) { return new NoFailRule(r, s); }
        public static Rule Seq(Rule x0, Rule x1) { return new SeqRule(new Rule[] { x0, x1 }); }
        public static Rule Seq(Rule x0, Rule x1, Rule x2) { return new SeqRule(new Rule[] { x0, x1, x2 }); }
        public static Rule Seq(Rule x0, Rule x1, Rule x2, Rule x3) { return new SeqRule(new Rule[] { x0, x1, x2, x3 }); }
        public static Rule Seq(Rule x0, Rule x1, Rule x2, Rule x3, Rule x4) { return new SeqRule(new Rule[] { x0, x1, x2, x3, x4 }); }
        public static Rule Seq(Rule x0, Rule x1, Rule x2, Rule x3, Rule x4, Rule x5) { return new SeqRule(new Rule[] { x0, x1, x2, x3, x4, x5 }); }
        public static Rule Choice(Rule x0, Rule x1) { return new ChoiceRule(new Rule[] { x0, x1 }); }
        public static Rule Choice(Rule x0, Rule x1, Rule x2) { return new ChoiceRule(new Rule[] { x0, x1, x2 }); }
        public static Rule Choice(Rule x0, Rule x1, Rule x2, Rule x3) { return new ChoiceRule(new Rule[] { x0, x1, x2, x3 }); }
        public static Rule Choice(Rule x0, Rule x1, Rule x2, Rule x3, Rule x4) { return new ChoiceRule(new Rule[] { x0, x1, x2, x3, x4 }); }
        public static Rule Opt(Rule x) { return new OptRule(x); }
        public static Rule Star(Rule x) { return new StarRule(x); }
        public static Rule Plus(Rule x) { return new PlusRule(x); }
        public static Rule Not(Rule x) { return new NotRule(x); }
        public static Rule WhileNot(Rule elem, Rule term) { return new WhileNotRule(elem, term); }
        public static Rule NL() { return CharSet("\n"); }
        public static Rule LowerCaseLetter() { return CharRange('a', 'z'); }
        public static Rule UpperCaseLetter() { return CharRange('A', 'Z'); }
        public static Rule Letter() { return Choice(LowerCaseLetter(), UpperCaseLetter()); }
        public static Rule Digit() { return CharRange('0', '9'); }
        public static Rule HexDigit() { return Choice(Digit(), Choice(CharRange('a', 'f'), CharRange('A', 'F'))); }
        public static Rule BinaryDigit() { return CharSet("01"); }
        public static Rule IdentFirstChar() { return Choice(SingleChar('_'), Letter()); }
        public static Rule IdentNextChar() { return Choice(IdentFirstChar(), Digit()); }
        public static Rule Ident() { return Seq(IdentFirstChar(), Star(IdentNextChar())); }
        public static Rule EOW() { return Not(IdentNextChar()); }
        public static Rule DelimitedGroup(String x, Rule r, String y) { return Seq(CharSeq(x), Star(r), NoFail(CharSeq(y), "expected " + y)); }
    }
}
