// 1) Input Myna 

'use strict';

let myna = require('../myna');
let g = require('../grammars/grammar_heron')(myna);
let fs = require('fs');

function processType(ast) {
    if (ast.name != "typeExpr") throw new Error("expected a type expression");
    return ast.allText;
}

function processPrimitive(ast, prims) {
    var name = ast.children[0].allText;
    var type = processType(ast.children[1]);
    prims[name] = type;
}

var heronTools = new function() {
    this.parsePrimitives = function(fileName) { 
        var text = fs.readFileSync(fileName, 'utf-8');
        var ast = myna.parse(g.primitiveFile, text);
        var prims = {};
        for (var p of ast.children) 
            processPrimitive(p, prims);
        return prims;
    }
}

// Export the function for use use with Node.js
if (typeof module === "object" && module.exports) 
    module.exports = heronTools;
