The Count Up Game
=================

This is a literate Haskell file.  To do the exercise, download this file to
your computer and name it `CountUp.lhs`.  Work through the file, replacing
each `undefined` function with your implementation of the function.  Test your
definitions as you go with the provided unit tests.  When all tests pass, you
can compile and play the game.

Requirements:

    * GHC 7.0.3 or higher (Haskell Platform 2011.2.0.1 or higher)
    * HUnit (`cabal install hunit` to install)
    * Haskeline (`cabal install haskeline` to install)

Overview
--------

The count up game is a game that I used to play in the Mixi mathematics
community.  Players must write mathematical functions, using a fixed set of
digits (usually those of the current date) and operators, that evaluate to
target values.  Each function must use the exact set of digits (no more, no
fewer).  The target value starts at 0 and increments when a suitable function
is found.

For example, with digits `20111116` and a target of `121`, the play may enter
the function `(20-(6+1+1+1))^(1+1)`.

In this exercise, you will develop the count up game using Haskell.

Please ignore the following module declaration and imports.

> module Main where
>
> -- base (Haskell Platform)
> import Control.Exception (ErrorCall(..), evaluate, handleJust)
> import Control.Monad (Monad(..), MonadPlus(..), replicateM)
> import Data.Char (isAlpha, isAlphaNum, isDigit, isLower, isSpace, isUpper,
>                   ord)
> import Data.List (sort)
> import System.IO (hFlush, stdout)
>
> -- transformers (Haskell Platform)
> import Control.Monad.IO.Class (liftIO)
>
> -- time (Haskell Platform)
> import Data.Time.Clock (getCurrentTime)
> import Data.Time.Format (formatTime)
>
> -- old-locale (Haskell Platform)
> import System.Locale (defaultTimeLocale)
>
> -- random (Haskell Platform)
> import System.Random (getStdRandom, randomR)
>
> -- hunit (http://hackage.haskell.org/package/HUnit)
> import Test.HUnit (Assertion(..), Counts(..), Test(..), assertEqual,
>                    assertFailure, runTestTT)
>
> -- haskeline (http://hackage.haskell.org/package/haskeline)
> import System.Console.Haskeline (InputT(..), defaultSettings, getInputLine,
>                                  outputStrLn, runInputT)

Functions
---------

The count up game is a game of integers.  Functions are composed using a fixed
set of operators, as specified in the following data structure definition.

> data Func = Val Int        -- value
>           | Add Func Func  -- addition (+)
>           | Sub Func Func  -- subtraction (-)
>           | Mul Func Func  -- multiplication (*)
>           | Div Func Func  -- integral division (/)
>           | Mod Func Func  -- modulo (%)
>           | Pow Func Func  -- exponentiation (^)
>           | Fac Func       -- factorial (_!)
>           | Abs Func       -- absolute value (|_|)
>   deriving (Eq)

Note that we are deriving `Eq` only for the sake of the unit tests.  For two
functions to be considered equal, they must be composed in exactly the same
way.  For example, `(1 + 2) + 3 /= 1 + (2 + 3)`, despite the fact that the two
functions are mathematically equivalent.

Show
----

Make `Func` and instance of `Show` by implementing `show :: Func -> String`.
Always use parenthesis to make grouping explicit, with the following
exceptions:

    * do not use outside parenthesis (around the whole function)
    * do not use parenthesis immediately inside absolute value bars

See the unit tests for concrete examples of how to format functions.

> instance Show Func where
>   show = showNP
>     where
>       showNP :: Func -> String
>       showNP (Val x)   = show x
>       showNP (Add f g) = infx '+' f g
>       showNP (Sub f g) = infx '-' f g
>       showNP (Mul f g) = infx '*' f g
>       showNP (Div f g) = infx '/' f g
>       showNP (Mod f g) = infx '%' f g
>       showNP (Pow f g) = infx '^' f g
>       showNP (Fac f)   = showP f ++ "!"
>       showNP (Abs f)   = delimit '|' '|' $ showNP f
>       showP :: Func -> String
>       showP (Val x) = show x
>       showP (Fac f) = delimit '(' ')' $ showP f ++ "!"
>       showP (Abs f) = delimit '|' '|' $ showNP f
>       showP f       = delimit '(' ')' $ showNP f
>       infx :: Char -> Func -> Func -> String
>       infx o f g = showP f ++ ' ' : o : ' ' : showP g
>       delimit :: Char -> Char -> String -> String
>       delimit b e = (b :) . (++ [e])

To test: `runTests showTests`

> showTests :: [Test]
> showTests = map TestCase
>   [ assertShow "1" (Val 1)
>   , assertShow "-1" (Val (-1))
>   , assertShow "1 + 2" (Add (Val 1) (Val 2))
>   , assertShow "1 - 2" (Sub (Val 1) (Val 2))
>   , assertShow "1 * 2" (Mul (Val 1) (Val 2))
>   , assertShow "4 / 2" (Div (Val 4) (Val 2))
>   , assertShow "4 % 3" (Mod (Val 4) (Val 3))
>   , assertShow "4 ^ 2" (Pow (Val 4) (Val 2))
>   , assertShow "4!" (Fac (Val 4))
>   , assertShow "|-2|" (Abs (Val (-2)))
>   , assertShow "(3 - 2)!" (Fac (Sub (Val 3) (Val 2)))
>   , assertShow "|2 - 3|!" (Fac (Abs (Sub (Val 2) (Val 3))))
>   , assertShow "(|2 - 5|!)!" (Fac (Fac (Abs (Sub (Val 2) (Val 5)))))
>   , assertShow "(4 - 3) * (2 + 1)"
>                (Mul (Sub (Val 4) (Val 3)) (Add (Val 2) (Val 1)))
>   , assertShow "(4 / 2) ^ (3 % 2)"
>                (Pow (Div (Val 4) (Val 2)) (Mod (Val 3) (Val 2)))
>   , assertShow "((6 + 1) ^ (4 / 2)) % ((5 * (3!)) - 7)"
>                (Mod (Pow (Add (Val 6) (Val 1)) (Div (Val 4) (Val 2)))
>                     (Sub (Mul (Val 5) (Fac (Val 3))) (Val 7)))
>   ]
>   where
>     assertShow :: Show a => String -> a -> Assertion
>     assertShow s = assertEqual s s . show

Read
----

Using the parsing library from chapter 8 (included at the bottom of this
file), implement a parser for functions.  While we add explicit parenthesis in
the implementation of `show`, the parser needs to be able to parse functions
lacking parenthesis.  Abide by the following binding precedence and fixity:

    * (+), (-): lowest binding precedence, left-associative
    * (*), (/), (%): middle binding precedence, left-associative
    * (^): highest binding precedence, right-associative

    expr1 ::= expr1 + expr2 | expr1 - expr2 | expr2
    expr2 ::= expr2 * expr3 | expr2 / expr3 | expr2 % expr3 | expr3
    expr3 ::= expr4 ( ^ expr3 | EPSILON )
    expr4 ::= expr5 ( ! | EPSILON )
    expr5 ::= (expr1) | |expr1| | value
    value ::= ... | -2 | -1 | 0 | 1 | 2 | ...

> func :: Parser Func
> func = expr1
>   where
>     parseOp :: String -> Parser Func -> Parser (Char, Func)
>     parseOp (o:os) p = do symbol [o]
>                           f <- p
>                           return (o, f)
>                          +++ parseOp os p
>     parseOp _ p      = failure
>     assemble :: Func -> (Char, Func) -> Func
>     assemble f (o,g) | o == '+' = Add f g
>                      | o == '-' = Sub f g
>                      | o == '*' = Mul f g
>                      | o == '/' = Div f g
>                      | o == '%' = Mod f g
>     parseBinL :: [Char] -> Parser Func -> Parser Func
>     parseBinL os p = do f <- p
>                         gs <- many (parseOp os p)
>                         return $ foldl assemble f gs
>     expr1, expr2, expr3, expr4, expr5, value :: Parser Func
>     expr1 = parseBinL "+-" expr2
>     expr2 = parseBinL "*/%" expr3
>     expr3 = do f <- expr4
>                do symbol "^"
>                   g <- expr3
>                   return (Pow f g)
>                  +++ return f
>     expr4 = do f <- expr5
>                do symbol "!"
>                   return (Fac f)
>                  +++ return f
>     expr5 = do symbol "("
>                f <- expr1
>                symbol ")"
>                return f
>               +++ do symbol "|"
>                      f <- expr1
>                      symbol "|"
>                      return (Abs f)
>                     +++ value
>     value = do x <- int
>                return (Val x)

The following definition makes `Func` and instance of `Read`.

> instance Read Func where
>   readsPrec _ = parse func

To test: `runTests readTests`

> readTests :: [Test]
> readTests = map TestCase
>   [ assertRead "1" (Val 1)
>   , assertRead "-1" (Val (-1))
>   , assertRead "1 + 2" (Add (Val 1) (Val 2))
>   , assertRead "1 - 2" (Sub (Val 1) (Val 2))
>   , assertRead "1 * 2" (Mul (Val 1) (Val 2))
>   , assertRead "4 / 2" (Div (Val 4) (Val 2))
>   , assertRead "4 % 3" (Mod (Val 4) (Val 3))
>   , assertRead "4 ^ 2" (Pow (Val 4) (Val 2))
>   , assertRead "4!" (Fac (Val 4))
>   , assertRead "|-2|" (Abs (Val (-2)))
>   , assertRead "(3 - 2)!" (Fac (Sub (Val 3) (Val 2)))
>   , assertRead "|2 - 3|!" (Fac (Abs (Sub (Val 2) (Val 3))))
>   , assertRead "(|2 - 5|!)!" (Fac (Fac (Abs (Sub (Val 2) (Val 5)))))
>   , assertRead "1 - 2 + 3" (Add (Sub (Val 1) (Val 2)) (Val 3))
>   , assertRead "4 / 2 * 2" (Mul (Div (Val 4) (Val 2)) (Val 2))
>   , assertRead "3 ^ 2 ^ 2" (Pow (Val 3) (Pow (Val 2) (Val 2)))
>   , assertRead "(4 - 3) * (2 + 1)"
>                (Mul (Sub (Val 4) (Val 3)) (Add (Val 2) (Val 1)))
>   , assertRead "(4 / 2) ^ (3 % 2)"
>                (Pow (Div (Val 4) (Val 2)) (Mod (Val 3) (Val 2)))
>   , assertRead "((6 + 1) ^ (4 / 2)) % ((5 * (3!)) - 7)"
>                (Mod (Pow (Add (Val 6) (Val 1)) (Div (Val 4) (Val 2)))
>                     (Sub (Mul (Val 5) (Fac (Val 3))) (Val 7)))
>   , assertRead "2--1" (Sub (Val 2) (Val (-1)))
>   , assertRead "2 + 3 !" (Add (Val 2) (Fac (Val 3)))
>   , assertRead "|(3-2)|" (Abs (Sub (Val 3) (Val 2)))
>   , assertRead "|2-5|!" (Fac (Abs (Sub (Val 2) (Val 5))))
>   , assertRead "1+2 * 3-4"
>                (Sub (Add (Val 1) (Mul (Val 2) (Val 3))) (Val 4))
>   , assertRead "4+3 % 2-1"
>                (Sub (Add (Val 4) (Mod (Val 3) (Val 2))) (Val 1))
>   , assertRead "1*2 ^ 3/4"
>                (Div (Mul (Val 1) (Pow (Val 2) (Val 3))) (Val 4))
>   , assertRead " | 1 * 2 | ^ 3/4 "
>                (Div (Pow (Abs (Mul (Val 1) (Val 2))) (Val 3)) (Val 4))
>   , assertRead "2 - 3 ^ | 3 - 5 | / 3 % 2 + 1 * 3!"
>                (Add (Sub (Val 2)
>                          (Mod (Div (Pow (Val 3) (Abs (Sub (Val 3) (Val 5))))
>                                    (Val 3))
>                               (Val 2)))
>                     (Mul (Val 1) (Fac (Val 3))))
>   , assertFail "(3 - 2|"
>   , assertFail "(3 - ) 2"
>   , assertFail "3 ( - 2)"
>   , assertFail "+ 3"
>   , assertFail "1 -"
>   ]
>   where
>     assertRead :: String -> Func -> Assertion
>     assertRead s f = assertEqual s f (read s)
>     assertFail :: String -> Assertion
>     assertFail s = assertError s (read s :: Func)

Digits
------

Implement a function that returns the digits used in a function.  Note that a
value of `12` uses digits `1` and `2`.  The returned array of digits should be
in sorted order.  You may use `sort :: Ord a => [a] -> [a]`, imported from
`Data.List`.

> digits :: Func -> [Int]
> digits = sort . map ((+ (-48)) . ord) . filter isDigit . show

To test: `runTests digitsTests`

> digitsTests :: [Test]
> digitsTests = map TestCase
>   [ assertDigits [1] (Val 1)
>   , assertDigits [1] (Val (-1))
>   , assertDigits [1,2] (Add (Val 1) (Val 2))
>   , assertDigits [1,2] (Add (Val 2) (Val 1))
>   , assertDigits [1,2] (Sub (Val 1) (Val 2))
>   , assertDigits [1,2] (Mul (Val 1) (Val 2))
>   , assertDigits [2,4] (Div (Val 4) (Val 2))
>   , assertDigits [3,4] (Mod (Val 4) (Val 3))
>   , assertDigits [2,4] (Pow (Val 4) (Val 2))
>   , assertDigits [4] (Fac (Val 4))
>   , assertDigits [2] (Abs (Val (-2)))
>   , assertDigits [1,2,3,4] (Mul (Sub (Val 4) (Val 3)) (Add (Val 2) (Val 1)))
>   , assertDigits [1,2,3,4] (Pow (Div (Val 4) (Val 2)) (Mod (Val 3) (Val 1)))
>   , assertDigits [1,2,3,4,5,6,7]
>                  (Mod (Pow (Add (Val 6) (Val 1)) (Div (Val 4) (Val 2)))
>                       (Sub (Mul (Val 5) (Fac (Val 3))) (Val 7)))
>   , assertDigits [0,1,1,2,2,3] (Add (Val 123) (Val 201))
>   ]
>   where
>     assertDigits :: [Int] -> Func -> Assertion
>     assertDigits xs f = assertEqual (show f) xs (digits f)

Evaluation
----------

Implement a function `eval` that evaluates a function.  Since not all
functions represented as a `Func` are valid, the return type of `eval` is
`Maybe Int`.  Return the value using `Just` when a function is valid.  Return
`Nothing` for the following conditions:

    * the result of the evaluation would not be integral
    * division or modulo of zero
    * exponentiation to a negative value
    * factorial of a negative value

Note that `Maybe` is a monadic type, so it is possible to define `eval` using
the `do` syntax.  This is not covered in the book, however, so I recommend
that you write your implementation without monadic syntax first.  Once your
implementation passes all tests, feel free to ask about the monadic syntax.

> eval :: Func -> Maybe Int
> eval = evalN

> -- non-monadic syntax
> evalN :: Func -> Maybe Int
> evalN (Val x) = Just x
> evalN (Add f g) =
>   case (evalN f, evalN g) of
>     (Just x, Just y) -> Just (x + y)
>     _                -> Nothing
> evalN (Sub f g) =
>   case (evalN f, evalN g) of
>     (Just x, Just y) -> Just (x - y)
>     _                -> Nothing
> evalN (Mul f g) =
>   case (evalN f, evalN g) of
>     (Just x, Just y) -> Just (x * y)
>     _                -> Nothing
> evalN (Div f g) =
>   case (evalN f, evalN g) of
>     (Just x, Just y) -> if y /= 0 && x `mod` y == 0
>                           then Just $ x `div` y
>                           else Nothing
>     _                -> Nothing
> evalN (Mod f g) =
>   case (evalN f, evalN g) of
>     (Just x, Just y) -> if y /= 0
>                           then Just $ x `mod` y
>                           else Nothing
>     _                -> Nothing
> evalN (Pow f g) =
>   case (evalN f, evalN g) of
>     (Just x, Just y) -> if y >= 0
>                           then Just $ x ^ y
>                           else Nothing
>     _                -> Nothing
> evalN (Fac f) =
>   case evalN f of
>     (Just x) -> if x >= 0
>                   then Just $ foldr (*) 1 [1..x]
>                   else Nothing
>     _        -> Nothing
> evalN (Abs f) =
>   case evalN f of
>     (Just x) -> Just $ abs x
>     _        -> Nothing

> -- monadic syntax
> evalM :: Func -> Maybe Int
> evalM (Val x)   = return x
> evalM (Add f g) = do x <- evalM f
>                      y <- evalM g
>                      return $ x + y
> evalM (Sub f g) = do x <- evalM f
>                      y <- evalM g
>                      return $ x - y
> evalM (Mul f g) = do x <- evalM f
>                      y <- evalM g
>                      return $ x * y
> evalM (Div f g) = do x <- evalM f
>                      y <- evalM g
>                      x `mdiv` y
>   where
>     mdiv :: Int -> Int -> Maybe Int
>     mdiv x y | y /= 0 && x `mod` y == 0 = Just $ x `div` y
>              | otherwise                = Nothing
> evalM (Mod f g) = do x <- evalM f
>                      y <- evalM g
>                      x `mmod` y
>   where
>     mmod :: Int -> Int -> Maybe Int
>     mmod x y | y /= 0    = Just $ x `mod` y
>              | otherwise = Nothing
> evalM (Pow f g) = do x <- evalM f
>                      y <- evalM g
>                      x `mpow` y
>   where
>     mpow :: Int -> Int -> Maybe Int
>     mpow x y | y >= 0    = Just $ x ^ y
>              | otherwise = Nothing
> evalM (Fac f)   = do x <- evalM f
>                      factorial x
>   where
>     factorial :: Int -> Maybe Int
>     factorial x | x >= 0    = Just $ foldr (*) 1 [1..x]
>                 | otherwise = Nothing
> evalM (Abs f)   = do x <- evalM f
>                      return $ abs x

To test: `runTests evalTests`

> evalTests :: [Test]
> evalTests = map TestCase
>   [ assertEval 1 (Val 1)
>   , assertEval (-1) (Val (-1))
>   , assertEval 3 (Add (Val 1) (Val 2))
>   , assertEval (-1) (Sub (Val 1) (Val 2))
>   , assertEval 2 (Mul (Val 1) (Val 2))
>   , assertEval 2 (Div (Val 4) (Val 2))
>   , assertEval 1 (Mod (Val 4) (Val 3))
>   , assertEval 16 (Pow (Val 4) (Val 2))
>   , assertEval 24 (Fac (Val 4))
>   , assertEval 2 (Abs (Val (-2)))
>   , assertEval 1 (Fac (Sub (Val 3) (Val 2)))
>   , assertEval 1 (Fac (Abs (Sub (Val 2) (Val 3))))
>   , assertEval 720 (Fac (Fac (Abs (Sub (Val 2) (Val 5)))))
>   , assertEval 3 (Mul (Sub (Val 4) (Val 3)) (Add (Val 2) (Val 1)))
>   , assertEval 2 (Pow (Div (Val 4) (Val 2)) (Mod (Val 3) (Val 2)))
>   , assertEval 3 (Mod (Pow (Add (Val 6) (Val 1)) (Div (Val 4) (Val 2)))
>                       (Sub (Mul (Val 5) (Fac (Val 3))) (Val 7)))
>   , assertEval 3 (Add (Val 1) (Sub (Mul (Val 2) (Val 3)) (Val 4)))
>   , assertEval 4 (Add (Val 4) (Sub (Mod (Val 3) (Val 2)) (Val 1)))
>   , assertEval 2 (Mul (Val 1) (Div (Pow (Val 2) (Val 3)) (Val 4)))
>   , assertEval 2 (Div (Pow (Abs (Mul (Val 1) (Val 2))) (Val 3)) (Val 4))
>   , assertEval 7 (Add (Sub (Val 2)
>                            (Mod (Div (Pow (Val 3)
>                                           (Abs (Sub (Val 3) (Val 5))))
>                                      (Val 3))
>                                 (Val 2)))
>                       (Mul (Val 1) (Fac (Val 3))))
>   , assertFail (Div (Val 1) (Val 0))
>   , assertFail (Div (Val 1) (Add (Val 1) (Val (-1))))
>   , assertFail (Div (Val 3) (Val 2))
>   , assertFail (Div (Val 3) (Add (Val 1) (Val 1)))
>   , assertFail (Mul (Val 4) (Div (Val 3) (Val 2)))
>   , assertFail (Mod (Val 3) (Val 0))
>   , assertEval (-2) (Mod (Val 7) (Val (-3)))
>   , assertEval 1 (Pow (Val 13) (Val 0))
>   , assertFail (Pow (Val 13) (Val (-1)))
>   , assertEval 1 (Fac (Val 0))
>   , assertFail (Fac (Val (-1)))
>   ]
>   where
>     assertEval :: Int -> Func -> Assertion
>     assertEval x f = assertEqual (show f) (Just x) (eval f)
>     assertFail :: Func -> Assertion
>     assertFail f = assertEqual (show f) Nothing (eval f)

Play
----

Write the function `play :: String -> Int -> IO ()` that defines the main game
loop.  The first argument is the list of digits, in `String` format.  The
second argument is the current target.  This function is in the `IO` monad, so
you may use functions such as `putStrLn` (to print to the screen) and
`getLine` (to read from the keyboard).

The first thing the function should do is display a prompt to inform the
player of the valid digits and current target.  If the valid digits are
`20111116` and the current target is `0`, then the prompt should be as
follows:

    {20111116} 0:

To allow the player to input on the same line, use `putStr` followed by
`hFlush stdout` to ensure that the output buffer is flushed before reading the
input using `getLine`.

If the player enters "quit", then you should exit the function.  Otherwise,
you should parse the function (displaying "parse error" on error), evaluate
the function (displaying "invalid function" on error), check that the
evaluated function is equal to the target (displaying "not equal to target" if
not), and check that the digits used are exactly those that are required
(displaying "invalid digits" otherwise).  When a check fails, you should
immediately continue with the same target.  When all checks pass, you should
continue with the incremented target.

> play :: String -> Int -> IO ()
> play cs = prompt
>   where
>     xs :: [Int]
>     xs = sort . map ((+ (-48)) . ord) $ cs
>     prompt :: Int -> IO ()
>     prompt target =
>       do putStr $ '{' : cs ++ "} " ++ show target ++ ": "
>          hFlush stdout
>          input <- getLine
>          if input == "quit"
>            then return ()
>            else checkParse target (parse func input)
>     checkParse :: Int -> [(Func,String)] -> IO ()
>     checkParse target [(f,"")] = checkEval target f (eval f)
>     checkParse target _        = do putStrLn "parse error"
>                                     prompt target
>     checkEval :: Int -> Func -> Maybe Int -> IO ()
>     checkEval target f (Just x)
>       | x == target = checkDigits target f
>       | otherwise   = do putStrLn "not equal to target"
>                          prompt target
>     checkEval target _ _ = do putStrLn "invalid function"
>                               prompt target
>     checkDigits :: Int -> Func -> IO ()
>     checkDigits target f
>       | digits f == xs = prompt (target + 1)
>       | otherwise      = do putStrLn "invalid digits"
>                             prompt target

The problem with this implementation is that `getLine` does not let you
edit your input.  For example, you are unable to go back and insert a
forgotten parenthesis, which can be very annoying.

I have written a version of `play` using the haskeline library, which allows
you to edit your input.  Assuming that all of the unit tests are passed, you
may run the `main` function to play the game.

Support Code
------------

The code in this section is used to implement the testing functions, the main
function, the haskeline version of `play`, and the parsing library.  You do
not need to make any modifications/additions to the code below.

Testing:

> allTests :: [Test]
> allTests = showTests ++ readTests ++ digitsTests ++ evalTests

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> assertError :: String -> a -> Assertion
> assertError msg x = handleJust errorCalls (const $ return ()) $ do
>     evaluate x
>     assertFailure $ msg ++ ": error not thrown"
>   where
>     errorCalls (ErrorCall _) = Just ()

Main:

> main :: IO ()
> main = runInputT defaultSettings title
>   where
>     title :: InputT IO ()
>     title = do outputStrLn "The Count Up Game"
>                check
>     check :: InputT IO ()
>     check = do outputStrLn "Checking unit tests..."
>                counts <- liftIO $ runTests allTests
>                if errors counts + failures counts == 0
>                  then menu
>                  else outputStrLn "Not all tests passed; stopping."
>     menu :: InputT IO ()
>     menu = do minput <- getInputLine
>                           "Play (d)efault, (r)andom, or (c)ustom game? "
>               case minput of
>                 Just "r" -> randomGame
>                 Just "c" -> customGame
>                 _        -> defaultGame

> instructions :: InputT IO ()
> instructions = outputStrLn "Type 'quit' to quit."

> getDate :: IO String
> getDate = do time <- getCurrentTime
>              return $ formatTime defaultTimeLocale "%Y%m%d" time

> defaultGame :: InputT IO ()
> defaultGame = do date <- liftIO getDate
>                  instructions
>                  playH date 0

> randomGame :: InputT IO ()
> randomGame = do count <- liftIO $ getStdRandom (randomR (6, 12))
>                 xs <- liftIO $ replicateM count
>                         (getStdRandom (randomR ((0,9) :: (Int,Int))))
>                 start <- liftIO $ getStdRandom (randomR (0, 100))
>                 instructions
>                 playH (concatMap show (sort xs)) start

> customGame :: InputT IO ()
> customGame = getDigits
>   where
>     getDigits = do date <- liftIO getDate
>                    mdigits <- getInputLine $
>                                 "Enter digits (" ++ date ++ "): "
>                    case mdigits of
>                      Just ""     -> getStart date
>                      Just digits -> checkDigits digits
>                      Nothing     -> getStart date
>     checkDigits :: String -> InputT IO ()
>     checkDigits digits = if (not . null . filter (not . isDigit)) digits
>                            then do outputStrLn "invalid digits"
>                                    getDigits
>                            else getStart digits
>     getStart :: String -> InputT IO ()
>     getStart digits = do mstart <- getInputLine "Enter start (0): "
>                          case mstart of
>                            Just ""    -> playH digits 0
>                            Just start -> checkStart digits start
>                            Nothing    -> playH digits 0
>     checkStart :: String -> String -> InputT IO ()
>     checkStart digits start = case parse int start of
>                                 [(s,"")] -> playH digits s
>                                 _        -> do outputStrLn "invalid start"
>                                                getStart digits

Haskeline version of `play`:

+-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-+
|                                                                         |
| Do not look at the implementation of `playH` until you have sucessfully |
| implemented `play`.                                                     |
|                                                                         |
+-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-WARNING-+

> playH :: String -> Int -> InputT IO ()
> playH cs = prompt
>   where
>     xs :: [Int]
>     xs = sort . map ((+ (-48)) . ord) $ cs
>     prompt :: Int -> InputT IO ()
>     prompt target =
>       do minput <- getInputLine $ '{' : cs ++ "} " ++ show target ++ ": "
>          case minput of
>            Just "quit" -> return ()
>            Nothing     -> return ()
>            Just input  -> checkParse target (parse func input)
>     checkParse :: Int -> [(Func,String)] -> InputT IO ()
>     checkParse target [(f,"")] = checkEval target f (eval f)
>     checkParse target _        = do outputStrLn "parse error"
>                                     prompt target
>     checkEval :: Int -> Func -> Maybe Int -> InputT IO ()
>     checkEval target f (Just x)
>       | x == target = checkDigits target f
>       | otherwise   = do outputStrLn "not equal to target"
>                          prompt target
>     checkEval target _ _ = do outputStrLn "invalid function"
>                               prompt target
>     checkDigits :: Int -> Func -> InputT IO ()
>     checkDigits target f
>       | digits f == xs = prompt (target + 1)
>       | otherwise      = do outputStrLn "invalid digits"
>                             prompt target

This parsing library is from chapter 8 of _Programming in Haskell_.

> newtype Parser a =  P (String -> [(a, String)])
> instance Monad Parser where
>    return v = P (\inp -> [(v, inp)])
>    p >>= f  = P (\inp -> case parse p inp of
>                            []        -> []
>                            [(v,out)] -> parse (f v) out)
> instance MonadPlus Parser where
>    mzero       = P (\inp -> [])
>    p `mplus` q = P (\inp -> case parse p inp of
>                               []        -> parse q inp
>                               [(v,out)] -> [(v,out)])

> failure :: Parser a
> failure = mzero

> item :: Parser Char
> item = P (\inp -> case inp of
>                     []     -> []
>                     (x:xs) -> [(x,xs)])

> parse :: Parser a -> String -> [(a,String)]
> parse (P p) inp =  p inp

> (+++) :: Parser a -> Parser a -> Parser a
> p +++ q = p `mplus` q
> infixr 5 +++

> sat :: (Char -> Bool) -> Parser Char
> sat p = do x <- item
>            if p x then return x else failure

> digit, lower, upper, letter, alphanum :: Parser Char
> digit    = sat isDigit
> lower    = sat isLower
> upper    = sat isUpper
> letter   = sat isAlpha
> alphanum = sat isAlphaNum

> char :: Char -> Parser Char
> char x = sat (== x)

> string :: String -> Parser String
> string []     = return []
> string (x:xs) = do char x
>                    string xs
>                    return (x:xs)

> many :: Parser a -> Parser [a]
> many p = many1 p +++ return []

> many1 :: Parser a -> Parser [a]
> many1 p = do v <- p
>              vs <- many p
>              return (v:vs)

> ident :: Parser String
> ident = do x <- lower
>            xs <- many alphanum
>            return (x:xs)

> nat, int :: Parser Int
> nat = do xs <- many1 digit
>          return (read xs)
> int = do char '-'
>          n <- nat
>          return (-n)
>         +++ nat

> space :: Parser ()
> space = do many (sat isSpace)
>            return ()

> token :: Parser a -> Parser a
> token p = do space
>              v <- p
>              space
>              return v

> identifier :: Parser String
> identifier = token ident

> natural, integer :: Parser Int
> natural = token nat
> integer = token int

> symbol :: String -> Parser String
> symbol xs = token (string xs)
