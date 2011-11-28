「プログラミングHaskell」：第12章：問題5
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

`fib`を定義せよ。

> fib :: Int -> Integer
> fib n = undefined

`fib1000`を定義せよ。

> fib1000 :: Integer
> fib1000 = undefined

テストのコマンド： `runTests fibsTests`

> fibsTests :: [Test]
> fibsTests = map TestCase
>   [ assertEqual "fib 30" 832040 (fib 30)
>   , assertEqual "fib1000" 1597 fib1000
>   ]

補助コード
----------

次のものはテストの実行するための定義だ。これは｛無視｝して良い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
