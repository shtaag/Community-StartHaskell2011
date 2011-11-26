「プログラミングHaskell」：第12章：問題6
========================================

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで確認せよ。

以下の関数の型を宣言する前に、このファイルをコンパイルできない。

次のインポートを無視する。

> -- hunit
> import Test.HUnit

Treeの定義
----------

> data Tree a = Leaf | Node (Tree a) a (Tree a)
>   deriving (Eq)
>   -- note: at least one tree must be finite to test equality

ヘルパー関数：

> instance Show a => Show (Tree a) where
>   show Leaf         = ""
>   show (Node l v r) = '(' : show l ++ '[' : show v ++ ']' : show r ++ ")"

> countNodes :: Tree a -> Int
> countNodes Leaf         = 0
> countNodes (Node l _ r) = 1 + countNodes l + countNodes r

テストの値：

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

`repeatT`の型を宣言して、関数を定義せよ。

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

`takeT`の型を宣言して、関数を定義せよ。

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

ボーナス：`Tree`の上から取る（幅優先順）関数を定義せよ。

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

`replicateT`の型を宣言して、関数を定義せよ。

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

サポートのコード
----------------

次の定義はテストの実行するための定義だ。以下のコードを無視する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
