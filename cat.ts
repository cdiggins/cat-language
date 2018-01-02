// The Cat Programming language v2.0
// A type-inferred pure functional stack language inspired by the Joy Programming Language
// Copyright 2017 by Christopher Diggins 
// Licensed under the MIT License

// Myna is a parsing library: https://github.com/cdiggins/myna-parser 
import { Myna as m } from "./node_modules/myna-parser/myna";

// A type-inference library: https://github.com/cdiggins/type-inference
import { TypeInference as ti } from "./node_modules/type-inference/type_inference";

export module CatLanguage
{
    // Defines a Myna grammar for parsing Cat programs and types
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

    // Register the Cat grammar 
    m.registerGrammar('cat', catGrammar, catGrammar.program);

    // Outputs the AST tree generated from the Cat grammar
    export function astSchemaString() : string {
        return m.astSchemaToString('cat');
    }

    // Outputs the Cat grammar as a string 
    export function grammarString() : string {
        return m.grammarToString('cat');
    }

    //====================================================================
    // Helper Functions

    // Converts a cons list into a flat list of types like Cat prefers
    function consListToString(t:ti.Type) : string {
        if (t instanceof ti.TypeArray)
            return _typeToString(t.types[0]) + " " + consListToString(t.types[1]);
        else 
            return _typeToString(t);
    }

    // Converts a string into a type expression
    function _typeToString(t:ti.Type) : string {        
        if (ti.isFunctionType(t)) {
            return "(" 
                + consListToString(ti.functionInput(t)) + " -> " 
                + consListToString(ti.functionOutput(t)) + ")";
        }
        else if (t instanceof ti.TypeVariable) {        
            return "'" + t.toString();
        }
        else {
            return t.toString();
        }
    }

    export function typeToString(t:ti.Type) : string {
        return _typeToString(ti.normalizeVarNames(t));
    }
        
    // Converts a string into a type expression
    export function stringToType(input:string) : ti.Type {
        var ast = m.parse(m.grammars['cat'].typeExpr, input);
        return astToType(ast);
    }

    // Converts a series of cat terms into an AST
    export function stringToCatAst(input:string) : m.AstNode {
        return m.parse(m.grammars['cat'].terms, input);
    }

    // Converts the AST children to a cons list
    export function astToConsList(astNodes:m.AstNode[]) : ti.Type {
        if (astNodes.length == 0)
            throw new Error("Expected at least one AST node");
        var tmp = astToType(astNodes[0]);
        if (astNodes.length == 1)
        {
            if (!(tmp instanceof ti.TypeVariable))
                throw new Error("The last type of a function input or output must be a type variable");
            return tmp;
        }
        else {
            return ti.typeArray([tmp,astToConsList(astNodes.slice(1))]);
        }
    }
        
    // Converts an AST generated from a parse int o type expression
    export function astToType(ast:m.AstNode) : ti.Type {
        if (!ast)
            throw new Error("Missing AST node");

        switch (ast.name)
        {
            case "typeVar":
                return ti.typeVariable(ast.allText.substr(1));
            case "typeConstant":
                return ti.typeConstant(ast.allText);
            case "typeFunc":
                return ti.functionType(
                    astToType(ast.children[0]), 
                    astToType(ast.children[1]));
            case "funcInput":
            case "funcOutput":
                return astToConsList(ast.children);
            case "typeArray":
                return ti.typeArray(ast.children.map(astToType));
            case "typeExpr":
                return astToType(ast.children[0]);
            default: 
                throw new Error("Unrecognized type expression: " + ast.name);
        }
    }

    // Converts an AST into a Cat instruction
    export function astToInstruction(ast:m.AstNode, env:CatEnvironment) : CatInstruction {
        if (!ast)
            throw new Error("Missing AST node");

        switch (ast.name)
        {
            case "identifier":
                return env.getInstruction(ast.allText);
            case "integer":
                return new CatConstant(parseInt(ast.allText));
            case "true":
                return new CatConstant(true);
            case "false":
                return new CatConstant(false);
            case "quotation":
                return new CatAbstraction(ast.children.map((c) => astToInstruction(c, env)))
            default: 
                throw new Error("Unrecognized term: " + ast.name);
        }
    }

