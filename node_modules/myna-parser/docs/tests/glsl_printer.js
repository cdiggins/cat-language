// Generates a text output of GLSL code. 
// This could either be a GLSL shader, or it could be a Heron program.

// Note: the skeleton code was generated using "myna_generate_ast_visitor".
// TODO: differentiate between scrope and record

// TODO: figure out the types of different expressions. 
// TODO: create a call tree
// TODO: assign a type to each expression 
// TODO: figure out where variables are assigned 

let augmentAst = require("../tools/myna_augment_ast");

var DEBUG1 = false;

function astLocation(ast) {
    if (!ast)
        return "predefined";
    else
        return "line " + ast.rowNum + ", column " + ast.colNum;
}

function addVar(state, ast, name, type) {
    if (DEBUG1)
        state.text.push("/* DEF: " + name + " */");
    var frame = getCurrentFrame(state);
    var uniqueName = frame.fullName + ":" + name;
    var varRecord = {
        name: name,
        uniqueName: uniqueName,
        declaration: ast,
        usages: [],
        index: Object.keys(state.vars).length,
        frame: frame,
        type: type
    }
    if (uniqueName in state.vars) {
        var loc = state.vars[uniqueName].declaration;
        if (DEBUG1)
            printNewLine(state, "/* Redefining " + uniqueName + " from " + astLocation(loc) + " */");
    }
    state.vars[uniqueName] = varRecord;
    frame.vars.push(varRecord);        
    if (name in frame.varLookup) {
        var loc = frame.varLookup[name].declaration;
        if (DEBUG1)
            printNewLine(state, "/* Redefining " + name + " from " + astLocation(loc) + " */");
    }
    frame.varLookup[name] = varRecord;
}

function addVarRef(state, ast, name) 
{
    var record = findVarRecord(state, name);
    var usage = {
        name:name,
        location:ast,
        record:record
    }
    if (record != undefined)
    {
        // TODO: create a proper record for usages of variables 
        record.usages.push(usage);
        var frame = getCurrentFrame(state);
        frame.varRefs.push(usage);
        if (DEBUG1)
            state.text.push("/* REF: " + usage.name + "*/");
    }
    else
    {
        if (DEBUG1)
            state.text.push("/* UNDEF: " + name + "*/");
        if (name in state.undefined)
            state.undefined[name].push(ast); 
        else 
            state.undefined[name] = [ast];
    }
}

function getCurrentFrame(state) {
    return state.frameStack[state.frameStack.length - 1];
}

function findVarRecord(state, name) {
    for (var i=state.frameStack.length-1; i >= 0; --i) {
        var frame = state.frameStack[i];
        var result = frame.varLookup[name];
        if (result != undefined) 
            return result;
    }
    return undefined;
}

function pushScope(state, name) {
    var index = state.frameList.length;
    name = name + index; 
    var fullName = "";
    for (var frame of state.frameStack)
        fullName += frame.name + ":";
    fullName += name;
    var parent = getCurrentFrame(state);
    var frame = {
        name:name,
        parent:parent,
        fullName:fullName,
        vars:[],
        varRefs:[],
        varLookup:{},
        index:index,
        depth:state.frameStack.length,
        children:[],
    }
    if (parent)
        parent.children.push(frame);

    state.frameStack.push(frame);
    state.frameList.push(frame);
    printNewLine(state, "// pushing activation record " + frame.fullName);
}

function varDescription(v) {
    return "variable " + v.name + ", unique name " + v.uniqueName + ", index " + v.index + ", declared at " + astLocation(v.declaration);
    //for (var u of v.usages) 
    //    r += "// used at " + astLocation(u) + "\n";    
}

function popScope(state) {        
    var frame = state.frameStack.pop();
    printNewLine(state, "// popping activation record " + frame.fullName);
    printNewLine(state, "// local variables: "); 
    for (var v of frame.vars) 
        printNewLine(state, "// " + varDescription(v));
    printNewLine(state, "// references:"); 
    for (var v of frame.varRefs) 
        printNewLine(state, "// " + v.name + " at " + astLocation(v.location));
    // NOW: I want a list of the varaibles that are reference from the top-level 
    // Also all the variables taht are referenced from outside the function 
}

