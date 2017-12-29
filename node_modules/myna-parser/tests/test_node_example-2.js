// Reference the Myna module
var m = require('myna-parser');

// Construct a grammar object 
var g = new function() 
{
    this.textdata   = m.notChar('\n\r"' + delimiter);    
    this.quoted     = m.doubleQuoted(m.notChar('"').or('""').zeroOrMore);
    this.field      = this.textdata.or(this.quoted).zeroOrMore.ast;
    this.record     = this.field.delimited(delimiter).ast;
    this.file       = this.record.delimited(m.newLine).ast;   
}

// Let consumers of the Myna module access 
m.registerGrammar("csv", g, g.file);

// Get the parser 
var parser = m.parsers.csv; 
var input = 'a,1,"hello"\nb,2,"goodbye"';
console.log(parser(input).toString());