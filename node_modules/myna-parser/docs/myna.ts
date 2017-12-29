// Myna Parsing Library
// Copyright (c) 2016 Christopher Diggins
// Usage permitted under terms of MIT License

// A parsing combinator library for JavaScript/TypeScript based on the PEG formalism.
// For more information see http://www.github.com/cdiggins/myna-parser
export namespace Myna
{   
    //====================================================================================
    // Internal variables used by the Myna library

    // A lookup table of all grammars registered with the Myna module 
    export var grammars = {}

    // A lookup table of all named rules registered with the Myna module
    export var allRules = {}

    // A lookup table of parsing functions for each registered grammar  
    export var parsers = {}

    //===========================================================================
    // class ParseLocation

    // Used to indicate the location of the parser to the user in a pleasant way.
    export class ParseLocation 
    {
        lineNum:number = 0;
        colNum:number = 0;
        lineStart:number = 0;
        lineEnd:number = 0;
        lineText:string;
        pointerText:string;

        constructor(
            public input:string,
            public index:number)
        {
            var r1 = 0;
            var r2 = 1;
            for (var i=0; i < this.index; ++i) {
                if (this.input.charCodeAt(i) == 13) { 
                    this.lineStart = i;
                    r1++;
                }
                if (this.input.charCodeAt(i) == 10) {
                    this.lineStart = i;
                    r2++;
                }
            }
            for (this.lineEnd=this.index; this.lineEnd < this.input.length; ++this.lineEnd) 
            {
                if (this.input.charCodeAt(this.lineEnd) == 13 || this.input.charCodeAt(this.lineEnd) == 10)
                    break;
            }
            this.lineNum = r1 > r2 ? r1 : r2;
            this.colNum = this.index - this.lineStart;
            this.lineText = this.input.substring(this.lineStart, this.lineEnd);
            this.pointerText = Array(this.colNum).join(' ') + "^";
        }

        toString() : string {
            return "Index " + this.index 
                + ", Line " + this.lineNum 
                + ", Column " + this.colNum 
                + "\n" + this.lineText 
                + "\n" + this.pointerText;
        }
    }

    //===========================================================================
    // class ParseState

    // This stores the state of the parser and is passed to the parse and match functions.
    export class ParseState
    {
        length:number = 0;

        constructor(
            public input:string, 
            public index:number,
            public nodes:AstNode[])
        { 
            this.length = this.input.length;
        }
                
        // Returns an object that representation of the location. 
        get location() : ParseLocation {
            return new ParseLocation(this.input, this.index);
        }
    }
    
    //===============================================================
    // RuleType union of Rule, string, and boolean

    // For convenience this enables strings and boolean to be used interchangably with Rules in the combinators.
    export type RuleType = Rule | string | boolean;

    // Represents a node in the generated parse tree. These nodes are returned by the Rule.parse function. If a Rule 
    // has the "_createAstNode" field set to true (because you created the rule using the ".ast" property), then the 
    // generated node will also be added to the constructed parse tree.   
    export class AstNode
    {
        // The list of child nodes in the parse tree. 
        // This is not allocated unless used, to minimize memory consumption 
        children: AstNode[] = null;

        // Constructs a new node associated with the given rule.  
        constructor(
            public rule:Rule, 
            public input:string,
            public start:number=0, 
            public end:number=-1) 
        { }

        // Returns the name of the rule associated with this node
        get name() : string { return this.rule != null ? this.rule.name : "unnamed"; }

        // Returns the name of the rule, preceded by the grammar name, associated with this node
        get fullName() : string { return this.rule != null ? this.rule.fullName : "unnamed"; }

        // Returns the parsed text associated with this node's start and end locations  
        get allText() : string { return this.input.slice(this.start, this.end); } 

        // Returns true if this node has no children
        get isLeaf() : boolean { return this.children == null || this.children.length == 0; }

        // Returns the first child with the given name, or null if no named child is found. 
        child(name:string) : AstNode { 
            if (this.children)
                for (var c of this.children) 
                    if (c.name == name) return c; 
            return null; 
        }

        // The position of the first child, or the end position for the entire node if no children 
        get _firstChildStart() : number {
            return this.isLeaf ? this.end : this.children[0].start;
        }        

        // The end position of the last child, or the end position for the entire node if no children 
        get _lastChildEnd() : number {
            return this.isLeaf ? this.end : this.children[0].end;
        }        

        // Returns the text before the children, or if no children returns the entire text. 
        get beforeChildrenText() : string {
            return this.input.slice(this.start, this._firstChildStart);
        }

        // Returns the text after the children, or if no children returns the empty string.
        get afterChildrenText() : string {
            return this.input.slice(this._lastChildEnd, this.end);
        }

        // Returns the text from the beginning of the first child to the end of the last child.
        get allChildrenText() : string {
            return this.input.slice(this._firstChildStart, this._lastChildEnd);
        }

        // Returns the AST as a string for debug and test purposes
        toString() : string {
            let contents = this.isLeaf 
                ? this.allText 
                : this.children.map(c => c.toString()).join(" ");
            return "(" + this.rule.name + ': ' + contents + ")";
        }
    }

