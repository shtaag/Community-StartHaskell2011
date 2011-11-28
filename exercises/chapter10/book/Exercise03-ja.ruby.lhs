「プログラミングHaskell」：｛第｝｛だい｝10｛章｝｛しょう｝：｛問題｝｛もんだい｝3
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛次｝｛つぎ｝のインポートは｛無視｝｛むし｝して｛良｝｛よ｝い。

> -- hunit
> import Test.HUnit

Treeの｛定義｝｛ていぎ｝
------------------------

> data Tree = Leaf Int | Node Tree Tree

テストのためのTree
------------------

> t0, t1, t2, t3, t4 :: Tree
> t0 = Leaf 1
> t1 = Node (Node (Leaf 1) (Leaf 2)) (Leaf 3)
> t2 = Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4))
> t3 = Node (Leaf 1) (Node (Node (Leaf 2) (Leaf 3)) (Leaf 4))
> t4 = Node (Node (Node (Node (Leaf 1) (Leaf 2))
>                       (Node (Leaf 3) (Leaf 4)))
>                 (Leaf 5))
>           (Node (Node (Leaf 6) (Leaf 7))
>                 (Node (Leaf 8)
>                       (Node (Leaf 9) (Leaf 10))))

｛問題｝｛もんだい｝
--------------------

`size`を｛定義｝｛ていぎ｝せよ。

> size :: Tree -> Int
> size = undefined

テストのコマンド： `runTests sizeTests`

> sizeTests :: [Test]
> sizeTests = map TestCase
>   [ assertEqual "t0" 1 (size t0)
>   , assertEqual "t1" 3 (size t1)
>   , assertEqual "t2" 4 (size t2)
>   , assertEqual "t3" 4 (size t3)
>   , assertEqual "t4" 10 (size t4)
>   ]

`balanced`を｛定義｝｛ていぎ｝せよ。

> balanced :: Tree -> Bool
> balanced = undefined

テストのコマンド： `runTests balancedTests`

> balancedTests :: [Test]
> balancedTests = map TestCase
>   [ assertEqual "t0" True (balanced t0)
>   , assertEqual "t1" True (balanced t1)
>   , assertEqual "t2" True (balanced t2)
>   , assertEqual "t3" False (balanced t3)
>   , assertEqual "t4" False (balanced t4)
>   ]

｛補助｝｛ほじょ｝コード
------------------------

｛次｝｛つぎ｝のものはテストの｛実行｝｛じっこう｝するための｛定義｝｛ていぎ｝
だ。これは｛無視｝｛むし｝して｛良｝｛よ｝い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
