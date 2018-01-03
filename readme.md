# Cat Programming Language 

Cat is a statically typed stack-based pure functional language inspired by [Joy](https://en.wikipedia.org/wiki/Joy_(programming_language). Cat has no variables, only instructions which manipulate a stack (e.g. `dup`, `pop`, `swap`), and a special expression form called a quotation (e.g. `[1 add]`) which pushes an expression onto the stack which can be executed at a later time (e.g. using `apply` or `dip`). 

For example: `6 7 dup mul sub` results in a stack with the value 43 on top. 

# The Primitive Instructions of Cat

The following is a core set of general purpose primitive (built-in) instructions of Cat and their types.

```
apply   : (('S -> 'R) 'S -> 'R)
quote   : ('a 'S -> ('R -> 'a 'R) 'S)
compose : (('B -> 'C) ('A -> 'B) 'S -> ('A -> 'C) 'S)
dup     : ('a 'S -> 'a 'a 'S)
pop     : ('a 'S -> 'S)
swap    : ('a 'b 'S -> 'b 'a 'S)
cond    : (Bool 'a 'a 'S -> 'a 'S)
while   : (('S -> Bool 'R) ('R -> 'S) 'S -> 'S)```
```

# The Syntax of Types

The Cat types express a function transformation between stacks. The terms to the left and right of the arrow represent the type configuration of the stack before and after the application of the function respectively. The last type term before the arrow, and the last type term after the arrow each represent the "rest" of the stack. This is an example of "row" polymorphism.  

Each identifer represents an individual type on the stack, except for the last identifier before th

Identifiers preceded by an apostrophe are type variables which can map any type, including polymorphic functions. 

## Standard Library 

The following are some of the standard library of Cat:

```
dip      = { swap quote compose apply}
rcompose = { swap compose}
papply   = { quote rcompose}
dipd     = { swap [dip] dip}
popd     = { [pop] dip}
popop    = { pop pop}
dupd     = { [dup] dip}
swapd    = { [swap] dip}
rollup   = { swap swapd}
rolldown = { swapd swap}
```

The types inferred are as follows: 

```
dip	     : (('t0 -> 't1) 't2 't0 -> 't2 't1) 
rcompose : (('t0 -> 't1) ('t1 -> 't2) 't3 -> ('t0 -> 't2) 't3) 
papply   : ('t0 ('t0 't1 -> 't2) 't3 -> ('t1 -> 't2) 't3) 
dipd     : (('t0 -> 't1) 't2 't3 't0 -> 't2 't3 't1) 
popd     : ('t0 't1 't2 -> 't0 't2) 
popop    : ('t0 't1 't2 -> 't2) 
dupd     : ('t0 't1 't2 -> 't0 't1 't1 't2) 
swapd    : ('t0 't1 't2 't3 -> 't0 't2 't1 't3) 
rollup   : ('t0 't1 't2 't3 -> 't1 't2 't0 't3) 
rolldown : ('t0 't1 't2 't3 -> 't2 't0 't1 't3) 
```

## Formalized Types of Cat

A more formal expression of the types of the Cat primitive instructions are:

```
apply   : !R.(!S.((S -> R) S) -> R)
quote   : !S!a.((a S) -> (!R.(R -> (a R)) S))
compose : !A!C!S.(!B.((B -> C) ((A -> B) S)) -> ((A -> C) S))
dup     : !S!a.((a S) -> (a (a S)))
pop     : !S.(!a.(a S) -> S)
swap    : !S!a!b.((a (b S)) -> (b (a S)))
cond    : !S!a.((Bool (a (a S))) -> (a S))
while   : !S.(!R.((S -> (Bool R)) ((R -> S) S)) -> S)
```

Stacks are explicitly expressed here as nested pairs of types. Because variable names are normalized, there is no need to expressly write out the forall quantifiers, they are inferred to be on the innermost type array that encloses all instances of the type variable. 

# Expressions are Functions

All instructions in Cat are functions which take a stack as input, and return a new stack as output. In fact all expressions in Cat are functions, including quotations. Two instructions side by side effectively are implicitly the composition of the two stack transformation operations. 

Quotations are an example of a higher-order function: it pushes an expression (a stack transformation function) onto the stack. 

## The Type System of Cat 

Cat supports higher-rank parametric polymorphism without recursive types and is fully inferred without requiring any user annotation. 

Types describe the effect of a function on a stack. Every function requires a well-typed stack and generates a well-typed stack of a particular configuration. The types of the valu

The [type inference module](https://github.com/cdiggins/type-inference) was developed as a separate standalone package so that it can be reused in other language projects targetting JavaScript or TypeScript, or could be easily translated into other languages. 

## History: from V1 to V2

This is a reimplementation of the original Cat language (v1) last released in 2008, which was written in C# and ran only on Windows. The version of Cat is written in TypeScript and translated to ES5 compliant JavaScript. The Cat language v2 has been simplified and the type system has been more rigorously formalized. 

I've developed the [type inference module](https://github.com/cdiggins/type-inference) and the [parsing module](https://github.com/cdiggins/myna-parser) as separate standalone packages so that they can be reused in other language projects in JavaScript or TypeScript.

## Appendix: Cat Grammar

The Cat syntactic parser is written using the Myna TypeScript/JavaScript library, and has the following grammar:

```
    export var catGrammar = new function() 
    {
        var _this = this;
        this.identifier     = m.identifier.ast;
        this.integer        = m.integer.ast;
        this.true           = m.keyword("true").ast;
        this.false          = m.keyword("false").ast;
        this.typeExprRec    = m.delay(() => { return _this.typeExpr});
        this.typeArray      = m.guardedSeq('[', m.ws, this.typeExprRec.ws.zeroOrMore, ']').ast;
        this.funcInput      = this.typeExprRec.ws.zeroOrMore.ast;
        this.funcOutput     = this.typeExprRec.ws.zeroOrMore.ast;
        this.typeFunc       = m.guardedSeq('(', m.ws, this.funcInput, '->', m.ws, this.funcOutput, ')').ast;
        this.typeVar        = m.guardedSeq("'", m.identifier).ast;
        this.typeConstant   = m.identifier.ast;
        this.typeExpr       = m.choice(this.typeArray, this.typeFunc, this.typeVar, this.typeConstant).ast;        
        this.recTerm        = m.delay(() => { return _this.term; });
        this.quotation      = m.guardedSeq('[', m.ws, this.recTerm.ws.zeroOrMore, ']').ast;
        this.term           = m.choice(this.quotation, this.integer, this.true, this.false, this.identifier); 
        this.terms          = m.ws.then(this.term.ws.zeroOrMore);
        this.definedName    = m.identifier.ast;
        this.typeSig        = m.guardedSeq(":", m.ws, this.typeExpr).ast;
        this.extern         = m.guardedSeq(m.keyword('extern').ws, this.definedName, m.ws, this.typeSig).ast;
        this.definition     = m.guardedSeq('{', this.term.zeroOrMore, '}').ast;
        this.define         = m.guardedSeq(m.keyword('define').ws, this.definedName, m.ws, this.typeSig.opt, this.definition).ast;
        this.program        = m.choice(this.define, this.extern, this.term).zeroOrMore.ast;
    }    
```
