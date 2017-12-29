// The createAstVisitor function creates a file of code that contains a Visitor object specialized 
// for walking the parse tree created from a grammar. 
// 
// This can be useful when constructing code for parsing special types of grammars  

function createAstVisitorFunction(rule, lines) {
    lines.push("  this.visit_" + rule.name + " = function(ast, stack, state) {");
    lines.push("    // " + rule.astRuleDefn());
    lines.push("    // TODO: add custom implementation")
    lines.push("    this.visitChildren(ast, stack, state);");
    lines.push("  }")
}

function createAstVisitor(myna, grammarName) {
    var lines = [
        "var " + grammarName + "Visitor = new function()",
        "{",
        "  this.visitNode = function(ast, state) {",
        "    this['visit_' + child.name](child, state);",
        "  }",        
        "  this.visitChildren = function(ast, state) {",
        "    for (var child of ast.children)",
        "      this.visitNode(child, state);",
        "  }"        
        ];
    var rules = myna.grammarAstRules(grammarName);
    for (var r of rules)
        createAstVisitorFunction(r, lines);    
    lines.push("}");

    return lines.join("\n");
}

// Export the function for use use with Node.js
if (typeof module === "object" && module.exports) 
    module.exports = createAstVisitor;
