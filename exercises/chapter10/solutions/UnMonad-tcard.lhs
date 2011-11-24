UnMonad
=======

This is a literate Haskell file.  Implement your solution below.

You may ignore the following imports.

> -- base
> import Control.Monad (MonadPlus(..))
> import Data.Char (isAlpha, isAlphaNum, isDigit, isLower, isSpace, isUpper)

do Notation
-----------

Here is the expression parser from chapter 8 (page 84):

> expr :: Parser Int
> expr = do t <- term
>           do symbol "+"
>              e <- expr
>              return (t + e)
>             +++ return t

> term :: Parser Int
> term = do f <- factor
>           do symbol "*"
>              t <- term
>              return (f * t)
>             +++ return f

> factor :: Parser Int
> factor = do symbol "("
>             e <- expr
>             symbol ")"
>             return e
>            +++ natural

Use the `parse` function to test the parser in GHCi.  For example:

    > parse expr "(1 + 2) * (3 + 4)"
    [(21,"")]

No do
-----

Rewrite the above three parsing functions without using `do` notation.  To do
this, you will have to make use of the `>>=` and `>>` functions.  You may
continue to use the `+++` operator.  Use plenty of parenthesis to make the
scope of each variable explicit.

> expr2 :: Parser Int
> expr2 = term2 >>= (\t ->
>           (symbol "+" >> expr2 >>= (\e -> return (t + e)))
>           +++ (return t))

> term2 :: Parser Int
> term2 = factor2 >>= (\f ->
>           (symbol "*" >> term2 >>= (\t -> return (f * t)))
>           +++ (return f))

> factor2 :: Parser Int
> factor2 = (symbol "(" >> expr2 >>= (\e -> symbol ")" >> return e))
>           +++ natural

Use the `parse` function to test the parser in GHCi.  For example:

    > parse expr2 "(1 + 2) * (3 + 4)"
    [(21,"")]

No +++
------

Rewrite the definitions again, without using `do` notation or the `+++`
operator.  Note that this time you will need to use the `Parser` constructor
(`P`) explicitly.

> expr3 :: Parser Int
> expr3 = term3 >>= (\t ->
>   P (\inp ->
>        case parse (symbol "+" >> expr3 >>= (\e -> return (t + e))) inp of
>          [] -> parse (return t) inp
>          x  -> x))

> term3 :: Parser Int
> term3 = factor3 >>= (\f ->
>   P (\inp ->
>        case parse (symbol "*" >> term3 >>= (\t -> return (f * t))) inp of
>          [] -> parse (return f) inp
>          x  -> x))

> factor3 :: Parser Int
> factor3 = P (\inp ->
>   case parse (symbol "(" >> expr3 >>= (\e -> symbol ")" >> return e)) inp of
>     [] -> parse natural inp
>     x  -> x)

Use the `parse` function to test the parser in GHCi.  For example:

    > parse expr3 "(1 + 2) * (3 + 4)"
    [(21,"")]

No Monad Functions
------------------

Rewrite the definitions again, without using the monadic functions `>>=`,
`>>`, and `return`.

> expr4 :: Parser Int
> expr4 = P (\inp ->
>   case parse term4 inp of
>     []         -> []
>     [(t,inp2)] ->
>       case (case parse (symbol "+") inp2 of
>               []         -> []
>               [(_,inp3)] ->
>                 case parse expr4 inp3 of
>                   []         -> []
>                   [(e,inp4)] -> [(t + e, inp4)]) of
>         [] -> [(t, inp2)]
>         x  -> x)

> term4 :: Parser Int
> term4 = P (\inp ->
>   case parse factor4 inp of
>     []         -> []
>     [(f,inp2)] ->
>       case (case parse (symbol "*") inp2 of
>               []         -> []
>               [(_,inp3)] ->
>                 case parse term4 inp3 of
>                   []         -> []
>                   [(t,inp4)] -> [(f * t, inp4)]) of
>         [] -> [(f,inp2)]
>         x  -> x)

> factor4 :: Parser Int
> factor4 = P (\inp ->
>   case (case parse (symbol "(") inp of
>           []         -> []
>           [(_,inp2)] ->
>             case parse expr4 inp2 of
>               []         -> []
>               [(e,inp3)] ->
>                 case parse (symbol ")") inp3 of
>                   []         -> []
>                   [(_,inp4)] -> [(e, inp4)]) of
>     [] -> parse natural inp
>     x  -> x)

Use the `parse` function to test the parser in GHCi.  For example:

    > parse expr4 "(1 + 2) * (3 + 4)"
    [(21,"")]

Support Code
------------

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
