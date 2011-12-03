Tree Map
========

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛次｝｛つぎ｝のインポートは｛無視｝｛むし｝して｛良｝｛よ｝い。

> -- hunit
> import Test.HUnit

Tree
----

｛次｝｛つぎ｝のものは103ページに｛定義｝｛ていぎ｝してある
`Tree`｛型｝｛かた｝だ。

    data Tree = Leaf Int | Node Tree Int Tree

このデータ｛型｝｛かた｝は`Int`の｛値｝｛あたい｝に｛特化｝｛とっか｝
している。｛多相型｝｛たそうかた｝｛版｝｛ばん｝は｛以下｝｛いか｝のように
なる。

    data Tree a = Leaf a | Node (Tree a) a (Tree a)

この｛宣言｝｛せんげん｝では、リストと｛同｝｛おな｝じように、`a`
｛型変数｝｛かたへんすう｝によってどの｛型｝｛かた｝でも｛持｝｛も｝つことが
できる。

125ページに｛定義｝｛ていぎ｝してある、｛節｝｛ふし｝のみにデータがある
｛木｝｛き｝を｛考｝｛かんが｝えよ。

> data Tree a = Leaf | Node (Tree a) a (Tree a)
>   deriving (Eq)

｛以下｝｛いか｝はテストの｛木｝｛き｝だ。

> test0, test1, test2, test4 :: Tree Int
> test0 = Leaf
> test1 = Node Leaf 1 Leaf
> test2 = Node (Node Leaf 1 Leaf) 2 Leaf
> test4 = Node (Node (Node Leaf 1 Leaf) 2 Leaf) 3 (Node Leaf 4 Leaf)

Show
----

`Show`のインスタンス｛宣言｝｛せんげん｝を｛書｝｛か｝くと、`Tree`を
｛画面｝｛がめん｝に｛表示｝｛ひょうじ｝することができる。`Show`のインスタンス
｛宣言｝｛せんげん｝がないまま｛表示｝｛ひょうじ｝したら、エラーが
｛起｝｛お｝こる。

もし`Int`に｛特化｝｛とっか｝した`Tree`の`Show`インスタンス
｛宣言｝｛せんげん｝を｛書｝｛か｝いたら、｛次｝｛つぎ｝のようになる。

    instance Show Tree where
      show (Leaf v)     = show v
      show (Node l v r) = ...

`Int`は`Show`のインスタンスであるので｛値｝｛あたい｝を｛表示｝｛ひょうじ｝
することできる。｛多相型｝｛たそうかた｝の`Tree`の`Show`のインスタンス
｛宣言｝｛せんげん｝を｛書｝｛か｝くときは、｛型変数｝｛かたへんすう｝も
`Show`のインスタンスである｛制約｝｛せいやく｝が｛必要｝｛ひつよう｝だ。

    instance Show a => Show (Tree a) where
      show Leaf         = ...
      show (Node l v r) = ...

｛好｝｛す｝きな｛木｝｛き｝の｛構文｝｛こうぶん｝を｛使｝｛つか｝って、
`Show`のインスタンス｛宣言｝｛せんげん｝を｛完成｝｛かんせい｝せよ。

> instance Show a => Show (Tree a) where
>   show = undefined

GHCiに`test4`を｛入力｝｛にゅうりょく｝して、｛正｝｛ただ｝しく
｛表示｝｛ひょうじ｝されることを｛確認｝｛かくにん｝せよ。

treeMap
-------

｛関数型｝｛かんすうがた｝プログラミングの｛目標｝｛もくひょう｝の
｛一｝｛ひと｝つは｛高階関数｝｛こうかいかんすう｝で
｛抽象化｝｛ちゅうしょうか｝を｛扱｝｛あつか｝うことだ。よく｛使｝｛つか｝う
｛高階関数｝｛こうかいかんすう｝`map :: (a -> b) -> [a] -> [b]`は、リストの
｛各｝｛かく｝｛要素｝｛ようそ｝に｛関数｝｛かんすう｝を｛適用｝｛てきよう｝
して、｛新｝｛あたら｝しいリストを｛返｝｛かえ｝す。`Tree`｛型｝｛かた｝に
｛対｝｛たい｝して｛同｝｛おな｝じことをする｛高階関数｝｛こうかいかんすう｝
`treeMap`を｛定義｝｛ていぎ｝せよ。

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

コンテナーの｛要素｝｛ようそ｝に｛関数｝｛かんすう｝を｛適用｝｛てきよう｝する
ことは｛基本｝｛きほん｝な｛作業｝｛さぎょう｝であるので、Haskellには
そのための`Functor`クラスがある。「Functor」（｛関手｝｛かんしゅ｝）は
｛圏論｝｛けんろん｝の｛言葉｝｛ことば｝だ。｛二｝｛ふた｝つの｛圏｝｛けん｝の
｛間｝｛あいだ｝の｛対応｝｛たいおう｝として｛考｝｛かんが｝える。
（｛例｝｛たと｝えば、`map show [1..10]`は｛整数｝｛せいすう｝のリストの
｛圏｝｛けん｝から｛文字列｝｛もじれつ｝のリストの｛圏｝｛けん｝への
｛対応｝｛たいおう｝として｛考｝｛かんが｝えることができる。）

