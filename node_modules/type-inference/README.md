# Type Inference for Rank-N Polymorphic Types

This is a practical implementation in TypeScript of a type inference algorithm that can infer non-recursive rank-n polymorphic types without user supplied type annotations. This is more powerful than type reconstruction for the  Hindley-Milner type system (aka Hindley Milner Damas Type inference or Algorithm W) which only allows universal quantifiers to occur at the top level. 

# Source Code and Dependencies 

All of the source code is constained in a single TypeScript file [type_inference.ts](https://github.com/cdiggins/type-inference/blob/master/type_inference.ts). The tests are contained in the file [test.ts](https://github.com/cdiggins/type-inference/blob/master/test.ts). The tests have a dependency on the [Myna parser](https://github.com/cdiggins/myna-parser).

# Motivation 

Most programming languages with support for parametric (aka generic) types don't allow programmers to use generic types as type parameters. Instead generic types have to be converted to non-polymorphic types by supplying non-polymorphic types for each type parameter before they can be used. Described another way these languages only support rank-1 polymorphism, also called prenex polymorphism.

Strongly typed languages with type inference usually can only infer types for certain expressions making them hard to learn for new users because they quickly find themselves in situiations where they have to understand the intricacies and limitations of the type system, and how to write complex types in situations that would be easy to express in a dynamic language (e.g. Python and JavaScript).

I believe that full type inference in a programming language with higher rank type polymorphism can give programmers the convenience and smooth learning curve of a dynamic programming language with the safety, security, and efficiency of a strongly typed programming language. 

## Limitations 

The type inference algorithm implemented is restricted in that it cannot properly infer recursive types, therefore it cannot be used to infer all types in an impredicative (first class) polymorphic system. Any recursive type is considered illegal. 

## Typed Lambda Calculus

The following are some examples of types inferred for common terms in the lambda calculus using the class `ScopedTypeInferenceEngine`. 

```
    i = \x.x                : !a.(a -> a)
    k = \x.\y.x             : !a.(a -> !b.(b -> a))
    s = \x.\y.\z.x z (y z)  : !a!b!c.((a -> (b -> c)) -> ((a -> b) -> (a -> c)))
    b = \x.\y.\z.x (y z)    : !a!b.((a -> b) -> !c.((c -> a) -> (c -> b)))
    c = \x.\y.\z.x y z      : !a!b!c.((a -> (b -> c)) -> (a -> (b -> c)))
    w = \x.\y.x y y         : !a!b.((a -> (a -> b)) -> (a -> b))
    m = \x.x x              : !a.((((rec 0) -> a) -> a) -> a)
```

# Implementation Overview

The basic algorithm is as follows:

* Step 1 (renaming): Uniquely name all type variables 
* Step 2 (forall inference): Infer the position of all forall quantifiers in type arrays
* Step 3 (unify constraint): Given a constraint between two types find a unifier for each variable.
* Step 4 (substitution): Given a type signature compute a new signature by subsituting all type variables in the given type signature with the appropriate unifying type.
* Step 5 (forall inference): Infer the position of all forall quanitifer in the resulting type.

During step 4 (substitution), if a polytype is substituted for a type variable more than once each subsequent instance is given a new set of names for the generic type parameters. This is key for the step 5 to be able to correctly assign the forall quantifiers to the right level of nesting. 

## Implementation Details 

Types are represented by the `Type` class. There are three kinds of types derived from this class: 

1. `TypeConstant` - Represents monotypes (simple non-plymorphic types)
2. `TypeVariable` - Represents a universally quantified type variable, also known as a generic type parameter. 
3. `TypeArray` - A fixed-size collection of types that may or may not have universally quantified type parameters

Other kinds of types, like functions and arrays, are encoded as special cases of type arrays. 

## Recursive Types

Recursive types are not supported but will be reported by the system when inferred. They are identified by a type pair with the special name `Rec` and the depth of the recursive relation as an integer. For example: `(Rec 0)`. Any type containing a `Rec` form should be considered illegal, and will not unify correctly, but the algorithm will nonetheless detect recurrence relations in type relations and report them as if they were a valid type. 

## Type Constants 

A type constant is an atomic non-polymorphic type. It can be an identifier (e.g. `Num` or `Bool`), a number (e.g. `0` or `42`), or a symbol (i.e. `->` or `[]`). The symbols and numbers have no special meaning to the type inference algorithm and are just treated the same as ordinary type constants with identifiers. Type constants can be be used as unifiers associated with type variables and two type cosntants can't be unified together if they are different.

## Type Arrays

A type array is an ordered collection of 0 or more types. It is written out as a sequence of type expressions seprated by whitespace and surrounded by parentheses. Some example are: `()`, `(Num Bool)`, `(a [])`, `(b -> c)`, `(a (b (c)))`. 

A type array may be monomorphic or polymorphic (i.e. have type parameters). Using symbolic type constants in a type array are used as a way of making them more readable and to help a language implementation associate different meaning to certain type arrays. For example: `(Num Num -> Bool)` can be used to represent the function type that takes two numbers and returns a boolean value, and the `((Num []) [])` can be used to represent an array of arrays of numbers. 

## Polymorphic Types 

A polymorphic type (aka polytype, type scheme, generic type, or parametric type) is a type array that has one or more type parameters that are universally quantified. Type parameters are bound to universal quantifiers, represented as a `!` in the syntax. 

For example: `!a.(a [])`, `!a!b.(pair a b)`, `!a!b.((a []) Num (a -> b) -> (b []))`

## Type Variables 

Type variables are the free occurrences of a type parameters that can be replaced a valid type expression. A type variable must be contained polymorphic type that contains the type parameter. 

# Type Encodings 

In a practical setting it is important to encode many different kinds of types such as functions, tuples, structs, arrays, and more. These can all be described using type arrays with special type constants, and the type inference algorithm can deal with them seamlessly. In this section several different encodings are described. 

## Encoding Function Types 

A function is encoded as a type array with 3 elements: the first element representing the arguments, the second element is the special type constant `->` and the third is a type that represents the function return types.

For example the type `((Num Num) -> Bool)` represents a function that converts a type array of two `Num` types to a single `Bool` type. 

## Encoding Type Lists 

A type list is encoded a pair of types (a type array of two elements) where the first element is the head of the list, and the second element is the rest of the list. Usually the type in the last position is a type variable which enables two type lists with different number of elements to be unified. 

## Encoding Array Types

An array type (not to be confused with an array of types) can be encoded as a type array of two elements: the type of elements in the followed by the special type constant `[]`.

For example: `!T.((T []) -> Num)` encodes the type of a function that accepts convert 

# Row Polymorphism

Two sequences of types of different lengths can be unified if they are encoded as type lists with a type variable in the tail position.

This is useful to express concepts like a function that accept all tuples that have at least one or two items, such as a `dup`, `pop`, or `swap` operation that works on stacks. The type then would be written as:

```
pop  : !a!s.((a s) -> s)))
dup  : !a!s.((a s) -> (a (a s)))
swap : !a!b!s.(a (b s) -> (b (a s)))
```

# Top-Level Type Operators

There are three top-level type operators provided:

1. Application - Given a function type, and the type of the arguments, returns the output type.
2. Composition - Given two functions types (f and g) returns a new type representing the composition of the two functions. 
3. Quotation - Given a type x generates a row-polymorphic function that will take any type (a) and return the pair a and x.

# Appendix: An Alternate Syntax of Type Signatures

In the test system an alternate type syntax is proposed that allows the forall quantifiers to be ommitted and a syntactic analysis to identify type variables. Apostrophes are placed in front of identifiers to identify them as variables. Variables are assumed to be uniquely named, and the appropriate polytype is assumed. 

For example a function type `!a!b.((a b) -> (!c.(c -> (a c) b))` can be expressed as `(('a 'b) -> (('c -> 'a 'c) 'b))`.

## Inference of Location of For-all Quantifiers

Given a type array containing type variables assumed to be uniqely named in potentially nested type arrays, the algorithm will infer which type parameters belong to which type arrays. In other words the precise location of the for-all quantifiers are determined. This process is done by assigning each type variables as a paraemter to the inner-most type array that contains all references to that type variable. This is done in the function `computeParameters()`.

# For More Information

* https://en.wikipedia.org/wiki/Parametric_polymorphism. 
* https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system
* https://en.wikipedia.org/wiki/Lambda_calculus
* https://en.wikipedia.org/wiki/Typed_lambda_calculus
* https://en.wikipedia.org/wiki/Unification_(computer_science) 
* https://www.cs.cornell.edu/courses/cs3110/2011sp/Lectures/lec26-type-inference/type-inference.htm
* http://www.angelfire.com/tx4/cus/combinator/birds.html