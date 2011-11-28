「プログラミングHaskell」：第11章：問題2
========================================

このファイルは文芸的プログラミングの形式で書かれている。このファイルに関数を
実装して、含まれているテストで確認せよ。

次のインポートは無視して良い。

> -- hunit
> import Test.HUnit

問題
----

自分の実装を定義せよ。

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

補助コード
----------

次のものはテストの実行するための定義だ。これは無視して良い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