    // Converts a string into a Cat instruction 
    export function stringToInstruction(name:string, code:string, env:CatEnvironment) : CatInstruction {
        var ast = m.parse(m.grammars['cat'].terms, code);
        return new CatDefinition(name, ast.children.map((c) => astToInstruction(c, env)));
    }

    // Returns the type of data
    export function dataType(data:CatValue) : ti.Type {    
        if (typeof(data) == 'number')
            return new ti.TypeConstant('Num');
        if (typeof(data) == 'boolean')
            return new ti.TypeConstant('Bool');
        if (typeof(data) == 'string')        
            return new ti.TypeConstant('Str');
        if (data instanceof CatInstruction)
            return data.type;
        throw new Error("Could not figure out the type of the data: " + data);    
    }

    // Returns true if the type can be a valid input/output of a Cat function type.
    export function isValidFunctionPart(t:ti.Type) : boolean {
        if (t instanceof ti.TypeArray) {
            if (t.types.length != 2)
                return false;                
            return isValidFunctionPart(t.types[1]);
        }
        else {
            return t instanceof ti.TypeVariable;
        }
    }
    
    // Returns true if the function is truly a valid Cat function type
    export function isCatFunctionType(t:ti.Type) : boolean {
        if (!ti.isFunctionType(t))
            return false;
        var input = ti.functionInput(t);
        if (!isValidFunctionPart(input)) 
            return false;
        var output = ti.functionOutput(t);
        if (!isValidFunctionPart(output))
            return false;
        return true;
    }
        
    // Given the type of the current stack, and a function type, returns the type of the resulting stack.
    export function evalType(stack : ti.TypeArray, func : ti.TypeArray) : ti.TypeArray {
        throw new Error("Not implemented yet");
    }

    // Applies a function to a stack transforming its internal state 
    export function applyFunc(stack : CatStack, func : Function) {
        func.apply(stack);
    }

    // Gets the type of a sequence of instructions 
    export function instructionSequenceType(q:CatInstruction[]) : ti.TypeArray {
        return ti.composeFunctionChain(q.map(i => i.type));
    }
    
    // Given the type of a stack, validates that the stack is in fact compatible with it or throws an error 
    export function validateType(stack : CatStack, type : ti.TypeArray) {
        throw new Error("Not implemented");
    }

    // Converts a JavaScript function to a Cat function 
    export function jsFunctionToCat(f:Function) : CatFunction {
        return (stack) => stack._function(f);            
    }

    //======================================================================
    // Classes and interfaces

    // Used for looking up instructions by name
    export interface ICatInstructionLookup {
        [name:string] : CatInstruction;
    }

    // The type of Cat functions in the implementation.
    // The implementation uses a shared mutable structure called a "CatStack".
    export type CatFunction = (CatStack) => void;

    // A Cat instruction (aka word in Forth)
    export class CatInstruction {
        constructor( 
            public name : string,
            public func : CatFunction,
            public type : ti.TypeArray) 
        { 
            if (!isCatFunctionType(type))
                throw new Error("Expected a valid Cat function type to describe an instruction");
        }

        toString() : string {
            return this.name;
        }

        toDebugString() : string {
            return this.name + "\t: " + typeToString(this.type);
        }
    }

    // A list of instructions 
    export class CatDefinition extends CatInstruction {
        constructor(
            public name:string,
            public instructions:CatInstruction[])
        { 
            super(name, 
                (stack) => instructions.forEach(i => i.func(stack)),
                instructionSequenceType(instructions)
            ); 
        }

        definitionString() : string {
            return this.instructions.map(i => i.toString()).join(" ");
        }

        toDebugString() : string {
            return this.name + "\t: " + typeToString(this.type) + " = { " + this.definitionString() + "}";
        }
    };

