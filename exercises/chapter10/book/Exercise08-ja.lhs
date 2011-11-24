「プログラミングHaskell」：第10章：問題8
========================================

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで確認せよ。

この問題の目標は`Maybe`と`[]`（リスト）の`Monad`インスタンス宣言を完成する
ことだ。でも両方の型は`Prelude`に`Monad`のインスタンスが定義してあるので、
エラーが起こるため、自分の宣言をテストするのが難しい。このファイルにテストする
方法が用意してある。

次のインポートを無視する。

> -- base
> import Prelude hiding (Monad(..))
>
> -- hunit
> import Test.HUnit

Monadのクラス
-------------

自分のインスタンス宣言をテストするために、本物の`Monad`クラスを隠されて、
ここで宣言するクラスのインスタンス宣言を完成する。

> class MyMonad m where
>   (>>=) :: m a -> (a -> m b) -> m b
>   (>>) :: m a -> m b -> m b
>   return :: a -> m a
>   p >> q = p >>= \_ -> q

Maybe
-----

以下のインスタンス宣言を完成せよ。

> instance MyMonad Maybe where
>   -- return :: a -> Maybe a
>   return = undefined
>   -- (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
>   (>>=) = undefined

テストのコマンド： `runTests maybeTests`

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

以下のインスタンス宣言を完成せよ。

> instance MyMonad [] where
>   -- return :: a -> [a]
>   return = undefined
>   -- (>>=) :: [a] -> (a -> [b]) [b]
>   (>>=) = undefined

テストのコマンド： `runTests listTests`

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

サポートのコード
----------------

次の定義はテストの実行するための定義だ。以下のコードを無視する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
