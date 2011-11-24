「プログラミングHaskell」：｛第｝｛だい｝11｛章｝｛しょう｝：｛問題｝｛もんだい｝2
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

｛自分｝｛じぶん｝の｛実装｝｛じっそう｝を｛定義｝｛ていぎ｝せよ。

> isChoice :: Eq a => [a] -> [a] -> Bool
> isChoice = undefined

テストのコマンド： `runTests isChoiceTests`

> isChoiceTests :: [Test]
> isChoiceTests = map TestCase
>   [ assertChoice [] []
>   , assertNotChoice [0] []
>   , assertChoice [] [1]
>   , assertChoice [1] [1]
>   , assertNotChoice [0] [1]
>   , assertChoice [] [1,2,3]
>   , assertChoice [2] [1,2,3]
>   , assertChoice [3,2] [1,2,3]
>   , assertChoice [1,3,2] [1,2,3]
>   , assertNotChoice [3,0,1] [1,2,3]
>   ]
>   where
>     assertChoice :: [Int] -> [Int] -> Assertion
>     assertChoice sub sup = assertEqual
>       (show sub ++ " `isChoice` " ++ show sup)
>       True (sub `isChoice` sup)
>     assertNotChoice :: [Int] -> [Int] -> Assertion
>     assertNotChoice sub sup = assertEqual
>       ("not (" ++ show sub ++ " `isChoice` " ++ show sup ++ ")")
>       False (sub `isChoice` sup)

サポートのコード
----------------

｛次｝｛つぎ｝の｛定義｝｛ていぎ｝はテストの｛実行｝｛じっこう｝するための
｛定義｝｛ていぎ｝だ。｛以下｝｛いか｝のコードを｛無視｝｛むし｝する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
