"use strict";
// A Type Inference Algorithm that provides support for full inference 
// of non-recursive higher rank polymorphic types.
//
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
// The one and only module
var TypeInference;
(function (TypeInference) {
    // Turn on for debugging purposes
    TypeInference.trace = false;
    // Base class of a type: either a TypeArray, TypeVariable, or TypeConstant
    var Type = /** @class */ (function () {
        function Type() {
            // All type varible referenced somewhere by the type, or the type itself if it is a TypeVariable.
            this.typeVars = [];
        }
        Type.prototype.clone = function (newTypes) {
            throw new Error("Clone must be overridden in derived class");
        };
        return Type;
    }());
    TypeInference.Type = Type;
    // A collection of a fixed number of types can be used to represent function types or tuple types. 
    // A list of types is usually encoded as a nested set of type pairs (TypeArrays with two elements).
    // If a TypeArray has Type parameters, quantified unbound type variables, it is considered a "PolyType".
    // Binding type variables is done through the clone function 
    var TypeArray = /** @class */ (function (_super) {
        __extends(TypeArray, _super);
        function TypeArray(types, computeParameters) {
            var _this = _super.call(this) || this;
            _this.types = types;
            // The type variables that are bound to this TypeArray. 
            // Always a subset of typeVars. This could have the same type variable repeated twice. 
            _this.typeParameterVars = [];
            // Compute all referenced types 
            for (var _i = 0, types_1 = types; _i < types_1.length; _i++) {
                var t = types_1[_i];
                _this.typeVars = _this.typeVars.concat(t.typeVars);
            }
            // Given just a type with type variables the sete of type parameters 
            // can be inferred based on where they occur in the type tree
            if (computeParameters)
                _this.computeParameters();
            return _this;
        }
        // A helper function to copy a parameter list 
        TypeArray.prototype.cloneParameters = function (dest, from, newTypes) {
            var params = [];
            for (var _i = 0, from_1 = from; _i < from_1.length; _i++) {
                var tv = from_1[_i];
                var param = newTypes[tv.name];
                if (param == undefined)
                    throw new Error("Could not find type parameter: " + tv.name);
                params.push(param);
            }
            dest.typeParameterVars = params;
        };
        // Returns a copy of the type array, substituting type variables using the lookup table.        
        TypeArray.prototype.clone = function (newTypes) {
            var r = new TypeArray(this.types.map(function (t) { return t.clone(newTypes); }), false);
            this.cloneParameters(r, this.typeParameterVars, newTypes);
            return r;
        };
        TypeArray.prototype.freshVariableNames = function (id) {
            var newTypes = {};
            for (var _i = 0, _a = descendantTypes(this); _i < _a.length; _i++) {
                var t = _a[_i];
                if (t instanceof TypeVariable)
                    newTypes[t.name] = new TypeVariable(t.name + "$" + id);
            }
            return this.clone(newTypes);
        };
        // Returns a copy of the type array creating new parameter names. 
        TypeArray.prototype.freshParamNames = function (id) {
            // Create a lookup table for the type parameters with new names 
            var newTypes = {};
            for (var _i = 0, _a = this.typeParameterNames; _i < _a.length; _i++) {
                var tp = _a[_i];
                newTypes[tp] = new TypeVariable(tp + "$" + id);
            }
            // Clone all of the types.             
            var types = this.types.map(function (t) { return t.clone(newTypes); });
            // Recursively call "freshParameterNames" on child type arrays as needed. 
            types = types.map(function (t) { return t instanceof TypeArray ? t.freshParamNames(id) : t; });
            var r = new TypeArray(types, false);
            // Now recreate the type parameter list
            this.cloneParameters(r, this.typeParameterVars, newTypes);
            return r;
        };
        Object.defineProperty(TypeArray.prototype, "typeParameterNames", {
            // A list of the parameter names (without repetition)
            get: function () {
                return uniqueStrings(this.typeParameterVars.map(function (tv) { return tv.name; })).sort();
            },
            enumerable: true,
            configurable: true
        });
        // Infer which type variables are actually type parameters (universally quantified) 
        // based on their position.
        TypeArray.prototype.computeParameters = function () {
            this.typeParameterVars = [];
            // Recursively compute the parameters for base types
            this.types.forEach(function (t) { if (t instanceof TypeArray)
                t.computeParameters(); });
            for (var i = 0; i < this.types.length; ++i) {
                var child = this.types[i];
                // Individual type variables are part of this scheme 
                if (child instanceof TypeVariable)
                    _reassignAllTypeVars(child.name, this);
                else if (child instanceof TypeArray) {
                    // Get the vars of the child type. 
                    // If any of them show up in multiple child arrays, then they 
                    // are part of the parent's child 
                    for (var _i = 0, _a = child.typeVars; _i < _a.length; _i++) {
                        var childVar = _a[_i];
                        if (_isTypeVarUsedElsewhere(this, childVar.name, i))
                            _reassignAllTypeVars(childVar.name, this);
                    }
                }
            }
            // Implementation validation step:
            // Assure that the type scheme variables are all in the typeVars 
            for (var _b = 0, _c = this.typeParameterVars; _b < _c.length; _b++) {
                var v = _c[_b];
                var i = this.typeVars.indexOf(v);
                if (i < 0)
                    throw new Error("Internal error: type scheme references a variable that is not marked as referenced by the type variable");
            }
        };
        Object.defineProperty(TypeArray.prototype, "typeParametersToString", {
            // Provides a user friendly representation of the type scheme (list of type parameters)
            get: function () {
                return this.isPolyType
                    ? "!" + this.typeParameterNames.join("!") + "."
                    : "";
            },
            enumerable: true,
            configurable: true
        });
        Object.defineProperty(TypeArray.prototype, "isPolyType", {
            // Returns true if there is at least one type parameter associated with this type array
            get: function () {
                return this.typeParameterVars.length > 0;
            },
            enumerable: true,
            configurable: true
        });
        //  A user friendly name 
        TypeArray.prototype.toString = function () {
            return this.typeParametersToString + "(" + this.types.join(' ') + ")";
        };
        return TypeArray;
    }(Type));
    TypeInference.TypeArray = TypeArray;
    // A type variable is used for generics (e.g. T0, TR). 
    // The type variable must belong to a type scheme of a polytype. This is like a "scope" for type variables.
    // Computing the type schema is done in an external function.
    var TypeVariable = /** @class */ (function (_super) {
        __extends(TypeVariable, _super);
        function TypeVariable(name) {
            var _this = _super.call(this) || this;
            _this.name = name;
            _this.typeVars.push(_this);
            return _this;
        }
        TypeVariable.prototype.clone = function (newTypes) {
            return this.name in newTypes
                ? newTypes[this.name]
                : newTypes[this.name] = new TypeVariable(this.name);
        };
        TypeVariable.prototype.toString = function () {
            return this.name;
        };
        return TypeVariable;
    }(Type));
    TypeInference.TypeVariable = TypeVariable;
    // A type constant is a fixed type (e.g. int, function). Also called a MonoType.
    var TypeConstant = /** @class */ (function (_super) {
        __extends(TypeConstant, _super);
        function TypeConstant(name) {
            var _this = _super.call(this) || this;
            _this.name = name;
            return _this;
        }
        TypeConstant.prototype.toString = function () {
            return this.name;
        };
        TypeConstant.prototype.clone = function (newTypes) {
            return new TypeConstant(this.name);
        };
        return TypeConstant;
    }(Type));
    TypeInference.TypeConstant = TypeConstant;
    // A type unifier is a mapping from a type variable to a best-fit type
    var TypeUnifier = /** @class */ (function () {
        function TypeUnifier(name, unifier) {
            this.name = name;
            this.unifier = unifier;
        }
        return TypeUnifier;
    }());
    TypeInference.TypeUnifier = TypeUnifier;
    // This is helper function helps determine whether a type variable should belong 
    function _isTypeVarUsedElsewhere(t, varName, pos) {
        for (var i = 0; i < t.types.length; ++i)
            if (i != pos && t.types[i].typeVars.some(function (v) { return v.name == varName; }))
                return true;
        return false;
    }
    TypeInference._isTypeVarUsedElsewhere = _isTypeVarUsedElsewhere;
    // Associate the variable with a new type scheme. Removing it from the previous varScheme 
    function _reassignVarScheme(v, t) {
        // Remove the variable from all other type schemes below the given one. 
        for (var _i = 0, _a = descendantTypes(t); _i < _a.length; _i++) {
            var x = _a[_i];
            if (x instanceof TypeArray)
                x.typeParameterVars = x.typeParameterVars.filter(function (vd) { return vd.name != v.name; });
        }
        t.typeParameterVars.push(v);
    }
    TypeInference._reassignVarScheme = _reassignVarScheme;
    // Associate all variables of the given name in the TypeArray with the TypeArray's scheme
    function _reassignAllTypeVars(varName, t) {
        t.typeVars.filter(function (v) { return v.name == varName; }).forEach(function (v) { return _reassignVarScheme(v, t); });
    }
    TypeInference._reassignAllTypeVars = _reassignAllTypeVars;
    // Use this class to unify types that are constrained together.
    var Unifier = /** @class */ (function () {
        function Unifier() {
            // Used for generate fresh variable names 
            this.id = 0;
            // Given a type variable name find the unifier. Multiple type variables will map to the same unifier 
            this.unifiers = {};
        }
        // Unify both types, returning the most specific type possible. 
        // When a type variable is unified with something the new unifier is stored. 
        // Note: TypeFunctions and TypePairs ar handled as TypeArrays
        // * Constants are preferred over lists and variables
        // * Lists are preferred over variables
        // * Given two variables, the first one is chosen. 
        Unifier.prototype.unifyTypes = function (t1, t2, depth) {
            if (depth === void 0) { depth = 0; }
            if (TypeInference.trace)
                console.log("Unification depth " + depth + " of " + t1 + " and " + t2);
            if (!t1 || !t2)
                throw new Error("Missing type expression");
            if (t1 == t2)
                return t1;
            // Variables are least preferred.  
            if (t1 instanceof TypeVariable) {
                return this._updateUnifier(t1, t2, depth);
            }
            else if (t2 instanceof TypeVariable) {
                return this._updateUnifier(t2, t1, depth);
            }
            else if (t1 instanceof TypeConstant && t2 instanceof TypeConstant) {
                if (t1.name != t2.name)
                    throw new Error("Can't unify: " + t1.name + " and " + t2.name);
                else
                    return t1;
            }
            else if (t1 instanceof TypeConstant || t2 instanceof TypeConstant) {
                throw new Error("Can't unify: " + t1 + " and " + t2);
            }
            else if (t1 instanceof TypeArray && t2 instanceof TypeArray) {
                return this._unifyLists(t1, t2, depth + 1);
            }
            throw new Error("Internal error, unexpected code path: " + t1 + " and " + t2);
        };
        // Debug function that dumps prints out a representation of the engine state. 
        Unifier.prototype.state = function () {
            var results = [];
            for (var k in this.unifiers) {
                var u = this.unifiers[k];
                var t = this.getUnifiedType(u.unifier, [], {});
                results.push("type unifier for " + k + ", unifier name " + u.name + ", unifying type " + t);
            }
            return results.join('\n');
        };
        // Replaces all variables in a type expression with the unified version
        // The previousVars variable allows detection of cyclical references
        Unifier.prototype.getUnifiedType = function (expr, previousVars, unifiedVars) {
            var _this = this;
            if (expr instanceof TypeConstant)
                return expr;
            else if (expr instanceof TypeVariable) {
                // If we encountered the type variable previously, it meant that there is a recursive relation
                for (var i = 0; i < previousVars.length; ++i)
                    if (previousVars[i] == expr.name)
                        return recursiveType(i);
                var u = this.unifiers[expr.name];
                if (!u)
                    return expr;
                else if (u.unifier instanceof TypeVariable)
                    return u.unifier;
                else if (u.unifier instanceof TypeConstant)
                    return u.unifier;
                else if (u.unifier instanceof TypeArray) {
                    if (u.name in unifiedVars) {
                        // We have already seen this unified var before
                        var u2 = u.unifier.freshParamNames(unifiedVars[u.name] += 1);
                        return this.getUnifiedType(u2, [expr.name].concat(previousVars), unifiedVars);
                    }
                    else {
                        unifiedVars[u.name] = 0;
                        return this.getUnifiedType(u.unifier, [expr.name].concat(previousVars), unifiedVars);
                    }
                }
                else
                    throw new Error("Unhandled kind of type " + expr);
            }
            else if (expr instanceof TypeArray) {
                var types = expr.types.map(function (t) { return _this.getUnifiedType(t, previousVars, unifiedVars); });
                var r = new TypeArray(types, false);
                return r;
            }
            else
                throw new Error("Unrecognized kind of type expression " + expr);
        };
        // Choose one of two unifiers, or continue the unification process if necessary
        Unifier.prototype._chooseBestUnifier = function (t1, t2, depth) {
            var r;
            if (t1 instanceof TypeVariable && t2 instanceof TypeVariable)
                r = t1;
            else if (t1 instanceof TypeVariable)
                r = t2;
            else if (t2 instanceof TypeVariable)
                r = t1;
            else
                r = this.unifyTypes(t1, t2, depth + 1);
            if (TypeInference.trace)
                console.log("Chose type for unification " + r + " between " + t1 + " and " + t2 + " at depth " + depth);
            return r;
        };
        // Unifying lists involves unifying each element
        Unifier.prototype._unifyLists = function (list1, list2, depth) {
            if (list1.types.length != list2.types.length)
                throw new Error("Cannot unify differently sized lists: " + list1 + " and " + list2);
            var rtypes = [];
            for (var i = 0; i < list1.types.length; ++i)
                rtypes.push(this.unifyTypes(list1.types[i], list2.types[i], depth));
            // We just return the first list for now. 
            return list1;
        };
        // All unifiers that refer to varName as the unifier are pointed to the new unifier 
        Unifier.prototype._updateVariableUnifiers = function (varName, u) {
            for (var x in this.unifiers) {
                var t = this.unifiers[x].unifier;
                if (t instanceof TypeVariable)
                    if (t.name == varName)
                        this.unifiers[x] = u;
            }
        };
        // Computes the best unifier between the current unifier and the new variable.        
        // Updates all unifiers which point to a (or to t if t is a TypeVar) to use the new type. 
        Unifier.prototype._updateUnifier = function (a, t, depth) {
            var u = this._getOrCreateUnifier(a);
            if (t instanceof TypeVariable)
                t = this._getOrCreateUnifier(t).unifier;
            u.unifier = this._chooseBestUnifier(u.unifier, t, depth);
            this._updateVariableUnifiers(a.name, u);
            if (t instanceof TypeVariable)
                this._updateVariableUnifiers(t.name, u);
            return u.unifier;
        };
        // Gets or creates a type unifiers for a type variables
        Unifier.prototype._getOrCreateUnifier = function (t) {
            if (!(t.name in this.unifiers))
                return this.unifiers[t.name] = new TypeUnifier(t.name, t);
            else
                return this.unifiers[t.name];
        };
        return Unifier;
    }());
    TypeInference.Unifier = Unifier;
    //======================================================================================
    // Helper functions 
    // Creates a type list as nested pairs ("cons" cells ala lisp). 
    // The last type is assumed to be a row variable. 
    function rowPolymorphicList(types) {
        if (types.length == 0)
            throw new Error("Expected a type list with at least one type variable");
        else if (types.length == 1) {
            if (types[0] instanceof TypeVariable)
                return types[0];
            else
                throw new Error("Expected a row variable in the final position");
        }
        else
            return typeArray([types[0], rowPolymorphicList(types.slice(1))]);
    }
    TypeInference.rowPolymorphicList = rowPolymorphicList;
    // Creates a row-polymorphic function type: adding the implicit row variable 
    function rowPolymorphicFunction(inputs, outputs) {
        var row = typeVariable('_');
        inputs.push(row);
        outputs.push(row);
        return functionType(rowPolymorphicList(inputs), rowPolymorphicList(outputs));
    }
    TypeInference.rowPolymorphicFunction = rowPolymorphicFunction;
    // Creates a type array from an array of types
    function typeArray(types) {
        return new TypeArray(types, true);
    }
    TypeInference.typeArray = typeArray;
    // Creates a type constant 
    function typeConstant(name) {
        return new TypeConstant(name);
    }
    TypeInference.typeConstant = typeConstant;
    // Creates a type variable
    function typeVariable(name) {
        return new TypeVariable(name);
    }
    TypeInference.typeVariable = typeVariable;
    // Creates a function type, as a special kind of a TypeArray 
    function functionType(input, output) {
        return typeArray([input, typeConstant('->'), output]);
    }
    TypeInference.functionType = functionType;
    // Creates an array type, as a special kind of TypeArray
    function arrayType(element) {
        return typeArray([element, typeConstant('[]')]);
    }
    TypeInference.arrayType = arrayType;
    // Creates a list type, as a special kind of TypeArray
    function listType(element) {
        return typeArray([element, typeConstant('*')]);
    }
    TypeInference.listType = listType;
    // Creates a recursive type, as a special kind of TypeArray. The numberical value 
    // refers to the depth of the recursion: how many TypeArrays you have to go up 
    // to find the recurison base case. 
    function recursiveType(depth) {
        return typeArray([typeConstant('rec'), typeConstant(depth.toString())]);
    }
    TypeInference.recursiveType = recursiveType;
    // Returns true if and only if the type is a type constant with the specified name
    function isTypeConstant(t, name) {
        return t instanceof TypeConstant && t.name === name;
    }
    TypeInference.isTypeConstant = isTypeConstant;
    // Returns true if and only if the type is a type constant with the specified name
    function isTypeVariable(t, name) {
        return t instanceof TypeVariable && t.name === name;
    }
    TypeInference.isTypeVariable = isTypeVariable;
    // Returns true if any of the types are the type variable
    function variableOccurs(name, type) {
        return descendantTypes(type).some(function (t) { return isTypeVariable(t, name); });
    }
    TypeInference.variableOccurs = variableOccurs;
    // Returns true if and only if the type is a type constant with the specified name
    function isTypeArray(t, name) {
        return t instanceof TypeArray && t.types.length == 2 && isTypeConstant(t.types[1], '[]');
    }
    TypeInference.isTypeArray = isTypeArray;
    // Returns true iff the type is a TypeArary representing a function type
    function isFunctionType(t) {
        return t instanceof TypeArray && t.types.length == 3 && isTypeConstant(t.types[1], '->');
    }
    TypeInference.isFunctionType = isFunctionType;
    // Returns the input types (argument types) of a TypeArray representing a function type
    function functionInput(t) {
        if (!isFunctionType(t))
            throw new Error("Expected a function type");
        return t.types[0];
    }
    TypeInference.functionInput = functionInput;
    // Returns the output types (return types) of a TypeArray representing a function type
    function functionOutput(t) {
        if (!isFunctionType(t))
            throw new Error("Expected a function type");
        return t.types[2];
    }
    TypeInference.functionOutput = functionOutput;
    // Returns all types contained in this type
    function descendantTypes(t, r) {
        if (r === void 0) { r = []; }
        r.push(t);
        if (t instanceof TypeArray)
            t.types.forEach(function (t2) { return descendantTypes(t2, r); });
        return r;
    }
    TypeInference.descendantTypes = descendantTypes;
    // Returns true if the type is a polytype
    function isPolyType(t) {
        return t instanceof TypeArray && t.typeParameterVars.length > 0;
    }
    TypeInference.isPolyType = isPolyType;
    // Returns true if the type is a function that generates a polytype.
    function generatesPolytypes(t) {
        if (!isFunctionType(t))
            return false;
        return descendantTypes(functionOutput(t)).some(isPolyType);
    }
    TypeInference.generatesPolytypes = generatesPolytypes;
    // Returns the type of the id function 
    function idFunction() {
        var s = typeVariable('_');
        return functionType(s, s);
    }
    TypeInference.idFunction = idFunction;
    //========================================================
    // Variable name functions
    // Rename all type variables os that they follow T0..TN according to the order the show in the tree. 
    function normalizeVarNames(t) {
        var names = {};
        var count = 0;
        for (var _i = 0, _a = descendantTypes(t); _i < _a.length; _i++) {
            var dt = _a[_i];
            if (dt instanceof TypeVariable)
                if (!(dt.name in names))
                    names[dt.name] = typeVariable("t" + count++);
        }
        return t.clone(names);
    }
    TypeInference.normalizeVarNames = normalizeVarNames;
    // Converts a number to a letter from 'a' to 'z'.
    function numberToLetters(n) {
        return String.fromCharCode(97 + n);
    }
    // Rename all type variables so that they are alphabetical in the order they occur in the tree
    function alphabetizeVarNames(t) {
        var names = {};
        var count = 0;
        for (var _i = 0, _a = descendantTypes(t); _i < _a.length; _i++) {
            var dt = _a[_i];
            if (dt instanceof TypeVariable)
                if (!(dt.name in names))
                    names[dt.name] = typeVariable(numberToLetters(count++));
        }
        return t.clone(names);
    }
    TypeInference.alphabetizeVarNames = alphabetizeVarNames;
    // Compares whether two types are the same after normalizing the type variables. 
    function areTypesSame(t1, t2) {
        var s1 = normalizeVarNames(t1).toString();
        var s2 = normalizeVarNames(t2).toString();
        return s1 === s2;
    }
    TypeInference.areTypesSame = areTypesSame;
    function variableOccursOnInput(varName, type) {
        for (var _i = 0, _a = descendantTypes(type); _i < _a.length; _i++) {
            var t = _a[_i];
            if (isFunctionType(t)) {
                var input = functionInput(type);
                if (variableOccurs(varName, input)) {
                    return true;
                }
            }
        }
    }
    TypeInference.variableOccursOnInput = variableOccursOnInput;
    // Returns true if and only if the type is valid 
    function isValid(type) {
        for (var _i = 0, _a = descendantTypes(type); _i < _a.length; _i++) {
            var t = _a[_i];
            if (isTypeConstant(t, "rec")) {
                return false;
            }
            else if (t instanceof TypeArray) {
                if (isFunctionType(t))
                    for (var _b = 0, _c = t.typeParameterNames; _b < _c.length; _b++) {
                        var p = _c[_b];
                        if (!variableOccursOnInput(p, t))
                            return false;
                    }
            }
        }
        return true;
    }
    TypeInference.isValid = isValid;
    //==========================================================================================
    // Type Environments 
    // 
    // This is the top-level implementation of a type inference algorithm that would be used in 
    // a programming language. 
    // Used to track equivalencies between types 
    var TypeConstraint = /** @class */ (function () {
        function TypeConstraint(a, b, location) {
            this.a = a;
            this.b = b;
            this.location = location;
        }
        return TypeConstraint;
    }());
    // An example implementation of a type environment. Used to implement a type inference algorithm
    // in a typical language with variable tracking and scopes.
    var TypeEnv = /** @class */ (function () {
        function TypeEnv() {
            this.unifier = new Unifier();
            this.scopes = [{}];
            this.history = [{}];
            this.index = 0;
        }
        TypeEnv.prototype.pushScope = function () {
            var scope = {};
            this.history.push(scope);
            this.scopes.push(scope);
        };
        TypeEnv.prototype.popScope = function () {
            this.scopes.pop();
        };
        TypeEnv.prototype.currentScope = function () {
            return this.scopes[this.scopes.length - 1];
        };
        TypeEnv.prototype.getName = function (name) {
            for (var _i = 0, _a = this.scopes; _i < _a.length; _i++) {
                var scope = _a[_i];
                if (name in scope)
                    return scope[name];
            }
            throw new Error("Could not find name: " + name);
        };
        TypeEnv.prototype.addName = function (name) {
            var scope = this.currentScope();
            if (name in scope)
                throw new Error("Name already defined in current scope: " + name);
            return scope[name] = null;
        };
        TypeEnv.prototype.findNameScope = function (name) {
            for (var i = this.scopes.length - 1; i >= 0; ++i) {
                var scope = this.scopes[i];
                if (name in scope)
                    return scope;
            }
            throw new Error("Could not find name in any of the scopes: " + name);
        };
        TypeEnv.prototype.addConstraint = function (a, b, location) {
            this.constraints.push(new TypeConstraint(a, b, location));
        };
        TypeEnv.prototype.addAssignment = function (name, type, location) {
            if (location === void 0) { location = null; }
            var scope = this.findNameScope(name);
            if (scope[name] == null)
                scope[name] = type;
            else
                this.addConstraint(scope[name], type, location);
            return type;
        };
        TypeEnv.prototype.addFunctionCall = function (name, args, location) {
            if (location === void 0) { location = null; }
            var funcType = this.findNameScope(name)[name];
            if (!isFunctionType(funcType))
                throw new Error("Not a function type associated with " + name);
            var input = functionInput(funcType);
            var output = functionOutput(funcType);
            this.addConstraint(input, output, location);
            return output;
        };
        return TypeEnv;
    }());
    TypeInference.TypeEnv = TypeEnv;
    //============================================================
    // Top level type operations  
    // - Composition
    // - Application
    // - Quotation
    // Returns the function type that results by composing two function types
    function composeFunctions(f, g) {
        if (!isFunctionType(f))
            throw new Error("Expected a function type for f");
        if (!isFunctionType(g))
            throw new Error("Expected a function type for g");
        f = f.freshVariableNames(0);
        g = g.freshVariableNames(1);
        if (TypeInference.trace) {
            console.log("f: " + f);
            console.log("g: " + g);
        }
        var inF = functionInput(f);
        var outF = functionOutput(f);
        var inG = functionInput(g);
        var outG = functionOutput(g);
        var e = new Unifier();
        e.unifyTypes(outF, inG);
        var input = e.getUnifiedType(inF, [], {});
        var output = e.getUnifiedType(outG, [], {});
        var r = functionType(input, output);
        if (TypeInference.trace) {
            console.log(e.state());
            console.log("Intermediate result: " + r);
        }
        //r = r.freshParameterNames(0);
        // Recompute parameters.
        r.computeParameters();
        if (TypeInference.trace) {
            console.log("Final result: " + r);
        }
        return r;
    }
    TypeInference.composeFunctions = composeFunctions;
    // Composes a chain of functions
    function composeFunctionChain(fxns) {
        if (fxns.length == 0)
            return idFunction();
        var t = fxns[0];
        for (var i = 1; i < fxns.length; ++i)
            t = composeFunctions(t, fxns[i]);
        return t;
    }
    TypeInference.composeFunctionChain = composeFunctionChain;
    // Applies a function to input arguments and returns the result 
    function applyFunction(fxn, args) {
        var u = new Unifier();
        fxn = fxn.clone({});
        args = args.clone({});
        var input = functionInput(fxn);
        var output = functionOutput(fxn);
        u.unifyTypes(input, args);
        return u.getUnifiedType(output, [], {});
    }
    TypeInference.applyFunction = applyFunction;
    // Creates a function type that generates the given type 
    function quotation(x) {
        var row = typeVariable('_');
        return functionType(row, typeArray([x, row]));
    }
    TypeInference.quotation = quotation;
    //=========================================================
    // A simple helper class for implementing scoped programming languages with names like the lambda calculus.
    // This class is more intended as an example of usage of the algorithm than for use in production code    
    var ScopedTypeInferenceEngine = /** @class */ (function () {
        function ScopedTypeInferenceEngine() {
            this.id = 0;
            this.names = [];
            this.types = [];
            this.unifier = new Unifier();
        }
        ScopedTypeInferenceEngine.prototype.applyFunction = function (t, args) {
            if (!isFunctionType(t)) {
                // Only variables and functions can be applied 
                if (!(t instanceof TypeVariable))
                    throw new Error("Type associated with " + name + " is neither a function type or a type variable: " + t);
                // Generate a new function type 
                var newInputType = typeVariable(t.name + "_i");
                var newOutputType = typeVariable(t.name + "_o");
                var fxnType = functionType(newInputType, newOutputType);
                // Unify the new function type with the old variable 
                this.unifier.unifyTypes(t, fxnType);
                t = fxnType;
            }
            this.unifier.unifyTypes(functionInput(t), args);
            var r = functionOutput(t);
            return this.unifier.getUnifiedType(r, [], {});
        };
        ScopedTypeInferenceEngine.prototype.introduceVariable = function (name) {
            var t = typeVariable(name + '$' + this.id++);
            this.names.push(name);
            this.types.push(t);
            return t;
        };
        ScopedTypeInferenceEngine.prototype.lookupOrIntroduceVariable = function (name) {
            var n = this.indexOfVariable(name);
            return (n < 0) ? this.introduceVariable(name) : this.types[n];
        };
        ScopedTypeInferenceEngine.prototype.assignVariable = function (name, t) {
            return this.unifier.unifyTypes(this.lookupVariable(name), t);
        };
        ScopedTypeInferenceEngine.prototype.indexOfVariable = function (name) {
            return this.names.lastIndexOf(name);
        };
        ScopedTypeInferenceEngine.prototype.lookupVariable = function (name) {
            var n = this.indexOfVariable(name);
            if (n < 0)
                throw new Error("Could not find variable: " + name);
            return this.types[n];
        };
        ScopedTypeInferenceEngine.prototype.getUnifiedType = function (t) {
            var r = this.unifier.getUnifiedType(t, [], {});
            if (r instanceof TypeArray)
                r.computeParameters();
            return r;
        };
        ScopedTypeInferenceEngine.prototype.popVariable = function () {
            this.types.pop();
            this.names.pop();
        };
        return ScopedTypeInferenceEngine;
    }());
    TypeInference.ScopedTypeInferenceEngine = ScopedTypeInferenceEngine;
    //=====================================================================
    // General purpose utility functions
    // Returns only the uniquely named strings
    function uniqueStrings(xs) {
        var r = {};
        for (var _i = 0, xs_1 = xs; _i < xs_1.length; _i++) {
            var x = xs_1[_i];
            r[x] = true;
        }
        return Object.keys(r);
    }
    TypeInference.uniqueStrings = uniqueStrings;
})(TypeInference = exports.TypeInference || (exports.TypeInference = {}));
//# sourceMappingURL=type_inference.js.map