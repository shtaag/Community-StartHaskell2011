「プログラミングHaskell」：｛第｝｛だい｝10｛章｝｛しょう｝：｛問題｝｛もんだい｝2
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛次｝｛つぎ｝のインポートは｛無視｝｛むし｝して｛良｝｛よ｝い。

> -- hunit
> import Test.HUnit

｛本｝｛ほん｝にある｛定義｝｛ていぎ｝
--------------------------------------

｛本｝｛ほん｝で｛定義｝｛ていぎ｝してある`Tree`の｛宣言｝｛せんげん｝と
｛二分木｝｛にぶんぎ｝の｛例｝｛れい｝だ。

> data Tree = Leaf Int | Node Tree Int Tree

> t :: Tree
> t = Node (Node (Leaf 1) 3 (Leaf 4)) 5 (Node (Leaf 6) 7 (Leaf 9))

occurs
------

`occurs`を｛定義｝｛ていぎ｝せよ。

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

｛新｝｛あたら｝しい｛実装｝｛じっそう｝が｛元｝｛もと｝の｛実装｝｛じっそう｝
よりも｛効率的｝｛こうりつてき｝である｛理由｝｛りゆう｝を｛述｝｛の｝べよ。

    ここに｛答｝｛こた｝えよ。

｛補助｝｛ほじょ｝コード
------------------------

｛次｝｛つぎ｝のものはテストの｛実行｝｛じっこう｝するための｛定義｝｛ていぎ｝
だ。これを｛無視｝｛むし｝して｛良｝｛よ｝い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
