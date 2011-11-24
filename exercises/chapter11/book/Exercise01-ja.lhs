「プログラミングHaskell」：第11章：問題1
========================================

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで確認せよ。

次のインポートを無視する。

> -- hunit
> import Test.HUnit

ヘルパー関数
------------

次の定義は本で定義してある。

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

問題
----

リスト内包表記を使って、`choices`を定義せよ。

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

次の定義はテストの実行するための定義だ。以下のコードを無視する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