    //===============================================================
    // class Rule
        
    // A Rule is both a rule in the PEG grammar and a parser. The parse function takes  
    // a particular parse location (in either a string, or array of tokens) and will return 
    // the location of the end of the parse if successful or null if not successful.  
    export class Rule
    {
        // Identifies individual rule
        name:string = "";

        // Identifies the grammar that this rule belongs to 
        grammarName:string = "";

        // Identifies types of rules. Rules can have "types" that are different than the class name
        type:string = "";

        // Used to provide access to the name of the class 
        className:string = "Rule"

        // Indicates whether generated nodes should be added to the abstract syntax tree
        _createAstNode:boolean = false;

        // A parser function, computed in a rule's constructor. If successful returns either the original or a new 
        // ParseState object. If it fails it returns null.
        parser : (ParseState)=>boolean = null;

        // A lexer function, computed in a rule's constructor. The lexer may update the ParseState if successful.
        // If it fails it is required that the lexer restore the ParseState index to the previous state. 
        // Lexers should only update the index. 
        lexer : (ParseState)=>boolean = null;

        // Constructor
        // Note: child-rules are exposed as a public field
        constructor(
            public rules:Rule[]) 
        { }

        // Sets the name of the rule, and the grammar 
        // Warning: this modifies the rule, use "copy" first if you don't want to update the rule.
        setName(grammarName:string, ruleName:string) : Rule {
            this.grammarName = grammarName;
            this.name = ruleName;
            return this;            
        }

        // Returns a default definition of the rule
        get definition() : string {
            return this.className + "(" + this.rules.map((r) => r.toString()).join(", ") + ")";
        }

        // Returns the name of the rule preceded by the grammar name and a "."
        get fullName() : string {
            return this.grammarName + "." + this.name
        }

        // Returns either the name of the rule, or it's definition
        get nameOrDefinition() : string {
            return this.name 
                ? this.fullName
                : this.definition;
        }

        // Returns a string representation of the rule 
        toString() : string {
            return this.nameOrDefinition;
        }

        // Returns the first child rule
        get firstChild() : Rule {
            return this.rules[0];
        }

        // Sets the "type" associated with the rule. 
        // This is useful for tracking how a rule was created. 
        setType(type : string) : Rule {
            this.type = type;
            return this;
        }

        // Returns a copy of this rule with default values for all fields.  
        // Note: Every new rule class must override cloneImplemenation
        cloneImplementation() : Rule {
            throw new Error("Missing override for cloneImplementation");
        }

        // Returns a copy of this rule with all fields copied.  
        get copy() : Rule {
            var r = this.cloneImplementation();
            if (typeof(r) !== typeof(this))
                throw new Error("Error in implementation of cloneImplementation: not returning object of correct type");
            r.name = this.name;
            r.grammarName = this.grammarName;
            r._createAstNode = this._createAstNode;
            return r;
        }

        // Returns a copy of the rule that will create a node in the parse tree.
        // This property is the only way to create rules that generate nodes in a parse tree. 
        // TODO: this might be better in a Rule class? 
        get ast() : Rule {
            var r = this.copy;
            r._createAstNode = true;
            var parser = r.parser;
            r.parser = (p : ParseState) => {
                var originalIndex = p.index; 
                var originalNodes = p.nodes;
                p.nodes = [];
                if (!parser(p)) {
                    p.nodes = originalNodes;
                    p.index = originalIndex;
                    return false;
                }                
                let node = new AstNode(r, p.input, originalIndex, p.index);
                node.children = p.nodes;
                p.nodes = originalNodes;
                p.nodes.push(node);
                return true;
            }
            return r;
        }

        // Returns true if any of the child rules are "ast rules" meaning they create nodes in the parse tree.
        get hasAstChildRule() : boolean {
            return this.rules.filter(r => r.createsAstNode).length > 0;
        }

        // Returns true if this rule when parsed successfully will create a node in the parse tree. 
        // Some rules will override this function. 
        get createsAstNode() : boolean {
            return this._createAstNode;
        }

        // Returns true if this rule doesn't advance the input
        get nonAdvancing() : boolean {
            return false; 
        }

        // Returns a string that describes the AST nodes created by this rule.
        // Will throw an exception if this is not a valid AST rule (this.isAstRule != true)
        astRuleDefn(inSeq:boolean=false, inChoice:boolean=false) : string {    
            var rules = this.rules.filter(r => r.createsAstNode);        
            if (!rules.length)
                return this.name;
            if (rules.length == 1) {
                var result = rules[0].astRuleNameOrDefn(inSeq, inChoice);
                if (this instanceof Quantified)
                    result += "[" + this.min + "," + this.max + "]";     
                return result;
            }
            if (this instanceof Sequence) {                
                var tmp = rules.map(r => r.astRuleNameOrDefn(true, false)).join(",");
                if (inSeq) return tmp;
                return "seq(" + tmp + ")";
            }

            if (this instanceof Choice) {
                var tmp = rules.map(r => r.astRuleNameOrDefn(false, true)).join(",");
                if (inChoice) return tmp;                
                return "choice(" + tmp + ")";
            }
                
            throw new Error("Internal error: not a valid AST rule");
        }

