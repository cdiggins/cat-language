"use strict";

// Implements a grammar for parsing JavaScript code into tokens
// See:
// - https://tc39.github.io/ecma262/#sec-ecmascript-language-lexical-grammar
// - https://github.com/jquery/esprima/blob/master/src/scanner.ts
// - https://github.com/jquery/esprima/blob/master/src/token.ts

function JavaScriptTokenGrammar(myna)
{
    let m = myna;
    this.whiteSpace = m.ws.copy.ast;
    this.lf = m.char("\u000a");
    this.cr = m.char("\u000D");
    this.ls = m.char("\u2028");
    this.ps = m.char("\u2029");
    this.lineTerminator = m.choice(this.lf, this.cr, this.ls, this.ps).ast;
    this.lineTerminatorSequence = m.choice(this.lf, this.cr.thenNot(this.lf), this.ls, this.ps, this.cr.then(this.lf));
    
    // TODO: find a way to signal that the input is invalid.
    this.multiLineComment = m.seq("/*", m.advanceUntil(m.choice("*/", m.end))).ast;
    this.singleLineComment = m.seq("//", m.advanceUntil(this.lineTerminator.or(m.end))).ast;
    this.comment = this.multiLineComment.or(this.singleLineComment);

    this.keyword = m.keywords("break do in typeof case else instanceof var catch export new void class extends return while"
        + "const finally super with continue for switch yield debugger function this default if throw delete import try await".split(" ")).ast;
        
    this.futureKeywords = m.keywords("enum await implements package protected interface private public".split(" "));

    this.punctuator = m.choice("{ ( ) [ ] . ... ; , < > <= >= == != === !== + - * % ++ -- << >> >>> & | ^ ! ~ && || ? : = += -= *= %= <<= >>= >>>= &= |= ^= => ** **=".split(" "));
    
    this.divPunctuator = m.seq("/", "/=");
    this.rightBrace = m.text("}");

    this.nullLiteral = m.text("null").ast;
    
    this.fraction       = m.seq(".", m.digit.zeroOrMore);    
    this.plusOrMinus    = m.char("+-");
    this.exponent       = m.seq(m.char("eE"), this.plusOrMinus.opt, m.digit.plus); 

    this.decimalLiteral = m.seq(this.plusOrMinus.opt, m.integer, this.fraction.opt, this.exponent.opt).ast    

    this.binaryDigits = m.binaryDigit.plus.ast;
    this.octalDigits = m.octalDigit.plus.ast;
    this.hexDigits = m.hexDigit.plus.ast;

    this.octalLiteral = m.seq("0", m.char("oO"), this.octalDigits).ast;
    this.binaryLiteral = m.seq("0", m.char("bB"), this.binaryDigits).ast;
    this.hexLiteral =  m.seq("0", m.char("xF"), this.hexDigits).ast;

    this.numericLiteral = m.choice(this.decimalLiteral, this.binaryLiteral, this.octalLiteral, this.hexLiteral).thenNot(m.IdentifierFirst.or(m.digit));

    this.unicodeHexDigits = m.hexDigit.repeat(4).ast;    
    this.unicodeEscapeSeq = m.seq('u', this.unicodeHexDigits.or(m.seq('{', this.unicodeHexDigits, '}')));
    this.hexEscapeDigits = m.seq(m.hexDigit, m.hexDigit).ast;
    this.hexEscapeSeq = m.seq('x', this.hexEscapeDigits).ast;
    this.escapeChar = m.char('\'"\\bfnrtv');
    
    this.escapeSeq = this.charEscapeSeq().or('0').

    this.lineContinuation = m.seq('\\', this.lineTerminatorSequence).ast;
    this.escapedLiteralChar = m.char('\\').then('')
    
    this.stringLiteralChar = m.notChar("\u005C\u000D\u2028\u2029\u000A\\").or(this.escapedLiteralChar).or(this.lineContinuation).ast;

    this.doubleQuotedStringContents = m.not('"').then(stringLiteralChar).zeroOrMore.ast;
    this.singleQuotedStringContents = m.not("'").then(stringLiteralChar).zeroOrMore.ast;
    this.doubleQuote = m.seq('"', this.doubleQuotedStringContents, '"');
    this.singleQuote = m.seq("'", this.singleQuotedStringContents, "'");
    this.stringLiteral = this.doubleQuote.or(this.singleQuote);

    this.regexNonTerminator = m.notChar(lineTerminator);
    this.regexBackslashSeq = m.seq('\\', this.regexNonTerminator);

    this.regexClassChar = this.not(']', '\\').then(regexNonTerminator).or(regexBackslashSeq).ast;
    this.regexClass = m.seq('[', this.regexClassChar.zeroOrMore, ']').ast;
    this.regexIllegalChar = m.char('\\/[');
    this.regexChar = this.regexNonTerminator.butNot(regexIllegalChar);
    this.regexLiteral = m.seq('/', this.regexBody, '/', this.regexFlags).ast;

    this.token = m.choice(this.nullLiteral, this.regexLiteral, this.identifierName, this.numericLiteral, this.stringLiteral, this.punctuator,
        this.templateLiteral);
}

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = JavaScriptTokenGrammar;