"use strict";
// The Cat Programming language v2.0
// A type-inferred pure functional stack language inspired by the Joy Programming Language
// Copyright 2017 by Christopher Diggins 
// Licensed under the MIT License
var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
// Myna is a parsing library: https://github.com/cdiggins/myna-parser 
var myna_1 = require("./node_modules/myna-parser/myna");
// A type-inference library: https://github.com/cdiggins/type-inference
var type_inference_1 = require("./node_modules/type-inference/type_inference");
// This is a full rewrite of the Cat language (which was originally in C#) written in TypeScript 
var CatLanguage;
(function (CatLanguage) {
    // Defines a Myna grammar for parsing Cat programs and types
    CatLanguage.catGrammar = new function () {
        var _this = this;
        this.identifier = myna_1.Myna.identifier.ast;
        this.integer = myna_1.Myna.integer.ast;
        this.true = myna_1.Myna.keyword("true").ast;
        this.false = myna_1.Myna.keyword("false").ast;
        this.typeExprRec = myna_1.Myna.delay(function () { return _this.typeExpr; });
        this.typeArray = myna_1.Myna.guardedSeq('[', myna_1.Myna.ws, this.typeExprRec.ws.zeroOrMore, ']').ast;
        this.funcInput = this.typeExprRec.ws.zeroOrMore.ast;
        this.funcOutput = this.typeExprRec.ws.zeroOrMore.ast;
        this.typeFunc = myna_1.Myna.guardedSeq('(', myna_1.Myna.ws, this.funcInput, '->', myna_1.Myna.ws, this.funcOutput, ')').ast;
        this.typeVar = myna_1.Myna.guardedSeq("'", myna_1.Myna.identifier).ast;
        this.typeConstant = myna_1.Myna.identifier.ast;
        this.typeExpr = myna_1.Myna.choice(this.typeArray, this.typeFunc, this.typeVar, this.typeConstant).ast;
        this.recTerm = myna_1.Myna.delay(function () { return _this.term; });
        this.quotation = myna_1.Myna.guardedSeq('[', myna_1.Myna.ws, this.recTerm.ws.zeroOrMore, ']').ast;
        this.term = myna_1.Myna.choice(this.quotation, this.integer, this.true, this.false, this.identifier);
        this.terms = myna_1.Myna.ws.then(this.term.ws.zeroOrMore);
        this.definedName = myna_1.Myna.identifier.ast;
        this.typeSig = myna_1.Myna.guardedSeq(":", myna_1.Myna.ws, this.typeExpr).ast;
        this.extern = myna_1.Myna.guardedSeq(myna_1.Myna.keyword('extern').ws, this.definedName, myna_1.Myna.ws, this.typeSig).ast;
        this.definition = myna_1.Myna.guardedSeq('{', this.term.zeroOrMore, '}').ast;
        this.define = myna_1.Myna.guardedSeq(myna_1.Myna.keyword('define').ws, this.definedName, myna_1.Myna.ws, this.typeSig.opt, this.definition).ast;
        this.program = myna_1.Myna.choice(this.define, this.extern, this.term).zeroOrMore.ast;
    };
    // Register the Cat grammar 
    myna_1.Myna.registerGrammar('cat', CatLanguage.catGrammar, CatLanguage.catGrammar.program);
    // Outputs the AST tree generated from the Cat grammar
    function astSchemaString() {
        return myna_1.Myna.astSchemaToString('cat');
    }
    CatLanguage.astSchemaString = astSchemaString;
    // Outputs the Cat grammar as a string 
    function grammarString() {
        return myna_1.Myna.grammarToString('cat');
    }
    CatLanguage.grammarString = grammarString;
    //====================================================================
    // Helper Functions
    // Converts a cons list into a flat list of types like Cat prefers
    function consListToString(t) {
        if (t instanceof type_inference_1.TypeInference.TypeArray)
            return _typeToString(t.types[0]) + " " + consListToString(t.types[1]);
        else
            return _typeToString(t);
    }
    // Converts a string into a type expression
    function _typeToString(t) {
        if (type_inference_1.TypeInference.isFunctionType(t)) {
            return "("
                + consListToString(type_inference_1.TypeInference.functionInput(t)) + " -> "
                + consListToString(type_inference_1.TypeInference.functionOutput(t)) + ")";
        }
        else if (t instanceof type_inference_1.TypeInference.TypeVariable) {
            return "'" + t.toString();
        }
        else {
            return t.toString();
        }
    }
    function typeToString(t) {
        return _typeToString(type_inference_1.TypeInference.normalizeVarNames(t));
    }
    CatLanguage.typeToString = typeToString;
    // Converts a string into a type expression
    function stringToType(input) {
        var ast = myna_1.Myna.parse(myna_1.Myna.grammars['cat'].typeExpr, input);
        return astToType(ast);
    }
    CatLanguage.stringToType = stringToType;
    // Converts a series of cat terms into an AST
    function stringToCatAst(input) {
        return myna_1.Myna.parse(myna_1.Myna.grammars['cat'].terms, input);
    }
    CatLanguage.stringToCatAst = stringToCatAst;
    // Converts the AST children to a cons list
    function astToConsList(astNodes) {
        if (astNodes.length == 0)
            throw new Error("Expected at least one AST node");
        var tmp = astToType(astNodes[0]);
        if (astNodes.length == 1) {
            if (!(tmp instanceof type_inference_1.TypeInference.TypeVariable))
                throw new Error("The last type of a function input or output must be a type variable");
            return tmp;
        }
        else {
            return type_inference_1.TypeInference.typeArray([tmp, astToConsList(astNodes.slice(1))]);
        }
    }
    CatLanguage.astToConsList = astToConsList;
    // Converts an AST generated from a parse int o type expression
    function astToType(ast) {
        if (!ast)
            throw new Error("Missing AST node");
        switch (ast.name) {
            case "typeVar":
                return type_inference_1.TypeInference.typeVariable(ast.allText.substr(1));
            case "typeConstant":
                return type_inference_1.TypeInference.typeConstant(ast.allText);
            case "typeFunc":
                return type_inference_1.TypeInference.functionType(astToType(ast.children[0]), astToType(ast.children[1]));
            case "funcInput":
            case "funcOutput":
                return astToConsList(ast.children);
            case "typeArray":
                return type_inference_1.TypeInference.typeArray(ast.children.map(astToType));
            case "typeExpr":
                return astToType(ast.children[0]);
            default:
                throw new Error("Unrecognized type expression: " + ast.name);
        }
    }
    CatLanguage.astToType = astToType;
    // Converts an AST into a Cat instruction
    function astToInstruction(ast, env) {
        if (!ast)
            throw new Error("Missing AST node");
        switch (ast.name) {
            case "identifier":
                return env.getInstruction(ast.allText);
            case "integer":
                return new CatConstant(parseInt(ast.allText));
            case "true":
                return new CatConstant(true);
            case "false":
                return new CatConstant(false);
            case "quotation":
                return new CatAbstraction(ast.children.map(function (c) { return astToInstruction(c, env); }));
            default:
                throw new Error("Unrecognized term: " + ast.name);
        }
    }
    CatLanguage.astToInstruction = astToInstruction;
    // Converts a string into a Cat instruction 
    function stringToInstruction(name, code, env) {
        var ast = myna_1.Myna.parse(myna_1.Myna.grammars['cat'].terms, code);
        return new CatDefinition(name, ast.children.map(function (c) { return astToInstruction(c, env); }));
    }
    CatLanguage.stringToInstruction = stringToInstruction;
    // Returns the type of data
    function dataType(data) {
        if (typeof (data) == 'number')
            return new type_inference_1.TypeInference.TypeConstant('Num');
        if (typeof (data) == 'boolean')
            return new type_inference_1.TypeInference.TypeConstant('Bool');
        if (typeof (data) == 'string')
            return new type_inference_1.TypeInference.TypeConstant('Str');
        if (data instanceof CatInstruction)
            return data.type;
        throw new Error("Could not figure out the type of the data: " + data);
    }
    CatLanguage.dataType = dataType;
    // Returns true if the type can be a valid input/output of a Cat function type.
    function isValidFunctionPart(t) {
        if (t instanceof type_inference_1.TypeInference.TypeArray) {
            if (t.types.length != 2)
                return false;
            return isValidFunctionPart(t.types[1]);
        }
        else {
            return t instanceof type_inference_1.TypeInference.TypeVariable;
        }
    }
    CatLanguage.isValidFunctionPart = isValidFunctionPart;
    // Returns true if the function is truly a valid Cat function type
    function isCatFunctionType(t) {
        if (!type_inference_1.TypeInference.isFunctionType(t))
            return false;
        var input = type_inference_1.TypeInference.functionInput(t);
        if (!isValidFunctionPart(input))
            return false;
        var output = type_inference_1.TypeInference.functionOutput(t);
        if (!isValidFunctionPart(output))
            return false;
        return true;
    }
    CatLanguage.isCatFunctionType = isCatFunctionType;
    // Given the type of the current stack, and a function type, returns the type of the resulting stack.
    function evalType(stack, func) {
        throw new Error("Not implemented yet");
    }
    CatLanguage.evalType = evalType;
    // Applies a function to a stack transforming its internal state 
    function applyFunc(stack, func) {
        func.apply(stack);
    }
    CatLanguage.applyFunc = applyFunc;
    // Gets the type of a sequence of instructions 
    function instructionSequenceType(q) {
        return type_inference_1.TypeInference.composeFunctionChain(q.map(function (i) { return i.type; }));
    }
    CatLanguage.instructionSequenceType = instructionSequenceType;
    // Given the type of a stack, validates that the stack is in fact compatible with it or throws an error 
    function validateType(stack, type) {
        throw new Error("Not implemented");
    }
    CatLanguage.validateType = validateType;
    // Converts a JavaScript function to a Cat function 
    function jsFunctionToCat(f) {
        return function (stack) { return stack._function(f); };
    }
    CatLanguage.jsFunctionToCat = jsFunctionToCat;
    // A Cat instruction (aka word in Forth)
    var CatInstruction = /** @class */ (function () {
        function CatInstruction(name, func, type) {
            this.name = name;
            this.func = func;
            this.type = type;
            if (!isCatFunctionType(type))
                throw new Error("Expected a valid Cat function type to describe an instruction");
        }
        CatInstruction.prototype.toString = function () {
            return this.name;
        };
        CatInstruction.prototype.toDebugString = function () {
            return this.name + "\t: " + typeToString(this.type);
        };
        return CatInstruction;
    }());
    CatLanguage.CatInstruction = CatInstruction;
    // A list of instructions 
    var CatDefinition = /** @class */ (function (_super) {
        __extends(CatDefinition, _super);
        function CatDefinition(name, instructions) {
            var _this = _super.call(this, name, function (stack) { return instructions.forEach(function (i) { return i.func(stack); }); }, instructionSequenceType(instructions)) || this;
            _this.name = name;
            _this.instructions = instructions;
            return _this;
        }
        CatDefinition.prototype.definitionString = function () {
            return this.instructions.map(function (i) { return i.toString(); }).join(" ");
        };
        CatDefinition.prototype.toDebugString = function () {
            return this.name + "\t: " + typeToString(this.type) + " = { " + this.definitionString() + "}";
        };
        return CatDefinition;
    }(CatInstruction));
    CatLanguage.CatDefinition = CatDefinition;
    ;
    // A list of instructions 
    var CatAbstraction = /** @class */ (function (_super) {
        __extends(CatAbstraction, _super);
        function CatAbstraction(instructions) {
            var _this = _super.call(this, "_quotation_", function (stack) { return instructions.forEach(function (i) { return i.func(stack); }); }, type_inference_1.TypeInference.quotation(instructionSequenceType(instructions))) || this;
            _this.instructions = instructions;
            return _this;
        }
        CatAbstraction.prototype.toString = function () {
            return '[' + this.instructions.map(function (i) { return i.toString(); }).join(" ") + ']';
        };
        CatAbstraction.prototype.toDebugString = function () {
            return this.name + "\t: " + typeToString(this.type) + "\t = { " + this.toString() + "}";
        };
        return CatAbstraction;
    }(CatInstruction));
    CatLanguage.CatAbstraction = CatAbstraction;
    ;
    // An instruction that pushes data on the stack
    var CatConstant = /** @class */ (function (_super) {
        __extends(CatConstant, _super);
        function CatConstant(data) {
            var _this = _super.call(this, data.toString(), function (stack) { return stack.push(data); }, type_inference_1.TypeInference.rowPolymorphicFunction([], [dataType(data)])) || this;
            _this.data = data;
            return _this;
        }
        CatConstant.prototype.toString = function () {
            return this.data.toString();
        };
        CatConstant.prototype.toDebugString = function () {
            return this.name + "\t: " + typeToString(this.type) + "\t = { " + this.toString() + "}";
        };
        return CatConstant;
    }(CatInstruction));
    CatLanguage.CatConstant = CatConstant;
    ;
    // Wraps the shared stack used by an executing Cat program 
    var CatStack = /** @class */ (function () {
        function CatStack() {
            this.stack = [];
        }
        // Pushes a value onto the stack. 
        CatStack.prototype.push = function (x) {
            this.stack.push(x);
        };
        // Returns the top value on the stack. 
        CatStack.prototype.top = function () {
            return this.stack[this.stack.length - 1];
        };
        // Removes the top value from the stack 
        CatStack.prototype.pop = function () {
            return this.stack.pop();
        };
        // Removes the top valued from the stack, and returns it as the specified type.
        CatStack.prototype.popType = function () {
            return this.pop();
        };
        // Removes the top value from the stack, assuring it is a function 
        CatStack.prototype.popFunc = function () {
            var i = this.popType();
            if (!i)
                throw new Error("Expected Cat instruction on the top of the stack");
            return i.func;
        };
        // Swaps the top two values of the stack 
        CatStack.prototype.swap = function () {
            var x = this.pop();
            var y = this.pop();
            this.push(x);
            this.push(y);
        };
        // Duplicates the top value on the stack 
        CatStack.prototype.dup = function () {
            this.push(this.top());
        };
        // Pops a function from the stack and applies it to the stack.
        CatStack.prototype.apply = function () {
            this.popFunc()(this);
        };
        // Pops a boolean and two values from the stack, pushing either the top value back on the stack if the boolean is true,
        // or the other value otherwise. 
        CatStack.prototype.cond = function () {
            var b = this.pop();
            var onTrue = this.pop();
            var onFalse = this.pop();
            this.push(b ? onTrue : onFalse);
        };
        // Executes a conditional function and then a body function repeatedly while the result of the conditional 
        // function is true. 
        CatStack.prototype.while = function () {
            var cond = this.popFunc();
            var body = this.popFunc();
            cond(this);
            while (this.pop()) {
                body(this);
                cond(this);
            }
        };
        // Creates a function that returns a value
        CatStack.prototype.quote = function () {
            this.push(new CatConstant(this.pop()));
        };
        // Creates a new quotation by combining two existing quotations 
        CatStack.prototype.compose = function () {
            var a = this.popType();
            var b = this.popType();
            this.push(new CatAbstraction([b, a]));
        };
        // Calls a plain JavaScript function using arguments from the stack
        // and pushes the result back onto the stack. 
        CatStack.prototype._function = function (f) {
            var args = [];
            for (var i = 0; i < f.length; ++i)
                args.push(this.pop());
            this.push(f.apply(null, args));
        };
        return CatStack;
    }());
    CatLanguage.CatStack = CatStack;
    // A cat environment holds the dictionary of instructions and their types. 
    var CatEnvironment = /** @class */ (function () {
        // Constructor 
        function CatEnvironment() {
            // The list of defined instruction. 
            this.instructions = {};
            // These are operations directly available on the "stack" object.   
            // They are retrieved by the name. 
            this.primOps = {
                apply: "(('S -> 'R) 'S -> 'R)",
                quote: "('a 'S -> ('R -> 'a 'R) 'S)",
                compose: "(('B -> 'C) ('A -> 'B) 'S -> ('A -> 'C) 'S)",
                dup: "('a 'S -> 'a 'a 'S)",
                pop: "('a 'S -> 'S)",
                swap: "('a 'b 'S -> 'b 'a 'S)",
                cond: "(Bool 'a 'a 'S -> 'a 'S)",
                while: "(('S -> Bool 'R) ('R -> 'S) 'S -> 'S)",
            };
            // These are additional primitives defined as lambdas        
            this.primFuncs = {
                eq: [function (x, y) { return x == y; }, "('a 'a 'S -> Bool 'S)"],
                neq: [function (x, y) { return x != y; }, "('a 'a 'S -> Bool 'S)"],
                add: [function (x, y) { return x + y; }, "(Num Num 'S -> Num 'S)"],
                neg: [function (x) { return -x; }, "(Num 'S -> Num 'S)"],
                sub: [function (x, y) { return x - y; }, "(Num Num 'S -> Num 'S)"],
                mul: [function (x, y) { return x * y; }, "(Num Num 'S -> Num 'S)"],
                div: [function (x, y) { return x / y; }, "(Num Num 'S -> Num 'S)"],
                mod: [function (x, y) { return x % y; }, "(Num Num 'S -> Num 'S)"],
                not: [function (x) { return !x; }, "(Bool 'S -> Bool 'S)"],
                gt: [function (x, y) { return x > y; }, "(Num Num 'S -> Bool 'S)"],
                gteq: [function (x, y) { return x >= y; }, "(Num Num 'S -> Bool 'S)"],
                lt: [function (x, y) { return x < y; }, "(Num Num 'S -> Bool 'S)"],
                lteq: [function (x, y) { return x <= y; }, "(Num Num 'S -> Bool 'S)"],
                and: [function (x, y) { return x && y; }, "(Bool Bool 'S -> Bool 'S)"],
                or: [function (x, y) { return x || y; }, "(Bool Bool 'S -> Bool 'S)"],
                xor: [function (x, y) { return x ^ y; }, "(Bool Bool 'S -> Bool 'S)"],
                succ: [function (x) { return x + 1; }, "(Num 'S -> Num 'S)"],
                pred: [function (x) { return x - 1; }, "(Num 'S -> Num 'S)"],
            };
            // Standard operations, their definitions and expected types. 
            // The type is not required: it is used for validation purposes
            // http://www.kevinalbrecht.com/code/joy-mirror/j03atm.html
            this.stdOps = {
                "dip": ["swap quote compose apply", "(('S -> 'R) 'a 'S -> 'a 'R)"],
                "rcompose": ["swap compose", "(('A -> 'B) ('B -> 'C) 'S -> ('A -> 'C) 'S)"],
                "papply": ["quote rcompose", "('a ('a 'S -> 'R) 'T -> ('S -> 'R) 'T)"],
                "dipd": ["swap [dip] dip", "(('S -> 'R) 'a 'b 'S -> 'a 'b 'R)"],
                "popd": ["[pop] dip", "('a 'b 'S -> 'a 'S)"],
                "popop": ["pop pop", "('a 'b 'S -> 'S)"],
                "dupd": ["[dup] dip", "('a 'b 'S -> 'a 'b 'b 'S)"],
                "swapd": ["[swap] dip", "('a 'b 'c 'S -> 'a 'c 'b 'S)"],
                "rollup": ["swap swapd", "('a 'b 'c 'S -> 'b 'c 'a 'S)"],
                "rolldown": ["swapd swap", "('a 'b 'c 'S -> 'c 'a 'b 'S)"],
                "if": ["cond apply", "(Bool ('A -> 'B) ('A -> 'B) 'A -> 'B)"]
            };
            var _loop_1 = function (k) {
                this_1.addInstruction(k, function (stack) { return stack[k](); }, this_1.primOps[k]);
            };
            var this_1 = this;
            // Register the primitive operations (stack built-in functions)
            for (var k in this.primOps) {
                _loop_1(k);
            }
            // Register core functions expressed as JavaScript functions 
            for (var k in this.primFuncs)
                this.addInstruction(k, jsFunctionToCat(this.primFuncs[k][0]), this.primFuncs[k][1]);
            // Register core functions expressed as JavaScript functions 
            for (var k in this.stdOps)
                this.addDefinition(k, this.stdOps[k][0], this.stdOps[k][1]);
        }
        // Helper function to get the function associated with an instruction
        CatEnvironment.prototype.getInstruction = function (s) {
            if (!(s in this.instructions))
                throw new Error("Could not find instruction: " + s);
            return this.instructions[s];
        };
        // Helper function to get the type associated with an instruction
        CatEnvironment.prototype.getType = function (s) {
            if (!(s in this.instructions))
                throw new Error("Could not find instruction: " + s);
            return this.instructions[s].type;
        };
        // Gets the list of all defined Cat instructions 
        CatEnvironment.prototype.getInstructions = function () {
            var r = new Array();
            for (var k in this.instructions)
                r.push(this.instructions[k]);
            return r;
        };
        // Returns the type of a quotation given the nodes in the quotation
        CatEnvironment.prototype.getQuotationType = function (astNodes) {
            var types = astNodes.map(function (ast) { return astToType(ast); });
            return type_inference_1.TypeInference.composeFunctionChain(types);
        };
        CatEnvironment.prototype.getTypeFromAst = function (ast) {
            if (!ast)
                throw new Error("Not a valid AST");
            switch (ast.name) {
                case "identifier":
                    return this.getType(ast.allText);
                case "integer":
                    return new type_inference_1.TypeInference.TypeConstant("Num");
                case "true":
                case "false":
                    return new type_inference_1.TypeInference.TypeConstant("Bool");
                case "quotation":
                    return this.getQuotationType(ast.children);
                default:
                    throw new Error("AST node has no known type: " + ast.name);
            }
        };
        // Creates a new instruction and returns it 
        CatEnvironment.prototype.addInstruction = function (name, func, type) {
            return this.instructions[name] = new CatInstruction(name, func, stringToType(type));
        };
        // Creates a new instruction from a definition
        CatEnvironment.prototype.addDefinition = function (name, code, type) {
            if (type === void 0) { type = null; }
            var i = stringToInstruction(name, code, this);
            var inferredType = i.type;
            if (type) {
                var expectedType = stringToType(type);
                if (!type_inference_1.TypeInference.areTypesSame(inferredType, expectedType)) {
                    var a = type_inference_1.TypeInference.normalizeVarNames(inferredType).toString();
                    var b = type_inference_1.TypeInference.normalizeVarNames(expectedType).toString();
                    throw new Error("Inferred type: " + a + " does not match expected type: " + b);
                }
            }
            return this.instructions[name] = i;
        };
        return CatEnvironment;
    }());
    CatLanguage.CatEnvironment = CatEnvironment;
    // The evaluator holds a Cat environment containing the dictionary of defined Cat words 
    // It also caches an evaluator function. It contains helper evaluation functions. 
    // The evaluator also maintains the current type of the Cat stack, and predicts it based 
    // on the terms it is about to evaluate.
    var CatEvaluator = /** @class */ (function () {
        function CatEvaluator() {
            this.env = new CatEnvironment();
            this.stk = new CatStack();
            this.type = type_inference_1.TypeInference.typeArray([]);
            this.trace = true;
        }
        CatEvaluator.prototype.print = function () {
            console.log("stack = " + this.stk.stack + " : " + typeToString(this.type));
        };
        CatEvaluator.prototype.eval = function (s) {
            this.evalTerm(stringToCatAst(s));
        };
        CatEvaluator.prototype.evalTerms = function (ast) {
            var _this = this;
            ast.children.forEach(function (c) { return _this.evalTerm(c); });
        };
        CatEvaluator.prototype.evalInstruction = function (instruction) {
            if (this.trace)
                console.log("evaluating " + instruction.toDebugString());
            // Apply the function type to the stack type
            this.type = type_inference_1.TypeInference.applyFunction(instruction.type, this.type);
            // Apply the function to the stack 
            instruction.func(this.stk);
            if (this.trace)
                this.print();
        };
        CatEvaluator.prototype.evalTerm = function (ast) {
            if (!ast)
                throw new Error("Not a valid AST");
            switch (ast.name) {
                case "terms":
                    return this.evalTerms(ast);
                default:
                    return this.evalInstruction(astToInstruction(ast, this.env));
            }
        };
        return CatEvaluator;
    }());
    CatLanguage.CatEvaluator = CatEvaluator;
})(CatLanguage = exports.CatLanguage || (exports.CatLanguage = {}));
//# sourceMappingURL=cat.js.map