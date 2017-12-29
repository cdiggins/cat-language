'use strict';

let myna = require('../myna');
let expand = require('../tools/myna_mustache_expander');

function testExpand(template, data, expected) {
    console.log("Expanding template: ", template);
    console.log("  Data: ", data);
    let result = expand(template, data);
    console.log("  Result: ", result);
    console.log("  Expected: ", expected);
    console.log(result == expected ? "Passed" : "Failed");
}

console.log("==========");
console.log("Basic expansion tests");
console.log("==========");
testExpand("{{a}}", { a:42 }, "42");
testExpand("{{a}}", null, "");
testExpand("a b c", null, "a b c");
testExpand("a {b} c", { b: 42 }, "a {b} c");
testExpand("a {{b}} c", { b: 42 }, "a 42 c");
testExpand("{{a}}", { }, "");
testExpand("{{a}}", { a:"<>"}, "&lt;&gt;");
testExpand("{{{a}}}", { a:"<>"}, "<>");
testExpand("{{&a}}", { a:"<>"}, "<>");
testExpand("{{a}} {{b}} {{c}} {{d}}", { a:10, b:"hello", d:true}, "10 hello  true");
testExpand("{{a}}{{b}}{{c}},{{#test}}{{a}}{{b}}{{c}}{{/test}}", { a:"A", b:"X", test:{ b:"B", c:"C" }}, "AX,ABC");

console.log("Example 1");
{
    let t = [
        "Hello {{name}}", 
        "You have just won {{value}} dollars!",
        "{{#in_ca}}",
        "Well, {{taxed_value}} dollars, after taxes.",
        "{{/in_ca}}",
        ].join('\n');

    let h = {
        "name": "Chris",
        "value": 10000,
        "taxed_value": 10000 - (10000 * 0.4),
        "in_ca": true
    };

    console.log(expand(t, h));
}

console.log("Example 3");
{
    let t = [
        "* {{name}}",
        "* {{age}}",
        "* {{company}}",
        "* {{{company}}}",
    ].join('\n');

    let h = {
        "name": "Chris",
        "company": "<b>GitHub</b>"
    };
    
    console.log(expand(t, h));
}

console.log("Example 4");
{
    let t = [
        "Shown.",
        "{{#person}}",
        "Never shown!",
        "{{/person}}",
    ].join('\n');

    let h = {
        "person" : false
    };
    
    console.log(expand(t, h));
}

console.log("Example 5");
{
    let t = [
        "{{#repo}}",
        "<b>{{name}}</b>",
        "{{/repo}}",
    ].join('\n');

    let h = {
        "repo": [
            { "name": "resque" },
            { "name": "hub" },
            { "name": "rip" }
        ]
    };

    console.log(expand(t, h));
}

console.log("Example 6");
{
    let t = [
        "{{#person?}}",
        "  Hi {{name}}!",
        "{{/person?}}",
    ].join('\n');

    let h = 
        {
            "person?": { "name": "Jon" }
        };

    console.log(expand(t, h));
}

console.log("Example 7");
{
    let t = [
        "{{#repo}}",
        "<b>{{name}}</b>",
        "{{/repo}}",
        "{{^repo}}",
        "No repos :(",
        "{{/repo}}",
    ].join('\n');

    let h = {
     "repo": []
    }

    console.log(expand(t, h));
}

console.log("Example 8");
{
    console.log(expand("<h1>Today{{! ignore me }}.</h1>", {}));
}

console.log("Example 9");
{
    console.log(expand("{{text}}", { today : "Tuesday", text : "Today is {{today}}" }));
}

