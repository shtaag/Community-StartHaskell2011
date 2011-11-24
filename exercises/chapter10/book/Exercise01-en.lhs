Programming in Haskell: Chapter 10: Exercise 1
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Book Definitions
----------------

The following are defined in the book:

> data Nat = Zero | Succ Nat
>   deriving (Eq)

`Eq` is derived for the unit tests.

> nat2int :: Nat -> Int
> nat2int Zero = 0
> nat2int (Succ n) = 1 + nat2int n

> int2nat :: Int -> Nat
> int2nat 0 = Zero
> int2nat n = Succ (int2nat (n - 1))

> add :: Nat -> Nat -> Nat
> add Zero n     = n
> add (Succ m) n = Succ (add m n)

`Nat` is made an instance of `Show` for the unit tests.

> instance Show Nat where
>   show n = '{' : show (nat2int n) ++ "}"

mult
----

Define `mult` here:

> mult :: Nat -> Nat -> Nat
> mult = undefined

To test: `runTests multTests`

> multTests :: [Test]
> multTests = map TestCase
>   [ assertMult "3 x 0" 0 3 0
>   , assertMult "3 x 1" 3 3 1
>   , assertMult "3 x 4" 12 3 4
>   , assertMult "0 x 3" 0 0 3
>   , assertMult "1 x 3" 3 1 3
>   , assertMult "4 x 3" 12 4 3
>   ]
>   where
>     assertMult :: String -> Int -> Int -> Int -> Assertion
>     assertMult s p x y = assertEqual s (int2nat p)
>                            (int2nat x `mult` int2nat y)

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
