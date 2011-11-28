Tree Map
========

このファイルは文芸的プログラミングの形式で書かれている。このファイルに関数を
実装して、含まれているテストで確認せよ。

次のインポートは無視して良い。

> -- hunit
> import Test.HUnit

Tree
----

次のものは103ページに定義してある`Tree`型だ。

    data Tree = Leaf Int | Node Tree Int Tree

このデータ型は`Int`の値に特化している。多相型版は以下のようになる。

    data Tree a = Leaf a | Node (Tree a) a (Tree a)

この宣言では、リストと同じように、`a`型変数によってどの型でも持つことが
できる。

しかしながら、この型には大きな問題がある。それは何か。

    ここに答えよ。

125ページに定義してある、節のみにデータがある木を考えよ。

> data Tree a = Leaf | Node (Tree a) a (Tree a)
>   deriving (Eq)

この木にも同じ問題があるかどうか述べよ。

    ここに答えよ。

以下はテストの木だ。

> test0, test1, test2, test4 :: Tree Int
> test0 = Leaf
> test1 = Node Leaf 1 Leaf
> test2 = Node (Node Leaf 1 Leaf) 2 Leaf
> test4 = Node (Node (Node Leaf 1 Leaf) 2 Leaf) 3 (Node Leaf 4 Leaf)

Show
----

`Show`のインスタンス宣言を書くと、`Tree`を画面に表示することができる。`Show`の
インスタンス宣言がないまま表示したら、エラーが起こる。

もし`Int`に特化した`Tree`の`Show`インスタンス宣言を書いたら、次のようになる。

    instance Show Tree where
      show (Leaf v)     = show v
      show (Node l v r) = ...

`Int`は`Show`のインスタンスであるので値を表示することできる。多相型の`Tree`の
`Show`のインスタンス宣言を書くときは、型変数も`Show`のインスタンスである制約が
必要だ。

    instance Show a => Show (Tree a) where
      show Leaf         = ...
      show (Node l v r) = ...

好きな木の構文を使って、`Show`のインスタンス宣言を完成せよ。

> instance Show a => Show (Tree a) where
>   show = undefined

GHCiに`test4`を入力して、正しく表示されることを確認せよ。

treeMap
-------

関数型プログラミングの目標の一つは高階関数で抽象化を扱うことだ。よく使う
高階関数`map :: (a -> b) -> [a] -> [b]`は、リストの各要素に関数を適用して、
新しいリストを返す。`Tree`型に対して同じことをする高階関数`treeMap`を定義
せよ。

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

コンテナーの要素に関数を適用することは基本な作業であるので、Haskellには
そのための`Functor`クラスがある。「Functor」（関手）は圏論の言葉だ。二つの圏の
間の対応として考える。（例えば、`map show [1..10]`は整数のリストの圏から
文字列のリストの圏への対応として考えることができる。）

`Prelude`では`Functor`クラスは次のように宣言されている。

    class Functor f where
      fmap :: (a -> b) -> f a -> f b

前述の`Tree`型の宣言では、どの型でも取れるように型変数`a`を使った。一方この
`Functor`の宣言では、型変数`f`はコンテナーの型を表している。例えば、`Tree`の
`fmap`は`fmap :: (a -> b) -> Tree a -> Tree b`という型で、最初の引数で渡す
関数を使って`a`型の`Tree`を`b`型の`Tree`へ写す。

`treeMap`関数を使わずに、`Tree`の`Functor`インスタンス宣言を完成させよ。

> instance Functor Tree where
>   fmap = undefined

（`Show`のインスタンス宣言と異なり、型の制約が必要ない。なのでインスタンス
宣言の最初の行に`(Tree a)`を書かない。）

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

`Functor`クラスを使えば、標準の`fmap`関数でコンテナーの要素に関数を適用する
ことができる。リストも`Functor`のインスタンスなので、リストにも`fmap`を使う
ことができる。`map`関数は、コンテナーがリストの場合の特殊な`fmap`として
考えられる。

目的
----

この練習問題の目的は、型クラスの使い方の例をもう一つ見せることだ。Haskellを
勉強する時、よくモナドについて語られる。なぜなら、モナドは理解するのが
難しいからだ。しかし私の経験によると、モナドをまだ理解していない人は大体、
型変数を持つ型クラスも理解していない。型変数を持つ型クラスを使えば、抽象化する
方法はいくらでもある。モナドはそのうちの一つにすぎない。モナドを
理解するためには、型クラスを理解することが必須だ。（下の補助コード以外、この
練習問題はモナドを使ってない。）

補助コード
----------

次のものはテストの実行するための定義だ。これは無視して良い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
