'use strict';

/*
    * I need to add memoization, I think this is going to have a huge impact. 
    * To do this, I need to change to "parsers" from "numbers" as results of parsers
    * I notice that "CharSet" could be more efficiently implemented than using "Lookup". Similar, BUT, I need 
*/

let m = require('../myna');
let jg = require('../grammars/grammar_json')(m);
let fs = require('fs');
let input = require('../tests/1k_json.js');


// (a b* b) => (a b*)
// (a b+ b) => (b)

/*
function optimizeRule(r) 
{
    if (r instanceof m.Quantified)
    {
        r.rules = r.rules.map(optimizeRule);
    }
    else if (r instanceof m.Sequence)
    {
        let tmp = [];

        for (let i=0; i < r.rules.length; ++i) {
            let r2 = optimizeRule(r.rules[i]);

            // Heuristic: Sequence flattening 
            // (a (b c)) => (a b c)
            if (!r2._createAstNode && r2 instanceof m.Sequence) 
                tmp = tmp.concat(r2.rules); 
            else 
                tmp.push(r2);
        }

        r.rules = tmp;

        if (!r._createAstNode) {
            // Heuristic: zero-length sequence rules are always true 
            // () => true
            if (r.rules.length == 0)
                return m.truePredicate;
           
            // Heuristic: single-length sequence rules are just the child rule
            // (a) => a
            if (r.rules.length == 1)
                return r.rules[0];
        }
    }
    else if (r instanceof m.Choice)
    {
        let tmp = [];

        for (let i=0; i < r.rules.length; ++i) {
            let r2 = optimizeRule(r.rules[i]);
            if (r2 == undefined)
                throw new Error("Whoops!");

            // Heuristic: Choice flattening
            // (a\(b\c)) => (a\b\c)
            if (!r2._createAstNode && r2 instanceof m.Choice) 
                tmp = tmp.concat(r2.rules);
            else 
                tmp.push(r2);
        }

        // Filter the new list of rules
        for (let i = tmp.length-1; i >= 1; --i) {
            let r1 = tmp[i-1];
            let r2 = tmp[i];
            if (r1._createAstNode || r2._createAstNode) continue;

            // Heuristic: stop processing choice after true
            // (a\true\b) => (a\true)
            if (r1 instanceof m.TruePredicate)
            {
                tmp = tmp.slice(0, i-1);
                continue;
            }

            // Heuristic: remove false nodes 
            // (a\false\b) => (a\b)
            if (r2 instanceof m.FalsePredicate)
            {
                tmp = tmp.splice(i, 1);
                continue;
            }            

            // Heuristic: convert text nodes to lookup tables 
            // This should make lookup merging work better
            // TODO: 

            // Heuristic: merge lookup tables
            let lookup1 = convertToLookup(r1);
            let lookup2 = convertToLookup(r2);
            if (lookup1 && lookup2)
            {
                tmp[i-1] = mergeLookups(lookup1, lookup2);
                tmp.splice(i, 1);
            }
        }

        // TODO: can I convert the things to lookups? 

        r.rules = tmp;

        if (!r._createAstNode) {
            // Heuristic: zero-length choice rules are always true
            if (r.rules.length == 0)
                return m.truePredicate;
            // Heuristic: single-length choice rules are just the child rule
            if (r.rules.length == 1)
                return r.rules[0];
        }
    }
    else if (r instanceof m.Text) 
    {
        if (!r._createAstNode)
        {
            // Heuristic: Text rules with no length are always true
            if (r.text.length == 0)
                return m.truePredicate;

            // Heuristic: Text rules with single length are always one 
            if (r.text.length == 1)
                return m.char(r.text);
        }
    }
    else if (r instanceof m.Not)
    {
        let child = optimizeRule(r.rules[0]);
        
        if (!r._createAstNode) {    
            // Heuristic: 
            // Not(Not(X)) => X
            if (child instanceof m.Not)
                return child.rules[0];

            // Heuristic: 
            // Not(At(X)) => Not(X)
            if (child instanceof m.At)
                return child.rules[0].not;

            // Heuristic: 
            // Not(True) => False
            if (child instanceof m.TruePredicate)
                return m.falsePredicate;

            // Heuristic: 
            // Not(False) => True
            if (child instanceof m.FalsePredicate)
                return m.truePredicate;

            // Heuristic:
            // Not([abc]) => [^abc];
            if (child instanceof m.CharSet)
                return m.notAtChar(child.chars);

            // Heuristic:
            // Not([^abc]) => [abc];
            if (child instanceof m.NegatedCharSet)
                return m.char(child.chars);

            // Not(Advance) => AtEnd
            if (child instanceof m.Advance) 
                return m.atEnd;
        }

        // Set the child to be the new optimized rule 
        r.rules[0] = child;
        return r;                
    }
    else if (r instanceof m.At)
    {
        let child = optimizeRule(r.rules[0]);
        
        if (!r._createAstNode) {    
            // Heuristic: 
            // At(At(X)) => At(X)
            if (child instanceof m.At)
                return child;

            // Heuristic: 
            // At(Not(X)) => Not(X)
            if (child instanceof m.Not)
                return child;

            // Heuristic: 
            // At(<predicate>) => <predicate>
            if (child instanceof m.MatchRule)
                return child;

            // Heuristic:
            // At([abc]) => <lookup>;
            if (child instanceof CharSet)
                return new m.Lookup(child.lookup, m.truePredicate);

            // Heuristic:
            // At([^abc]) => <lookup>;
            if (child instanceof NegatedCharSet)
                return child;
        }

        // Set the child to be the new optimized rule 
        r.rules[0] = child;
        return r;                
    }

    return r;
}
*/

