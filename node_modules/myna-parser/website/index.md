# Myna - Recursive Descent Parsing Library for JavaScript

Myna is an easy to use recursive-descent parsing library for JavaScript (EcmaScript 5.1) written in TypeScript. 

This web-site was [made using Myna tools](https://github.com/cdiggins/myna-parser/blob/master/tools/myna_build_site.js) to:

1. [Parse and convert Markdown into HTML](https://github.com/cdiggins/myna-parser/blob/master/tools/myna_markdown_to_html.js)
1. [Parse and expand Mustache style templates](https://github.com/cdiggins/myna-parser/blob/master/tools/myna_mustache_expander.js)
1. [Convert HTML characters into escape codes](https://github.com/cdiggins/myna-parser/blob/master/tools/myna_escape_html_chars.js)

Myna features: 

* Myna is a JavaScript library not a code generator
* Parsing automatically creates an abstract syntax tree (AST) 
* No separate tokenization phase
* [Competitive performance](https://sap.github.io/chevrotain/performance/) with other libraries 
* Many [sample grammars](https://github.com/cdiggins/myna-parser/tree/master/grammars) and [example tools](https://github.com/cdiggins/myna-parser/tree/master/tools).
* Functions for generating a PEG representation of the grammar, or the AST schema 

## Using Myna 

Below is an example of how to use Myna from Node.JS in a single self-contained example: 

```
// Load the Myna module and all grammars
var m = require('myna-parser');

// Load the JSON grammar
require('myna-parser/grammars/grammar_json')(m);

// Get the JSON parser 
var parser = m.parsers.json; 

// Define some input 
var input = '{ "integer":42, "greeting":"hello", "truth":false, "array":[1,2,3] }';

// Output the generated AST 
console.log(parser(input).toString());
```

## Writing a Grammar 

The following example shows how to use Myna with a custom Grammar:

```
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
```

Only rules that are defined with the `.ast` property will create nodes in the output parse tree. This saves the work of having to convert from a Concrete Syntax Tree (CST) to an  Abstract Syntax Tree (AST).
