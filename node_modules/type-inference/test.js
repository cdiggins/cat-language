"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var type_inference_1 = require("./type_inference");
var myna_1 = require("./node_modules/myna-parser/myna");
var verbose = false;
// Defines syntax parsers for type expressions and a simple lambda calculus
function registerGrammars() {
    // A simple grammar for parsing type expressions
    var typeGrammar = new function () {
        var _this = this;
        this.typeExprRec = myna_1.Myna.delay(function () { return _this.typeExpr; });
        this.typeList = myna_1.Myna.guardedSeq('(', myna_1.Myna.ws, this.typeExprRec.ws.zeroOrMore, ')').ast;
        this.typeVar = myna_1.Myna.guardedSeq("'", myna_1.Myna.identifier).ast;
        this.typeConstant = myna_1.Myna.identifier.or(myna_1.Myna.digits).or("->").or("*").or("[]").ast;
        this.typeExpr = myna_1.Myna.choice(this.typeList, this.typeVar, this.typeConstant).ast;
    };
    myna_1.Myna.registerGrammar('type', typeGrammar, typeGrammar.typeExpr);
    // A simple grammar for parsing the lambda calculus 
    var lambdaGrammar = new function () {
        var _this = this;
        this.recExpr = myna_1.Myna.delay(function () { return _this.expr; });
        this.var = myna_1.Myna.identifier.ast;
        this.abstraction = myna_1.Myna.guardedSeq("\\", this.var, ".").then(this.recExpr).ast;
        this.parenExpr = myna_1.Myna.guardedSeq("(", this.recExpr, ")").ast;
        this.expr = myna_1.Myna.choice(this.parenExpr, this.abstraction, this.var).then(myna_1.Myna.ws).oneOrMore.ast;
    };
    myna_1.Myna.registerGrammar('lambda', lambdaGrammar, lambdaGrammar.expr);
}
registerGrammars();
var typeParser = myna_1.Myna.parsers['type'];
var lcParser = myna_1.Myna.parsers['lambda'];
function runTest(f, testName, expectFail) {
    if (expectFail === void 0) { expectFail = false; }
    try {
        console.log("Running test: " + testName);
        var result = f();
        console.log("Result = " + result);
        if (result && !expectFail || !result && expectFail) {
            console.log("PASSED");
        }
        else {
            console.log("FAILED");
        }
    }
    catch (e) {
        if (expectFail) {
            console.log("PASSED: expected fail, error caught: " + e.message);
        }
        else {
            console.log("FAILED: error caught: " + e.message);
        }
    }
}
function stringToType(input) {
    var ast = typeParser(input);
    if (ast.end != input.length)
        throw new Error("Only part of input was consumed");
    return astToType(ast);
}
function typeToString(t) {
    if (t instanceof type_inference_1.TypeInference.TypeVariable)
        return "'" + t.name;
    else if (t instanceof type_inference_1.TypeInference.TypeArray)
        return "(" + t.types.map(typeToString).join(" ") + ")";
    else
        return t.toString();
}
function astToType(ast) {
    if (!ast)
        return null;
    switch (ast.name) {
        case "typeVar":
            return type_inference_1.TypeInference.typeVariable(ast.allText.substr(1));
        case "typeConstant":
            return type_inference_1.TypeInference.typeConstant(ast.allText);
        case "typeList":
            return type_inference_1.TypeInference.typeArray(ast.children.map(astToType));
        case "typeExpr":
            if (ast.children.length != 1)
                throw new Error("Expected only one child of node, not " + ast.children.length);
            return astToType(ast.children[0]);
        default:
            throw new Error("Unrecognized type expression: " + ast.name);
    }
}
function testParse(input, fail) {
    if (fail === void 0) { fail = false; }
    runTest(function () { return stringToType(input); }, input, fail);
}
var coreTypes = {
    apply: "((('a -> 'b) 'a) -> 'b)",
    compose: "((('b -> 'c) (('a -> 'b) 'd)) -> (('a -> 'c) 'd))",
    quote: "(('a 'b) -> (('c -> ('a 'c)) 'b))",
    dup: "(('a 'b) -> ('a ('a 'b)))",
    swap: "(('a ('b 'c)) -> ('b ('a 'c)))",
    pop: "(('a 'b) -> 'b)",
};
var combinators = {
    i: "\\x.x",
    k: "\\x.\\y.x",
    s: "\\x.\\y.\\z.x z (y z)",
    b: "\\x.\\y.\\z.x (y z)",
    c: "\\x.\\y.\\z.x y z",
    w: "\\x.\\y.x y y",
    m: "\\x.x x",
    succ: "\\n.\\f.\\x.f (n f x)",
    pred: "\\n.\\f.\\x.n (\\g.\\h.h (g f)) (\\u.x) (\\t.t)",
    plus: "\\m.\\n.\\f.\\x.m f (n f x)",
    mul: "\\m.\\n.\\f.m (n f)",
    zero: "\\f.\\x.x",
    one: "\\f.\\x.f x",
    two: "\\f.\\x.f (f x)",
    three: "\\f.\\x.f (f (f x))",
    True: "\\x.\\y.x",
    False: "\\x.\\y.y",
    pair: "\\x.\\y.\\f.f x y",
    first: "\\p.p \\x.\\y.x",
    second: "\\p.p \\x.\\y.y",
    nil: "\\a.\\x.\\y.x",
    null: "\\p.p (\\a.\\b.\\x.\\y.y)",
};
function lambdaAstToType(ast, engine) {
    switch (ast.rule.name) {
        case "abstraction":
            {
                var arg = engine.introduceVariable(ast.children[0].allText);
                var body = lambdaAstToType(ast.children[1], engine);
                var fxn = type_inference_1.TypeInference.functionType(arg, body);
                engine.popVariable();
                return fxn;
            }
        case "parenExpr":
            return lambdaAstToType(ast.children[0], engine);
        case "var":
            return engine.lookupVariable(ast.allText);
        case "expr":
            {
                var r = lambdaAstToType(ast.children[0], engine);
                for (var i = 1; i < ast.children.length; ++i) {
                    var args = lambdaAstToType(ast.children[i], engine);
                    r = engine.applyFunction(r, args);
                }
                return r;
            }
        default:
            throw new Error("Unrecognized ast rule " + ast.rule);
    }
}
function stringToLambdaExprType(s) {
    var e = new type_inference_1.TypeInference.ScopedTypeInferenceEngine();
    var ast = lcParser(s);
    if (ast.end != s.length)
        throw new Error("Only part of input was consumed");
    var t = lambdaAstToType(ast, e);
    t = e.getUnifiedType(t);
    t = type_inference_1.TypeInference.alphabetizeVarNames(t);
    return t;
}
function testLambdaCalculus() {
    for (var k in combinators) {
        try {
            var s = combinators[k];
            var t = stringToLambdaExprType(s);
            console.log(k + " = " + s + " : " + t);
        }
        catch (e) {
            console.log("FAILED: " + k + " " + e);
        }
    }
}
function printCoreTypes() {
    for (var k in coreTypes) {
        var ts = coreTypes[k];
        var t = stringToType(ts);
        console.log(k);
        console.log(ts);
        console.log(t.toString());
    }
}
function testForallInference() {
    var data = {
        apply: "!t1.(!t0.((t0 -> t1) t0) -> t1)",
        compose: "!t1!t2!t3.(!t0.((t0 -> t1) ((t2 -> t0) t3)) -> ((t2 -> t1) t3))",
        quote: "!t0!t1.((t0 t1) -> (!t2.(t2 -> (t0 t2)) t1))",
        dup: "!t0!t1.((t0 t1) -> (t0 (t0 t1)))",
        swap: "!t0!t1!t2.((t0 (t1 t2)) -> (t1 (t0 t2)))",
        pop: "!t1.(!t0.(t0 t1) -> t1)",
    };
    for (var k in data) {
        var expType = data[k];
        var infType = type_inference_1.TypeInference.normalizeVarNames(stringToType(coreTypes[k]));
        if (infType != expType)
            console.log("FAILED: " + k + " + expected " + expType + " got " + infType);
        else
            console.log("PASSED: " + k);
    }
}
function regressionTestComposition() {
    var data = [
        ["apply apply", "!t2.(!t0.((t0 -> !t1.((t1 -> t2) t1)) t0) -> t2)"],
        ["apply compose", "!t2!t3!t4.(!t0.((t0 -> !t1.((t1 -> t2) ((t3 -> t1) t4))) t0) -> ((t3 -> t2) t4))"],
        ["apply quote", "!t1!t2.(!t0.((t0 -> (t1 t2)) t0) -> (!t3.(t3 -> (t1 t3)) t2))"],
        ["apply dup", "!t1!t2.(!t0.((t0 -> (t1 t2)) t0) -> (t1 (t1 t2)))"],
        ["apply swap", "!t1!t2!t3.(!t0.((t0 -> (t1 (t2 t3))) t0) -> (t2 (t1 t3)))"],
        ["apply pop", "!t2.(!t0.((t0 -> !t1.(t1 t2)) t0) -> t2)"],
        ["compose apply", "!t1.(!t0.((t0 -> t1) !t2.((t2 -> t0) t2)) -> t1)"],
        ["compose compose", "!t1!t3!t4.(!t0.((t0 -> t1) !t2.((t2 -> t0) ((t3 -> t2) t4))) -> ((t3 -> t1) t4))"],
        ["compose quote", "!t1!t2!t3.(!t0.((t0 -> t1) ((t2 -> t0) t3)) -> (!t4.(t4 -> ((t2 -> t1) t4)) t3))"],
        ["compose dup", "!t1!t2!t3.(!t0.((t0 -> t1) ((t2 -> t0) t3)) -> ((t2 -> t1) ((t2 -> t1) t3)))"],
        ["compose swap", "!t1!t2!t3!t4.(!t0.((t0 -> t1) ((t2 -> t0) (t3 t4))) -> (t3 ((t2 -> t1) t4)))"],
        ["compose pop", "!t3.(!t0.(!t1.(t0 -> t1) (!t2.(t2 -> t0) t3)) -> t3)"],
        ["quote apply", "!t0!t1.((t0 t1) -> (t0 t1))"],
        ["quote compose", "!t0!t1!t2!t3.((t0 ((t1 -> t2) t3)) -> ((t1 -> (t0 t2)) t3))"],
        ["quote quote", "!t0!t1.((t0 t1) -> (!t2.(t2 -> (!t3.(t3 -> (t0 t3)) t2)) t1))"],
        ["quote dup", "!t0!t1.((t0 t1) -> (!t2.(t2 -> (t0 t2)) (!t3.(t3 -> (t0 t3)) t1)))"],
        ["quote swap", "!t0!t1!t2.((t0 (t1 t2)) -> (t1 (!t3.(t3 -> (t0 t3)) t2)))"],
        ["quote pop", "!t1.(!t0.(t0 t1) -> t1)"],
        ["dup apply", "!t1.(!t0.((((rec 1) t0) -> t1) t0) -> t1)"],
        ["dup compose", "!t0!t1.(((t0 -> t0) t1) -> ((t0 -> t0) t1))"],
        ["dup quote", "!t0!t1.((t0 t1) -> (!t2.(t2 -> (t0 t2)) (t0 t1)))"],
        ["dup dup", "!t0!t1.((t0 t1) -> (t0 (t0 (t0 t1))))"],
        ["dup swap", "!t0!t1.((t0 t1) -> (t0 (t0 t1)))"],
        ["dup pop", "!t0!t1.((t0 t1) -> (t0 t1))"],
        ["swap apply", "!t2.(!t0.(t0 !t1.(((t0 t1) -> t2) t1)) -> t2)"],
        ["swap compose", "!t0!t2!t3.(!t1.((t0 -> t1) ((t1 -> t2) t3)) -> ((t0 -> t2) t3))"],
        ["swap quote", "!t0!t1!t2.((t0 (t1 t2)) -> (!t3.(t3 -> (t1 t3)) (t0 t2)))"],
        ["swap dup", "!t0!t1!t2.((t0 (t1 t2)) -> (t1 (t1 (t0 t2))))"],
        ["swap swap", "!t0!t1!t2.((t0 (t1 t2)) -> (t0 (t1 t2)))"],
        ["swap pop", "!t0!t2.((t0 !t1.(t1 t2)) -> (t0 t2))"],
        ["pop apply", "!t2.(!t0.(t0 !t1.((t1 -> t2) t1)) -> t2)"],
        ["pop compose", "!t2!t3!t4.(!t0.(t0 !t1.((t1 -> t2) ((t3 -> t1) t4))) -> ((t3 -> t2) t4))"],
        ["pop quote", "!t1!t2.(!t0.(t0 (t1 t2)) -> (!t3.(t3 -> (t1 t3)) t2))"],
        ["pop dup", "!t1!t2.(!t0.(t0 (t1 t2)) -> (t1 (t1 t2)))"],
        ["pop swap", "!t1!t2!t3.(!t0.(t0 (t1 (t2 t3))) -> (t2 (t1 t3)))"],
        ["pop pop", "!t2.(!t0.(t0 !t1.(t1 t2)) -> t2)"],
    ];
    for (var _i = 0, data_1 = data; _i < data_1.length; _i++) {
        var xs = data_1[_i];
        var ops = xs[0].split(" ");
        var exp = xs[1];
        var expr1 = stringToType(coreTypes[ops[0]]);
        var expr2 = stringToType(coreTypes[ops[1]]);
        var r = type_inference_1.TypeInference.composeFunctions(expr1, expr2);
        r = type_inference_1.TypeInference.normalizeVarNames(r);
        if (r.toString() != exp) {
            console.log("FAILED: " + xs[0] + " + expected " + exp + " got " + r);
        }
        else {
            console.log("PASSED: " + xs[0]);
        }
    }
}
printCoreTypes();
testLambdaCalculus();
testForallInference();
regressionTestComposition();
process.exit();
//# sourceMappingURL=test.js.map