        // Returns a string that is either the name of the AST parse node, or a definition 
        // (schema) describing the makeup of the rules. 
        astRuleNameOrDefn(inSeq:boolean = false, inChoice:boolean = false) : string {
            if (this._createAstNode) 
                return this.name;
            return this.astRuleDefn(inSeq, inChoice);
        }

        //======================================================
        // Extensions to support method/property chaining. 
        // This is also known as a fluent API syntax

        get opt() : Rule { return opt(this); }
        get zeroOrMore() : Rule { return zeroOrMore(this); }
        get oneOrMore() : Rule { return oneOrMore(this); }
        get at() : Rule { return at(this); }
        get not() : Rule { return not(this); }
        get advance() : Rule { return this.then(advance); }
        get ws() : Rule { return this.then(ws); }
        get all() : Rule { return this.then(all); }
        get end() : Rule { return this.then(end); }
        get assert() : Rule { return assert(this); }

        then(r:RuleType) : Rule { return seq(this, r); }
        thenAt(r:RuleType) : Rule { return this.then(at(r)); }
        thenNot(r:RuleType) : Rule { return this.then(not(r)); }
        or(r:RuleType) : Rule { return choice(this, r); } 
        until(r:RuleType) : Rule { return repeatWhileNot(this, r); }
        untilPast(r:RuleType) : Rule { return repeatUntilPast(this, r); }        
        repeat(count:number) { return repeat(this, count); }
        quantified(min:number, max:number) { return quantified(this, min, max); }
        delimited(delimiter:RuleType) { return delimited(this, delimiter); }        
        unless(r:RuleType) { return unless(this, r); }
    }

    //===============================================================
    // Rule derived classes 

    // These are the core Rule classes of Myna. Normally you would not use theses directly but use the factory methods
    // If you fork this code, think twice before adding new classes here. Maybe you can implement your new Rule
    // in terms of functions or other low-level rules. Then you can be happy knowing that the same code is being 
    // re-used and tested all the time.  

    // Matches a series of rules in order. Succeeds only if all sub-rules succeed. 
    export class Sequence extends Rule 
    {
        type = "seq";
        className = "Sequence";

        constructor(public rule1:Rule, public rule2:Rule) { 
            super([rule1, rule2]);
            var parser1 = rule1.parser;
            var parser2 = rule2.parser;
            var lexer1 = rule1.lexer;
            var lexer2 = rule2.lexer;
            this.parser = (p : ParseState) => {
                var originalCount = p.nodes.length;
                var originalIndex = p.index;
                
                if (parser1(p) === false)
                    // The first parser will restore everything automatically 
                    return false; 
                
                if (parser2(p) === false) {                        
                    // Any created nodes need to be popped off the list 
                    if (p.nodes.length !== originalCount) 
                        p.nodes.splice(-1, p.nodes.length - originalCount);
                    // Assure that the parser is restored to its original position 
                    p.index = originalIndex;
                    return false;
                }
                return true;
            };
            this.lexer = (p : ParseState) => {
                var original = p.index;
                if (lexer1(p) === false)
                    return false;
                
                if (lexer2(p) === false) {                        
                    p.index = original;
                    return false;
                }

                return true;
            }
            // When none of the child rules create a node, we can use the lexer to parse
            if (!this.createsAstNode)
                this.parser = this.lexer;
        }

        get definition() : string {
            var result = this.rules.map((r) => r.toString()).join(" ");
            if (this.rules.length > 1)   
                result = "(" + result + ")";
            return result;
        }

        get nonAdvancing() : boolean {
            return this.rules.every(r => r.nonAdvancing); 
        }

        get createsAstNode() : boolean {
            return this._createAstNode || this.hasAstChildRule;
        }

        cloneImplementation() : Rule { return new Sequence(this.rule1, this.rule2); }
    }
    
    // Tries to match each rule in order until one succeeds. Succeeds if any of the sub-rules succeed. 
    export class Choice extends Rule
    {
        type = "choice";
        className = "Choice";

        constructor(public rule1:Rule, public rule2:Rule) { 
            super([rule1, rule2]);
            var parser1 = rule1.parser;
            var parser2 = rule2.parser;
            var lexer1 = rule1.lexer;
            var lexer2 = rule2.lexer;
            this.parser = (p : ParseState) => {
                return parser1(p) || parser2(p);
            };
            this.lexer = (p : ParseState) => {
                return lexer1(p) || lexer2(p);
            }
            // When none of the child rules create a node, we can use the lexer to parse
            if (!this.createsAstNode)
                this.parser = this.lexer;
        }

        get definition() : string {
            var result = this.rules.map((r) => r.toString()).join(" / ");
            if (this.rules.length > 1)   
                result = "(" + result + ")";
            return result;
        }

        get nonAdvancing() : boolean {
            return this.rules.every(r => r.nonAdvancing); 
        }

