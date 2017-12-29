// Pithy is a tiny embedded programming language whose syntax is a strict subset of Python.
// https://docs.python.org/2/reference/grammar.html

// Executing Pithy code within a Python interpreter is possible and should usually give the same results, 
// but this is not guaranteed.     body { 

// Some differences 
// * No optional ";" only as a delimiter
// * Limited "import" forms
// * No global or exec statements 
// * No >> style print statements 
// * No modules 
// * Identation must be 4 spaces 

"use strict";

function CreatePithyGrammar(myna)  
{
    // Setup a shorthand for the Myna parsing library object
    let m = myna;

    let g = new function() 
    {       
        // Capture the "this" varible for use in closures
        var _this = this;

        // Comments and whitespace 
        this.untilEol       = m.advanceWhileNot(m.newLine).then(m.newLine.opt);
        this.docString      = m.seq('"""', m.advanceUntilPast('"""'));
        this.comment        = m.seq("#", this.untilEol);
        this.ws             = this.comment.or(m.atWs.then(m.advance)).zeroOrMore;
        this.indent         = m.text('    ');
        this.comma          = m.char(",").then(this.ws);
        this.escapedChar    = m.seq('\\', m.advance);
        this.doubleQuoteChar      = m.choice(this.escapedChar, m.notChar('"'));
        this.singleQuoteChar      = m.choice(this.escapedChar, m.notChar("'"));
        this.string         = m.choice(
            m.doubleQuoted(this.doubleQuoteChar.zeroOrMore),
            m.singleQuoted(this.singleQuoteChar.zeroOrMore)).unless(this.docString).ast;

        // If the first rule argument passes, all subsequent rules must pass or an assert will throw 
        function guardedSeq() { 
            var args = Array.prototype.slice.call(arguments, 1).map(function(r) { return m.seq(m.assert(r), _this.ws); });
            return m.seq(arguments[0], _this.ws, m.seq.apply(m, args)); 
        }

        // Comma delimited list with a trailing comma
        function commaList(r, trailing = true) {
            var result = r.then(guardedSeq(_this.comma, r).zeroOrMore);
            if (trailing) return result.then(_this.comma.opt);
            else return result;
        }

        // Matches specific character sequences that are not simply prefixes (e.g. 'in' and not 'inside')
        function keyword(text) { 
            return m.seq(text, m.not(m.atIdentifierNext)); 
        }
        
        // Recursive definition of an expression
        this.recExpr = m.delay(function() { return _this.expr; }).ast;

        // Recursive test 
        this.recTest = m.delay(function() { return _this.test; });

        // Recursive definition of a Stmt
        this.recStmt = m.delay(function() { return _this.stmt; }).ast;

        // Recursive list iteration
        this.recListIter = m.delay(function() { return _this.listIter; });
        
        // Recursive comprehension statement
        this.recCompIter = m.delay(function() { return _this.compIter; });

        // Literals
        this.fraction       = m.seq(".", m.digit.zeroOrMore);    
        this.plusOrMinus    = m.char("+-");
        this.exponent       = m.seq(m.char("eE"), this.plusOrMinus.opt, m.digits); 
        this.bool           = m.choice(keyword("True"), keyword("False")).ast;
        this.number         = m.seq(this.plusOrMinus.opt, m.integer.then(this.fraction.opt).or(this.fraction), this.exponent.opt).ast;
        this.literal        = m.choice(this.number, this.bool);
        this.name           = m.identifier.ast;

        // Operators 
        this.addOp = m.choice('+', '-').ast;
        this.mulOp = m.choice('*', '//', '%', '/').ast;
        this.prefixOp = m.choice('+', '-', '~').ast;
        this.shiftOp = m.choice('<<', '>>').ast;
        this.xorOp = m.text('^').ast;
        this.orOp = m.text('|').ast;
        this.andOp = m.text('&').ast;
        this.powOp = m.text('**').ast;

        this.exprList = commaList(this.recExpr);

        this.fpDef = m.choice(this.name).ast;
        this.fpList = commaList(this.fpDef).ast;

        this.recOldTest = m.delay(function() { return _this.oldTest; });
        this.recOrTest = m.delay(function() { return _this.orTest; });
        this.oldLambda = guardedSeq(keyword('lambda'), this.fpList.opt, ':', this.recOldTest).ast;
        this.oldTest = this.recOrTest.or(this.oldLambda).ast;
        this.testListSafe = commaList(this.oldTest).ast;

        this.listFor = guardedSeq(keyword('for'), this.exprList, keyword('in'), this.testListSafe, this.recListIter.opt).ast;
        this.listIf = guardedSeq(keyword('if'), this.oldTest, this.recListIter).ast;
        this.listIter = this.listFor.or(this.listIf).ast;

        this.compIf = guardedSeq(keyword('if'), this.oldTest, this.recCompIter.opt).ast;
        this.compFor = guardedSeq(keyword('for'), this.exprList, keyword('in'), this.recOrTest, this.recCompIter.opt).ast;
        this.compIter = this.compFor.or(this.compIf).ast;

        this.keyValue = m.seq(this.recTest, ':', this.recTest).ast;
        this.dictMaker = m.seq(this.keyValue, m.choice(this.compFor, commaList(this.keyValue))).ast;
        this.setMaker = m.seq(this.recTest, m.choice(this.compFor, commaList(this.recTest))).ast;
        this.dictOrSetMaker = m.choice(this.dictMaker, this.setMaker);
        
        this.sliceOp = guardedSeq(':', this.recTest.opt).ast;
        this.subScript = m.choice("...", 
            m.seq(this.recTest.opt, ':', this.recTest.opt, this.sliceOp.opt),
            this.recTest);
        this.subScriptList = commaList(this.subScript);

        this.argument = m.seq(this.recTest, this.compFor.opt).ast;
        this.argList = commaList(this.argument).ast;
        this.trailer = m.choice(
            guardedSeq('(', this.argList.opt, ')'),
            guardedSeq('[', this.subScriptList.opt, ']'),
            guardedSeq('.', this.name)).ast;

        // Backward compatibility cruft to support:
        // [ x for x in lambda: True, lambda: False if x() ]
        // even while also allowing:
        // lambda x: 5 if x else 2
        // (But not a mix of the two)

        this.lambda = guardedSeq(keyword('lambda'), this.fpList.opt, ':', this.recExpr).ast;

        this.testList = commaList(this.recTest).ast;
        this.testListComp = this.recTest.then(this.compFor.or(this.testList)).ast;
        this.listMaker = this.recTest.then(this.listFor.or(this.testList)).ast;        
        this.strings = m.oneOrMore(this.string, this.ws).ast;
        this.yieldExpr = guardedSeq(keyword('yield'), this.testList.opt).ast;

        this.atom = m.delay(function() { return m.choice(
            guardedWsSeq('(', _this.yieldExpr.or(_this.testListComp).opt, ')'),
            guardedWsSeq('[', _this.listMaker.opt, ']'),
            guardedWsSeq('{', _this.dictOrSetMaker.opt, '}'),
            _this.name,
            _this.number,
            _this.strings
        ); });

        // Expressions
        this.powClause = guardedSeq(this.powOp, m.delay(function() { return factor; })).ast;
        this.powExpr = m.seq(this.atom, this.trailer.zeroOrMore, this.powClause).ast;
        this.factor = this.prefixOp.zeroOrMore.then(this.powExpr).ast;
        this.mulClause = guardedSeq(this.mulOp, this.factor).ast;
        this.mulExpr = this.factor.then(this.mulClause.zeroOrMore).ast;
        this.addClause = guardedSeq(this.addOp, this.mulExpr).ast;
        this.addExpr = this.mulExpr.then(this.addClause.zeroOrMore).ast;
        this.shiftClause = guardedSeq(this.shiftOp, this.addExpr).ast;
        this.shiftExpr = this.addExpr.then(this.shiftClause.zeroOrMore).ast;
        this.andClause = guardedSeq(this.andOp, this.shiftExpr).ast;
        this.andExpr = this.shiftExpr.then(this.andClause.zeroOrMore).ast
        this.xorClause = guardedSeq(this.xorOp, this.andExpr).ast;
        this.xorExpr = this.andExpr.then(this.xorClause.zeroOrMore).ast;
        this.orClause = guardedSeq(this.orOp, this.xorExpr).ast;
        this.expr = this.xorExpr.then(this.orClause.zeroOrMore).ast;

        this.compOp = m.choice('==', '>=', '<=', '<>', '!=', '<', '>', keyword('in'), keyword('not in'), keyword('is not'), keyword('is')).ast;
        this.comparison = this.expr.then(this.compOp)
        this.notClause = guardedSeq(keyword('not'), this.comparison).ast;
        this.notTest = this.notClause.or(this.comparison).ast;
        this.andTest = this.notTest.then(guardedSeq(keyword('and'), this.notTest).zeroOrMore).ast;
        this.orTest = this.andTest.then(guardedSeq(keyword('or'), this.andTest).zeroOrMore).ast;
        this.test = m.seq(this.orTest, guardedSeq(keyword('if'), this.orTest, keyword('else'), this.recTest).or(this.lambda)).ast;

        // Statements 
        this.suite = m.delay(function() { 
            return m.choice(this.simpleStmt, m.seq(this.newLine, this.indent, this.stmt.oneOrMore, this.dedent));  
        }).ast;

        this.withItem = m.seq(this.test, guardedSeq(keyword('as'), this.expr).opt).ast;
        this.withStmt = guardedSeq(keyword('with'), commaList(this.withItem), ':', this.suite).ast;

        // Function definitions
        this.parameter = this.name.ast;
        this.parameters = guardedSeq('(', commaList(this.parameter), ')').ast;
        this.functionDef = guardedSeq(keyword('def'), this.name, this.parameters, ':', this.suite).ast;

        // Helpers 
        this.dottedName = this.name.then(guardedSeq(".", this.name).zeroOrMore).ast;
        this.yieldOrTest = m.choice(this.yieldExpr, this.testList);
        this.augmentedAssign = m.choice('+=', '-=', '*=', '/=', '%=', '&=', '|=', '^=', '<<=', '>>=', '**=', '//=').ast;

        // Compound statements
        this.elseStmt = guardedSeq(keyword('else'), this.suite).ast;
        this.forStmt = guardedSeq(keyword('for'), this.exprList, keyword('in'), this.testList, ':', this.suite, this.elseStmt.opt).ast;
        this.whileStmt = guardedSeq(keyword('while'), this.test, ':', this.suite, this.elseStmt.opt).ast;    
        this.elifStmt =  guardedSeq(keyword('elif'), this.test, ':', this.suite).ast;
        this.ifStmt = guardedSeq(keyword('if'), this.test, ':', this.suite, this.elifStmt.zeroOrMore, this.elseStmt).ast;
        this.compoundStmt = m.choice(this.ifStmt, this.whileStmt, this.forStmt, this.withStmt, this.functionDef);

        // Simple statements 
        this.assertStmt = guardedSeq(keyword('assert'), this.test, guardedSeq(',', this.test).zeroOrMore).ast;
        this.importStmt = guardedSeq(keyword('import'), this.dottedName, keyword('as'), this.name).ast;
        this.passStmt = keyword('pass').ast;
        this.breakStmt = keyword('break').ast;
        this.continueStmt = keyword('continue').ast;
        this.returnStmt = keyword('return').then(this.expr.opt).ast;
        this.yieldStmt = this.yieldExpr.ast;
        this.raiseStmt = keyword('raise').then(m.opt(this.test, guardedSeq(",", this.test, guardedSeq(",", this.test).opt).opt)).ast;
        this.flowStmt = m.choice(this.breakStmt, this.continueStmt, this.returnStmt, this.raiseStmt, this.yieldStmt).ast;
        this.delStmt = guardedSeq(keyword('del'), this.exprList).ast;
        this.printStmt = guardedSeq(keyword('print'), commaList(this.test)).ast;
        this.exprStmt = m.seq(this.testList, m.choice(
            guardedSeq(this.augmentedAssign, this.yieldOrTest),
            guardedSeq('=',  this.yieldOrTest).zeroOrMore)).ast;               
        this.smallStmt = m.choice(this.printStmt, this.delStmt, this.passStmt, this.flowStmt, this.importStmt, this.assertStmt, this.exprStmt).ast
        this.simpleStmt = m.seq(this.smallStmt, m.zeroOrMore(';', this.ws, this.smallStmt), m.newLine).ast;
        
        this.stmt = m.choice(this.simpleStmt, this.compoundStmt);
        this.singleInput = m.choice(m.newLine, this.simpleStmt, this.compoundStmt);
        this.program = this.singleInput.zeroOrMore.ast;
    };

    // Register the grammar, providing a name and the default parse rule
    return m.registerGrammar("pithy", g, g.program);
};

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreatePithyGrammar;