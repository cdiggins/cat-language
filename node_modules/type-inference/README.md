# Another Type Inference Algorithm 

This is a practical implementation in TypeScript of a novel higher-rank type inference algorithm that can infer non-recursive higher-kind polymorphic types without user supplied type annotations. 

# Motivation 

Most programming languages with support for generic types (*polytypes* or polymorphic types) don't allow programmers to use generic types as type parameters. Instead generic types have to be converted to non-polymorphic types (*monotypes*) by supplying non-polymorphic types for each type parameter before they can be used. Described another way these languages only support rank-1 polymorphism, also called *prenex polymorphism*.

Most strongly typed languages with type inference can only infer types for certain expressions are hard to learn for new users, because they quicklyk find themselves in situiations where they have to understand the intricacies of the type system, and how to write complex types in situiations that would be easy to use in a dynamic language (e.g. Python and JavaScript).  

Full type inference in a programming language can give programmers the convenience and smooth learning curve of a dynamic programming language with the safety and efficiency of a strongly typed programming language. 

This algorithm is inspired by Hindley-Milner-Damas type inference, aka [Algorithm W](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system), but Algorithm W only works for on rank-1 polymorphic types. In other words type parameters can only be bound to monotypes (non-polymorphic types). 

For more informationI sugsee [the article on Parametric Polymorphism on Wikipedia](https://en.wikipedia.org/wiki/Parametric_polymorphism).

## Implementation Overview

The basic algorithm is as follows:

* Step 1 (renaming): Uniquely name all type variables 
* Step 2 (forall inference): Infer the position of all forall quantifiers in type arrays
* Step 3 (unify constraint): Given a constraint between two types find a unifier for each variable.
* Step 4 (substitution): Given a type signature compute a new signature by subsituting all type variables in the given type signature with the appropriate unifying type.
* Step 5 (forall inference): Infer the position of all forall quanitifer in resulting type.

During step 4 (substitution), if a polytype is substituted for a type variable more than once each subsequent instance is given a new set of names for the generic type parameters.

## Details 

Types are represented by the `Type` class. There are three kinds of types derived from this class: 

1. `TypeConstant` - Represents monotypes (simple non-plymorphic types)
2. `TypeVariable` - Represents a universally quantified type variable, also known as a generic type parameter 
3. `TypeArray` - A fixed-size collection of types that may or may not have universally quantified type parameters

Other kinds of types, like functions and arrays, are encoded as special cases of type arrays. 

## Illegal Types

Any type where the type variable occurs only on the right-side of a function, or that contains an illegal type, is considered an illegal type. Recursive types are not supported. They will be identified by the name 

## Encoding Function Types 

A function is encoded as a type array with 3 elements: the first element is a type list representing the arguments, the second element a type constant (`->`) and the third is a type list that represents the function return types. 

## Encoding Type Lists 

A type list is encoded a pair of types (a type array of two elements) where the first element is the head of the list, and the second element is the rest of the list. Usually the type in the last position is a type variable which enables two type lists with different number of elements to be unified. 

## Encoding Array Types

An array type (not to be confused with an array of types) can be encoded as a type 

## Inferring Row Polymorphism

When unifying two type lists with different lengths but the shorter has a type variable in the last poistion, the unification algorithm will "just work" treating the final type variable as a row variable. Encoding all function arguments and function results as type lists with type variables. 

## Inference of Location of For-all Quantifiers

Given a type array with type variables, the algorithm will infer the precise location of the for-all quantifiers by assigning them to the inner-most type array that contains all references to that type variable. This is done in the function `computeSchemes`.

For example consider the quote function 

```
quote   ( as written ) : (('a 'b) -> (('c -> 'a 'c) 'b))
quote   ( as implied ) : !a!b.((a b) -> (!c.(c -> a c) b))
```

## Polytype

A polytype is a type with universally quantified type variables (aka generic type parameters). In the type system, only type arrays can be polytypes. 

## Monotype

A monotype is a non-polymorphic type, like `Num` or `Bool`. 

# Usage with Functional Stack-Based Languages / Concatenative Languages

The type inference algorithm was developed initially for use with the [Cat programming language](http://www.cat-language.com) which is a strongly typed functional stack-based language, also called a concatenative language, based on [Joy](https://en.wikipedia.org/wiki/Joy_(programming_language).

## Example Function Types 

```
pop     : !a!b.((a b) -> b)
dup     : !a!b.((a b) -> (a (a b))
swap    : !a!b!c.((a (b c)) -> (b (a c)))
apply   : !a!b.(((a -> b) a) -> b) 
quote   : !a!b.((a b) -> (!c.(c -> a c) b)
compose : !a!b!c!d.(((b -> c) ((a -> b) d)) -> ((a -> c) d)
```