        get createsAstNode() : boolean {
            return this._createAstNode || this.hasAstChildRule;
        }

        cloneImplementation() : Rule { return new Choice(this.rule1, this.rule2); }
    }

    // A generalization of several rules such as zeroOrMore (0+), oneOrMore (1+), opt(0 or 1),
    // When matching with an unbounded upper limit set the maxium to  -1   
    export class Quantified extends Rule
    {    
        type = "quantified";
        className = "Quantified";
       
        constructor(rule:Rule, public min:number=0, public max:number=Infinity) { 
            super([rule]); 
            if (max === Infinity && rule.nonAdvancing)
                throw new Error("Rule would create an infinite loop");                
            var pChild = this.firstChild.parser;
            this.parser = (p : ParseState) => {
                var originalCount = p.nodes.length;
                var originalIndex = p.index;                
                for (var i=0; i < max; ++i) {
                    var index = p.index;

                    // If parsing the rule fails, we return the last result, or failed 
                    // if the minimum number of matches is not met. 
                    if (pChild(p) === false) {
                        if (i >= min) 
                            return true;
                         
                        // Any created nodes need to be popped off the list 
                        if (p.nodes.length !== originalCount) 
                            p.nodes.splice(-1, p.nodes.length - originalCount);

                        // Assure that the parser is restored to its original position 
                        p.index = originalIndex;
                        return false;
                    }

                    // Check for progress, to assure we aren't hitting an infinite loop  
                    debugAssert(max !== Infinity || p.index !== originalIndex, this);
                }            
                return true;
            };
            var lChild = this.firstChild.lexer;
            this.lexer = (p : ParseState) => {
                var originalIndex = p.index;
                for (var i=0; i < max; ++i) {
                    var index = p.index;
                    if (lChild(p) === false) {
                        if (i >= min) 
                            return true;
                        p.index = originalIndex;
                        return false;
                    }

                    // Check for progress, to assure we aren't hitting an infinite loop  
                    debugAssert(max !== Infinity || p.index !== originalIndex, this);
                }            
                return true;
            };
            // When none of the child rules create a node, we can use the lexer to parse
            if (!this.createsAstNode)
                this.parser = this.lexer;
        }

        // Used for creating a human readable definition of the grammar.
        get definition() : string {            
            if (this.min == 0 && this.max == 1)
                return this.firstChild.toString() + "?";
            if (this.min == 0 && this.max == Infinity)
                return this.firstChild.toString() + "*";
            if (this.min == 1 && this.max == Infinity)
                return this.firstChild.toString() + "+";
            return this.firstChild.toString() + "{" + this.min + "," + this.max + "}";
         }

        get createsAstNode() : boolean {
            return this._createAstNode || this.hasAstChildRule;
        }

        cloneImplementation() : Rule { return new Quantified(this.firstChild, this.min, this.max); }
    }

    // Matches a child rule zero or once. 
    export class Optional extends Quantified
    {    
        type = "optional";
        className = "Optional";
       
        constructor(rule:Rule) { 
            super(rule, 0, 1); 
            var pChild = this.firstChild.parser;
            this.parser = (p : ParseState) => {
                pChild(p);
                return true;
            };
            var lChild = this.firstChild.lexer;
            this.lexer = (p : ParseState) => {
                lChild(p);
                return true;
            };
            // When none of the child rules create a node, we can use the lexer to parse
            if (!this.createsAstNode)
                this.parser = this.lexer;
        }

        // Used for creating a human readable definition of the grammar.
        get definition() : string {            
            return this.firstChild.toString() + "?";
         }

        cloneImplementation() : Rule { return new Optional(this.firstChild); }
    }

    // Advances the parser by one token unless at the end
    export class Advance extends Rule
    {
        type = "advance";
        className = "Advance";
        constructor() { 
            super([]); 
            this.lexer = (p : ParseState) => 
                p.index < p.length ? ++p.index >= 0 : false;
            this.parser = this.lexer;
        }
        get definition() : string { return "<advance>"; }
        cloneImplementation() : Rule { return new Advance(); }                
    }

    // Advances the parser by one token if the predicate is true.
    export class AdvanceIf extends Rule
    {
        type = "advanceIf";
        className = "AdvanceIf";
        constructor(condition:Rule) { 
            super([condition]); 
            var lexCondition = condition.lexer;
            this.lexer = (p : ParseState) => {
                return lexCondition(p) && p.index < p.length ? ++p.index !== 0 : false;
            }
            this.parser = this.lexer;
        }
        get definition() : string { return "advanceIf(" + this.firstChild.toString() + ")"; }
        cloneImplementation() : Rule { return new AdvanceIf(this.firstChild); }                
    }

    // Used to match a string in the input string, advances the token. 
    export class Text extends Rule
    {
        type = "text";
        className = "Text";
        constructor(public text:string) { 
            super([]); 
            var length = text.length;
            var vals = [];
            for (var i=0; i < length; ++i)
                vals.push(text.charCodeAt(i));
            this.lexer = (p : ParseState) => {
                let index = p.index; 
                // TODO: consider pulling the sub-string out of the text.        
                for (let val of vals)
                    if (p.input.charCodeAt(index++) !== val) 
                        return false;
                p.index = index;
                return true;
            }
            this.parser = this.lexer;
        }           
        get definition() : string { return '"' + escapeChars(this.text) + '"' }
        cloneImplementation() : Rule { return new Text(this.text); }        
    }

