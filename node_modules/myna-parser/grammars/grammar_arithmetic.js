"use strict";

// Defines a grammar for basic arithmetic 
function CreateArithmeticGrammar(myna)  
{
    // Setup a shorthand for the Myna parsing library object
    let m = myna;    

    // Construct a grammar 
    let g = new function() 
    {
        // These are helper rules, they do not create nodes in the parse tree.  
        this.fraction       = m.seq(".", m.digit.zeroOrMore);    
        this.plusOrMinus    = m.char("+-");
        this.exponent       = m.seq(m.char("eE"), this.plusOrMinus.opt, m.digits); 
        this.comma          = m.text(",").ws;  
        
        // Using a lazy evaluation rule to allow recursive rule definitions  
        let _this = this; 
        this.expr = m.delay(function() { return _this.sum; });

        // The following rules create nodes in the abstract syntax tree 
        this.number     = m.seq(m.integer, this.fraction.opt, this.exponent.opt).ast;    
        this.parenExpr  = m.parenthesized(this.expr.ws).ast;
        this.leafExpr   = m.choice(this.parenExpr, this.number.ws);
        this.prefixOp   = this.plusOrMinus.ast;
        this.prefixExpr = m.seq(this.prefixOp.ws.zeroOrMore, this.leafExpr).ast;
        this.divExpr    = m.seq(m.char("/").ws, this.prefixExpr).ast;
        this.mulExpr    = m.seq(m.char("*").ws, this.prefixExpr).ast;
        this.product    = m.seq(this.prefixExpr.ws, this.mulExpr.or(this.divExpr).zeroOrMore).ast;
        this.subExpr    = m.seq(m.char("-").ws, this.product).ast;
        this.addExpr    = m.seq(m.char("+").ws, this.product).ast;
        this.sum        = m.seq(this.product, this.addExpr.or(this.subExpr).zeroOrMore).ast;
    };

    // Register the grammar, providing a name and the default parse rule
    return myna.registerGrammar("arithmetic", g, g.expr);
};

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreateArithmeticGrammar;