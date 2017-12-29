"use strict";

// Implements a CSV (comma separated values) grammar using the Myna parsing library
// See https://tools.ietf.org/html/rfc4180
// Because this grammar is computed at run-time, it can support tab delimited data by passing in "\t" 
// to the constructor as the delimiter.  
function CreateCsvGrammar(myna, delimiter)  
{
    if (delimiter === undefined)
        delimiter = ",";

    // Set a shorthand for the Myna parsing library object
    let m = myna;

    let g = new function() 
    {
        this.textdata   = m.notChar('\n\r"' + delimiter);    
        this.quoted     = m.doubleQuoted(m.notChar('"').or('""').zeroOrMore);
        this.field      = this.textdata.or(this.quoted).zeroOrMore.ast;
        this.record     = this.field.delimited(delimiter).ast;
        this.file       = this.record.delimited(m.newLine).ast;   
    }

    // Register the grammar, providing a name and the default parse rule
    myna.registerGrammar("csv", g, g.file);
}

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreateCsvGrammar;