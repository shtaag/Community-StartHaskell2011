Programming in Haskell: Chapter 11: Exercise 1
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Helper Functions
----------------

These are defined in the book:

> subs :: [a] -> [[a]]
> subs []     = [[]]
> subs (x:xs) = yss ++ map (x :) yss
>   where
>     yss = subs xs

> interleave :: a -> [a] -> [[a]]
> interleave x []     = [[x]]
> interleave x (y:ys) = (x:y:ys) : map (y :) (interleave x ys)

> perms :: [a] -> [[a]]
> perms []     = [[]]
> perms (x:xs) = concat (map (interleave x) (perms xs))

Exercise
--------

Implement `choices` using a list comprehension.

> choices :: [a] -> [[a]]
> choices = undefined

To test: `runTests choicesTests`

> choicesTests :: [Test]
> choicesTests = map TestCase
>   [ assertChoices [[]] []
>   , assertChoices [[],[1]] [1]
>   , assertChoices [[],[2],[1],[1,2],[2,1]] [1,2]
>   , assertChoices [[],[3],[2],[2,3],[3,2],[1],[1,3],[3,1],[1,2],[2,1],
>                    [1,2,3],[2,1,3],[2,3,1],[1,3,2],[3,1,2],[3,2,1]]
>                   [1,2,3]
>   ]
>   where
>     assertChoices :: [[Int]] -> [Int] -> Assertion
>     assertChoices c l = assertEqual (show l) c (choices l)

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
