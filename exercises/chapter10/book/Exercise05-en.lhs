Programming in Haskell: Chapter 10: Exercise 5
==============================================

This is a literate Haskell file.  Implement your solution below and test your
implementation with the included test cases.

You may ignore the following import.

> -- hunit
> import Test.HUnit

Helper Functions
----------------

These are defined in the book:

> type Assoc k v = [(k, v)]

> find :: Eq k => k -> Assoc k v -> v
> find k t = head [v | (k', v) <- t, k == k']

> bools :: Int -> [[Bool]]
> bools 0 = [[]]
> bools n = map (False :) bss ++ map (True :) bss
>   where
>     bss = bools (n - 1)

> rmdups :: Eq a => [a] -> [a]
> rmdups []     = []
> rmdups (x:xs) = x : rmdups (filter (/= x) xs)

Exercise
--------

Update the tautology checker implementation from the book to support logical
disjunction and equivalence.

> data Prop = Const Bool
>           | Var Char
>           | Not Prop
>           | And Prop Prop
>           | Imply Prop Prop

> type Subst = Assoc Char Bool

> eval :: Subst -> Prop -> Bool
> eval _ (Const b)   = b
> eval s (Var x)     = find x s
> eval s (Not p)     = not (eval s p)
> eval s (And p q)   = eval s p && eval s q
> eval s (Imply p q) = eval s p <= eval s q

> vars :: Prop -> [Char]
> vars (Const _)   = []
> vars (Var x)     = [x]
> vars (Not p)     = vars p
> vars (And p q)   = vars p ++ vars q
> vars (Imply p q) = vars p ++ vars q

> substs :: Prop -> [Subst]
> substs p = map (zip vs) (bools (length vs))
>   where
>     vs = rmdups (vars p)

> isTaut :: Prop -> Bool
> isTaut p = and [eval s p | s <- substs p]

Here are the test propositions from the book.  Add some test propositions that
use the new functionality, and then add them to the tests below.

> p1, p2, p3, p4 :: Prop
> p1 = And (Var 'A') (Not (Var 'A'))
> p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')
> p3 = Imply (Var 'A') (And (Var 'A') (Var 'B'))
> p4 = Imply (And (Var 'A') (Imply (Var 'A') (Var 'B'))) (Var 'B')

To test: `runTests isTautTests`

> isTautTests :: [Test]
> isTautTests = map TestCase
>   [ assertEqual "p1" False (isTaut p1)
>   , assertEqual "p2" True (isTaut p2)
>   , assertEqual "p3" False (isTaut p3)
>   , assertEqual "p4" True (isTaut p4)
>   ]

Support Code
------------

The following definition is used to run tests.  Please ignore it.

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
