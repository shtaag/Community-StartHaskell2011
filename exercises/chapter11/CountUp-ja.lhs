「数え上げ」ゲーム
==================

このファイルは文芸的プログラミングの形式で書かれている。このファイルを自分の
パソコンにダウンロードして、`CountUp.lhs`と名付けよ。ファイルにある`undefined`
関数を消して、自分の定義で実装せよ。含まれているテストで自分の定義を確認せよ。
全てのテストが通ったら、ゲームをコンパイルして遊ぶことができるようになる。

依存関係：

    * GHC 7.0.3 以上 (Haskell Platform 2011.2.0.1 以上)
    * HUnit (インストールするコマンド： `cabal install hunit`)
    * Haskeline (インストールするコマンド： `cabal install haskeline`)

概要
----

「数え上げ」ゲームは、昔、私がMixiの数学コミュニティーで遊んだゲームだ。
プレーヤーは、ある決まった数字の集合（大体現在の年月日）と演算子を使って、
目標の値になる関数を作る。各関数は全ての数字をちょうど一回ずつ使う必要がある。
目標の値は0から始まり、正当な関数を見つかったら増加させていく。

例：数字が`20111116`で、目標の値が`121`だったら、`(20-(6+1+1+1))^(1+1)`が
正当な関数だ。

この練習問題では、Haskellでこのゲームを開発する。

次のモジュール宣言とインポートは無視して良い。

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

関数
----

「数え上げ」ゲームは、整数のゲームだ。次のデータ構造で宣言している演算子を
使って関数を作る。

> data Func = Val Int        -- 値
>           | Add Func Func  -- 和算(+)
>           | Sub Func Func  -- 減算(-)
>           | Mul Func Func  -- 乗算(*)
>           | Div Func Func  -- 整数の除算(/)
>           | Mod Func Func  -- モジュロ演算(%)
>           | Pow Func Func  -- 累乗演算(^)
>           | Fac Func       -- 階乗演算(_!)
>           | Abs Func       -- 絶対値(|_|)
>   deriving (Eq)

テストのために`Eq`のインスタンスを自動導出する。二つの関数が全く同じ構文木を
持っていたら同等だ。例えば、`(1 + 2) + 3`と`1 + (2 + 3)`は構文木が異なるので
同等ではない。

Show
----

`Func`のための`Show`インスタンス宣言の`show :: Func -> String`関数を定義せよ。
以下の場合を除いて、必ず括弧を付けよ。

    * 関数全体には括弧は必要ない
    * 絶対値の中の関数には括弧は必要ない

具体的な実例は以下のテストにある。

> instance Show Func where
>   show = undefined

テストのコマンド： `runTests showTests`

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

第8章のパーサー・ライブラリを使って、関数のパーサーを実装せよ。（パーサー・
ライブラリはこのファイルの下に付いてる。）`show`の実装では明示的に括弧を
使うが、このパーサーは括弧がない関数を取り込める必要がある。以下の結合性と
束縛の優先順位を使え。

    * (+), (-): 最も弱い束縛、左結合
    * (*), (/), (%): 中束縛、左結合
    * (^): 最も強い束縛、右結合

> func :: Parser Func
> func = undefined

次は`Func`のための`Read`インスタンス宣言だ。

> instance Read Func where
>   readsPrec _ = parse func

テストのコマンド： `runTests readTests`

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

数字
----

関数に使っている数字を返す関数`digits`を定義せよ。`12`という値は二つの数字
（`1`と`2`）を使っていることに注意せよ。戻り値は昇順のリストとする。
`Data.List`からインポートされた`sort :: Ord a => [a] -> [a]`関数を使うと良い。

> digits :: Func -> [Int]
> digits = undefined

テストのコマンド： `runTests digitsTests`

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

評価
----

関数を評価する関数`eval`を定義せよ。正当ではない関数もあるので、`eval`の
戻り値の型は`Maybe Int`だ。正当な関数だったら、`Just`を使って値を返せ。以下の
場合は`Nothing`を返せ。

    * 評価する値が整数ではない
    * 0によるの除算やモジュロ
    * マイナスの階乗

`Maybe`はモナドのインスタンスだから、do記法を使って`eval`を定義できる。
こういう`Maybe`の使い方は本には書いてない。最初にdo記法を使わずに`eval`を
普通に定義することをお勧めする。この定義が全てのテストを通ったらdo記法を
使ってみると良い。

> eval :: Func -> Maybe Int
> eval = undefined

テストのコマンド： `runTests evalTests`

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

ゲームのメイン・ループの関数`play :: String -> Int -> IO ()`を定義せよ。最初の
引数は`String`型の数字のリストだ。二番目の引数は現在の目標の値だ。この関数は
`IO`モナドに入っているので、画面に文字列を表示するために`putStrLn`関数を
使ったり、プレーヤーが入力した文字列を受け取るために`getLine`関数を使ったり
することができる。

プレーヤーに数字と現在の目標の値が分かるように、この関数は最初にプロンプトを
表示する。例えば、数字が`20111116`で現在の目標の値が`0`だったら、次のような
プロンプトを表示する。

    {20111116} 0:

プレーヤーが同じ行に入力できるように、`putStr`でプロンプトを表示して後
`hFlush stdout`を実行する。それから`getLine`を使って、入力した文字列を
受け取る。

プレーヤーが「quit」を入力したら止める。他の値だったら、パーサーで関数に変換
して（エラーの場合：「parse error」を表示）、関数を評価して（正当ではない
場合：「invalid function」を表示）、現在の目標の値と同等であることを確認して
（同等ではない場合：「not equal to target」を表示）、関数の数字が正当である
ことを確認する（そうではない場合：「invalid digits」を表示）。何かが
正しくなかったら、すぐに同じ目標の値で再帰する。全てが正しかったら、増加した
目標の値で再帰する。

> play :: String -> Int -> IO ()
> play = undefined

この実装の問題は、`getLine`では入力時に編集することができない点だ。例えば、
括弧を忘れても戻って入力しなおすことができない。これはとても面倒だ。

入力する時に編集できるように、私がhaskelineライブラリを使って他の`play`関数を
定義した。このファイルの全てのテストを通ったら、`main`関数でゲームを遊ぶことが
できる。

補助コード
----------

以下のコードはテストするための定義と`main`関数とhaskeline版の`play`関数と
パーサーのライブラリだ。このコードを編集する必要はない。

テストするための定義：

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

`main`関数：

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

Haskeline版の`play`関数：

+-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-+
|                                                                            |
| 自分で`play`を正しく定義する前に`playH`を見ない方が良い。                  |
|                                                                            |
+-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-+

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
