「プログラミングHaskell」：｛第｝｛だい｝11｛章｝｛しょう｝：｛問題｝｛もんだい｝1
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝いている。このファイルの｛中｝｛なか｝に｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝して、｛含｝｛ふく｝まれているテストで
｛確認｝｛かくにん｝せよ。

｛次｝｛つぎ｝のインポートを｛無視｝｛むし｝する。

> -- hunit
> import Test.HUnit

ヘルパー｛関数｝｛かんすう｝
----------------------------

｛次｝｛つぎ｝の｛定義｝｛ていぎ｝は｛本｝｛ほん｝で｛定義｝｛ていぎ｝して
ある。

> subs :: [a] -> [[a]]
> subs []     = [[]]
> subs (x:xs) = yss ++ map (x :) yss
>   where
>     yss = subs xs

> interleave :: a -> [a] -> [[a]]
> interleave x []     = [[x]]
> interleave x (y:ys) = (x:y:ys) : map (y :) (interleave x ys)

> perms :: [a] -> [[a]]
> perms []     = [[]]
> perms (x:xs) = concat (map (interleave x) (perms xs))

｛問題｝｛もんだい｝
--------------------

リスト｛内包表記｝｛ないほうひょうき｝を｛使｝｛つか｝って、`choices`を
｛定義｝｛ていぎ｝せよ。

> choices :: [a] -> [[a]]
> choices = undefined

テストのコマンド： `runTests choicesTests`

> choicesTests :: [Test]
> choicesTests = map TestCase
>   [ assertChoices [[]] []
>   , assertChoices [[],[1]] [1]
>   , assertChoices [[],[2],[1],[1,2],[2,1]] [1,2]
>   , assertChoices [[],[3],[2],[2,3],[3,2],[1],[1,3],[3,1],[1,2],[2,1],
>                    [1,2,3],[2,1,3],[2,3,1],[1,3,2],[3,1,2],[3,2,1]]
>                   [1,2,3]
>   ]
>   where
>     assertChoices :: [[Int]] -> [Int] -> Assertion
>     assertChoices c l = assertEqual (show l) c (choices l)

サポートのコード
----------------

｛次｝｛つぎ｝の｛定義｝｛ていぎ｝はテストの｛実行｝｛じっこう｝するための
｛定義｝｛ていぎ｝だ。｛以下｝｛いか｝のコードを｛無視｝｛むし｝する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
