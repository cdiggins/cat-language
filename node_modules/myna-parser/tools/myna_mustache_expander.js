// Exposes a function for expanding mustache and CTemplate style templates.
// http://mustache.github.io/mustache.5.html
// 
// Difference with Mustache:
// * Partials are not supported, 
// * Changing the delimiter is not supported 
// * Variable expansion continues recursively until all variables are expanded. 

'use strict';

// Load the Myna module 
let myna = require('../myna');

// Create the template grammar and give it Myna
let grammar = require('../grammars/grammar_mustache')(myna);

// Escape HTML characters into their special representations
let escapeHtmlChars = require('../tools/myna_escape_html_chars');

// Get the document parsing rules  
let templateRule = grammar.document;

// Creates a new object containing the properties of the first object and the second object. 
// If any value has the same key in both values, the second object overrides the first. 
function mergeObjects(a, b) {
    var r = { };
    for (var k in a)
        r[k] = a[k];
    for (var k in b)
        r[k] = b[k];
    return r;
}

// Given an AST node, a data object, and an optional array of string, converts the nodes 
// expanding the reserved characters. 
function expandAst(ast, data, lines) {
    if (lines == undefined)
        lines = [];
    
    // If there is a child "key" get the value associated with it. 
    let keyNode = ast.child("key");
    let key = keyNode ? keyNode.allText : "";
    let val = data ? (key in data ? data[key] : "") : "";

    // Functions are not supported
    if (typeof(val) == 'function')
        throw new Exception('Functions are not supported');

    switch (ast.rule.name) 
    {
        case "document":
        case "sectionContent":
            ast.children.forEach(function(c) { 
                expandAst(c, data, lines); });
            return lines;

        case "comment":
            return lines;

        case "plainText":
            lines.push(ast.allText);
            return lines;

        case "section":        
            let content = ast.child("sectionContent");
            if (typeof val === "boolean" || typeof val === "number" || typeof val === "string") {
                if (val) 
                    expandAst(content, data, lines);
            }
            else if (val instanceof Array) {
                for (let x of val)
                    expandAst(content, mergeObjects(data, x), lines);
            }                
            else {
                expandAst(content, mergeObjects(data, val), lines);
            }
            return lines;

        case "invertedSection":
            if (!val || ((val instanceof Array) && val.length == 0))
                expandAst(ast.child("sectionContent"), data, lines);
            return lines;

        case "escapedVar":
            if (val) 
                lines.push(
                    expand(escapeHtmlChars(String(val)), data));
            return lines;
        
        case "unescapedVar":
            if (val) 
                lines.push(
                    expand(String(val), data));
            return lines;
    }
            
    throw "Unrecognized AST node " + ast.rule.name;
}

// Expands text containing CTemplate delimiters "{{" using the data object 
function expand(template, data) {
    if (template.indexOf("{{") >= 0) {
        let ast = myna.parsers.mustache(template);
        let lines = expandAst(ast, data);
        return lines.join("");
    } 
    else {
        return template;
    }
}

// Export the function for use with Node.js
if (typeof module === "object" && module.exports) 
    module.exports = expand;