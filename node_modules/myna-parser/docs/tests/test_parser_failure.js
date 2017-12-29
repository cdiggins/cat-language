var myna = require('../myna');
var g = require('../grammars/grammar_json')(myna);
var parse = myna.parsers.json;

try 
{
    var ast = parse(
    `{ 
        "number" : 42,
        "array" : [1, 2, 3 }
    }`);

    console.log(ast);
}
catch (e)
{
    console.log("Error occured:");
    console.log(e.toString());
}

process.exit();

