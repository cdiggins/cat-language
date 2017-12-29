"use strict";

// Load Myna and all the grammars 
var m = require('../tools/myna_all');
var inputs = require('../tests/rule_test_inputs')(m);
var ruleTester = require('../tests/rule_tester');
var assert = require('assert');

// Set up the unit tests with Mocha
describe("Parser tests", function() {
    function tester(name, testFxn) {
        //console.log("Running test: " + name);
        it(name, function() { testFxn(assert); });
    }
    ruleTester(m, inputs, tester);
});
