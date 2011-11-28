「プログラミングHaskell」：｛第｝｛だい｝12｛章｝｛しょう｝：｛問題｝｛もんだい｝6
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛以下｝｛いか｝の｛関数｝｛かんすう｝の｛型｝｛かた｝を
｛宣言｝｛せんげん｝する｛前｝｛まえ｝に、このファイルをコンパイルできない。

｛次｝｛つぎ｝のインポートは｛無視｝｛むし｝して｛良｝｛よ｝い。

> -- hunit
> import Test.HUnit

Treeの｛定義｝｛ていぎ｝
------------------------

> data Tree a = Leaf | Node (Tree a) a (Tree a)
>   deriving (Eq)
>   -- note: at least one tree must be finite to test equality

ヘルパー｛関数｝｛かんすう｝：

> instance Show a => Show (Tree a) where
>   show Leaf         = ""
>   show (Node l v r) = '(' : show l ++ '[' : show v ++ ']' : show r ++ ")"

> countNodes :: Tree a -> Int
> countNodes Leaf         = 0
> countNodes (Node l _ r) = 1 + countNodes l + countNodes r

テストの｛値｝｛あたい｝：

> t0, t1, t2, t3, t4 :: Tree Int
> t0 = Leaf
> t1 = Node Leaf 1 Leaf
> t2 = Node (Node Leaf 2 Leaf)
>           1
>           (Node (Node Leaf 4 Leaf)
>                 3
>                 (Node Leaf 5 Leaf))
> t3 = Node (Node (Node Leaf 3 Leaf)
>                 2
>                 (Node Leaf 4 Leaf))
>           1
>           (Node Leaf 5 Leaf)
> t4 = Node (Node (Node (Node Leaf 4 Leaf)
>                       3
>                       (Node Leaf 5 Leaf))
>                 2
>                 (Node Leaf 6 Leaf))
>           1
>           (Node (Node Leaf 8 Leaf)
>                 7
>                 (Node (Node Leaf 10 Leaf)
>                       9
>                       (Node Leaf 11 Leaf)))

repeatT
-------

`repeatT`の｛型｝｛かた｝を｛宣言｝｛せんげん｝して、｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝せよ。

> repeatT = undefined

テストのコマンド： `runTests repeatTTests`

> repeatTTests :: [Test]
> repeatTTests = map TestCase
>   [ assertBool "0" (check 10 0 (repeatT 0))
>   , assertBool "a" (check 10 'a' (repeatT 'a'))
>   ]
>   where
>     check :: Eq a => Int -> a -> (Tree a) -> Bool
>     check 0 _ _                        = True
>     check n x Leaf                     = False
>     check n x (Node l y r) | x == y    = let n' = n - 1
>                                          in  check n' x l && check n' x r
>                            | otherwise = False

takeT
-----

`takeT`の｛型｝｛かた｝を｛宣言｝｛せんげん｝して、｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝せよ。

> takeT = undefined

テストのコマンド： `runTests takeTTests`

> takeTTests :: [Test]
> takeTTests = map TestCase
>   [ assertEqual "takeT 0 t0" 0 (countNodes (takeT 0 t0))
>   , assertEqual "takeT 1 t0" 0 (countNodes (takeT 1 t0))
>   , assertEqual "takeT 0 t1" 0 (countNodes (takeT 0 t1))
>   , assertEqual "takeT 1 t1" 1 (countNodes (takeT 1 t1))
>   , assertEqual "takeT 2 t1" 1 (countNodes (takeT 2 t1))
>   , assertEqual "takeT 2 t2" 2 (countNodes (takeT 2 t2))
>   , assertEqual "takeT 4 t2" 4 (countNodes (takeT 4 t2))
>   , assertEqual "takeT 6 t2" 5 (countNodes (takeT 6 t2))
>   , assertEqual "takeT 2 t3" 2 (countNodes (takeT 2 t3))
>   , assertEqual "takeT 4 t3" 4 (countNodes (takeT 4 t3))
>   , assertEqual "takeT 6 t3" 5 (countNodes (takeT 6 t3))
>   , assertEqual "takeT 4 t4" 4 (countNodes (takeT 4 t4))
>   , assertEqual "takeT 6 t4" 6 (countNodes (takeT 6 t4))
>   , assertEqual "takeT 10 t4" 10 (countNodes (takeT 10 t4))
>   , assertEqual "takeT 12 t4" 11 (countNodes (takeT 12 t4))
>   , assertEqual "takeT 0 r" 0 (countNodes (takeT 0 (repeatT 'r')))
>   , assertEqual "takeT 10 r" 10 (countNodes (takeT 10 (repeatT 'r')))
>   , assertEqual "takeT 20 r" 20 (countNodes (takeT 20 (repeatT 'r')))
>   ]

