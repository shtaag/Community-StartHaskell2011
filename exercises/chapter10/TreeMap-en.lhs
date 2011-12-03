Tree Map
========

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Tree
----

Here is the `Tree` data type defined on page 103:

    data Tree = Leaf Int | Node Tree Int Tree

This data type is specialized to `Int` values; here is a polymorphic version:

    data Tree a = Leaf a | Node (Tree a) a (Tree a)

In this definition, the type variable `a` allows any type to be stored in a
`Tree`, similar to how any type can be stored in a list.

Consider the `Tree` definition on page 104 that only stores values in nodes:

> data Tree a = Leaf | Node (Tree a) a (Tree a)
>   deriving (Eq)

Here are some test trees:

> test0, test1, test2, test4 :: Tree Int
> test0 = Leaf
> test1 = Node Leaf 1 Leaf
> test2 = Node (Node Leaf 1 Leaf) 2 Leaf
> test4 = Node (Node (Node Leaf 1 Leaf) 2 Leaf) 3 (Node Leaf 4 Leaf)

Show
----

By making `Tree` an instance of the `Show` type class, you can print trees to
the screen.  If you try to display a `Tree` without doing so, an error is
displayed.

If we were still using the `Tree` type that is specialized to `Int` values,
then we would make it an instance of `Show` as follows:

    instance Show Tree where
      show (Leaf v)     = show v
      show (Node l v r) = ...

We can display values because `Int` is an instance of `Show`.  To make our
polymorphic `Tree` definition an instance of `Show`, we have to add a
constraint that the type of the values is also an instance of `Show`:

    instance Show a => Show (Tree a) where
      show Leaf         = ...
      show (Node l v r) = ...

Write an instance declaration using your favorite tree syntax.

> instance Show a => Show (Tree a) where
>   show = undefined

Then type `test4` into GHCi to confirm that it prints to the screen correctly.

treeMap
-------

One of the goals of functional programming is to allow use of higher order
functions as a method of abstraction.  One higher order function that we have
used extensively is `map :: (a -> b) -> [a] -> [b]`, which applies a function
to all elements of a list and returns the new list.  Implement a function
`treeMap` that does the same thing, but with `Tree` data structures.

> treeMap :: (a -> b) -> Tree a -> Tree b
> treeMap = undefined

To test: `runTests treeMapTests`

> treeMapTests :: [Test]
> treeMapTests = map TestCase
>   [ assertEqual "treeMap (+ 1) test0"
>                 Leaf
>                 (treeMap (+ 1) test0)
>   , assertEqual "treeMap (+ 1) test1"
>                 (Node Leaf 2 Leaf)
>                 (treeMap (+ 1) test1)
>   , assertEqual "treeMap (+ 1) test2"
>                 (Node (Node Leaf 2 Leaf) 3 Leaf)
>                 (treeMap (+ 1) test2)
>   , assertEqual "treeMap (+ 1) test4"
>                 (Node (Node (Node Leaf 2 Leaf) 3 Leaf) 4 (Node Leaf 5 Leaf))
>                 (treeMap (+ 1) test4)
>   , assertEqual "treeMap show test0"
>                 Leaf
>                 (treeMap show test0)
>   , assertEqual "treeMap show test1"
>                 (Node Leaf "1" Leaf)
>                 (treeMap show test1)
>   , assertEqual "treeMap show test2"
>                 (Node (Node Leaf "1" Leaf) "2" Leaf)
>                 (treeMap show test2)
>   , assertEqual "treeMap show test4"
>                 (Node (Node (Node Leaf "1" Leaf) "2" Leaf)
>                       "3"
>                       (Node Leaf "4" Leaf))
>                 (treeMap show test4)
>   ]

Functor
-------

Mapping functions onto containers is a fundamental operation, so Haskell
provides a `Functor` type class to describe it.  The word "functor" comes
from category theory; it can be thought of as a mapping between two
categories.  (For example, the function `map show [1..10]` can be thought of
as mapping from the category of lists of integers to the category of lists of
strings.)

The `Functor` type class, defined in the `Prelude`, is defined as follows:

    class Functor f where
      fmap :: (a -> b) -> f a -> f b

In the declaration of `Tree` above, the type variable `a` was used to make the
values accept any type.  In this class definition, however, type variable `f`
refers to the container type.  For example, for the `Tree` container type,
`fmap` could be specialized to `fmap :: (a -> b) -> Tree a -> Tree b`, which
would map from a `Tree` with values of type `a` to a `Tree` with values of
type `b` using the function passed as the first argument.

Make `Tree` and instance of `Functor` (without using the `treeMap` function):

> instance Functor Tree where
>   fmap = undefined

(Note that unlike the instance declaration for `Show`, we do not require any
type constraints.  We therefore do not use `(Tree a)` in the first line of the
instance declaration.)

To test: `runTests fmapTests`

> fmapTests :: [Test]
> fmapTests = map TestCase
>   [ assertEqual "fmap (+ 1) test0"
>                 Leaf
>                 (fmap (+ 1) test0)
>   , assertEqual "fmap (+ 1) test1"
>                 (Node Leaf 2 Leaf)
>                 (fmap (+ 1) test1)
>   , assertEqual "fmap (+ 1) test2"
>                 (Node (Node Leaf 2 Leaf) 3 Leaf)
>                 (fmap (+ 1) test2)
>   , assertEqual "fmap (+ 1) test4"
>                 (Node (Node (Node Leaf 2 Leaf) 3 Leaf) 4 (Node Leaf 5 Leaf))
>                 (fmap (+ 1) test4)
>   , assertEqual "fmap show test0"
>                 Leaf
>                 (fmap show test0)
>   , assertEqual "fmap show test1"
>                 (Node Leaf "1" Leaf)
>                 (fmap show test1)
>   , assertEqual "fmap show test2"
>                 (Node (Node Leaf "1" Leaf) "2" Leaf)
>                 (fmap show test2)
>   , assertEqual "fmap show test4"
>                 (Node (Node (Node Leaf "1" Leaf) "2" Leaf)
>                       "3"
>                       (Node Leaf "4" Leaf))
>                 (fmap show test4)
>   ]

By using the `Functor` class, we can use a standard function (`fmap`) to map
functions onto containers.  The list type is an instance of `Functor`, so
`fmap` can be used with lists as well.  The `map` function can be considered
a specialization of `fmap` onto lists.

Purpose
-------

The purpose of this exercise was to give another example of how type classes
are used.  Monads are often given a lot of attention when learning Haskell
because they can be difficult to grasp, but I have found that many people who
have yet to grasp monads do not understand parameterized type classes.
Parameterized type classes allow for *many* different types of abstractions,
of which monads is just one example.  Understanding how type classes are used
is essential to understand monads.  (With the exception of the support code
below, no monads were used in this exercise.)

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
