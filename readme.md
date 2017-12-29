# Cat Programming Language v2

This is a reimplementation of the Cat language, with fewer features and a more precise specification and type system than the original, this time in TypeScript (the original was C#). 

I'm developing the [type inference module](https://github.com/cdiggins/type-inference) and the [parsing module](https://github.com/cdiggins/myna-parser) as separate standalone packages that can be reused in other language projects.

## A Concatenative Calculus

Lambda calculus (LC) is based on function abstraction and application. Combinatory logic (CL) eliminates the need for quantified variables. Both LC and CL can be used as complete theoretical models of computation. 

The concatenative calculus is based on function abstraction and composition. It is interesting to study because it closely models an imperative evaluation model of higher-order stack-based language but expressed in purely functional terms. 

An expression in the concatenative calculus is a function from a tuple to a tuple, usually the tuple is encoding a stack. 

There are two types of terms in the concatenative calculus:

* quotation: `[f]  => \s. [f:s]`
* composition: `f g => \s. g(f(s)) => compose(g, f) => g.f`

Quotation is effectively the lambda abstraction operator. Note that composition is postfix.

## Function Composition is Associative

In the concatenative calculus the order of evaluation doesn't matter because function composition is associative. 

Consider the concatenative expression: `A B C D`. This is equivalent to `  which by the law of associativity is equivalent to Compose(Compose(D, C), Compose(B, A)). This is interesting because it implies the evaluation of the concatenative calculus is massively parallelizable. 

This applies to type inference algorithms and compilers.

## Links 

* https://en.wikipedia.org/wiki/Combinatory_logic 
* https://en.wikipedia.org/wiki/Lambda_calculus
* https://en.wikipedia.org/wiki/SKI_combinator_calculus 
* [The Theory of Concatenative Combinators](http://tunes.org/~iepos/joy.html) 
* https://github.com/leonidas/codeblog/blob/master/2012/2012-02-17-concatenative-haskell.md

