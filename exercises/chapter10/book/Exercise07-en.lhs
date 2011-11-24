Programming in Haskell: Chapter 10: Exercise 7
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Exercise
--------

Update the abstract machine implementation from the book to support
multiplication.

> data Expr = Val Int
>           | Add Expr Expr

> data Op = EVAL Expr
>         | ADD Int

> type Cont = [Op]

> eval :: Expr -> Cont -> Int
> eval (Val n) c    = exec c n
> eval (Add x y) c  = eval x (EVAL y : c)

> exec :: Cont -> Int -> Int
> exec [] n           = n
> exec (EVAL y : c) n = eval y (ADD n : c)
> exec (ADD n : c) m  = exec c (n + m)

> value :: Expr -> Int
> value e = eval e []

Here is the test expression from the book.  Add some test expressions that
test the new functionality, and then add them to the tests below.

> e1 :: Expr
> e1 = Add (Add (Val 2) (Val 3)) (Val 4)

To test: `runTests valueTests`

> valueTests :: [Test]
> valueTests = map TestCase
>   [ assertEqual "e1" 9 (value e1)
>   ]

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
