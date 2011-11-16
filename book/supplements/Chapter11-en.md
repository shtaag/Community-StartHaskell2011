Chapter 11: Supplement
======================

Show
----

In chapter 10, we learned about class and instance declarations.  Another
important class is the `Show` class, defined in the `Prelude`.  Instances of
the `Show` class must implement the function `show :: a -> String`, which
creates a `String` representation for type `a`.

It would be nice to be able to print out values of the `Expr` type (defined on
page 117).  Here is how to do so:

    instance Show Expr where
      show (Val x)       = show x
      show (App Add x y) = '(' : show x ++ " + " ++ show y ++ ")"
      show (App Sub x y) = '(' : show x ++ " - " ++ show y ++ ")"
      show (App Mul x y) = '(' : show x ++ " * " ++ show y ++ ")"
      show (App Div x y) = '(' : show x ++ " / " ++ show y ++ ")"

Timing
------

This chapter measures performance of programs using elapsed time.  To measure
elapsed time within Haskell, import the `getCPUTime` function from
`System.CPUTime` and use the following function:

    timeIO :: Show a => a -> IO ()
    timeIO action = do t0 <- getCPUTime
                       putStrLn . show $ action
                       t1 <- getCPUTime
                       let td = fromIntegral (t1 - t0) / 10^12
                       putStrLn $ "Time elapsed: " ++ show td ++ " seconds"

This function times an action and prints both the result and elapsed time to
the screen.  Here is the code for the three brute force algorithm tests:

    mainBF1 :: IO ()
    mainBF1 = timeIO . head $ solutions [1,3,7,10,25,50] 765

    mainBF2 :: IO ()
    mainBF2 = timeIO . length $ solutions [1,3,7,10,25,50] 765

    mainBF3 :: IO ()
    mainBF3 = timeIO . length $ solutions [1,3,7,10,25,50] 831

In `mainBF1`, `head` is used to get only the first solution.  Thanks to lazy
evaluation, the rest are not computed.  In `mainBF2` and `mainBF3`, `length`
is used to force evaluation of all solutions.

The functions to test the improved algorithms are the same as the above, with
the appropriate `solutions` function for each algorithm.

Test the program from the command line, not from within GHCi.  To do so,
define the `main` function as the function that you want to test.

    main :: IO ()
    main = mainBF1

Compile and link the program using `ghc -O2 Filename.hs`, and then run the
built executable.