    // Creates a rule that is defined from a function that generates the rule. 
    // This allows two rules to have a cyclic relation. 
    export class Delay extends Rule 
    {
        type = "delay";
        className = "Delay";
        constructor(public fn:()=>Rule) { 
            super([]); 
            var tmpParser = null;
            this.parser = (p : ParseState) => (tmpParser ? tmpParser : tmpParser = fn().parser)(p);
            var tmpLexer = null;
            this.lexer = (p : ParseState) => (tmpLexer ? tmpLexer : tmpLexer = fn().lexer)(p);
        }
        cloneImplementation() : Rule { return new Delay(this.fn); }    
        get definition() : string { return "<delay>"; }    

        // It is assumed that a delay function creates an AST node,
        get createsAstNode() : boolean {
            return true;
        }
    } 

    //====================================================================================================================
    // Predicates don't advance the input 

    // Used to identify rules that do not advance the input
    export class NonAdvancingRule extends Rule {
        type = "charSet";
        constructor(rules:Rule[]) { 
            super(rules);
        }
        get nonAdvancing() : boolean {
            return true;
        }
    }

    // Returns true if the current token is in the token set. 
    export class CharSet extends NonAdvancingRule {
        type = "charSet";
        className = "CharSet";
        constructor(public chars:string) { 
            super([]);
            let vals = [];
            let length = chars.length;
            for (var i=0; i < length; ++i)
                vals[i] = chars.charCodeAt(i);
            this.lexer = (p : ParseState) => 
                // TODO: Try this instead, could be faster.
                // chars.indexOf(p.input[p.index]) >= 0;
                vals.indexOf(p.input.charCodeAt(p.index)) >= 0;
            this.parser = this.lexer;
        }
        get definition() : string { return "[" + escapeChars(this.chars) + "]"};
        cloneImplementation() : Rule { return new CharSet(this.chars); }        
    }

    // Returns true if the current token is within a range of characters, otherwise returns false
    export class CharRange extends NonAdvancingRule {
        type = "charRange";
        className = "CharRange";
        constructor(public min:string, public max:string) { 
            super([]);
            let minCode = min.charCodeAt(0);
            let maxCode = max.charCodeAt(0);
            this.lexer = (p : ParseState) => { 
                let code = p.input.charCodeAt(p.index);
                return code >= minCode && code <= maxCode;
            }
            this.parser = this.lexer;
        }
        get definition() : string { return "[" + this.min + ".." + this.max + "]"};
        cloneImplementation() : Rule { return new CharRange(this.min, this.max); }            
    }

    // Returns true only if the child rule fails to match.
    export class Not extends NonAdvancingRule
    {
        type = "not";
        className = "Not";
        constructor(rule:Rule) { 
            super([rule]); 
            var childLexer = rule.lexer; 
            this.lexer = (p : ParseState) => { 
                if (p.index >= p.length) return true;
                let index = p.index; 
                if (childLexer(p) === false) 
                    return true;
                p.index = index;
                return false; 
            }
            this.parser = this.lexer;
        }
        cloneImplementation() : Rule { return new Not(this.firstChild); }
        get definition() : string { return "!" + this.firstChild.toString(); }
    }   

    // Returns true only if the child rule matches, but does not advance the parser
    export class At extends NonAdvancingRule
    {
        type = "at";
        className = "At";
        constructor(rule:Rule) { 
            super([rule]); 
            var childLexer = rule.lexer; 
            this.lexer = (p : ParseState) => { 
                let index = p.index; 
                if (childLexer(p) === false) 
                    return false;
                p.index = index; 
                return true; 
            }
            this.parser = this.lexer;
        }
        cloneImplementation() : Rule { return new At(this.firstChild); }
        get definition() : string { return "&" + this.firstChild.toString(); }
    }   

    // Uses a function to return true or not based on the behavior of the predicate rule
    export class Predicate extends NonAdvancingRule
    {
        type = "predicate";
        className = "Predicate";
        constructor(public fn:(p:ParseState)=>boolean) {
            super([]); 
            this.lexer = fn;
            this.parser = this.lexer;
        }
        cloneImplementation() : Rule { return new Predicate(this.fn); }        
        get definition() : string { return "<predicate>"; }
    }
    
    //===============================================================
    // Rule creation function
    
    // Create a rule that matches the text 
    export function text(text:string) { return new Text(text);  }

    // Creates a rule that matches a series of rules in order, and succeeds if they all do
    export function seq(...rules:RuleType[]) { 
        var rs = rules.map(RuleTypeToRule);
        if (rs.length == 0) throw new Error("At least one rule is expected when calling `seq`");
        if (rs.length == 1) return rs[0];
        var rule1 = rs[0];
        var rule2 = seq(...rs.slice(1));
        if (rule1.nonAdvancing && rule2 instanceof Advance)
            return new AdvanceIf(rule1);
        else
            return new Sequence(rule1, rule2);
    }

