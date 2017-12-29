"use strict";

// Implements a JSON (JavaScript Object Notation) grammar using the Myna parsing library
// See http://www.json.org
function CreateJsonGrammar(myna)  
{
    // Setup a shorthand for the Myna parsing library object
    let m = myna;    

    let g = new function() 
    {
        // These are helper rules, they do not create nodes in the parse tree.  
        this.escapedChar    = m.seq('\\', m.advance);
        this.quoteChar      = m.choice(this.escapedChar, m.notChar('"'));
        this.fraction       = m.seq(".", m.digit.zeroOrMore);    
        this.plusOrMinus    = m.char("+-");
        this.exponent       = m.seq(m.char("eE"), this.plusOrMinus.opt, m.digits); 
        this.comma          = m.char(",").ws;  

        // The following rules create nodes in the abstract syntax tree     
        this.string         = m.doubleQuoted(this.quoteChar.zeroOrMore).ast;
        this.null           = m.keyword("null").ast;
        this.bool           = m.keywords("true", "false").ast;
        this.number         = m.seq(this.plusOrMinus.opt, m.integer, this.fraction.opt, this.exponent.opt).ast;
            
        let _this = this;
        this.value = m.choice(this.string, this.bool, this.null, this.number, 
            // Using a lazy evaluation rule to allow recursive rule definitions  
            m.delay(function() { return m.choice(_this.object, _this.array); 
        }));

        this.array          = m.bracketed(m.delimited(this.value.ws, this.comma)).ast;
        this.pair           = m.seq(this.string, m.ws, ":", m.ws, this.value.ws).ast;
        this.object         = m.braced(m.delimited(this.pair.ws, this.comma)).ast;
    };

    // Register the grammar, providing a name and the default parse rule
    return m.registerGrammar("json", g, g.object);
};

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreateJsonGrammar;