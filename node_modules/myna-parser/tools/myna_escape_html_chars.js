// This module replaces HTML reserved characters in text 
// with the appropriate entities using the Myna module. 
// The concept is to scan text creating AST nodes for reserved 
// characters or "plain text" which are strings of characters 
// containing none of the reserved text. 

'use strict';

// Load the Myna module 
let myna = require('../myna');

// Get the HTML reserved characters grammar 
require('../grammars/grammar_html_reserved_chars')(myna);

// Given a character that belongs to one of the reserved HTML characters 
// returns the entity representation. For all other text, returns the text  
function charToEntity(text) {
    if (text.length != 1)
        return text; 
    switch (text) {
        case '&': return "&amp;";
        case '<': return "&lt;";
        case '>': return "&gt;";
        case '"': return "&quot;";
        case "'": return "&#039;";
    };    
    return text;
}

// Given an ast node that represents either an HTML reserved char or 
// text without any special entity returns a sanitized version
function astNodeToHtmlText(ast) {
    return charToEntity(ast.allText);
}

// Returns a string, replacing all of the reserved characters with entities 
function escapeHtmlChars(text) 
{
    let ast = myna.parsers.html_reserved_chars(text);
    if (!ast.children)    
        return "";
    return ast.children.map(astNodeToHtmlText).join('');
}

// Export the main function for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = escapeHtmlChars;