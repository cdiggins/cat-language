// Load the Myna module and all grammars
var m = require('myna-parser');

// Load the JSON grammar
require('myna-parser/grammars/grammar_json')(m);

// Get the JSON parser 
var parser = m.parsers.json; 

// Define some input 
var input = '{ "integer":42, "greeting":"hello", "truth":false, "array":[1,2,3] }';

// Output the generated AST 
console.log(parser(input).toString());
