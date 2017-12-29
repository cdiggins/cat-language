// Adds additional information to an AST once it has been constructed.
// This information is expensive to add at parse time. 
// It adds a parent pointer, a unique index, a row number, and a column number.
// All of the nodes are then placed in an array. 
function augmentAstTree(ast) {
    return augmentAstNode(ast, null, 0, 0, 0, []);
}

function augmentAstNode(node, parent, index, rowNum, colNum, nodes) {
    var lineCount1 = 0;
    var lineCount2 = 0;
    for (;index < node.start; ++index) {
        if (node.input.charCodeAt(index) == 10) {
            lineCount1++;
            colNum = 0;
        }
        else if (node.input.charCodeAt(index) == 13) {
            lineCount2++;
            colNum = 0;
        }
        else {
            colNum++;
        }
    }
    if (lineCount1 >= lineCount2) {
        rowNum += lineCount1;
    }
    else {
        rowNum += lineCount2;
    }
    node.parent = parent;
    node.rowNum = rowNum;
    node.colNum = colNum;
    node.index = nodes.length;
    nodes.push(node);
    for (var child of node.children)
        augmentAstNode(child, node, index, rowNum, colNum, nodes);
    return nodes;
}

// Export the function for use use with Node.js
if (typeof module === "object" && module.exports) 
    module.exports = augmentAstTree;
