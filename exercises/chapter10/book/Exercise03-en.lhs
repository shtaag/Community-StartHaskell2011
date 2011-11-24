Programming in Haskell: Chapter 10: Exercise 3
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Tree Definition
---------------

> data Tree = Leaf Int | Node Tree Tree

Test Trees
----------

> t0, t1, t2, t3, t4 :: Tree
> t0 = Leaf 1
> t1 = Node (Node (Leaf 1) (Leaf 2)) (Leaf 3)
> t2 = Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4))
> t3 = Node (Leaf 1) (Node (Node (Leaf 2) (Leaf 3)) (Leaf 4))
> t4 = Node (Node (Node (Node (Leaf 1) (Leaf 2))
>                       (Node (Leaf 3) (Leaf 4)))
>                 (Leaf 5))
>           (Node (Node (Leaf 6) (Leaf 7))
>                 (Node (Leaf 8)
>                       (Node (Leaf 9) (Leaf 10))))

Exercise
--------

Define the function `size`:

> size :: Tree -> Int
> size = undefined

To test: `runTests sizeTests`

> sizeTests :: [Test]
> sizeTests = map TestCase
>   [ assertEqual "t0" 1 (size t0)
>   , assertEqual "t1" 3 (size t1)
>   , assertEqual "t2" 4 (size t2)
>   , assertEqual "t3" 4 (size t3)
>   , assertEqual "t4" 10 (size t4)
>   ]

Define the function `balanced`:

> balanced :: Tree -> Bool
> balanced = undefined

To test: `runTests balancedTests`

> balancedTests :: [Test]
> balancedTests = map TestCase
>   [ assertEqual "t0" True (balanced t0)
>   , assertEqual "t1" True (balanced t1)
>   , assertEqual "t2" True (balanced t2)
>   , assertEqual "t3" False (balanced t3)
>   , assertEqual "t4" False (balanced t4)
>   ]

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
