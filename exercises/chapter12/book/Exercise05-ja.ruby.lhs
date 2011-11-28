「プログラミングHaskell」：｛第｝｛だい｝12｛章｝｛しょう｝：｛問題｝｛もんだい｝5
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛次｝｛つぎ｝のインポートは｛無視｝｛むし｝して｛良｝｛よ｝い。

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

｛補助｝｛ほじょ｝コード
------------------------

｛次｝｛つぎ｝のものはテストの｛実行｝｛じっこう｝するための｛定義｝｛ていぎ｝
だ。これは｛無視｝して｛良｝｛よ｝い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
