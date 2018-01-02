"use strict";
// Test module for the Cat language
Object.defineProperty(exports, "__esModule", { value: true });
var cat_1 = require("./cat");
var type_inference_1 = require("./node_modules/type-inference/type_inference");
//===============================================================
// Test functions
function printEnvironment(ce) {
    for (var k in ce.instructions) {
        var i = ce.instructions[k];
        var t = cat_1.CatLanguage.typeToString(i.type);
        console.log(k + "\t : " + t);
    }
}
function testEvaluator() {
    var ce = new cat_1.CatLanguage.CatEvaluator();
    ce.trace = true;
    ce.eval("6 7 dup mul sub");
    console.log("expected 43 on stack");
}
function testComposition() {
    var ce = new cat_1.CatLanguage.CatEnvironment();
    for (var _i = 0, _a = ce.getInstructions(); _i < _a.length; _i++) {
        var i1 = _a[_i];
        for (var _b = 0, _c = ce.getInstructions(); _b < _c.length; _b++) {
            var i2 = _c[_b];
            testComposeInstruction(i1, i2);
        }
    }
}
function testComposeInstruction(i1, i2) {
    try {
        var q = new cat_1.CatLanguage.CatAbstraction([i1, i2]);
        var t = type_inference_1.TypeInference.composeFunctions(i1.type, i2.type);
        console.log(q + " : " + cat_1.CatLanguage.typeToString(t));
    }
    catch (e) {
        console.log(i1.name + " " + i2.name + " : " + e);
    }
}
function testCompose(a, b) {
    testComposeInstruction(getInstruction(a), getInstruction(b));
}
var globalEnv = new cat_1.CatLanguage.CatEnvironment();
function getInstruction(s) {
    return globalEnv.instructions[s];
}
function testEnvironment() {
    var ce = new cat_1.CatLanguage.CatEnvironment();
    printEnvironment(ce);
}
function outputInstruction(i) {
    console.log(i.toDebugString());
}
function outputDefinitions() {
    var ce = new cat_1.CatLanguage.CatEnvironment();
    console.log('=====================');
    console.log("Core Stack Operations");
    console.log('=====================');
    for (var k in ce.primOps)
        outputInstruction(ce.getInstruction(k));
    console.log('===================');
    console.log("Primitive Functions");
    console.log('===================');
    for (var k in ce.primFuncs)
        outputInstruction(ce.getInstruction(k));
    console.log('================');
    console.log("Standard Library");
    console.log('================');
    for (var k in ce.stdOps)
        outputInstruction(ce.getInstruction(k));
}
function outputGrammar() {
    console.log('===========');
    console.log('Cat Grammar');
    console.log('===========');
    console.log(cat_1.CatLanguage.grammarString());
    console.log('==============');
    console.log('Cat AST Schema');
    console.log('==============');
    console.log(cat_1.CatLanguage.astSchemaString());
}
outputGrammar();
outputDefinitions();
testEvaluator();
process.exit();
//# sourceMappingURL=cat-test.js.map