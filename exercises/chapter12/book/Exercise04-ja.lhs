「プログラミングHaskell」：第12章：問題4
========================================

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで確認せよ。

次のインポートを無視する。

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

サポートのコード
----------------

次の定義はテストの実行するための定義だ。以下のコードを無視する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