    // Creates a rule that tries to match each rule in order, and succeeds if at least one does 
    export function choice(...rules:RuleType[]) { 
        var rs = rules.map(RuleTypeToRule);
        if (rs.length == 0) throw new Error("At least one rule is expected when calling `choice`");
        if (rs.length == 1) return rs[0];
        var rule1 = rs[0];
        var rule2 = choice(...rs.slice(1));
        if (rule1 instanceof AdvanceIf && rule2 instanceof AdvanceIf)
            return new AdvanceIf(choice(rule1.firstChild, rule2.firstChild));
        else
            return new Choice(rule1, rule2);
    }        

    // Enables Rules to be defined in terms of variables that are defined later on.
    // This enables recursive rule definitions.  
    export function delay(fxn:()=>Rule) { return new Delay(fxn);  }

    // Parses successfully if the given rule does not match the input at the current location  
    export function not(rule:RuleType) { return new Not(RuleTypeToRule(rule));  };

    // Returns true if the rule successfully matches, but does not advance the parser index. 
    export function at(rule:RuleType) {  return new At(RuleTypeToRule(rule)); };

    // Attempts to apply a rule between min and max number of times inclusive. If the maximum is set to Infinity, 
    // it will attempt to match as many times as it can, but throw an exception if the parser does not advance 
    export function quantified(rule:RuleType, min:number=0, max:number=Infinity) { 
        if (min === 0 && max === 1) 
            return new Optional(RuleTypeToRule(rule));
        else
            return new Quantified(RuleTypeToRule(rule), min, max);  
    }

    // Attempts to apply the rule 0 or more times. Will always succeed unless the parser does not 
    // advance, in which case an exception is thrown.    
    export function zeroOrMore(rule:RuleType) {  return quantified(rule).setType("zeroOrMore");  };

    // Attempts to apply the rule 1 or more times. Will throw an exception if the parser does not advance.  
    export function oneOrMore(rule:RuleType) { return quantified(rule, 1).setType("oneOrMore"); } 

    // Attempts to match a rule 0 or 1 times. Always succeeds.   
    export function opt(rule:RuleType) { return quantified(rule, 0, 1).setType("optional"); }

    // Attempts to apply a rule a precise number of times
    export function repeat(rule:RuleType, count:number) { return quantified(rule, count, count).setType("repeat"); }
    
    // Returns true if one of the characters are present. Does not advances the parser position.
    export function atChar(chars:string) { return new CharSet(chars); }    

    // Returns true if none of the characters are present. Does not advances the parser position.
    export function notAtChar(chars:string) { return atChar(chars).not; }    

    // Advances parser if one of the characters are present.
    export function char(chars:string) { return atChar(chars).advance; }    

    // Advances parser if none of the characters are present.
    export function notChar(chars:string) { return notAtChar(chars).advance; }    

    // Advances if one of the characters are present, or returns false
    export function atRange(min:string, max:string) { return new CharRange(min, max); }

    // Advances if one of the characters are present, or returns false
    export function range(min:string, max:string) { return atRange(min, max).advance; }

    // Returns true if on of the characters are not in the range, but does not advance the parser position
    export function notRange(min:string, max:string) { return range(min, max).not; }

    // Repeats a rule zero or more times, with a delimiter between each one. 
    export function delimited(rule:RuleType, delimiter:RuleType) { return opt(seq(rule, seq(delimiter, rule).zeroOrMore)).setType("delimitedList"); }

    // Executes the rule, if the condition is not true
    export function unless(rule:RuleType, condition:RuleType) { return seq(not(condition), rule).setType("unless"); }        

    // Repeats the rule while the condition is not true
    export function repeatWhileNot(body:RuleType, condition:RuleType) { return unless(body, condition).zeroOrMore.setType("repeatWhileNot"); }

    // Repeats the rule while the condition is not true, but must execute at least once 
    export function repeatOneOrMoreWhileNot(body:RuleType, condition:RuleType) { return not(condition).then(body).then(repeatWhileNot(body, condition)).setType("repeatOneOrMoreWhileNot"); }

    // Repeats the rule until just after the condition is true once 
    export function repeatUntilPast(body:RuleType, condition:RuleType) { return repeatWhileNot(body, condition).then(condition).setType("repeatUntilPast"); }

    // Repeats the rule until just after the condition is true once but must execute at least once 
    export function repeatOneOrMoreUntilPast(body:RuleType, condition:RuleType) { return not(condition).then(body).then(repeatUntilPast(body, condition)).setType("repeatOneOrMoreUntilPast"); }

    // Advances the parse state while the rule is not true. 
    export function advanceWhileNot(rule:RuleType) { return repeatWhileNot(advance, rule).setType("advanceWhileNot"); }

    // Advances the parse state while the rule is not true but must execute ast least once 
    export function advanceOneOrMoreWhileNot(rule:RuleType) { return repeatOneOrMoreWhileNot(advance, rule).setType("advanceOneOrMoreWhileNot"); }

