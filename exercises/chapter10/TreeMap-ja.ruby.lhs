Tree Map
========

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝いている。このファイルの｛中｝｛なか｝に｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝して、｛含｝｛ふく｝まれているテストで
｛確認｝｛かくにん｝せよ。

｛次｝｛つぎ｝のインポートを｛無視｝｛むし｝する。

> -- hunit
> import Test.HUnit

Tree
----

｛次｝｛つぎ｝は103ページに｛定義｝｛ていぎ｝してある`Tree`｛型｝｛かた｝だ。

    data Tree = Leaf Int | Node Tree Int Tree

この｛型｝｛かた｝は`Int`の｛値｝｛あたい｝だけ｛入｝｛い｝れる。
｛多相型｝｛たそうかた｝の｛版｝｛ばん｝は｛以下｝｛いか｝にある。

    data Tree a = Leaf a | Node (Tree a) a (Tree a)

この｛宣言｝｛せんげん｝は、リストと｛同｝｛おな｝じように、`a`
｛型変数｝｛かたへんすう｝を｛使｝｛つか｝ってどの｛型｝｛かた｝でも
｛入｝｛い｝れる。

でも、この｛型｝｛かた｝は｛大｝｛おお｝きい｛問題｝｛もんだい｝がある。この
｛問題｝｛もんだい｝を｛述｝｛の｝べよ。

    ここに｛答｝｛こた｝えよ。

125ページに｛定義｝｛ていぎ｝してある｛節｝｛ふし｝のみにデータがある
｛木｝｛き｝を｛考｝｛かんが｝えよ。

> data Tree a = Leaf | Node (Tree a) a (Tree a)
>   deriving (Eq)

この｛型｝｛かた｝は｛同｝｛おな｝じ｛問題｝｛もんだい｝があるかどうかを
｛述｝｛の｝べよ。

    ここに｛答｝｛こた｝えよ。

｛以下｝｛いか｝はテストの｛木｝｛き｝だ。

> test0, test1, test2, test4 :: Tree Int
> test0 = Leaf
> test1 = Node Leaf 1 Leaf
> test2 = Node (Node Leaf 1 Leaf) 2 Leaf
> test4 = Node (Node (Node Leaf 1 Leaf) 2 Leaf) 3 (Node Leaf 4 Leaf)

Show
----

`Show`のインスタンス｛宣言｝｛せんげん｝を｛書｝｛か｝いたら、`Tree`を
｛表示｝｛ひょうじ｝することができる。`Show`のインスタンス
｛宣言｝｛せんげん｝がないままに｛表示｝｛ひょうじ｝したら、エラーが
｛起｝｛お｝こる。

もし`Int`だけの`Tree`のための`Show`インスタンス｛宣言｝｛せんげん｝を
｛書｝｛か｝いたら、｛次｝｛つぎ｝のように｛書｝｛か｝く。

    instance Show Tree where
      show (Leaf v)     = show v
      show (Node l v r) = ...

`Int`は`Show`のインスタンスであるので｛値｝｛あたい｝を｛表示｝｛ひょうじ｝
することできる。｛多相型｝｛たそうかた｝のための`Show`のインスタンス
｛宣言｝｛せんげん｝を｛書｝｛か｝いたら、｛型変数｝｛かたへんすう｝も`Show`の
インスタンスである｛制約｝｛せいやく｝が｛必要｝｛ひつよう｝。

    instance Show a => Show (Tree a) where
      show Leaf         = ...
      show (Node l v r) = ...

｛好｝｛す｝きな｛木｝｛き｝の｛構文｝｛こうぶん｝を｛使｝｛つか｝って、
`Show`のインスタンス｛宣言｝｛せんげん｝を｛完成｝｛かんせい｝せよ。

> instance Show a => Show (Tree a) where
>   show = undefined

GHCiに`test4`を｛入力｝｛にゅうりょく｝して、｛正｝｛ただ｝しく
｛表示｝｛ひょうじ｝することを｛確認｝｛かくにん｝せよ。

treeMap
-------

｛関数型｝｛かんすうがた｝プログラミングの｛目標｝｛もくひょう｝の
｛一｝｛ひと｝つは｛高階関数｝｛こうかいかんすう｝で
｛抽象化｝｛ちゅうしょうか｝を｛扱｝｛あつか｝うことだ。よく｛使｝｛つか｝う
｛高階関数｝｛こうかいかんすう｝`map`はリストの｛各｝｛かく｝
｛要素｝｛ようそ｝にある｛関数｝｛かんすう｝を｛適用｝｛てきよう｝して、
｛新｝｛あたら｝しいリストを｛戻｝｛もど｝る。`Tree`の｛型｝｛かた｝と
｛同｝｛おな｝じことをする｛関数｝｛かんすう｝`treeMap`を｛定義｝｛ていぎ｝
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

