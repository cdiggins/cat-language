'use strict';

let myna = require('../myna');
let g = require('../grammars/grammar_glsl')(myna);
let genVisitor = require('../tools/myna_generate_ast_visitor');
let glslPrinter = require('../tests/glsl_printer');
let heronTools = require('../tests/heron_tools');

var path = require('path'), fs=require('fs');

function fromDir(startPath,filter,results){    
    if (!fs.existsSync(startPath))
        return results;

    var files=fs.readdirSync(startPath);
    for(var i=0;i<files.length;i++){
        var fileName=path.join(startPath,files[i]);
        var stat = fs.lstatSync(fileName);
        if (stat.isDirectory()) {
            fromDir(fileName,filter); //recurse
        }
        else if (fileName.indexOf(filter)>=0) {
            results.push(fileName);
        };
    };
    return results;
};

// TODO: uncomment only when you want to recreate a visitor file. 
/*
    var visitorCode = genVisitor(myna, "glsl");
    fs.writeFileSync("./tests/output/glsl_visitor.js", visitorCode); 
*/

var prims = heronTools.parsePrimitives('./tests/input/primitives.heron');
console.log(prims);

function testParseFile(file) {
    try 
    {
        console.log("Test parsing: " + file);
        var contents = fs.readFileSync(file, 'utf-8');
        var ast = myna.parse(g.program, contents);
        var state = glslPrinter(ast, prims, false); 
        for (var u in state.undefined) {
            console.log("Undefined variable : " + u);
        }
        var text = state.text.join("");
        var outputFile = file.replace("input", "output");
        fs.writeFileSync(outputFile, text);
        var state = glslPrinter(ast, prims, true);
        text = state.text.join("");
        outputFile = outputFile.replace(".glsl", ".heron");
        fs.writeFileSync(outputFile, text);
        if (ast.end != contents.length) {
            console.log("Only parsed " + ast.end 
              + " characters out of " + contents.length);
        }
        console.log("Succeeded parse");
    }
    catch (e)
    {
        console.log("Failure: ");
        console.log(e);
    }
}

function parseFiles() {
    var files = fromDir('./tests/input/glsl','.glsl', []);
    for (var i=0; i < files.length; ++i) {
        var f = files[i]; 
        testParseFile(f);
    }
}

parseFiles();
process.exit();