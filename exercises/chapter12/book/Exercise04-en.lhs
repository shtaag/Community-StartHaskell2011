Programming in Haskell: Chapter 12: Exercise 4
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Problem
-------

Define `fibs`:

> fibs :: [Integer]
> fibs = undefined

To test: `runTests fibsTests`

> fibsTests :: [Test]
> fibsTests = map TestCase
>   [ assertEqual "take 10 fibs" [0,1,1,2,3,5,8,13,21,34] (take 10 fibs)
>   ]

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
