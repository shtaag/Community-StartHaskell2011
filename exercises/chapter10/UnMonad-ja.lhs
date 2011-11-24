UnMonad
=======

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで確認せよ。

次のインポートを無視する。

> -- base
> import Control.Monad (MonadPlus(..))
> import Data.Char (isAlpha, isAlphaNum, isDigit, isLower, isSpace, isUpper)

do記法
------

以下は第8章のパーサー（ページ101～102）だ。

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

GHCiで`parse`関数を使ってテストできる。例：

    > parse expr "(1 + 2) * (3 + 4)"
    [(21,"")]

do記法を抜く
------------

do記法を使えず、上のパーサー関数を再定義せよ。`>>=`と`>>`の関数を直接使う
必要になる。`+++`の演算子を使って良い。各変数のスコープを明らかにするために
沢山括弧を使って良い。

> expr2 :: Parser Int
> expr2 = undefined

> term2 :: Parser Int
> term2 = undefined

> factor2 :: Parser Int
> factor2 = undefined

GHCiで`parse`関数を使ってテストできる。例：

    > parse expr2 "(1 + 2) * (3 + 4)"
    [(21,"")]

+++演算子を抜く
---------------

do記法と`+++`演算子を使えず、またパーサー関数を再定義せよ。今回、`Parser`の
コンストラクター（`P`）を直接使う必要になる。

> expr3 :: Parser Int
> expr3 = undefined

> term3 :: Parser Int
> term3 = undefined

> factor3 :: Parser Int
> factor3 = undefined

GHCiで`parse`関数を使ってテストできる。例：

    > parse expr3 "(1 + 2) * (3 + 4)"
    [(21,"")]

モナド関数を抜く
----------------

モナド関数（`>>=`、`>>=`、`return`）を使えず、またパーサー関数を再定義せよ。

> expr4 :: Parser Int
> expr4 = undefined

> term4 :: Parser Int
> term4 = undefined

> factor4 :: Parser Int
> factor4 = undefined

GHCiで`parse`関数を使ってテストできる。例：

    > parse expr4 "(1 + 2) * (3 + 4)"
    [(21,"")]

サポートのコード
----------------

「プログラミングHaskell」の第8章のパーサー・ライブラリは以下にある。

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
