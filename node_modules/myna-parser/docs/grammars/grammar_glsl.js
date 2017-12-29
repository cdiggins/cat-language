// https://github.com/burg/glsl-simulator/blob/master/src/glsl.pegjs
// https://www.khronos.org/registry/gles/specs/2.0/GLSL_ES_Specification_1.0.17.pdf

"use strict";

function CreateGlslGrammar(myna)  
{
    // Setup a shorthand for the Myna parsing library object
    let m = myna;    

    let g = new function() 
    {       
        var _this = this;

        // Comments and whitespace 
        this.untilEol       = m.advanceWhileNot(m.newLine).then(m.newLine.opt);
        this.fullComment    = m.seq("/*", m.advanceUntilPast("*/"));
        this.lineComment    = m.seq("//", this.untilEol);
        this.comment        = this.fullComment.or(this.lineComment);
        this.ws             = this.comment.or(m.atWs.then(m.advance)).zeroOrMore;

        // Helpers
        this.eos            = m.text(";").then(this.ws);
        this.comma          = m.char(",").then(this.ws);  

        // Helper for whitespace delimited sequences that must start with a specific value
        function guardedWsDelimSeq() { 
            var args = Array.prototype.slice.call(arguments, 1).map(function(r) { return m.seq(m.assert(r), _this.ws); });
            return m.seq(arguments[0], _this.ws, m.seq.apply(m, args)); 
        }

        function commaDelimited(rule) {
            return m.delimited(rule, _this.comma);
        }
        
        // Recursive definition of an expression
        this.expr = m.delay(function() { return _this.expr1; }).ast;

        // Recursive definition of a statement
        this.recStatement = m.delay(function() { return _this.statement; }).ast;

        // Literals
        this.fraction       = m.seq(".", m.digit.zeroOrMore);    
        this.plusOrMinus    = m.char("+-");
        this.exponent       = m.seq(m.char("eE"), this.plusOrMinus.opt, m.digits); 
        this.bool           = m.keywords("true", "false").ast;
        this.number         = m.seq(this.plusOrMinus.opt, m.integer.then(this.fraction.opt).or(this.fraction), this.exponent.opt).ast;
        this.literal        = m.choice(this.number, this.bool);
        this.identifier     = m.identifier.ast;

        // Operators 
        this.relationalOp = m.choice("<=", ">=", "<", ">").ast;
        this.equalityOp = m.choice("==", "!=").ast;
        this.prefixOp = m.choice("++", "--", "+", "-", "!").ast;
        this.assignmentOp = m.choice("+=", "-=", "*=", "/=", "=").ast;
        this.additiveOp = m.choice("+", "-").unless(m.choice("++", "--", "+=", "-=")).ast;
        this.multiplicativeOp = m.choice("*", "/").unless(m.choice("*=", "/=")).ast;
        this.logicalAndOp = m.text("&&").ast;
        this.logicalXOrOp = m.text("^^").ast;
        this.logicalOrOp = m.text("||").ast;
        this.conditionalOp = m.text("?").ast;
        this.conditionalElseOp = m.text(":").ast;
        
        // Postfix expressions
        this.funcCall = guardedWsDelimSeq("(", commaDelimited(this.expr), ")").ast;
        this.arrayIndex = guardedWsDelimSeq("[", this.expr, "]").ast;
        this.fieldName = this.identifier.ast;
        this.fieldSelect = guardedWsDelimSeq(".", this.fieldName).ast;
        this.postfixOp = m.choice("++", "--").ast;
        this.postfixExpr = m.choice(this.funcCall, this.arrayIndex, this.fieldSelect, this.postfixOp).then(this.ws).ast;

        // Expressions of different precedences 
        this.leafExpr = m.choice(this.literal, this.identifier).ast;
        this.parenExpr = guardedWsDelimSeq("(", this.expr, ")").ast;
        this.expr12 = this.parenExpr.or(this.leafExpr).ast; 
        this.expr11 = this.expr12.then(this.ws).then(this.postfixExpr.zeroOrMore).ast;
        this.expr10 = m.choice(m.seq(this.prefixOp, this.ws, this.expr11), this.expr11).ast;
        this.multiplicativeExpr = guardedWsDelimSeq(this.multiplicativeOp, this.expr10).ast
        this.expr9 = this.expr10.then(this.multiplicativeExpr.zeroOrMore).ast;
        this.additiveExpr = guardedWsDelimSeq(this.additiveOp, this.expr9).ast        
        this.expr8 = this.expr9.then(this.additiveExpr.zeroOrMore).ast;
        this.relationalExpr = guardedWsDelimSeq(this.relationalOp, this.expr8).ast;
        this.expr7 = this.expr8.then(this.relationalExpr.zeroOrMore).ast;
        this.equalityExpr = guardedWsDelimSeq(this.equalityOp, this.expr7).ast;
        this.expr6 = this.expr7.then(this.equalityExpr.zeroOrMore).ast;
        this.logicalAndExpr = guardedWsDelimSeq(this.logicalAndOp, this.expr6).ast;
        this.expr5 = this.expr6.then(this.logicalAndExpr.zeroOrMore).ast;
        this.logicalXOrExpr = guardedWsDelimSeq(this.logicalXOrOp, this.expr5).ast;
        this.expr4 = this.expr5.then(this.logicalXOrExpr.zeroOrMore).ast;
        this.logicalOrExpr = guardedWsDelimSeq(this.logicalOrOp, this.expr4).ast;
        this.expr3 = this.expr4.then(this.logicalOrExpr.zeroOrMore).ast;
        this.conditionalExpr = guardedWsDelimSeq(this.conditionalOp, this.expr, this.conditionalElseOp, this.expr).ast;
        this.expr2 = this.expr3.then(this.conditionalExpr.opt).ast;
        this.assignmentExpr = guardedWsDelimSeq(this.assignmentOp, this.expr2).ast;
        this.expr1 = this.expr2.then(this.assignmentExpr.zeroOrMore).ast; 
        
        // Type expression
        this.typeExpr = this.identifier.ast;

        // Qualifiers 
        this.precisionQualifier = m.keywords("highp", "mediump", "lowp").ast;
        this.storageQualifier = m.keywords("const","attribute","uniform","varying").ast;
        this.parameterQualifier = m.keywords("in","out","inout").ast;
        this.invariantQualifier = m.keyword("invariant").ast;        
        this.qualifiers = m.seq(
            this.invariantQualifier.then(this.ws).opt, 
            this.storageQualifier.then(this.ws).opt, 
            this.parameterQualifier.then(this.ws).opt, 
            this.precisionQualifier.then(this.ws).opt,
            this.ws).ast;

        // Preprocessor directives      
        this.ppType = m.identifier.ast;
        this.ppDefineName = m.identifier.ast;        
        this.ppDefineArg = m.identifier.ast;
        this.ppDefineArgs = guardedWsDelimSeq("(", commaDelimited(this.ppDefineArg), ")").ast;
        this.ppStart = m.choice(m.space, m.tab).zeroOrMore.then('#');
        this.ppDefineExpr = this.untilEol.ast;
        this.ppDefine = m.seq("define", this.ws, this.ppDefineName.then(this.ppDefineArgs.opt), this.ppDefineExpr).ast;
        this.ppOther = this.ppType.then(this.untilEol.then(this.ws)).ast;
        this.ppDirective = m.seq(this.ppStart, this.ws, m.choice(this.ppDefine, this.ppOther)).ast;

        // Statements 
        this.exprStatement = this.expr.then(this.ws).then(this.eos).ast;
        this.varArraySizeDecl = guardedWsDelimSeq("[", this.leafExpr, "]").ast;
        this.varName = this.identifier.ast;
        this.varInit = guardedWsDelimSeq("=", this.expr1).ast;
        this.varNameAndInit = guardedWsDelimSeq(this.varName, this.varArraySizeDecl.opt, this.varInit.opt).ast;
        this.varDecl = m.seq(this.qualifiers, this.typeExpr, this.ws, commaDelimited(this.varNameAndInit), this.ws, this.eos).ast;        
        this.forLoopInit = m.seq(this.varDecl).ast;
        this.forLoopInvariant = guardedWsDelimSeq(this.expr.opt, this.eos).ast;
        this.forLoopVariant = this.expr.then(this.ws).opt.ast;
        this.loopCond = guardedWsDelimSeq("(", this.expr, ")").ast;
        this.forLoop = guardedWsDelimSeq(m.keyword("for"), "(", this.forLoopInit, this.forLoopInvariant, this.forLoopVariant, ")", this.recStatement).ast;
        this.whileLoop = guardedWsDelimSeq(m.keyword("while"), this.loopCond, this.recStatement).ast;
        this.doLoop = guardedWsDelimSeq(m.keyword("do"), this.recStatement, m.keyword("while"), this.loopCond).ast;
        this.elseStatement = guardedWsDelimSeq(m.keyword("else"), this.recStatement).ast;
        this.ifStatement = guardedWsDelimSeq(m.keyword("if"), "(", this.expr, ")", this.recStatement, this.elseStatement.opt).ast;
        this.compoundStatement = guardedWsDelimSeq("{", this.recStatement.zeroOrMore, "}").ast;
        this.breakStatement = guardedWsDelimSeq(m.keyword("break"), this.eos).ast;
        this.continueStatement = guardedWsDelimSeq(m.keyword("continue"), this.eos).ast;
        this.returnStatement = guardedWsDelimSeq(m.keyword("return"), this.expr.opt, this.eos).ast;
        this.emptyStatement = this.eos.ast;
        this.statement = m.choice(
            this.ppDirective,
            this.emptyStatement,
            this.compoundStatement,
            this.ifStatement,
            this.returnStatement, 
            this.continueStatement, 
            this.breakStatement, 
            this.forLoop, 
            this.doLoop, 
            this.whileLoop, 
            this.varDecl,
            this.exprStatement           
        ).ast;

        this.funcParamName = this.identifier.ast;
        this.funcParam = m.choice(m.keyword("void"), m.seq(this.qualifiers, this.typeExpr, this.ws, this.funcParamName)).ast;       
        this.funcName = this.identifier.ast;
        this.funcParams = guardedWsDelimSeq("(", m.keyword("void").or(commaDelimited(this.funcParam)), ")").ast;
        this.funcDef = m.seq(this.qualifiers, this.typeExpr, this.ws, this.funcName, this.ws, this.funcParams, this.ws, this.compoundStatement.or(";"), this.ws).ast;

        this.structMember = this.varDecl.ast;
        this.structVarName = this.identifier.ast;
        this.structTypeName = this.identifier.ast;
        this.structMembers = this.structMember.zeroOrMore.ast;
        this.structDef = guardedWsDelimSeq(m.keyword("struct"), this.structTypeName, "{", this.structMembers, "}", 
            this.structVarName.opt, this.varArraySizeDecl.opt, this.eos).ast;

        // Precision directive
        this.precisionDirective = guardedWsDelimSeq("precision", this.precisionQualifier, this.typeExpr, this.eos);

        this.topLevelDecl = m.choice(this.ppDirective, this.structDef, this.precisionDirective, this.funcDef, this.varDecl).ast;
        this.program = m.seq(this.ws, this.topLevelDecl.then(this.ws).zeroOrMore, m.assert(m.end)).ast;
    };

    // Register the grammar, providing a name and the default parse rule
    return m.registerGrammar("glsl", g, g.program);
};

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreateGlslGrammar;