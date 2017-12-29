'use strict';

let fs = require("fs");
let myna = require("../myna");
let escapeHtmlChars = require('../tools/myna_escape_html_chars');

function testEscape(text, expected) {
    console.log("Input: " + text);
    console.log("Expected: " + expected);
    let result = escapeHtmlChars(text);
    console.log("Output: " + result);
    console.log(result == expected ? "Success" : "Failure");
}

testEscape("123", "123");
testEscape("'", "&#039;");
testEscape("< >", "&lt; &gt;");
testEscape(" && ", " &amp;&amp; ");
testEscape('"', "&quot;");
testEscape("", "");

function timeIt(f) {    
    let t = process.hrtime();
    f();
    t = process.hrtime(t);
    // https://blog.tompawlak.org/measure-execution-time-nodejs-javascript
    let msec = Math.floor(t[0] * 1000 + t[1] / (1000 * 1000));
    console.log('benchmark took %d msec', msec);
}

function naiveEscapeChars(s) {
    // http://stackoverflow.com/questions/784586/convert-special-characters-to-html-in-javascript
    return s.replace(/&/g, "&amp;").replace(/>/g, "&gt;").replace(/</g, "&lt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;")
}

var s = fs.readFileSync("tests\\qunit.html", "utf-8");

for (var i=0; i < 2; ++i) {
    var s1, s2;
    console.log("Running naive test");
    timeIt(function() { s1 = naiveEscapeChars(s); });
    console.log("Running Myna test");
    timeIt(function() { s2 = escapeHtmlChars(s); });
    console.log(s1 == s2 ? "Tests are same" : "Tests are different");
}