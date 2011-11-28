UnMonad
=======

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛次｝｛つぎ｝のインポートは｛無視｝｛むし｝して｛良｝｛よ｝い。

> -- base
> import Control.Monad (MonadPlus(..))
> import Data.Char (isAlpha, isAlphaNum, isDigit, isLower, isSpace, isUpper)

do｛記法｝｛きほう｝
--------------------

｛以下｝｛いか｝は｛第｝｛だい｝8｛章｝｛しょう｝のパーサー（101～102ページ）
だ。

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

GHCiで`parse`｛関数｝｛かんすう｝を｛使｝｛つか｝ってテストできる。例：

    > parse expr "(1 + 2) * (3 + 4)"
    [(21,"")]

do｛記法｝｛きほう｝なし
------------------------

do｛記法｝｛きほう｝を｛使｝｛つか｝わず、｛上｝｛うえ｝のパーサー
｛関数｝｛かんすう｝を｛再定義｝｛さいていぎ｝せよ。`>>=`と`>>`の
｛関数｝｛かんすう｝を｛直接｝｛ちょくせつ｝｛使｝｛つか｝う
｛必要｝｛ひつよう｝がある。`+++`｛演算子｝｛えんざんし｝を
｛使｝｛つか｝って｛良｝｛よ｝い。｛各｝｛かく｝｛変数｝｛へんすう｝の
スコープを｛明｝｛あき｝らかにするために｛括弧｝｛かっこ｝を
｛沢山｝｛たくさん｝｛使｝｛つか｝って｛良｝｛よ｝い。

> expr2 :: Parser Int
> expr2 = undefined

> term2 :: Parser Int
> term2 = undefined

> factor2 :: Parser Int
> factor2 = undefined

GHCiで`parse`｛関数｝｛かんすう｝を｛使｝｛つか｝ってテストできる。例：

    > parse expr2 "(1 + 2) * (3 + 4)"
    [(21,"")]

+++｛演算子｝｛えんざんし｝なし
-------------------------------

do｛記法｝｛きほう｝と`+++`｛演算子｝｛えんざんし｝を｛使｝｛つか｝わず、また
パーサー｛関数｝｛かんすう｝を｛再定義｝｛さいていぎ｝せよ。
｛今回｝｛こんかい｝は、`Parser`のコンストラクター（`P`）を
｛直接｝｛ちょくせつ｝｛使｝｛つか｝う｛必要｝｛ひつよう｝がある。

> expr3 :: Parser Int
> expr3 = undefined

> term3 :: Parser Int
> term3 = undefined

> factor3 :: Parser Int
> factor3 = undefined

GHCiで`parse`｛関数｝｛かんすう｝を｛使｝｛つか｝ってテストできる。例：

    > parse expr3 "(1 + 2) * (3 + 4)"
    [(21,"")]

モナド｛関数｝｛かんすう｝なし
------------------------------

モナド｛関数｝｛かんすう｝（`>>=`、`>>=`、`return`）を｛使｝｛つか｝わず、また
パーサー｛関数｝｛かんすう｝を｛再定義｝｛さいていぎ｝せよ。

> expr4 :: Parser Int
> expr4 = undefined

> term4 :: Parser Int
> term4 = undefined

> factor4 :: Parser Int
> factor4 = undefined

GHCiで`parse`｛関数｝｛かんすう｝を｛使｝｛つか｝ってテストできる。例：

    > parse expr4 "(1 + 2) * (3 + 4)"
    [(21,"")]

｛補助｝｛ほじょ｝コード
------------------------

「プログラミングHaskell」の｛第｝｛だい｝8｛章｝｛しょう｝のパーサー・
ライブラリは｛以下｝｛いか｝にある。

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
