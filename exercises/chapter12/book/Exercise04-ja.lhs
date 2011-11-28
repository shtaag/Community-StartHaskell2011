「プログラミングHaskell」：第12章：問題4
========================================

このファイルは文芸的プログラミングの形式で書かれている。このファイルに関数を
実装して、含まれているテストで確認せよ。

次のインポートは無視して良い。

> -- hunit
> import Test.HUnit

問題
----

`fibs`を定義せよ。

> fibs :: [Integer]
> fibs = undefined

テストのコマンド： `runTests fibsTests`

> fibsTests :: [Test]
> fibsTests = map TestCase
>   [ assertEqual "take 10 fibs" [0,1,1,2,3,5,8,13,21,34] (take 10 fibs)
>   ]

補助コード
----------

次のものはテストの実行するための定義だ。これは無視して良い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
