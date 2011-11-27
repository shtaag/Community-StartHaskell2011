「プログラミングHaskell」：第10章：問題2
========================================

このファイルは文芸的プログラミングの形式で書かれている。このファイルに関数を
実装して、含まれているテストで確認せよ。

次のインポートは無視してよい。

> -- hunit
> import Test.HUnit

本にある定義
------------

本で定義してある`Tree`の宣言と二分木の例だ。

> data Tree = Leaf Int | Node Tree Int Tree

> t :: Tree
> t = Node (Node (Leaf 1) 3 (Leaf 4)) 5 (Node (Leaf 6) 7 (Leaf 9))

occurs
------

`occurs`を定義せよ。

> occurs :: Int -> Tree -> Bool
> occurs = undefined

テストのコマンド： `runTests occursTests`

> occursTests :: [Test]
> occursTests = map TestCase
>   [ assertBool "1 in (1)" (occurs 1 (Leaf 1))
>   , assertBool "1 in (2)" (not $ occurs 1 (Leaf 2))
>   , assertBool "1 in t" (occurs 1 t)
>   , assertBool "2 in t" (not $ occurs 2 t)
>   , assertBool "3 in t" (occurs 3 t)
>   , assertBool "4 in t" (occurs 4 t)
>   , assertBool "5 in t" (occurs 5 t)
>   , assertBool "6 in t" (occurs 6 t)
>   , assertBool "7 in t" (occurs 7 t)
>   , assertBool "8 in t" (not $ occurs 8 t)
>   , assertBool "9 in t" (occurs 9 t)
>   , assertBool "10 in t" (not $ occurs 10 t)
>   ]

新しい実装が元の実装よりも効率的である理由を述べよ。

    ここに答えよ。

補助コード
----------------

次のものはテストの実行するための定義だ。これは無視してよい。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