function increaseIndent(state) {        
    state.indent++;
}

function decreaseIndent(state) {
    state.indent--;    
}

function printNewLine(state, text) {
    if (text)
        state.text.push(text);
    state.text.push("\n");
    state.text.push("    ".repeat(state.indent));                    
}

var glslPrinter = new function() 
{
    this.asHeron = false;

    this.visitNode = function(ast, state) {
            this['visit_' + ast.name](ast, state);
    }
    this.visitChildren = function(ast, state) {
        for (var child of ast.children) 
            this.visitNode(child, state);
    }
    this.visit_additiveExpr = function(ast, state) {
        // seq(additiveOp,expr9)
        this.visitChildren(ast, state);
    }
    this.visit_additiveOp = function(ast, state) {
        // additiveOp
        state.text.push(" " + ast.allText + " ");
    }
    this.visit_arrayIndex = function(ast, state) {
        // expr
        state.text.push("[");
        this.visitChildren(ast, state);
        state.text.push("]");
    }
    this.visit_assignmentExpr = function(ast, state) {
        // seq(assignmentOp,expr2)
        this.visitChildren(ast, state);
    }
    this.visit_assignmentOp = function(ast, state) {
        // assignmentOp
        state.text.push(" " + ast.allText + " ");
    }
    this.visit_bool = function(ast, state) {
        // bool
        state.text.push(ast.allText);
    }
    this.visit_breakStatement = function(ast, state) {
        // breakStatement
        state.text.push("break;");
        printNewLine(state);
    }
    this.visit_commentStatementAst = function(ast, state) {
        state.text.push(ast.allText);
        printNewLine(state);
    }
    this.visit_commentStatement = function(ast, state) {
        this.visitChildren(ast, state);
    }
    this.visit_compoundStatement = function(ast, state) {
        // recStatement[0,Infinity]
        printNewLine(state, "{");
        increaseIndent(state);
        pushScope(state, "");
        this.visitChildren(ast, state);
        decreaseIndent(state);
        // The last thing was almost definitely a newline + indent
        // Just remove it. And we can reindent properly. 
        state.text.pop();
        printNewLine(state, "");
        printNewLine(state, "}");
        popScope(state);
    }
    this.visit_conditionalElseOp = function(ast, state) {
        // conditionalElseOp
        state.text.push(" : ");
        this.visitChildren(ast, state);
    }
    this.visit_conditionalExpr = function(ast, state) {
        // seq(conditionalOp,expr,conditionalElseOp,expr)
        this.visitChildren(ast, state);
    }
    this.visit_conditionalOp = function(ast, state) {
        // conditionalOp
        state.text.push(" ? ");
        this.visitChildren(ast, state);
    }
    this.visit_continueStatement = function(ast, state) {
        // continueStatement
        state.text.push("continue;");
        printNewLine(state);        
        this.visitChildren(ast, state);
    }
    this.visit_doLoop = function(ast, state) {
        // seq(recStatement,loopCond)
        state.text.push("do {");
        increaseIndent(state);
        printNewLine(state);
        this.visitNode(ast.children[0], state);
        decreaseIndent(state);
        state.text.push("} while (");
        this.visitNode(ast.children[1], state);
        state.text.push(")");
        printNewLine(state);
    }
    this.visit_elseStatement = function(ast, state) {
        // recStatement
        state.text.push("else ");
        this.visitChildren(ast, state);
    }
    this.visit_emptyStatement = function(ast, state) {
        // emptyStatement
    }
    this.visit_eosStatement = function(ast, state) {
        state.text.push(ast.allText);
        printNewLine(state);
    }    
    this.visit_equalityExpr = function(ast, state) {
        // seq(equalityOp,expr7)
        this.visitChildren(ast, state);
    }
    this.visit_equalityOp = function(ast, state) {
        // equalityOp
        state.text.push(" " + ast.allText + " ");
    }
    this.visit_expr = function(ast, state) {
        // expr
        this.visitChildren(ast, state);
    }
    this.visit_expr1 = function(ast, state) {
        // seq(expr2,assignmentExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_expr10 = function(ast, state) {
        // choice(seq(prefixOp,expr11),expr11)
        this.visitChildren(ast, state);
    }
    this.visit_expr11 = function(ast, state) {
        // seq(expr12,postfixExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_expr12 = function(ast, state) {
        // choice(parenExpr,leafExpr)
        this.visitChildren(ast, state);
    }
    this.visit_expr2 = function(ast, state) {
        // seq(expr3,conditionalExpr[0,1])
        this.visitChildren(ast, state);
    }
    this.visit_expr3 = function(ast, state) {
        // seq(expr4,logicalOrExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_expr4 = function(ast, state) {
        // seq(expr5,logicalXOrExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_expr5 = function(ast, state) {
        // seq(expr6,logicalAndExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_expr6 = function(ast, state) {
        // seq(expr7,equalityExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_expr7 = function(ast, state) {
        // seq(expr8,relationalExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_expr8 = function(ast, state) {
        // seq(expr9,additiveExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_expr9 = function(ast, state) {
        // seq(expr10,multiplicativeExpr[0,Infinity])
        this.visitChildren(ast, state);
    }
    this.visit_exprStatement = function(ast, state) {
        // expr
        this.visitChildren(ast, state);
        state.text.push(";");
        printNewLine(state);
    }
    this.visit_fieldName = function(ast, state) {
        // identifier
        state.text.push(".");
        state.text.push(ast.allText);
    }
    this.visit_fieldSelect = function(ast, state) {
        // fieldName
        this.visitChildren(ast, state);
    }
    this.visit_forLoop = function(ast, state) {
        // seq(forLoopInit,forLoopInvariant,forLoopVariant,recStatement)
        pushScope(state, "for");
        state.text.push("for (");
        this.visitNode(ast.children[0], state);
        this.visitNode(ast.children[1], state);
        this.visitNode(ast.children[2], state);
        state.text.push(") ");
        this.visitNode(ast.children[3], state);
        popScope(state);
    }
    this.visit_forLoopInit = function(ast, state) {
        // seq(qualifiers,typeExpr,varNameAndInit,varNameAndInit[0,Infinity][0,1])
        this.visitChildren(ast, state);
        state.text.push("; ");
    }
    this.visit_forLoopInvariant = function(ast, state) {
        // expr[0,1]        
        this.visitChildren(ast, state);
        state.text.push("; ");
    }
    this.visit_forLoopVariant = function(ast, state) {
        // expr[0,1]
        this.visitChildren(ast, state);
    }
    this.visit_funcCall = function(ast, state) {
        // seq(expr,expr[0,Infinity])[0,1]
        state.text.push("(");
        for (var i=0; i < ast.children.length; ++i) {
            if (i > 0) state.text.push(", ");
            this.visitNode(ast.children[i], state);
        }
        state.text.push(")");
    }
    this.visit_funcDef = function(ast, state) {
        // seq(qualifiers,typeExpr,funcName,funcParams,compoundStatement)
        if (!this.asHeron)
        {
            var funcName = ast.children[2].allText;
            addVar(state, ast, funcName);
            pushScope(state, funcName);
            this.visitNode(ast.children[0], state);
            this.visitNode(ast.children[1], state);
            this.visitNode(ast.children[2], state);
            this.visitNode(ast.children[3], state);
            printNewLine(state);
            if (ast.children.length > 4) {
                this.visitNode(ast.children[4], state);
            }
            else {
                state.text.push(";");
                printNewLine(state);
            }
            popScope(state);
        }
        else
        {
            // Check that this is not a function declaration 
            if (ast.children.length > 4)
            {
                var funcName = ast.children[2].allText;
                addVar(state, ast, funcName);
                pushScope(state, funcName);
                this.visitNode(ast.children[0], state);
                state.text.push("function ")
                state.text.push(funcName);
                this.visitNode(ast.children[3], state);
                printNewLine(state);
                this.visitNode(ast.children[4], state);
                popScope(state);
            }
        }
    }
    this.visit_funcName = function(ast, state) {
        // funcName
        state.text.push(ast.allText);
    }
    this.visit_funcParam = function(ast, state) {
        // seq(qualifiers,typeExpr,funcParamName)
        if (this.asHeron) {
            this.visitNode(ast.children[0], state);
            this.visitNode(ast.children[2], state);
        }
        else {
            this.visitChildren(ast, state);
        }
    }
    this.visit_funcParamName = function(ast, state) {
        // funcParamName
        addVar(state, ast, ast.allText);
        state.text.push(ast.allText);
    }
    this.visit_funcParams = function(ast, state) {
        // seq(funcParam,funcParam[0,Infinity])[0,1]
        state.text.push("(");
        for (var i=0; i < ast.children.length; ++i) {
            if (i > 0) state.text.push(", ");         
            this.visitNode(ast.children[i], state);
        }
        state.text.push(")");
    }
    this.visit_identifier = function(ast, state) {
        // identifier
        addVarRef(state, ast, ast.allText);
        state.text.push(ast.allText);
    }
    this.visit_ifStatement = function(ast, state) {
        // seq(expr,recStatement,elseStatement[0,1])
        state.text.push("if (");
        this.visitNode(ast.children[0], state);
        state.text.push(") ");
        this.visitNode(ast.children[1], state);
    }
    this.visit_invariantQualifier = function(ast, state) {
        // invariantQualifier
        state.text.push(ast.allText + " ");
    }
    this.visit_leafExpr = function(ast, state) {
        // choice(number,bool,identifier)
        this.visitChildren(ast, state);
    }
    this.visit_logicalAndExpr = function(ast, state) {
        // seq(logicalAndOp,expr6)
        this.visitChildren(ast, state);
    }
    this.visit_logicalAndOp = function(ast, state) {
        // logicalAndOp
        state.text.push(" " + ast.allText + " ");
    }
    this.visit_logicalOrExpr = function(ast, state) {
        // seq(logicalOrOp,expr4)
        this.visitChildren(ast, state);
    }
    this.visit_logicalOrOp = function(ast, state) {
        // logicalOrOp
        state.text.push(" " + ast.allText + " ");
    }
    this.visit_logicalXOrExpr = function(ast, state) {
        // seq(logicalXOrOp,expr5)
        this.visitChildren(ast, state);
    }
    this.visit_logicalXOrOp = function(ast, state) {
        // logicalXOrOp
        state.text.push(" " + ast.allText + " ");
    }
    this.visit_loopCond = function(ast, state) {
        // expr
        this.visitChildren(ast, state);
    }
    this.visit_multiplicativeExpr = function(ast, state) {
        // seq(multiplicativeOp,expr10)
        this.visitChildren(ast, state);
    }
    this.visit_multiplicativeOp = function(ast, state) {
        // multiplicativeOp
        state.text.push(" " + ast.allText + " ");
    }
    this.visit_number = function(ast, state) {
        // number
        state.text.push(ast.allText);
    }
    this.visit_parameterQualifier = function(ast, state) {
        // parameterQualifier
        state.text.push(ast.allText + " ");
    }
    this.visit_parenExpr = function(ast, state) {
        // expr
        state.text.push("(");
        this.visitChildren(ast, state);
        state.text.push(")");
    }
    this.visit_postfixExpr = function(ast, state) {
        // choice(funcCall,arrayIndex,fieldSelect,postfixOp)
        this.visitChildren(ast, state);
    }
    this.visit_postfixOp = function(ast, state) {
        // postfixOp
        state.text.push(ast.allText);
    }
    this.visit_ppDefineExpr = function(ast, state) {
        // TODO: this is an expression, BUT, the rules of name lookup don't apply. 
        state.text.push(ast.allText);
    }
    this.visit_ppDefine = function(ast, state) {
        // seq(ppDefineName, this.ppDefineArgs, this.ppDefineExpr.opt, this.ppDefineExpr.opt, this.untilEol).ast;
        state.text.push("#define ");
        this.visitNode(ast.children[0], state);
        //pushScope(state);
        for (var i=1; i < ast.children.length; ++i) {
            this.visitNode(ast.children[i], state);
        }
        //popScope(state);
        state.text.push("\n");        
    }
    this.visit_ppDefineName = function(ast, state) {
        var name = ast.allText;
        addVar(state, ast, name);
        state.text.push(name);
        state.text.push(" ");
    }
    this.visit_ppDefineArg = function(ast, state) {
        var name = ast.allText;
        //addVar(state, ast, name);
        state.text.push(name);
    }
    this.visit_ppDefineArgs = function(ast, state) {
        if (ast.children.length == 0) return;
        state.text.push("(");
        for (var i=0; i < ast.children.length; ++i) {
            if (i > 0) state.text.push(", ");
            this.visitNode(ast.children[i], state);
        }
        state.text.push(")");
    }
    this.visit_ppOther = function(ast, state) {
        state.text.push("#");
        state.text.push(ast.allText);
        state.text.push("\n");        
    }
    this.visit_ppDirective = function(ast, state) {
        // choice(ppDefine, ppOther)
        this.visitChildren(ast, state);
    }
    this.visit_precisionQualifier = function(ast, state) {
        // precisionQualifier
        state.text.push(ast.allText + " ");
    }
    this.visit_prefixOp = function(ast, state) {
        // prefixOp
        state.text.push(ast.allText);
    }
    this.visit_program = function(ast, state) {
        // topLevelDecl[0,Infinity]
        this.visitChildren(ast, state);
    }
    this.visit_qualifiers = function(ast, state) {
        // seq(invariantQualifier[0,1],storageQualifier[0,1],parameterQualifier[0,1],precisionQualifier[0,1])
        if (!this.asHeron)
        {
            this.visitChildren(ast, state);
        }
        else
        {
            if (ast.children.length > 1) {
                state.text.push('[');
                for (var i=0; i < ast.children.length; ++i) {
                    var q = ast.children[i].allText;
                    state.text.push(q + "(); ");
                }
                this.visitChildren(ast, state);
                state.text.push('] ');
            }            
        }
    }
    this.visit_recStatement = function(ast, state) {
        // recStatement
        this.visitChildren(ast, state);
    }
    this.visit_relationalExpr = function(ast, state) {
        // seq(relationalOp,expr8)
        this.visitChildren(ast, state);
    }
    this.visit_relationalOp = function(ast, state) {
        // relationalOp
        state.text.push(" " + ast.allText + " ");
    }
    this.visit_returnStatement = function(ast, state) {
        // expr[0,1]
        state.text.push("return ");
        this.visitChildren(ast, state);
        state.text.push(";");
        printNewLine(state);
    }
    this.visit_statement = function(ast, state) {
        // choice(emptyStatement,compoundStatement,ifStatement,returnStatement,continueStatement,breakStatement,forLoop,doLoop,whileLoop,varDecl,exprStatement)        
        this.visitChildren(ast, state);
    }
    this.visit_storageQualifier = function(ast, state) {
        // storageQualifier
        state.text.push(ast.allText + " ");
    }
    this.visit_structMembers    = function(ast, state) {
        // structMember[0, Infinity]
        this.visitChildren(ast, state);
    }
    this.visit_structDef = function(ast, state) {
        // seq(structTypeName,structMembers,structVarName[0,1]
        addVar(state, ast, ast.children[0].allText);
        state.text.push("struct ");
        this.visitNode(ast.children[0]);
        state.text.push(" {");
        increaseIndent(state);
        printNewLine(state);
        this.visitNode(ast.children[1]);
        state.text.push("}");
        this.visitChildren(ast, state);
        state.text.push(";");
        decreaseIndent(state);
        printNewLine(state);        
    }
    this.visit_structMember = function(ast, state) {
        // seq(qualifiers,typeExpr,varNameAndInit,varNameAndInit[0,Infinity][0,1])
        this.visitChildren(ast, state);
        state.text.push(";");
        printNewLine(state);
    }
    this.visit_structTypeName = function(ast, state) {
        // structTypeName
        state.text.push(ast.allText);
    }
    this.visit_structVarName = function(ast, state) {
        // structVarName
        state.text.push(ast.allText);
    }
    this.visit_topLevelDecl = function(ast, state) {
        // choice(ppDirective,structDef,varArraySizeDecl[0,1]),funcDef,varDecl)
        this.visitChildren(ast, state);
    }
    this.visit_typeExpr = function(ast, state) {
        // typeExpr
        state.text.push(ast.allText + " ");
    }
    this.visit_varArraySizeDecl = function(ast, state) {
        // leafExpr
        state.text.push("[");
        this.visitChildren(ast, state);
        state.text.push("]");
    }
    this.visit_varDecl = function(ast, state) {
        // seq(qualifiers,typeExpr,varNameAndInit,varNameAndInit[0,Infinity][0,1])
        var qualifiers = ast.children[0];
        var type = ast.children[1];
        if (!this.asHeron)
        {
            this.visitNode(qualifiers, state);
            this.visitNode(type, state);
            for (var i=2; i < ast.children.length; ++i) {
                if (i > 2) state.text.push(", ");
                this.visitNode(ast.children[i], state);
            }
            state.text.push(";");
            printNewLine(state);
        }
        else
        {
            for (var i=2; i < ast.children.length; ++i) {
                this.visitNode(qualifiers, state);
                state.text.push("var ")
                var varNameAndInit = ast.children[i];
                var name = varNameAndInit.children[0];
                this.visitNode(name, state);
                state.text.push(" : ");
                this.visitNode(type, state); 
                var init = varNameAndInit.children[1];
                if (init)
                    this.visitNode(init, state);
                state.text.push(";");
                printNewLine(state);
            }
        }
    }
    this.visit_varInit = function(ast, state) {
        // expr1
        if (ast.children.length > 0) {
            state.text.push(" = ");
            this.visitChildren(ast, state);
        }
    }
    this.visit_varName = function(ast, state) {
        // varName
        var name = ast.allText;
        addVar(state, ast, name);
        state.text.push(name);
    }
    this.visit_varNameAndInit = function(ast, state) {
        // seq(varName,varArraySizeDecl[0,1],varInit[0,1])        
        this.visitChildren(ast, state);
    }
    this.visit_whileLoop = function(ast, state) {
        // seq(loopCond,recStatement)
        state.text.push("while");
        state.text.push("(");
        this.visitNode(ast.children[0], state);
        state.text.push(") ");
        this.visitNode(ast.children[1], state);
    }
}

function printGlsl(ast, prims, asHeron) {
    var nodes = augmentAst(ast);
    var state =    { 
        text : [], 
        indent : 0, 
        frameStack: [],
        frameList : [], 
        vars : {},
        undefined : {},
        nodes : nodes,
    }
    pushScope(state, "");
    var oldDebugState = DEBUG1;
    DEBUG1 = false;
    for (var k in prims) {
        addVar(state, null, k, prims[k]);  
    }
    DEBUG1 = oldDebugState;
    glslPrinter.asHeron = asHeron;
    glslPrinter.visitNode(ast, state);
    state.text.push("// undefined variables \n");
    for (var u in state.undefined)
        state.text.push("//    " + u + "\n"); // + this.astLocation(state.undefined[u]) + "\n");
    return state;
}

// Export the function for use use with Node.js
if (typeof module === "object" && module.exports) 
    module.exports = printGlsl;
