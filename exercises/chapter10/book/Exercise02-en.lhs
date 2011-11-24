Programming in Haskell: Chapter 10: Exercise 2
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Book Definitions
----------------

Here is the `Tree` definition and test tree from the book:

> data Tree = Leaf Int | Node Tree Int Tree

> t :: Tree
> t = Node (Node (Leaf 1) 3 (Leaf 4)) 5 (Node (Leaf 6) 7 (Leaf 9))

occurs
------

Define `occurs` here:

> occurs :: Int -> Tree -> Bool
> occurs = undefined

To test: `runTests occursTests`

> occursTests :: [Test]
> occursTests = map TestCase
>   [ assertBool "1 in (1)" (occurs 1 (Leaf 1))
>   , assertBool "1 in (2)" (not $ occurs 1 (Leaf 2))
>   , assertBool "1 in t" (occurs 1 t)
>   , assertBool "2 in t" (not $ occurs 2 t)
>   , assertBool "3 in t" (occurs 3 t)
>   , assertBool "4 in t" (occurs 4 t)
>   , assertBool "5 in t" (occurs 5 t)
>   , assertBool "6 in t" (occurs 6 t)
>   , assertBool "7 in t" (occurs 7 t)
>   , assertBool "8 in t" (not $ occurs 8 t)
>   , assertBool "9 in t" (occurs 9 t)
>   , assertBool "10 in t" (not $ occurs 10 t)
>   ]

Why is it more efficient?

    ANSWER HERE

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
