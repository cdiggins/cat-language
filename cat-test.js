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
    ce.eval("6");
    ce.print();
    ce.eval("7");
    ce.print();
    ce.eval("mul");
    ce.print();
}
function instructionToString(ci) {
    return ci.name + " : " + cat_1.CatLanguage.typeToString(ci.type);
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
process.exit();
//# sourceMappingURL=cat-test.js.map