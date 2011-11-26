「プログラミングHaskell」：｛第｝｛だい｝12｛章｝｛しょう｝：｛問題｝｛もんだい｝5
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝いている。このファイルの｛中｝｛なか｝に｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝して、｛含｝｛ふく｝まれているテストで
｛確認｝｛かくにん｝せよ。

｛次｝｛つぎ｝のインポートを｛無視｝｛むし｝する。

> -- hunit
> import Test.HUnit

｛問題｝｛もんだい｝
--------------------

`fibs`を｛定義｝｛ていぎ｝せよ。

> fibs :: [Integer]
> fibs = undefined

`fib`を｛定義｝｛ていぎ｝せよ。

> fib :: Int -> Integer
> fib n = undefined

`fib1000`を｛定義｝｛ていぎ｝せよ。

> fib1000 :: Integer
> fib1000 = undefined

テストのコマンド： `runTests fibsTests`

> fibsTests :: [Test]
> fibsTests = map TestCase
>   [ assertEqual "fib 30" 832040 (fib 30)
>   , assertEqual "fib1000" 1597 fib1000
>   ]

サポートのコード
----------------

｛次｝｛つぎ｝の｛定義｝｛ていぎ｝はテストの｛実行｝｛じっこう｝するための
｛定義｝｛ていぎ｝だ。｛以下｝｛いか｝のコードを｛無視｝｛むし｝する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