    // Advance the parser until just after the rule is executed 
    export function advanceUntilPast(rule:RuleType) { return repeatUntilPast(advance, rule).setType("advanceUntilPast"); }

    // Advance the parser until just after the rule is executed, but must execute at least once  
    export function advanceOneOrMoreUntilPast(rule:RuleType) { return repeatOneOrMoreUntilPast(advance, rule).setType("advanceOneOrMoreUntilPast"); }

    // Advances the parser unless the rule is true. 
    export function advanceUnless(rule:RuleType) { return advance.unless(rule).setType("advanceUnless"); }

    // Parses successfully if  the predictate passes
    export function predicate(fn:(p:ParseState)=>boolean) { return new Predicate(fn); }

    // Executes an action when arrived at and continues 
    export function action(fn:(p:ParseState)=>void) { return predicate((p)=> { fn(p); return true; }).setType("action"); }

    // Logs a message as an action 
    export function log(msg:string = "") { return action(p=> { console.log(msg); }).setType("log"); }

    // Throw a Error if reached 
    export function err(message) {  return action(p => { 
        var e = new Error(message + '\n' + p.location.toString()); 
        throw e;
    }).setType("err");  }

    // Asserts that the rule is executed 
    // This has to be embedded in a function because the rule might be in a circular definition.  
    export function assert(rule:RuleType) { return choice(rule, err("Expected: " + RuleTypeToRule(rule))); }
    
    // If first part of a guarded sequence passes then each subsequent rule must pass as well 
    // otherwise an exception occurs. This helps create parsers that fail fast, and thus provide
    // better feedback for badly formed input.      
    export function guardedSeq(condition:RuleType, ...rules:RuleType[]) { 
        return seq(condition, seq(...rules.map((r) => assert(r)))).setType("guardedSeq"); 
    }
    
    // Parses the given rule surrounded by double quotes 
    export function doubleQuoted(rule:RuleType) { return guardedSeq("\"", rule, assert("\"")).setType("doubleQuoted"); }

    // Parses a double quoted string, taking into account special escape rules
    export function doubleQuotedString(escape:RuleType) { return doubleQuoted(choice(escape, notChar('"').zeroOrMore)).setType("doubleQuotedString"); }

    // Parses the given rule surrounded by single quotes 
    export function singleQuoted(rule:RuleType) { return guardedSeq("'", rule, assert("'")).setType("singleQuoted"); }

    // Parses a singe quoted string, taking into account special escape rules
    export function singleQuotedString(escape:RuleType) { return singleQuoted(choice(escape, notChar("'").zeroOrMore)).setType("singleQuotedString"); }

    // Parses the given rule surrounded by parentheses, and consumes whitespace  
    export function parenthesized(rule:RuleType) { return guardedSeq("(", ws, rule, ws, ")").setType("parenthesized"); }

    // Parses the given rule surrounded by curly braces, and consumes whitespace 
    export function braced(rule:RuleType) { return guardedSeq("{", ws, rule, ws, "}").setType("braced"); }

    // Parses the given rule surrounded by square brackets, and consumes whitespace 
    export function bracketed(rule:RuleType) { return guardedSeq("[", ws, rule, ws, "]").setType("bracketed"); }

    // Parses the given rule surrounded by angle brackets, and consumes whitespace 
    export function tagged(rule:RuleType) { return guardedSeq("<", ws, rule, ws, ">").setType("tagged"); }
         
    // A complete identifier, with no other letters or numbers
    export function keyword(text:string) { return seq(text, not(identifierNext)).setType("keyword"); }

    // Chooses one of a a list of identifiers
    export function keywords(...words:string[]) { return choice(...words.map(keyword)); }

    //===============================================================    
    // Core grammar rules 
        
    export var truePredicate    = new Predicate((p : ParseState) => true);
    export var falsePredicate   = new Predicate((p : ParseState) => false);
    export var end              = new Predicate((p : ParseState) => p.index >= p.length);
    export var notEnd           = new Predicate((p : ParseState) => p.index < p.length);
    export var advance          = new Advance();   
    export var all              = advance.zeroOrMore;

    export var atLetterLower      = atRange('a','z');
    export var atLetterUpper      = atRange('A','Z');
    export var atLetter           = choice(atLetterLower, atLetterUpper);
    export var atDigit            = atRange('0', '9');
    export var atDigitNonZero     = atRange('1', '9');
    export var atHexDigit         = choice(atDigit, atRange('a','f'), atRange('A','F'));
    export var atBinaryDigit      = atChar('01');
    export var atOctalDigit       = atRange('0','7');
    export var atAlphaNumeric     = choice(atLetter, atDigit);
    export var atUnderscore       = atChar("_");
    export var atSpace            = atChar(" ");
    export var atTab              = atChar("\t");    
    export var atWs               = atChar(" \t\r\n\u00A0\uFEFF");
    export var atIdentifierNext   = choice(atAlphaNumeric, atUnderscore);