    // A list of instructions 
    export class CatAbstraction extends CatInstruction {
        constructor(
            public instructions:CatInstruction[])
        { 
            super("_quotation_", 
                (stack) => instructions.forEach(i => i.func(stack)),
                ti.quotation(instructionSequenceType(instructions))
            ); 
        }

        toString() : string {
            return '[' + this.instructions.map(i => i.toString()).join(" ") + ']';
        }

        toDebugString() : string {
            return this.name + "\t: " + typeToString(this.type) + "\t = { " + this.toString() + "}";
        }
    };

    // An instruction that pushes data on the stack
    export class CatConstant extends CatInstruction {
        constructor(
            public data:CatValue)
        { 
            super(data.toString(), 
                (stack) => stack.push(data),
                ti.rowPolymorphicFunction([], [dataType(data)]));        
        }

        toString() : string {
            return this.data.toString();
        }

        toDebugString() : string {
            return this.name + "\t: " + typeToString(this.type) + "\t = { " + this.toString() + "}";
        }
    };

    // The type of things on the Cat stack
    export type CatValue = number | boolean | string | CatInstruction; 

    // Wraps the shared stack used by an executing Cat program 
    export class CatStack 
    {
        stack:CatValue[] = [];

        // Pushes a value onto the stack. 
        push(x:CatValue) {
            this.stack.push(x);
        }

        // Returns the top value on the stack. 
        top() : CatValue {
            return this.stack[this.stack.length-1];
        }

        // Removes the top value from the stack 
        pop() : CatValue {
            return this.stack.pop();    
        }

        // Removes the top valued from the stack, and returns it as the specified type.
        popType<T extends CatValue>() : T {
            return this.pop() as T;
        }

        // Removes the top value from the stack, assuring it is a function 
        popFunc() : CatFunction {
            var i = this.popType<CatInstruction>();
            if (!i) throw new Error("Expected Cat instruction on the top of the stack");
            return i.func;
        }

        // Swaps the top two values of the stack 
        swap() {
            var x = this.pop();
            var y = this.pop();
            this.push(x);
            this.push(y);
        }

        // Duplicates the top value on the stack 
        dup() {
            this.push(this.top());
        }

        // Pops a function from the stack and applies it to the stack.
        apply() {
            this.popFunc()(this);
        }

        // Pops a boolean and two values from the stack, pushing either the top value back on the stack if the boolean is true,
        // or the other value otherwise. 
        cond() {
            var b = this.pop();
            var onTrue = this.pop();
            var onFalse = this.pop();
            this.push(b ? onTrue : onFalse);
        }

        // Executes a conditional function and then a body function repeatedly while the result of the conditional 
        // function is true. 
        while() {
            var cond = this.popFunc();
            var body = this.popFunc();
            cond(this);
            while (this.pop()) {
                body(this);
                cond(this);
            }
        }

        // Creates a function that returns a value
        quote() {
            this.push(new CatConstant(this.pop()));
        }

        // Creates a new quotation by combining two existing quotations 
        compose() {
            var a = this.popType<CatInstruction>();
            var b = this.popType<CatInstruction>();
            this.push(new CatAbstraction([b, a]));
        }

        // Calls a plain JavaScript function using arguments from the stack
        // and pushes the result back onto the stack. 
        _function(f:Function) { 
            var args = [];
            for (var i=0; i < f.length; ++i) 
                args.push(this.pop());
            this.push(f.apply(null, args));        
        }
    }

    // A cat environment holds the dictionary of instructions and their types. 
    export class CatEnvironment
    {
        // The list of defined instruction. 
        instructions : ICatInstructionLookup = {};

