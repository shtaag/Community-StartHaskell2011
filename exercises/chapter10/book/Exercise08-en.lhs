Programming in Haskell: Chapter 10: Exercise 8
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

The goal of this exercise is write `Monad` instance declarations for `Maybe`
and `[]` (list) types.  Both of these types are given `Monad` instance
declarations in the `Prelude`, however, so it can be difficult to test your
declarations without getting errors.  This file provides a way to do so.

You may ignore the following imports.

> -- base
> import Prelude hiding (Monad(..))
>
> -- hunit
> import Test.HUnit

Monad Class
-----------

To test your instance declarations, we hide the real `Monad` class and instead
write instances for an equivalent, custom class.

> class MyMonad m where
>   (>>=) :: m a -> (a -> m b) -> m b
>   (>>) :: m a -> m b -> m b
>   return :: a -> m a
>   p >> q = p >>= \_ -> q

Maybe
-----

Write a `MyMonad` instance declaration for `Maybe`.

> instance MyMonad Maybe where
>   -- return :: a -> Maybe a
>   return = undefined
>   -- (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
>   (>>=) = undefined

To test: `runTests maybeTests`

> maybeTests :: [Test]
> maybeTests = map TestCase
>   [ assertEqual "return 1" (Just 1) (return 1)
>   , assertEqual "Nothing >>= (\\v -> return 1)" Nothing
>                 (Nothing >>= (\v -> return 1))
>   , assertEqual "Just 2 >>= (\\v -> return (2 + v))" (Just 4)
>                 (Just 2 >>= (\v -> return (2 + v)))
>   , assertEqual "Just 2 >> return 3" (Just 3) (Just 2 >> return 3)
>   ]

List
----

Write a `MyMonad` instance declaration for `[]`.

> instance MyMonad [] where
>   -- return :: a -> [a]
>   return = undefined
>   -- (>>=) :: [a] -> (a -> [b]) [b]
>   (>>=) = undefined

To test: `runTests listTests`

> listTests :: [Test]
> listTests = map TestCase
>   [ assertEqual "return 1" [1] (return 1)
>   , assertEqual "[1,2,3] >>= (\\v -> return (2 * v))" [2,4,6]
>                 ([1,2,3] >>= (\v -> return (2 * v)))
>   , assertEqual "[1,2,3] >>= (\\v -> [v, 2 * v])" [1,2,2,4,3,6]
>                 ([1,2,3] >>= (\v -> [v, 2 * v]))
>   , assertEqual "[1,2] >>= (\\x -> [3,4] >>= (\\y -> return (x,y)))"
>                 [(1,3),(1,4),(2,3),(2,4)]
>                 ([1,2] >>= (\x -> [3,4] >>= (\y -> return (x,y))))
>   ]

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
