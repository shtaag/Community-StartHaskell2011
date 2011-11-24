Programming in Haskell: Chapter 11: Exercise 1
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Exercise
--------

Implement your solution here:

> isChoice :: Eq a => [a] -> [a] -> Bool
> isChoice = undefined

To test: `runTests isChoiceTests`

> isChoiceTests :: [Test]
> isChoiceTests = map TestCase
>   [ assertChoice [] []
>   , assertNotChoice [0] []
>   , assertChoice [] [1]
>   , assertChoice [1] [1]
>   , assertNotChoice [0] [1]
>   , assertChoice [] [1,2,3]
>   , assertChoice [2] [1,2,3]
>   , assertChoice [3,2] [1,2,3]
>   , assertChoice [1,3,2] [1,2,3]
>   , assertNotChoice [3,0,1] [1,2,3]
>   ]
>   where
>     assertChoice :: [Int] -> [Int] -> Assertion
>     assertChoice sub sup = assertEqual
>       (show sub ++ " `isChoice` " ++ show sup)
>       True (sub `isChoice` sup)
>     assertNotChoice :: [Int] -> [Int] -> Assertion
>     assertNotChoice sub sup = assertEqual
>       ("not (" ++ show sub ++ " `isChoice` " ++ show sup ++ ")")
>       False (sub `isChoice` sup)

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