        // These are operations directly available on the "stack" object.   
        // They are retrieved by the name. 
        primOps = {
            apply   : "(('S -> 'R) 'S -> 'R)",
            quote   : "('a 'S -> ('R -> 'a 'R) 'S)",
            compose : "(('B -> 'C) ('A -> 'B) 'S -> ('A -> 'C) 'S)",
            dup     : "('a 'S -> 'a 'a 'S)",
            pop     : "('a 'S -> 'S)",
            swap    : "('a 'b 'S -> 'b 'a 'S)",
            cond    : "(Bool 'a 'a 'S -> 'a 'S)",
            while   : "(('S -> Bool 'R) ('R -> 'S) 'S -> 'S)",
        };

        // These are additional primitives defined as lambdas        
        primFuncs = {
            eq      : [(x,y) => x == y, "('a 'a 'S -> Bool 'S)"],
            neq     : [(x,y) => x != y, "('a 'a 'S -> Bool 'S)"],
            add     : [(x,y) => x + y,  "(Num Num 'S -> Num 'S)"],
            neg     : [(x) => -x,       "(Num 'S -> Num 'S)"],
            sub     : [(x,y) => x - y,  "(Num Num 'S -> Num 'S)"],
            mul     : [(x,y) => x * y,  "(Num Num 'S -> Num 'S)"],
            div     : [(x,y) => x / y,  "(Num Num 'S -> Num 'S)"],
            mod     : [(x,y) => x % y,  "(Num Num 'S -> Num 'S)"],
            not     : [(x) => !x,       "(Bool 'S -> Bool 'S)"],
            gt      : [(x,y) => x > y,  "(Num Num 'S -> Bool 'S)"],
            gteq    : [(x,y) => x >= y, "(Num Num 'S -> Bool 'S)"],
            lt      : [(x,y) => x < y,  "(Num Num 'S -> Bool 'S)"],
            lteq    : [(x,y) => x <= y, "(Num Num 'S -> Bool 'S)"],       
            and     : [(x,y) => x && y, "(Bool Bool 'S -> Bool 'S)"],       
            or      : [(x,y) => x || y, "(Bool Bool 'S -> Bool 'S)"],       
            xor     : [(x,y) => x ^ y,  "(Bool Bool 'S -> Bool 'S)"],
            succ    : [(x) => x + 1,    "(Num 'S -> Num 'S)"],
            pred    : [(x) => x - 1,    "(Num 'S -> Num 'S)"],
        }

        // Standard operations, their definitions and expected types. 
        // The type is not required: it is used for validation purposes
        // http://www.kevinalbrecht.com/code/joy-mirror/j03atm.html
        stdOps = {
            "dip"       : ["swap quote compose apply", "(('S -> 'R) 'a 'S -> 'a 'R)"],
            "rcompose"  : ["swap compose", "(('A -> 'B) ('B -> 'C) 'S -> ('A -> 'C) 'S)"],
            "papply"    : ["quote rcompose", "('a ('a 'S -> 'R) 'T -> ('S -> 'R) 'T)"],
            "dipd"      : ["swap [dip] dip", "(('S -> 'R) 'a 'b 'S -> 'a 'b 'R)"],
            "popd"      : ["[pop] dip", "('a 'b 'S -> 'a 'S)"],
            "popop"     : ["pop pop", "('a 'b 'S -> 'S)"],
            "dupd"      : ["[dup] dip", "('a 'b 'S -> 'a 'b 'b 'S)"],                
            "swapd"     : ["[swap] dip", "('a 'b 'c 'S -> 'a 'c 'b 'S)"],                
            "rollup"    : ["swap swapd", "('a 'b 'c 'S -> 'b 'c 'a 'S)"],                
            "rolldown"  : ["swapd swap", "('a 'b 'c 'S -> 'c 'a 'b 'S)"],    
            "if"        : ["cond apply", "(Bool ('A -> 'B) ('A -> 'B) 'A -> 'B)"]            
        }
        
        // Helper function to get the function associated with an instruction
        getInstruction(s:string) : CatInstruction {
            if (!(s in this.instructions))
                throw new Error("Could not find instruction: " + s);
            return this.instructions[s];
        }

        // Helper function to get the type associated with an instruction
        getType(s:string) : ti.TypeArray {
            if (!(s in this.instructions))
                throw new Error("Could not find instruction: " + s);
            return this.instructions[s].type;
        }

