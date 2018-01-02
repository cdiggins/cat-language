// Test module for the Cat language

import { CatLanguage as cat } from "./cat";
import { TypeInference as ti } from "./node_modules/type-inference/type_inference";

//===============================================================
// Test functions

function printEnvironment(ce : cat.CatEnvironment) {
    for (var k in ce.instructions) {
        var i = ce.instructions[k];
        var t = cat.typeToString(i.type);
        console.log(k + "\t : " + t);
    }
}

function testEvaluator() {
    var ce = new cat.CatEvaluator();    
    ce.trace = true;
    ce.eval("6 7 dup mul sub");
    console.log("expected 43 on stack");
}

function testComposition() {
    var ce = new cat.CatEnvironment();
    for (var i1 of ce.getInstructions()) {
        for (var i2 of ce.getInstructions()) {
            testComposeInstruction(i1, i2);
        }
    }
}

function testComposeInstruction(i1:cat.CatInstruction, i2:cat.CatInstruction) {
    try {
        var q = new cat.CatAbstraction([i1,i2]);
        var t = ti.composeFunctions(i1.type, i2.type);
        console.log(q + " : " + cat.typeToString(t));
    }
    catch (e) {
        console.log(i1.name + " " + i2.name + " : " + e);
    }
}

function testCompose(a:string, b:string) {
    testComposeInstruction(getInstruction(a), getInstruction(b));
}

var globalEnv = new cat.CatEnvironment();

function getInstruction(s : string) : cat.CatInstruction {
    return globalEnv.instructions[s];
}

function testEnvironment() {
    var ce = new cat.CatEnvironment();
    printEnvironment(ce);
}

function outputInstruction(i : cat.CatInstruction) { 
    console.log(i.toDebugString());
}

function outputDefinitions() {
    var ce = new cat.CatEnvironment();

    console.log('=====================');
    console.log("Core Stack Operations")
    console.log('=====================');
    for (var k in ce.primOps) 
        outputInstruction(ce.getInstruction(k));
 
    console.log('===================');
    console.log("Primitive Functions")
    console.log('===================');
    for (var k in ce.primFuncs) 
        outputInstruction(ce.getInstruction(k));
 
    console.log('================');
    console.log("Standard Library")
    console.log('================');
    for (var k in ce.stdOps) 
        outputInstruction(ce.getInstruction(k));
}

function outputGrammar() {
    console.log('===========');
    console.log('Cat Grammar');
    console.log('===========');
    console.log(cat.grammarString());

    console.log('==============');
    console.log('Cat AST Schema');
    console.log('==============');
    console.log(cat.astSchemaString());
}

outputGrammar();
outputDefinitions();
testEvaluator();

declare var process : any;
process.exit();