    export var letterLower      = atLetterLower.advance;
    export var letterUpper      = atLetterUpper.advance;
    export var letter           = atLetter.advance;
    export var letters          = letter.oneOrMore;
    export var digit            = atDigit.advance;
    export var digitNonZero     = atDigitNonZero.advance;
    export var digits           = digit.oneOrMore;
    export var integer          = char('0').or(digits);
    export var hexDigit         = atHexDigit.advance;
    export var binaryDigit      = atBinaryDigit.advance;
    export var octalDigit       = atOctalDigit.advance;
    export var alphaNumeric     = atAlphaNumeric.advance;
    export var underscore       = atUnderscore.advance;
    export var identifierFirst  = choice(atLetter, atUnderscore).advance;
    export var identifierNext   = choice(atAlphaNumeric, atUnderscore).advance;
    export var identifier       = seq(identifierFirst, identifierNext.zeroOrMore);     
    export var hyphen           = text("-");
    export var crlf             = text("\r\n");
    export var newLine          = choice(crlf, "\n");          
    export var space            = text(" ");
    export var tab              = text("\t");    
    
    // JSON definition of white-space 
    export var ws               = atWs.advance.zeroOrMore;        

    //===============================================================
    // Parsing function 
    
    // Returns an array of nodes created by parsing the given rule repeatedly until 
    // it fails or the end of the input is arrived. One Astnode is created for each time 
    // the token is parsed successfully, whether or not it explicitly has the "_createAstNode" 
    // flag set explicitly. 
    export function tokenize(r:Rule, s:string) : AstNode[]
    {
        var result = this.parse(r.ast.zeroOrMore, s);
        return result ? result.children : [];
    }

    // Returns the root node of the abstract syntax tree created 
    // by parsing the rule. 
    export function parse(r : Rule, s : string) : AstNode
    {
        var p = new ParseState(s, 0, []);        
        if (!r.ast.parser(p)) 
            return null;
        return p && p.nodes ? p.nodes[0] : null;
    }

    //===============================================================
    // Grammar functions 
    
    // The following are helper functions for grammar objects. A grammar is a loosely defined concept.
    // It is any JavaScript object where one or more member fields are instances of the Rule class.    

    // Returns all rules that belong to a specific grammar and that create AST nodes. 
    export function grammarAstRules(grammarName:string) {
        return grammarRules(grammarName).filter(r => r._createAstNode);
    }

    // Returns all rules that belong to a specific grammar
    export function grammarRules(grammarName:string) {
        return allGrammarRules().filter(r => r.grammarName == grammarName);
    }

    // Returns all rules as an array sorted by name.
    export function allGrammarRules() {
        return Object.keys(allRules).sort().map(k => allRules[k]);
    }

    // Returns an array of names of the grammars
    export function grammarNames() : string[] {
        return Object.keys(grammars).sort();
    }
        
    // Creates a string representation of a grammar 
    export function grammarToString(grammarName:string) : string {
        return grammarRules(grammarName).map(r => r.fullName + " <- " + r.definition).join('\n');
    }

    // Creates a string representation of the AST schema generated by parsing the grammar 
    export function astSchemaToString(grammarName:string) : string {
        return grammarAstRules(grammarName).map(r => r.name + " <- " + r.astRuleDefn()).join('\n');
    }

    // Initializes and register a grammar object and all of the rules. 
    // Sets names for all of the rules from the name of the field it is associated with combined with the 
    // name of the grammar. Each rule is stored in Myna.rules and each grammar is stored in Myna.grammars. 
    export function registerGrammar(grammarName:string, grammar:any, defaultRule:Rule)
    {
        for (var k in grammar) {
            if (grammar[k] instanceof Rule) {
                var rule = grammar[k];
                rule.setName(grammarName, k);
                allRules[rule.fullName] = rule;
            }
        }
        grammars[grammarName] = grammar;

        if (defaultRule) {
            parsers[grammarName] = text => parse(defaultRule, text);
        }
        return grammar;
    }

    //===========================================================================
    // Utility functions

    // Replaces characters with the JSON escaped version
    export function escapeChars(text:string) {
        var r = JSON.stringify(text);
        return r.slice(1, r.length - 1);
    }

    // Given a RuleType returns an instance of a Rule.
    export function RuleTypeToRule(rule:RuleType) : Rule {
        if (rule instanceof Rule) return rule;
        if (typeof(rule) === "string") return text(rule);
        if (typeof(rule) === "boolean") return rule ? truePredicate : falsePredicate;
        throw new Error("Invalid rule type: " + rule);
    }     

    // These should be commented out in the filnal version 
    export function debugAssert(condition: boolean, rule: Rule) {
        if (!condition)
            throw new Error("Error occured while parsing rule: " + rule.fullName);
    }

    //===========================================================================
    // Initialization

    // The entire module is a grammar because it is an object that exposes rules as properties
    registerGrammar("core", Myna, null);
}

// Export the function for use with Node.js and the CommonJS module system. 
declare var module;
if (typeof module === "object" && module.exports) {
    module.exports = Myna;
    // When importing from TypeScript the imports expect a "Myna" variable 
    module.exports.Myna = Myna;
}
