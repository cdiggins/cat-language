"use strict";

// This class tests parser rules given an array of inputs. 
// Each input is an array [rule, [passing inputs], [failint inputs]]
// The TestRunner is a function like QUnit.test 
function RuleTester(myna, inputs, testRunner)
{    
    if (!myna) 
        throw new Error("Missing Myna module");
    if (!inputs)
        throw new Error("Missing inputs");
    if (!testRunner)
        throw new Error("Missing test runner")

    // Tests parsing an individual rule against the input input text, and returns an object 
    // representing the result of running the test 
    function testParse(rule, assert, text, shouldPass)  {    
        if (shouldPass == undefined) shouldPass = true;
        let result = myna.failed;
        let err = undefined;    
        try {        
            let node = myna.parse(rule, text);
            if (node)
                result = node.end;            
        }
        catch (e) {
            err = e;
        }

        let testResult = {
            name : rule.toString() + ' with input "' + text + '"',
            description : result + "/" + text.length,
            negative : !shouldPass,
            success : (result == text.length) ^ !shouldPass,
            error : err,
            ruleDescr : rule.type + ": " + rule.toString(),
            rule : rule        
        };
        
        if (!testResult.success)
            console.log(testResult);

        assert.ok(testResult.success, testResult.name + (shouldPass ? "" : " should fail"));
    }

    // Tests parsing an individual rule against using an array of inputs string that should pass
    // and an array of inputs strings that should fail. 
    function testRule(rule, assert, passStrings, failStrings) {
        for (let input of passStrings)
            testParse(rule, assert, input, true);
        
        for (let input of failStrings)
            testParse(rule, assert, input, false);
    }

    //===============================================
    // Body of the function 

    for (let i=0; i < inputs.length; ++i) 
    {        
        let t = inputs[i];
        if (!t || t.length < 2 || !t[0]) 
            throw new Error("Each test must have a rule, an array of passing strings, and an array of failing strings");
        
        testRunner(t[0].toString(), function(assert) {
            testRule(t[0], assert, t[1], t[2]); 
        }); 
    }
}

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = RuleTester;