`Prelude`では`Functor`クラスは｛次｝｛つぎ｝のように｛宣言｝｛せんげん｝
されている。

    class Functor f where
      fmap :: (a -> b) -> f a -> f b

｛前述｝｛ぜんじゅつ｝の`Tree`｛型｝｛かた｝の｛宣言｝｛せんげん｝では、どの
｛型｝｛かた｝でも｛取｝｛と｝れるように｛型変数｝｛かたへんすう｝`a`を
｛使｝｛つか｝った。｛一方｝｛いっぽう｝この`Functor`の
｛宣言｝｛せんげん｝では、｛型変数｝｛かたへんすう｝`f`はコンテナーの
｛型｝｛かた｝を｛表｝｛あらわ｝している。｛例｝｛とと｝えば、`Tree`の`fmap`は
`fmap :: (a -> b) -> Tree a -> Tree b`という｛型｝｛かた｝で、
｛最初｝｛さいしょ｝の｛引数｝｛ひきすう｝で｛渡｝｛わた｝す
｛関数｝｛かんすう｝を｛使｝｛つか｝って`a`｛型｝｛かた｝の`Tree`を
`b`｛型｝｛かた｝の`Tree`へ｛写｝｛うつ｝す。

`treeMap`｛関数｝｛かんすう｝を｛使｝｛つか｝わずに、`Tree`の`Functor`
インスタンス｛宣言｝｛せんげん｝を｛完成｝｛かんせい｝させよ。

> instance Functor Tree where
>   fmap = undefined

（`Show`のインスタンス｛宣言｝｛せんげん｝と｛異｝｛こと｝なり、
｛型｝｛かた｝の｛制約｝｛せいやく｝が｛必要｝｛ひつよう｝ない。なので
インスタンス｛宣言｝｛せんげん｝の｛最初｝｛さいしょ｝の｛行｝｛ぎょう｝に
`(Tree a)`を｛書｝｛か｝かない。）

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

`Functor`クラスを｛使｝｛つか｝えば、｛標準｝｛ひょうじゅん｝の`fmap`
｛関数｝｛かんすう｝でコンテナーの｛要素｝｛ようそ｝に｛関数｝｛かんすう｝を
｛適用｝｛てきよう｝することができる。リストも`Functor`のインスタンスなので、
リストにも`fmap`を｛使｝｛つか｝うことができる。`map`｛関数｝｛かんすう｝は、
コンテナーがリストの｛場合｝｛ばあい｝の｛特殊｝｛とくしゅ｝な`fmap`として
｛考｝｛かんが｝えられる。

｛目的｝｛もくてき｝
--------------------

この｛練習｝｛れんしゅう｝｛問題｝｛もんだい｝の｛目的｝｛もくてき｝は、
｛型｝｛かた｝クラスの｛使｝｛つか｝い｛方｝｛かた｝の｛例｝｛れい｝をもう
｛一｝｛ひと｝つ｛見｝｛み｝せることだ。Haskellを｛勉強｝｛べんきょう｝する
｛時｝｛とき｝、よくモナドについて｛語｝｛かた｝られる。なぜなら、モナドは
｛理解｝｛りかい｝するのが｛難｝｛むずか｝しいからだ。しかし｛私｝｛わたし｝の
｛経験｝｛けいけん｝によると、モナドをまだ｛理解｝｛りかい｝していない
｛人｝｛ひと｝は｛大体｝｛だいたい｝、｛型変数｝｛かたへんすう｝を
｛持｝｛も｝つ｛型｝｛かた｝クラスも｛理解｝｛りかい｝していない。
｛型変数｝｛かたへんすう｝を｛持｝｛も｝つ｛型｝｛かた｝クラスを
｛使｝｛つか｝えば、｛抽象化｝｛ちゅうしょうか｝する｛方法｝｛ほうほう｝は
いくらでもある。モナドはそのうちの｛一｝｛ひと｝つにすぎない。モナドを
｛理解｝｛りかい｝するためには、｛型｝｛かた｝クラスを｛理解｝｛りかい｝する
ことが｛必須｝｛ひっす｝だ。（｛下｝｛した｝の｛補助｝｛ほじょ｝コード
｛以外｝｛いがい｝、この｛練習｝｛れんしゅう｝｛問題｝｛もんだい｝はモナドを
｛使｝｛つか｝ってない。）

｛補助｝｛ほじょ｝コード
------------------------

｛次｝｛つぎ｝のものはテストの｛実行｝｛じっこう｝するための｛定義｝｛ていぎ｝
だ。これは｛無視｝｛むし｝して｛良｝｛よ｝い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
