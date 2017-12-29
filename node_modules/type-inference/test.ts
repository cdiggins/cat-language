import { TypeInference as ti } from "./type_inference";
import { Myna as m } from "./node_modules/myna-parser/myna";

var verbose = false;

function registerGrammars() 
{
    // This is a more verbose type grammar than the one used in Cat. 
    var typeGrammar = new function() 
    {
        var _this = this;
        this.typeExprRec            = m.delay(() => { return _this.typeExpr});
        this.typeList               = m.guardedSeq('(', m.ws, this.typeExprRec.ws.zeroOrMore, ')').ast;
        this.typeVar                = m.guardedSeq("'", m.identifier).ast;
        this.typeConstant           = m.identifier.or(m.digits).or("->").or("*").or("[]").ast;
        this.typeExpr               = m.choice(this.typeList, this.typeVar, this.typeConstant).ast;        
    }        

    m.registerGrammar('type', typeGrammar, typeGrammar.typeExpr);    
}

registerGrammars();

var parser = m.parsers['type'];

function runTest(f:() => any, testName:string, expectFail:boolean = false) {
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

function stringToType(input:string) : ti.Type {
    var ast = parser(input);
    if (ast.end != input.length) 
        throw new Error("Only part of input was consumed");
    return astToType(ast);
}

function astToType(ast) : ti.Type {
    if (!ast)
        return null;
    switch (ast.name)
    {
        case "typeVar":
            return ti.typeVariable(ast.allText.substr(1));
        case "typeConstant":
            return ti.typeConstant(ast.allText);
        case "typeList":
            return ti.typeArray(ast.children.map(astToType));
        case "typeExpr":
            if (ast.children.length != 1) 
                throw new Error("Expected only one child of node, not " + ast.children.length);
            return astToType(ast.children[0]);
        default: 
            throw new Error("Unrecognized type expression: " + ast.name);
    }
}  

function testClone(input:string, fail:boolean=false) {
    runTest(() => {
        var t = stringToType(input) as ti.TypeArray;
        console.log("Original   : " + t);
        t = t.clone({})  as ti.TypeArray;
        console.log("Cloned     : " + t);
        t = t.freshVariableNames(0) as ti.TypeArray;
        console.log("Fresh vars : " + t);
        t = ti.normalizeVarNames(t) as ti.TypeArray;
        console.log("Normalized : " + t);
        return true;
    }, input, fail);
}

function runCloneTests() 
{
    testClone("(('a 'b) -> ('b 'c))");
    testClone("('a)");
    testClone("('a 'b)");
    testClone("('a ('b))");
    testClone("('a ('b) ('a))");
    testClone("('a ('b) ('a ('c) ('c 'd)))");
    testClone("('a -> 'b)");
    testClone("(('a *) -> int)");
    testClone("(('a 'b) -> ('b 'c))");
    testClone("(('a ('b 'c)) -> ('a 'c))");
    for (var k in coreTypes)
        testClone(coreTypes[k]);
}

function testParse(input:string, fail:boolean=false)
{
    runTest(() => stringToType(input), input, fail);
}

var coreTypes = {
    apply   : "((('a -> 'b) 'a) -> 'b)",
    compose : "((('b -> 'c) (('a -> 'b) 'd)) -> (('a -> 'c) 'd))",
    quote   : "(('a 'b) -> (('c -> ('a 'c)) 'b))",
    dup     : "(('a 'b) -> ('a ('a 'b)))",
    swap    : "(('a ('b 'c)) -> ('b ('a 'c)))",
    pop     : "(('a 'b) -> 'b)",
};

function testComposition(a:string, b:string, fail:boolean = false)
{
    runTest( () => {        
        var expr1 = stringToType(a);

        if (verbose)
            console.log("Type A: " + expr1.toString());
        
        var expr2 = stringToType(b);

        if (verbose)
            console.log("Type B: " + expr2.toString());

        var r = ti.composeFunctions(expr1 as ti.TypeArray, expr2 as ti.TypeArray);

        if (verbose)
            console.log("Composed type: " + r.toString())

        // Return a prettified version of the function
        r = ti.normalizeVarNames(r) as ti.TypeArray;        
        return r.toString();
    }, 
    "Composing " + a + " with " + b, 
    fail);
}

function testUnifyChain(ops:string[]) {
    var t1 = coreTypes[ops[0]];
    var t2 = coreTypes[ops[1]];
    testComposition(t1, t2);
}

function testComposingCoreOps() {
    for (var op1 in coreTypes) {
        for (var op2 in coreTypes) {
            console.log(op1 + " " + op2);
            testComposition(coreTypes[op1], coreTypes[op2]);
        }
    }
}

function outputCompositions() {
    for (var op1 in coreTypes) {
        for (var op2 in coreTypes) { 
            var expr1 = stringToType(coreTypes[op1]);
            var expr2 = stringToType(coreTypes[op2]);
            var r = ti.composeFunctions(expr1 as ti.TypeArray, expr2 as ti.TypeArray);
            r = ti.normalizeVarNames(r) as ti.TypeArray;        
            console.log('["' + op1 + " " + op2 + '", "' + r.toString() + '"],');
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

    for (var xs of data) {
        var ops = xs[0].split(" ");
        var exp = xs[1];
        var expr1 = stringToType(coreTypes[ops[0]]);
        var expr2 = stringToType(coreTypes[ops[1]]);
        var r = ti.composeFunctions(expr1 as ti.TypeArray, expr2 as ti.TypeArray);
        r = ti.normalizeVarNames(r) as ti.TypeArray;
        if (r.toString() != exp) {
            console.log("FAILED: " + xs[0] + " + expected " + exp + " got " + r);
        }
        else {
            console.log("PASSED: " + xs[0]);
        }
    }
}

//runCloneTests();
//printCoreTypes();
//testComposingCoreOps();
//outputCompositions();
regressionTestComposition();

declare var process : any;
process.exit();
