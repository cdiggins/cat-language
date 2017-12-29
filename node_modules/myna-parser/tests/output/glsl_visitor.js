var glslVisitor = new function()
{
  this.visitNode = function(ast, state) {
    this['visit_' + child.name](child, state);
  }
  this.visitChildren = function(ast, state) {
    for (var child ofd ast.children)
      this.visitNode(child, state);
  }
  this.visit_additiveExpr = function(ast, stack, state) {
    // seq(additiveOp,expr9)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_additiveOp = function(ast, stack, state) {
    // additiveOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_arrayIndex = function(ast, stack, state) {
    // expr
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_assignmentExpr = function(ast, stack, state) {
    // seq(assignmentOp,expr2)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_assignmentOp = function(ast, stack, state) {
    // assignmentOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_bool = function(ast, stack, state) {
    // bool
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_breakStatement = function(ast, stack, state) {
    // breakStatement
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_compoundStatement = function(ast, stack, state) {
    // recStatement[0,Infinity]
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_conditionalElseOp = function(ast, stack, state) {
    // conditionalElseOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_conditionalExpr = function(ast, stack, state) {
    // seq(conditionalOp,expr,conditionalElseOp,expr)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_conditionalOp = function(ast, stack, state) {
    // conditionalOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_continueStatement = function(ast, stack, state) {
    // continueStatement
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_doLoop = function(ast, stack, state) {
    // seq(recStatement,loopCond)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_elseStatement = function(ast, stack, state) {
    // recStatement
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_emptyStatement = function(ast, stack, state) {
    // emptyStatement
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_equalityExpr = function(ast, stack, state) {
    // seq(equalityOp,expr7)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_equalityOp = function(ast, stack, state) {
    // equalityOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr = function(ast, stack, state) {
    // expr
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr1 = function(ast, stack, state) {
    // seq(expr2,assignmentExpr[0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr10 = function(ast, stack, state) {
    // choice(seq(prefixOp,expr11),expr11)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr11 = function(ast, stack, state) {
    // seq(expr12,postfixExpr[0,Infinity])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr12 = function(ast, stack, state) {
    // choice(parenExpr,leafExpr)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr2 = function(ast, stack, state) {
    // seq(expr3,conditionalExpr[0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr3 = function(ast, stack, state) {
    // seq(expr4,logicalOrExpr[0,Infinity])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr4 = function(ast, stack, state) {
    // seq(expr5,logicalXOrExpr[0,Infinity])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr5 = function(ast, stack, state) {
    // seq(expr6,logicalAndExpr[0,Infinity])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr6 = function(ast, stack, state) {
    // seq(expr7,equalityExpr[0,Infinity])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr7 = function(ast, stack, state) {
    // seq(expr8,relationalExpr[0,Infinity])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr8 = function(ast, stack, state) {
    // seq(expr9,additiveExpr[0,Infinity])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_expr9 = function(ast, stack, state) {
    // seq(expr10,multiplicativeExpr[0,Infinity])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_exprStatement = function(ast, stack, state) {
    // expr
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_fieldName = function(ast, stack, state) {
    // fieldName
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_fieldSelect = function(ast, stack, state) {
    // fieldName
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_forLoop = function(ast, stack, state) {
    // seq(forLoopInit,forLoopInvariant,forLoopVariant,recStatement)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_forLoopInit = function(ast, stack, state) {
    // seq(qualifiers,typeExpr,varNameAndInit,varNameAndInit[0,Infinity][0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_forLoopInvariant = function(ast, stack, state) {
    // expr[0,1]
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_forLoopVariant = function(ast, stack, state) {
    // expr[0,1]
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_funcCall = function(ast, stack, state) {
    // seq(expr,expr[0,Infinity])[0,1]
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_funcDef = function(ast, stack, state) {
    // seq(qualifiers,typeExpr,funcName,funcParams,compoundStatement)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_funcName = function(ast, stack, state) {
    // funcName
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_funcParam = function(ast, stack, state) {
    // seq(qualifiers,typeExpr,funcParamName)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_funcParamName = function(ast, stack, state) {
    // funcParamName
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_funcParams = function(ast, stack, state) {
    // seq(funcParam,funcParam[0,Infinity])[0,1]
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_identifier = function(ast, stack, state) {
    // identifier
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_ifStatement = function(ast, stack, state) {
    // seq(expr,recStatement,elseStatement[0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_invariantQualifier = function(ast, stack, state) {
    // invariantQualifier
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_leafExpr = function(ast, stack, state) {
    // choice(number,bool,identifier)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_logicalAndExpr = function(ast, stack, state) {
    // seq(logicalAndOp,expr6)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_logicalAndOp = function(ast, stack, state) {
    // logicalAndOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_logicalOrExpr = function(ast, stack, state) {
    // seq(logicalOrOp,expr4)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_logicalOrOp = function(ast, stack, state) {
    // logicalOrOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_logicalXOrExpr = function(ast, stack, state) {
    // seq(logicalXOrOp,expr5)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_logicalXOrOp = function(ast, stack, state) {
    // logicalXOrOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_loopCond = function(ast, stack, state) {
    // expr
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_multiplicativeExpr = function(ast, stack, state) {
    // seq(multiplicativeOp,expr10)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_multiplicativeOp = function(ast, stack, state) {
    // multiplicativeOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_number = function(ast, stack, state) {
    // number
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_parameterQualifier = function(ast, stack, state) {
    // parameterQualifier
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_parenExpr = function(ast, stack, state) {
    // expr
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_postfixExpr = function(ast, stack, state) {
    // choice(funcCall,arrayIndex,fieldSelect,postfixOp)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_postfixOp = function(ast, stack, state) {
    // postfixOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_ppDirective = function(ast, stack, state) {
    // ppDirective
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_precisionQualifier = function(ast, stack, state) {
    // precisionQualifier
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_prefixOp = function(ast, stack, state) {
    // prefixOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_program = function(ast, stack, state) {
    // topLevelDecl[0,Infinity]
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_qualifiers = function(ast, stack, state) {
    // seq(invariantQualifier[0,1],storageQualifier[0,1],parameterQualifier[0,1],precisionQualifier[0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_recStatement = function(ast, stack, state) {
    // recStatement
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_relationalExpr = function(ast, stack, state) {
    // seq(relationalOp,expr8)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_relationalOp = function(ast, stack, state) {
    // relationalOp
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_returnStatement = function(ast, stack, state) {
    // expr[0,1]
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_statement = function(ast, stack, state) {
    // choice(emptyStatement,compoundStatement,ifStatement,returnStatement,continueStatement,breakStatement,forLoop,doLoop,whileLoop,varDecl,exprStatement)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_storageQualifier = function(ast, stack, state) {
    // storageQualifier
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_structDef = function(ast, stack, state) {
    // seq(structTypeName,structMembers,structVarName[0,1],varArraySizeDecl[0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_structMember = function(ast, stack, state) {
    // seq(qualifiers,typeExpr,varNameAndInit,varNameAndInit[0,Infinity][0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_structMembers = function(ast, stack, state) {
    // structMember[0,Infinity]
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_structTypeName = function(ast, stack, state) {
    // structTypeName
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_structVarName = function(ast, stack, state) {
    // structVarName
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_topLevelDecl = function(ast, stack, state) {
    // choice(ppDirective,structDef,funcDef,varDecl)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_typeExpr = function(ast, stack, state) {
    // typeExpr
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_varArraySizeDecl = function(ast, stack, state) {
    // leafExpr
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_varDecl = function(ast, stack, state) {
    // seq(qualifiers,typeExpr,varNameAndInit,varNameAndInit[0,Infinity][0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_varInit = function(ast, stack, state) {
    // expr1
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_varName = function(ast, stack, state) {
    // varName
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_varNameAndInit = function(ast, stack, state) {
    // seq(varName,varArraySizeDecl[0,1],varInit[0,1])
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
  this.visit_whileLoop = function(ast, stack, state) {
    // seq(loopCond,recStatement)
    // TODO: add custom implementation
    this.visitChildren(ast, stack, state);
  }
}