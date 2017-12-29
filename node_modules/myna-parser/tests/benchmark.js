'use strict';

/*
    * I need to add memoization, I think this is going to have a huge impact. 
    * To do this, I need to change to "parsers" from "numbers" as results of parsers
    * I notice that "CharSet" could be more efficiently implemented than using "Lookup". Similar, BUT, I need 
*/

let m = require('../myna');
let jg = require('../grammars/grammar_json')(m);
let fs = require('fs');
let input = require('../tests/input/1k_json.js');


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

function ruleStructure(r, indent, lines) 
{
    lines.push(indent + r.toString() + " : " + r.type);
    r.rules.forEach(r2 => ruleStructure(r2, indent + "  ", lines));
    return lines;
}

function optimizeRule(r) 
{
    r = r.copy;

    if (r instanceof m.Sequence)
    {
        let rs = [];

        for (let i=0; i < r.rules.length; ++i) {
            let r2 = optimizeRule(r.rules[i]);

            // Heuristic: Sequence flattening 
            // (a (b c)) => (a b c)
            if (!r2._createAstNode && r2 instanceof m.Sequence) 
                rs = rs.concat(r2.rules); 
            else 
                rs.push(r2);
        }

        // x? advance => advanceIf(x)
        for (var i=rs.length-2; i >= 0; --i)
            if (rs[i].nonAdvancing && rs[i+1] instanceof m.Advance) 
                rs.splice(i, 2, new m.AdvanceIf(rs[i]));

        // If we are down to one rule we return it.
        if (rs.length == 1)        
            return rs[0];

        r.rules = rs;
        return r;
    }
        
    if (r instanceof m.Choice)
    {
        let rs = [];

        for (let i=0; i < r.rules.length; ++i) {
            let r2 = optimizeRule(r.rules[i]);

            // Heuristic: Choice flattening
            // (a\(b\c)) => (a\b\c)
            if (r2 instanceof m.Choice) 
                rs = rs.concat(r2.rules);
            else 
                rs.push(r2);
        }

        // Filter the new list of rules
        for (let i = rs.length-1; i >= 1; --i) {
            let r1 = rs[i-1];
            let r2 = rs[i];

            if (r1 instanceof m.CharSet && r2 instanceof m.CharSet)
            {
                let text = r1.text + r2.text;
                rs[i-1] = m.chars(text);
                rs.splice(i, 1);
            }
        }
        
        // Should really be: also check if they are sequences that start with "AdvanceIf"
        if (rs.every((r) => r instanceof m.AdvanceIf)) {
            let tmp = rs.map(r => r.firstChild);
            return new m.AdvanceIfAny(tmp);
        }
        
        // TODO: can I convert the things to lookups?         

        // If we are down to one rule we return it.
        if (rs.length == 1)        
            return rs[0];

        r.rules = rs;
        return r;
    }

    // Optimize "quantified" rules
    if (r instanceof m.Quantified)
    {
        r.rules[0] = optimizeRule(r.rules[0]);

        // m.AdvanceIf.opt is redundant. 
        if (!r._createAstNode && r.min==0 && r.max==1 && r.rules[0] instanceof m.AdvanceIf)
            return r.rules[0];

        return r;
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

{
    //console.log("Unoptimized rule");
    let txt = ruleStructure(o, "", []).join("\n");
    //console.log(txt);
    fs.writeFileSync("e:\\tmp\\myna.txt", txt);
}
{
    //console.log("Optimized rule");
    let txt = ruleStructure(o2, "", []).join("\n");
    //console.log(txt);
    fs.writeFileSync("e:\\tmp\\myna_opt.txt", txt);
}

//let ast = m.parse(o, input);
//let ast2 = m.parse(o2, input);

// TODO: compre the two ASTs. I need a function for converting an AST to a string. 

{
    for (let i = 0; i < 10; ++i) {
        console.log("Unoptimized");
        timeParse(o, input);
        console.log("Optimized");
        timeParse(o2, input);
    }
    console.log("Native")
    timeIt(function() { JSON.parse(input); });
}

// console.log(r);

process.exit();