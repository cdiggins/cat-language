'use strict';

let myna = require('../myna');
let grammar = require('../grammars/grammar_arithmetic')(myna);
let evaluator = require('../tools/myna_arithmetic_evaluator.js')(myna);

let arithmeticTestInputs = [  
    ["(42)", 42],
    ["6 * 7", 42],    
    ["42", 42],
    ["0", 0],    
    ["-42", -42],
    ["- 5", -5],
    ["-\t-   5", 5],
    ["-(42)", -42],
    ["+42", +42],
    ["+(42)", +42],
    ["2 * 3 * 7", 42],        
    ["5 * 8 + 2", 42],        
    ["2 + 5 * 8", 42],        
    ["(5 * 8) + 2", 42],        
    ["2 + (5 * 8)", 42],        
    ["((5 * 8) + 2)", 42],        
    ["(2 + (5 * 8))", 42],        
    ["6 * (9 - 2)", 42],        
    ["(9 - 2) * 6", 42],        
    ["5 * 9 - 3", 42],
    ["-5 * 9", -45],        
    ["3 - -5", 8],        
    ["-3 - -5 * 9", 42]];

for (let test of arithmeticTestInputs) {
    let input = test[0];
    let expected = test[1];
    let result = evaluator(input);
    if (result !== expected) 
        console.log("test failed: " + test + ", instead was: " + result);
    else 
        console.log("test passed: " + test)
}