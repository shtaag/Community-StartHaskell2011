「プログラミングHaskell」：第10章：問題8
========================================

このファイルは文芸的プログラミングの形式で書かれている。このファイルに関数を
実装して、含まれているテストで確認せよ。

この問題の目標は`Maybe`と`[]`（リスト）の`Monad`インスタンス宣言を完成させる
ことだ。しかし両方の型とも既に`Prelude`に`Monad`のインスタンスが定義してあるため
エラーになり、自分の宣言をテストするのが難しい。このファイルにテストする
方法を用意した。

次のインポートは無視してよい。

> -- base
> import Prelude hiding (Monad(..))
>
> -- hunit
> import Test.HUnit

Monadのクラス
-------------

自分のインスタンス宣言をテストするために、本物の`Monad`クラスを隠して、
代わりに同等な次のクラスを使うことにする。

> class MyMonad m where
>   (>>=) :: m a -> (a -> m b) -> m b
>   (>>) :: m a -> m b -> m b
>   return :: a -> m a
>   p >> q = p >>= \_ -> q

Maybe
-----

以下のインスタンス宣言を完成させよ。

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

以下のインスタンス宣言を完成させよ。

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

補助コード
----------------

次のものはテストの実行するための定義だ。これは無視してよい。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
