// Test module for the Cat language

import { CatLanguage as cat } from "./cat";
import { TypeInference as ti } from "./type_inference";

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
    ce.eval("6");
    ce.print();
    ce.eval("7");
    ce.print();
    ce.eval("mul");
    ce.print();
}

function instructionToString(ci:cat.CatInstruction) : string {
    return ci.name + " : " + cat.typeToString(ci.type);
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

//testEvaluator();
//testEnvironment();
//testComposition();
//testCompose("[dup]")
//globalEnv.addDefinition("doubleDip", "dup dup", "('a -> 'a 'a 'a 's)");
//globalEnv.addDefinition("test", "[dup] dup");
//             "qdup"      : ["[dup]", "('S -> ('a 'R -> 'a 'a 'R) 'S)"],


declare var process : any;
process.exit();
