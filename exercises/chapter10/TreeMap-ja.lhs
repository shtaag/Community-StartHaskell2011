Tree Map
========

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで確認せよ。

次のインポートを無視する。

> -- hunit
> import Test.HUnit

Tree
----

次は103ページに定義してある`Tree`型だ。

    data Tree = Leaf Int | Node Tree Int Tree

この型は`Int`の値だけ入れる。多相型の版は以下にある。

    data Tree a = Leaf a | Node (Tree a) a (Tree a)

この宣言は、リストと同じように、`a`型変数を使ってどの型でも入れる。

でも、この型は大きい問題がある。この問題を述べよ。

    ここに答えよ。

125ページに定義してある節のみにデータがある木を考えよ。

> data Tree a = Leaf | Node (Tree a) a (Tree a)
>   deriving (Eq)

この型は同じ問題があるかどうかを述べよ。

    ここに答えよ。

以下はテストの木だ。

> test0, test1, test2, test4 :: Tree Int
> test0 = Leaf
> test1 = Node Leaf 1 Leaf
> test2 = Node (Node Leaf 1 Leaf) 2 Leaf
> test4 = Node (Node (Node Leaf 1 Leaf) 2 Leaf) 3 (Node Leaf 4 Leaf)

Show
----

`Show`のインスタンス宣言を書いたら、`Tree`を表示することができる。`Show`の
インスタンス宣言がないままに表示したら、エラーが起こる。

もし`Int`だけの`Tree`のための`Show`インスタンス宣言を書いたら、次のように
書く。

    instance Show Tree where
      show (Leaf v)     = show v
      show (Node l v r) = ...

`Int`は`Show`のインスタンスであるので値を表示することできる。多相型のための
`Show`のインスタンス宣言を書いたら、型変数も`Show`のインスタンスである制約が
必要。

    instance Show a => Show (Tree a) where
      show Leaf         = ...
      show (Node l v r) = ...

好きな木の構文を使って、`Show`のインスタンス宣言を完成せよ。

> instance Show a => Show (Tree a) where
>   show = undefined

GHCiに`test4`を入力して、正しく表示することを確認せよ。

treeMap
-------

関数型プログラミングの目標の一つは高階関数で抽象化を扱うことだ。よく使う
高階関数`map`はリストの各要素にある関数を適用して、新しいリストを戻る。
`Tree`の型と同じことをする関数`treeMap`を定義せよ。

> treeMap :: (a -> b) -> Tree a -> Tree b
> treeMap = undefined

テストのコマンド： `runTests treeMapTests`

> treeMapTests :: [Test]
> treeMapTests = map TestCase
>   [ assertEqual "treeMap (+ 1) test0"
>                 Leaf
>                 (treeMap (+ 1) test0)
>   , assertEqual "treeMap (+ 1) test1"
>                 (Node Leaf 2 Leaf)
>                 (treeMap (+ 1) test1)
>   , assertEqual "treeMap (+ 1) test2"
>                 (Node (Node Leaf 2 Leaf) 3 Leaf)
>                 (treeMap (+ 1) test2)
>   , assertEqual "treeMap (+ 1) test4"
>                 (Node (Node (Node Leaf 2 Leaf) 3 Leaf) 4 (Node Leaf 5 Leaf))
>                 (treeMap (+ 1) test4)
>   , assertEqual "treeMap show test0"
>                 Leaf
>                 (treeMap show test0)
>   , assertEqual "treeMap show test1"
>                 (Node Leaf "1" Leaf)
>                 (treeMap show test1)
>   , assertEqual "treeMap show test2"
>                 (Node (Node Leaf "1" Leaf) "2" Leaf)
>                 (treeMap show test2)
>   , assertEqual "treeMap show test4"
>                 (Node (Node (Node Leaf "1" Leaf) "2" Leaf)
>                       "3"
>                       (Node Leaf "4" Leaf))
>                 (treeMap show test4)
>   ]

Functor
-------

コンテナーの要素にある関数を適用することは基本な作業であるので、Haskellが
`Functor`クラスを宣言する。「Functor」（関手）は圏論の言葉だ。二つの圏の対応で
考える。（例えば、`map show [1..10]`は整数のリストの圏から文字列のリストの圏に
対応する。）

`Prelude`で宣言してある`Functor`クラスは次のように宣言してある。

    class Functor f where
      fmap :: (a -> b) -> f a -> f b

上の`Tree`の宣言には、どの型でも入れるために`a`の型変数を使った。でも
`Functor`の宣言には、`f`の型変数はコンテナーの型だ。例えば、`Tree`の`fmap`は
`fmap :: (a -> b) -> Tree a -> Tree b`という型を持って、最初の引数で渡す関数を
使って`a`型の`Tree`を`b`型の`Tree`に対応する。

`treeMap`関数を使えず、`Tree`のための`Functor`インスタンス宣言を完成せよ。

> instance Functor Tree where
>   fmap = undefined

（`Show`のインスタンス宣言と異なって、型の制約が必要ない。それで
インスタンス宣言の最初の行に`(Tree a)`を使わない。）

テストのコマンド： `runTests fmapTests`

> fmapTests :: [Test]
> fmapTests = map TestCase
>   [ assertEqual "fmap (+ 1) test0"
>                 Leaf
>                 (fmap (+ 1) test0)
>   , assertEqual "fmap (+ 1) test1"
>                 (Node Leaf 2 Leaf)
>                 (fmap (+ 1) test1)
>   , assertEqual "fmap (+ 1) test2"
>                 (Node (Node Leaf 2 Leaf) 3 Leaf)
>                 (fmap (+ 1) test2)
>   , assertEqual "fmap (+ 1) test4"
>                 (Node (Node (Node Leaf 2 Leaf) 3 Leaf) 4 (Node Leaf 5 Leaf))
>                 (fmap (+ 1) test4)
>   , assertEqual "fmap show test0"
>                 Leaf
>                 (fmap show test0)
>   , assertEqual "fmap show test1"
>                 (Node Leaf "1" Leaf)
>                 (fmap show test1)
>   , assertEqual "fmap show test2"
>                 (Node (Node Leaf "1" Leaf) "2" Leaf)
>                 (fmap show test2)
>   , assertEqual "fmap show test4"
>                 (Node (Node (Node Leaf "1" Leaf) "2" Leaf)
>                       "3"
>                       (Node Leaf "4" Leaf))
>                 (fmap show test4)
>   ]

`Functor`クラスを使って、標準である`fmap`関数でコンテナーの要素にある関数を
適用することができる。リストも`Functor`のインスタンスだのでリストと`fmap`も
使える。`map`はリストだけの`fmap`として考える。

目的
----

この練習問題の目的は型クラスの使い方の例をもう一つ見せることだ。モナドを完全
理解することが難しいのでHaskellを勉強する時によくモナドについて話す。でも私の
経験で、モナドがまだ分からない方は大体型変数を持つ型クラスも分からない。
型変数を持つ型クラスを使って、沢山抽象化の方法を作れる。モナドはただ一つだ。
モナドを理解するために型クラスを理解する必要。（サポートのコード以外、この練習
問題はモナドを使ってない。）

サポートのコード
----------------

次の定義はテストの実行するための定義だ。以下のコードを無視する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