コンテナーの｛要素｝｛ようそ｝にある｛関数｝｛かんすう｝を｛適用｝｛てきよう｝
することは｛基本｝｛きほん｝な｛作業｝｛さぎょう｝であるので、Haskellが
`Functor`クラスを｛宣言｝｛せんげん｝する。「Functor」
（｛関手｝｛かんしゅ｝）は｛圏論｝｛けんろん｝の｛言葉｝｛ことば｝だ。
｛二｝｛ふた｝つの｛圏｝｛けん｝の｛対応｝｛たいおう｝で｛考｝｛かんが｝える。
（｛例｝｛たと｝えば、`map show [1..10]`は｛整数｝｛せいすう｝のリストの
｛圏｝｛けん｝から｛文字列｝｛もじれつ｝のリストの｛圏｝｛けん｝に
｛対応｝｛たいおう｝する。）

`Prelude`で｛宣言｝｛せんげん｝してある`Functor`クラスは｛次｝｛つぎ｝のように
｛宣言｝｛せんげん｝してある。

    class Functor f where
      fmap :: (a -> b) -> f a -> f b

｛上｝｛うえ｝の`Tree`の｛宣言｝｛せんげん｝には、どの｛型｝｛かた｝でも
｛入｝｛い｝れるために`a`の｛型変数｝｛かたへんすう｝を｛使｝｛つか｝った。
でも`Functor`の｛宣言｝｛せんげん｝には、`f`の｛型変数｝｛かたへんすう｝は
コンテナーの｛型｝｛かた｝だ。｛例｝｛とと｝えば、`Tree`の`fmap`は
`fmap :: (a -> b) -> Tree a -> Tree b`という｛型｝｛かた｝を｛持｝｛も｝って、
｛最初｝｛さいしょ｝の｛引数｝｛ひきすう｝で｛渡｝｛わた｝す
｛関数｝｛かんすう｝を｛使｝｛つか｝って`a`｛型｝｛かた｝の`Tree`を
`b`｛型｝｛かた｝の`Tree`に｛対応｝｛たいおう｝する。

`treeMap`｛関数｝｛かんすう｝を｛使｝｛つか｝えず、`Tree`のための`Functor`
インスタンス｛宣言｝｛せんげん｝を｛完成｝｛かんせい｝せよ。

> instance Functor Tree where
>   fmap = undefined

（`Show`のインスタンス｛宣言｝｛せんげん｝と｛異｝｛こと｝なって、
｛型｝｛かた｝の｛制約｝｛せいやく｝が｛必要｝｛ひつよう｝ない。それで
インスタンス｛宣言｝｛せんげん｝の｛最初｝｛さいしょ｝の｛行｝｛ぎょう｝に
`(Tree a)`を｛使｝｛つか｝わない。）

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

`Functor`クラスを｛使｝｛つか｝って、｛標準｝｛ひょうじゅん｝である`fmap`
｛関数｝｛かんすう｝でコンテナーの｛要素｝｛ようそ｝にある
｛関数｝｛かんすう｝を｛適用｝｛てきよう｝することができる。リストも
`Functor`のインスタンスだのでリストと`fmap`も｛使｝｛つか｝える。`map`はリスト
だけの`fmap`として｛考｝｛かんが｝える。

｛目的｝｛もくてき｝
--------------------

この｛練習｝｛れんしゅう｝｛問題｝｛もんだい｝の｛目的｝｛もくてき｝は
｛型｝｛かた｝クラスの｛使｝｛つか｝い｛方｝｛かた｝の｛例｝｛れい｝をもう
｛一｝｛ひと｝つ｛見｝｛み｝せることだ。モナドを｛完全｝｛かんぜん｝
｛理解｝｛りかい｝することが｛難｝｛むずか｝しいのでHaskellを
｛勉強｝｛べんきょう｝する｛時｝｛とき｝によくモナドについて｛話｝｛はな｝す。
でも｛私｝｛わたし｝の｛経験｝｛けいけん｝で、モナドがまだ｛分｝｛わ｝からない
｛方｝｛かた｝は｛大体｝｛だいたい｝｛型変数｝｛かたへんすう｝を｛持｝｛も｝つ
｛型｝｛かた｝クラスも｛分｝｛わ｝からない。｛型変数｝｛かたへんすう｝を
｛持｝｛も｝つ｛型｝｛かた｝クラスを｛使｝｛つか｝って、｛沢山｝｛たくさん｝
｛抽象化｝｛ちゅうしょうか｝の｛方法｝｛ほうほう｝を｛作｝｛つく｝れる。
モナドはただ｛一｝｛ひと｝つだ。モナドを｛理解｝｛りかい｝するために
｛型｝｛かた｝クラスを｛理解｝｛りかい｝する｛必要｝｛ひつよう｝。
（サポートのコード｛以外｝｛いがい｝、この｛練習｝｛れんしゅう｝
｛問題｝｛もんだい｝はモナドを｛使｝｛つか｝ってない。）

サポートのコード
----------------

｛次｝｛つぎ｝の｛定義｝｛ていぎ｝はテストの｛実行｝｛じっこう｝するための
｛定義｝｛ていぎ｝だ。｛以下｝｛いか｝のコードを｛無視｝｛むし｝する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