        // Gets the list of all defined Cat instructions 
        getInstructions() : CatInstruction[] {
            var r = new Array<CatInstruction>();
            for (var k in this.instructions)
                r.push(this.instructions[k]);
            return r;
        }

        // Returns the type of a quotation given the nodes in the quotation
        getQuotationType(astNodes : m.AstNode[]) : ti.TypeArray {
            var types = astNodes.map(ast => astToType(ast) as ti.TypeArray);
            return ti.composeFunctionChain(types);
        }

        getTypeFromAst(ast : m.AstNode) : ti.Type {
            if (!ast) throw new Error("Not a valid AST");        
            switch (ast.name) 
            {
                case "identifier":
                    return this.getType(ast.allText);
                case "integer":
                    return new ti.TypeConstant("Num");
                case "true":
                case "false":
                    return new ti.TypeConstant("Bool");
                case "quotation":
                    return this.getQuotationType(ast.children);
                default:
                    throw new Error("AST node has no known type: " + ast.name);
            }
        }

        // Creates a new instruction and returns it 
        addInstruction(name:string, func:CatFunction, type:string) : CatInstruction {
            return this.instructions[name] = new CatInstruction(name, func, stringToType(type) as ti.TypeArray);
        }

        // Creates a new instruction from a definition
        addDefinition(name:string, code:string, type:string = null) : CatInstruction {
            var i = stringToInstruction(name, code, this);
            var inferredType = i.type;
            if (type)
            {
                var expectedType = stringToType(type);
                if (!ti.areTypesSame(inferredType, expectedType)) {
                    var a = ti.normalizeVarNames(inferredType).toString();
                    var b = ti.normalizeVarNames(expectedType).toString();                    
                    throw new Error("Inferred type: " + a + " does not match expected type: " + b);
                }
            }
            return this.instructions[name] = i;
        }

        // Constructor 
        constructor() 
        {        
            // Register the primitive operations (stack built-in functions)
            for (let k in this.primOps) 
                this.addInstruction(k, (stack) => stack[k](), this.primOps[k]);

            // Register core functions expressed as JavaScript functions 
            for (let k in this.primFuncs) 
                this.addInstruction(k, jsFunctionToCat(this.primFuncs[k][0]), this.primFuncs[k][1]);

            // Register core functions expressed as JavaScript functions 
            for (let k in this.stdOps) 
                this.addDefinition(k, this.stdOps[k][0], this.stdOps[k][1]);
        }
    }

    // The evaluator holds a Cat environment containing the dictionary of defined Cat words 
    // It also caches an evaluator function. It contains helper evaluation functions. 
    // The evaluator also maintains the current type of the Cat stack, and predicts it based 
    // on the terms it is about to evaluate.
    export class CatEvaluator 
    {
        env : CatEnvironment = new CatEnvironment();
        stk : CatStack = new CatStack();
        type : ti.Type = ti.typeArray([]);
        trace : boolean = true;
        
        print() {
            console.log("stack = " + this.stk.stack + " : " + typeToString(this.type));
        }

        eval(s : string) {
            this.evalTerm(stringToCatAst(s));
        }    

        evalTerms(ast : m.AstNode) {
            ast.children.forEach(c => this.evalTerm(c));
        }
            
        evalInstruction(instruction : CatInstruction) {
            if (this.trace) 
                console.log("evaluating " + instruction.toDebugString());

            // Apply the function type to the stack type
            this.type = ti.applyFunction(instruction.type, this.type);
            
            // Apply the function to the stack 
            instruction.func(this.stk); 
            
            if (this.trace)
                this.print();                      
        }

        evalTerm(ast : m.AstNode) {
            if (!ast) throw new Error("Not a valid AST");
            switch (ast.name) 
            {
                case "terms":
                    return this.evalTerms(ast);                
                default:
                    return this.evalInstruction(astToInstruction(ast, this.env));
            }
        }
    }
}
