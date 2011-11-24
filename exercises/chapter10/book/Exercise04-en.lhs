Programming in Haskell: Chapter 10: Exercise 4
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

Note that GHC 7.0.3 or greater is required.

You may ignore the following imports.

> -- base
> import Control.Exception (ErrorCall(..), evaluate, handleJust)
>
> -- hunit
> import Test.HUnit

Tree Definition
---------------

> data Tree = Leaf Int | Node Tree Tree
>   deriving (Eq)

> instance Show Tree where
>   show (Leaf v)   = '(' : show v ++ ")"
>   show (Node l r) = '(' : show l ++ show r ++ ")"

Exercise
--------

Define the function `halve`:

> halve :: [a] -> ([a], [a])
> halve = undefined

To test: `runTests halveTests`

> halveTests :: [Test]
> halveTests = map TestCase
>   [ assertHalve ([],[]) []
>   , assertHalve ([],[1]) [1]
>   , assertHalve ([1],[2]) [1,2]
>   , assertHalve ([1],[2,3]) [1..3]
>   , assertHalve ([1,2],[3,4]) [1..4]
>   , assertHalve ([1..49],[50..99]) [1..99]
>   ]
>   where
>     assertHalve :: ([Int], [Int]) -> [Int] -> Assertion
>     assertHalve t l = assertEqual (show l) t (halve l)

Define the function `balance`:

> balance :: [Int] -> Tree
> balance = undefined

To test: `runTests balanceTests`

> balanceTests :: [Test]
> balanceTests = map TestCase
>   [ assertError "[]" (balance [])
>   , assertBalance (Leaf 1) [1]
>   , assertBalance (Node (Leaf 1) (Leaf 2)) [1,2]
>   , assertBalance (Node (Leaf 1) (Node (Leaf 2) (Leaf 3))) [1..3]
>   , assertBalance (Node (Node (Leaf 1) (Leaf 2))
>                         (Node (Leaf 3) (Node (Leaf 4) (Leaf 5))))
>                   [1..5]
>   ]
>   where
>     assertBalance :: Tree -> [Int] -> Assertion
>     assertBalance t l = assertEqual (show l) t (balance l)

Support Code
------------

The following definitions are used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> assertError :: String -> a -> Assertion
> assertError msg x = handleJust errorCalls (const $ return ()) $ do
>     evaluate x
>     assertFailure $ msg Prelude.++ ": error not thrown"
>   where
>     errorCalls (ErrorCall _) = Just ()
