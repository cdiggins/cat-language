"use strict";

function EvalArithmetic(exprNode)
{
    switch (exprNode.rule.name) 
    {   
        case "expr":
        {
            return EvalArithmetic(exprNode.children[0]);
        }
        case "sum": 
        {
            let v = EvalArithmetic(exprNode.children[0]);
            for (let i=1; i < exprNode.children.length; ++i) {
                let child = exprNode.children[i];
                switch (child.rule.name) {
                    case("addExpr"): v += EvalArithmetic(child); break;
                    case("subExpr"): v -= EvalArithmetic(child); break;
                    default: throw "Unexpected expression " + child.rule.name;
                }
            }
            return v;
        }
        case "product": 
        {
            let v = EvalArithmetic(exprNode.children[0]);
            for (let i=1; i < exprNode.children.length; ++i) {
                let child = exprNode.children[i];
                switch (child.rule.name) {
                    case("mulExpr"): v *= EvalArithmetic(child); break;
                    case("divExpr"): v /= EvalArithmetic(child); break;
                    default: throw "Unexpected expression " + child.rule.name;
                }
            }
            return v;
        }
        case "prefixExpr":  
        {
            let v = EvalArithmetic(exprNode.children[exprNode.children.length-1]);
            for (let i=exprNode.children.length-2; i >= 0; --i)
                if (exprNode.children[i].allText == "-")
                    v = -v;
            return v;
        }
        case "parenExpr" : return EvalArithmetic(exprNode.children[0]);
        case "number": return Number(exprNode.allText);
        case "addExpr": return EvalArithmetic(exprNode.children[0]);
        case "subExpr": return EvalArithmetic(exprNode.children[0]);
        case "mulExpr": return EvalArithmetic(exprNode.children[0]);
        case "divExpr": return EvalArithmetic(exprNode.children[0]);
        default: throw "Unrecognized expression " + exprNode.rule.name;
    }
}

function CreateEvaluator(myna) {
    return function (expr) {
        let ast = myna.parsers.arithmetic(expr);
        return EvalArithmetic(ast);
    }
}

// Export the function for use with Node.js
if (typeof module === "object" && module.exports) 
    module.exports = CreateEvaluator;