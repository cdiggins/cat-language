var myna = require('../myna');
var g = require('../grammars/grammar_pithy')(myna);

console.log("Pithy Grammar");
console.log(myna.grammarToString("pithy"));

console.log("Pithy AST Schema");
console.log(myna.astSchemaToString("pithy"));

process.exit();