ボーナス：`Tree`の｛上｝｛うえ｝から｛取｝｛と｝る
（｛幅優先順｝｛はばゆうせんじゅん｝）｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝せよ。

> takeTB = undefined

テストのコマンド： `runTests takeTBTests`

> takeTBTests :: [Test]
> takeTBTests = map TestCase
>   [ assertEqual "takeTB 0 t2" Leaf (takeTB 0 t2)
>   , assertEqual "takeTB 2 t2"
>       (Node (Node Leaf 2 Leaf) 1 Leaf)
>       (takeTB 2 t2)
>   , assertEqual "takeTB 3 t2"
>       (Node (Node Leaf 2 Leaf) 1 (Node Leaf 3 Leaf))
>       (takeTB 3 t2)
>   , assertEqual "takeTB 6 t2" t2 (takeTB 6 t2)
>   , assertEqual "takeTB 0 t3" Leaf (takeTB 0 t3)
>   , assertEqual "takeTB 2 t3"
>       (Node (Node Leaf 2 Leaf) 1 Leaf)
>       (takeTB 2 t3)
>   , assertEqual "takeTB 3 t3"
>       (Node (Node Leaf 2 Leaf) 1 (Node Leaf 5 Leaf))
>       (takeTB 3 t3)
>   , assertEqual "takeTB 6 t3" t3 (takeTB 6 t3)
>   , assertEqual "takeTB 0 t4" Leaf (takeTB 0 t4)
>   , assertEqual "takeTB 6 t4"
>       (Node (Node (Node Leaf 3 Leaf) 2 (Node Leaf 6 Leaf))
>             1
>             (Node (Node Leaf 8 Leaf) 7 Leaf))
>       (takeTB 6 t4)
>   , assertEqual "takeTB 12 t4" t4 (takeTB 12 t4)
>   , assertEqual "takeTB 0 r" Leaf (takeTB 0 (repeatT 'r'))
>   , assertEqual "takeTB 4 r"
>       (Node (Node (Node Leaf 'r' Leaf) 'r' Leaf) 'r' (Node Leaf 'r' Leaf))
>       (takeTB 4 (repeatT 'r'))
>   ]

replicateT
----------

`replicateT`の｛型｝｛かた｝を｛宣言｝｛せんげん｝して、｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝せよ。

> replicateT = undefined

テストのコマンド： `runTests replicateTTests`

> replicateTTests :: [Test]
> replicateTTests = map TestCase
>   [ testRep 0
>   , testRep 5
>   , testRep 10
>   ]
>   where
>     testRep :: Int -> Assertion
>     testRep n = let t = replicateT n 'r'
>                 in  assertBool ("replicateT " ++ show n ++ " 'r'")
>                                (countNodes t == n && checkNodes 'r' t)
>     checkNodes :: Eq a => a -> Tree a -> Bool
>     checkNodes x Leaf                     = True
>     checkNodes x (Node l y r) | x == y    = checkNodes x l && checkNodes x r
>                               | otherwise = False

｛補助｝｛ほじょ｝コード
------------------------

｛次｝｛つぎ｝のものはテストの｛実行｝｛じっこう｝するための｛定義｝｛ていぎ｝
だ。これは｛無視｝｛むし｝して｛良｝｛よ｝い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
