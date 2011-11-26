Programming in Haskell: Chapter 12: Exercise 5
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

Define `fib`:

> fib :: Int -> Integer
> fib n = undefined

Define `fib1000`:

> fib1000 :: Integer
> fib1000 = undefined

To test: `runTests fibsTests`

> fibsTests :: [Test]
> fibsTests = map TestCase
>   [ assertEqual "fib 30" 832040 (fib 30)
>   , assertEqual "fib1000" 1597 fib1000
>   ]

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