function optimizeRule(r) 
{
    if (r instanceof m.Sequence)
    {
        let tmp = [];

        for (let i=0; i < r.rules.length; ++i) {
            let r2 = optimizeRule(r.rules[i]);

            // Heuristic: Sequence flattening 
            // (a (b c)) => (a b c)
            if (!r2._createAstNode && r2 instanceof m.Sequence) 
                tmp = tmp.concat(r2.rules); 
            else 
                tmp.push(r2);
        }

        r.rules = tmp;
    }
    else if (r instanceof m.Choice)
    {
        let tmp = [];

        for (let i=0; i < r.rules.length; ++i) {
            let r2 = optimizeRule(r.rules[i]);

            // Heuristic: Choice flattening
            // (a\(b\c)) => (a\b\c)
            if (r2 instanceof m.Choice) 
                tmp = tmp.concat(r2.rules);
            else 
                tmp.push(r2);
        }

        // Filter the new list of rules
        for (let i = tmp.length-1; i >= 1; --i) {
            let r1 = tmp[i-1];
            let r2 = tmp[i];

            if (r1 instanceof CharSet && r2 instanceof CharSet)
            {
                let text = r1.text + r2.text;
                tmp[i-1] = m.chars(text);
                tmp.splice(i, 1);
            }
        }

        // TODO: can I convert the things to lookups? 

        r.rules = tmp;
    }
    return r;
}

function timeIt(fn) {
    let start = process.hrtime();
    fn();
    let end = process.hrtime();
    let precision = 3; // 3 decimal places
    let elapsed = process.hrtime(start)[1] / 1000000; // divide by a million to get nano to milli
    console.log(process.hrtime(start)[0] + " s " + elapsed.toFixed(precision) + " ms"); 
}

function timeParse(rule, input) {
    timeIt(function () { 
        for (let i=0; i < 10; ++i)
            m.parse(rule, input); 
    });    
}

let o = jg.array;
let o2 = optimizeRule(o.copy);
/*
{
    let rs = m.ruleStructure(o); 
    let txt = JSON.stringify(rs, null, 2);
    //console.log(txt);
    fs.writeFileSync("e:\\tmp\\myna.json", txt);
}
{
    let rs = m.ruleStructure(o2); 
    let txt = JSON.stringify(rs, null, 2);
    //console.log(txt);
    fs.writeFileSync("e:\\tmp\\myna_opt.json", txt);
}

//let ast = m.parse(o, input);
//let ast2 = m.parse(o2, input);

// TODO: compre the two ASTs. I need a function for converting an AST to a string. 
*/
console.log("Unoptimized");
for (let i = 0; i < 3; ++i) {
    timeParse(o, input);
}
console.log("Optimized");
for (let i = 0; i < 3; ++i) {
    timeParse(o2, input);
}
console.log("Native")
timeIt(function() { JSON.parse(input); });

// console.log(r);
process.exit();