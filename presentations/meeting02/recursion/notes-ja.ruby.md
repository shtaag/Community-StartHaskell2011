｛再帰関数｝｛さいきかんすう｝（｛補足｝｛ほそく｝）
====================================================

A-Intro-01-Title
----------------

｛再帰関数｝｛さいきかんすう｝（｛補足｝｛ほそく｝）

トラビス・カードウェル

2011年9月11日

A-Intro-02-Overview
-------------------

「プログラミングHaskell」の｛第｝｛だい｝6｛章｝｛しょう｝の｛補足｝｛ほそく｝
です。

｛二｝｛ふた｝つの｛例｝｛れい｝で｛再帰関数｝｛さいきかんすう｝についてもう
｛少｝｛すこ｝し｛教｝｛おし｝えたいです。

* `factorial`
* `reverse`

B-Factorial-01-Book
-------------------

｛本｝｛ほん｝に｛定義｝｛ていぎ｝している｛関数｝｛かんすう｝（ページ57）：

    factorial :: Int -> Int
    factorial 0       = 1
    factorial (n + 1) = (n + 1) * factorial n

> Haskellから｛廃止｝｛はいし｝された「n+kパターン」を
> ｛使｝｛つか｝っています。このまま｛実行｝｛じっこう｝してみるとエラーが
> ｛出｝｛で｝ます。

B-Factorial-02-NoNPlusK
-----------------------

Haskellから｛廃止｝｛はいし｝された「n+kパターン」を｛使｝｛つか｝わないように
｛変換｝｛へんかん｝します。

    factorial :: Int -> Int
    factorial 0 = 1
    factorial n = n * factorial (n - 1)

B-Factorial-03-Partial-Question
-------------------------------

`factorial`に｛負数｝｛ふすう｝を｛渡｝｛わた｝したら、｛何｝｛なに｝が
｛起｝｛お｝こりますか？

    factorial :: Int -> Int
    factorial 0 = 1
    factorial n = n * factorial (n - 1)

B-Factorial-04-Partial-Answer
-------------------------------

`factorial`に｛負数｝｛ふすう｝を｛渡｝｛わた｝したら、｛何｝｛なに｝が
｛起｝｛お｝こりますか？

｛無限｝｛むげん｝ループに｛入｝｛はい｝ってしまいます。

｛正当｝｛せいとう｝な｛入力｝｛にゅうりょく｝の
｛部分集合｝｛ぶぶんしゅうごう｝の｛値｝｛あたい｝に｛対｝｛たい｝して
｛値｝｛あたい｝を｛返｝｛かえ｝さない｛関数｝｛かんすう｝は
「｛部分関数｝｛ぶぶんかんすう｝」と｛言｝｛い｝います。

B-Factorial-05-Partial-Error
----------------------------

｛終了｝｛しゅうりょう｝しない｛関数｝｛かんすう｝が｛危｝｛あぶ｝ないです。
この｛場合｝｛ばあい｝に`error`を｛使｝｛つか｝った｛方｝｛ほう｝が
｛良｝｛い｝いです。

    factorial :: Int -> Int
    factorial 0             = 1
    factorial n | n > 0     = n * factorial (n - 1)
                | otherwise = error "factorial of negative"

B-Factorial-06-Reorder
----------------------

｛定義｝｛ていぎ｝の｛候補｝｛こうほ｝の｛順番｝｛じゅんばん｝は
パフォーマンスに｛影響｝｛えいきょう｝を｛与｝｛あた｝えます。｛多｝｛おお｝く
｛実行｝｛じっこう｝する｛候補｝｛こうほ｝を｛上｝｛うえ｝にした
｛方｝｛ほう｝が｛良｝｛い｝いです。

    factorial :: Int -> Int
    factorial n | n > 0     = n * factorial (n - 1)
                | n == 0    = 1
                | otherwise = error "factorial of negative"

> ｛大体｝｛だいたい｝、｛再帰｝｛さいき｝する｛候補｝｛こうほ｝を
> ｛上｝｛うえ｝にします。

C-Reverse-01-Book
-----------------

｛本｝｛ほん｝に｛定義｝｛ていぎ｝している｛関数｝｛かんすう｝（ページ60）：

    reverse :: [a] -> [a]
    reverse []     = []
    reverse (x:xs) = reverse xs ++ [x]

これは｛遅｝｛おそ｝い｛方法｝｛ほうほう｝です。

> ｛理由｝｛りゆう｝を｛理解｝｛りかい｝するためにリストについて
> ｛考｝｛かんが｝えます。

C-Reverse-02-Lists-Structure
----------------------------

Haskellのリストは｛連結｝｛れんけつ｝リストです。

    s0 = "hat"

     s0
     ↓
    [↓|→[↓|→[↓|ヌル]
    [h] [a] [t]

> ｛永続｝｛えいぞく｝データ｛構造｝｛こうぞう｝です。

C-Reverse-03-Lists-Cons
-----------------------

Haskellのリストは｛連結｝｛れんけつ｝リストです。

    s0 = "hat"
    s1 = 't' : s0

     s1  s0
     ↓   ↓
    [↓|→[↓|→[↓|→[↓|ヌル]
    [t] [h] [a] [t]

> 「cons」（`(:)`）が｛早｝｛はや｝いです。
> リストをコピーする｛必要｝｛ひつよう｝ないです。

C-Reverse-04-Lists-Tail
-----------------------

Haskellのリストは｛連結｝｛れんけつ｝リストです。

    s0 = "hat"
    s1 = 't' : s0
    s2 = tail s0

     s1  s0  s2
     ↓   ↓   ↓
    [↓|→[↓|→[↓|→[↓|ヌル]
    [t] [h] [a] [t]

> `tail`も｛早｝｛はや｝いです。
> リストをコピーする｛必要｝｛ひつよう｝ないです。

C-Reverse-05-Lists-Append-1
---------------------------

    s3 = s0 ++ ['s']

         s3
         ↓
     s1  s0  s2
     ↓   ↓   ↓
    [↓|→[↓|→[↓|→[↓|→[↓|ヌル]
    [t] [h] [a] [t] [s]

｛後｝｛うし｝ろに｛入｝｛い｝れたら、`s0`と`s1`と`s2`の｛値｝｛あたい｝が
｛変更｝｛へんこう｝させてしまいます。それで、これできません。

C-Reverse-06-Lists-Append-2
---------------------------

    s3 = s0 ++ ['s']

     s1  s0  s2
     ↓   ↓   ↓
    [↓|→[↓|→[↓|→[↓|ヌル]
    [t] [h] [a] [t]

     s3
     ↓
    [↓|→[↓|→[↓|→[↓|ヌル]
    [h] [a] [t] [s]

リストをコピーする｛必要｝｛ひつよう｝があります。

> `(++)`を｛使｝｛つか｝う｛時｝｛とき｝、｛注意｝｛ちゅうい｝が
> ｛必要｝｛ひつよう｝です。

C-Reverse-07-Slow
-----------------

｛各｝｛かく｝ステップにリストをコピーしてしまいます。

    reverse :: [a] -> [a]
    reverse []     = []
    reverse (x:xs) = reverse xs ++ [x]

C-Reverse-08-Fix
----------------

こういう｛方法｝｛ほうほう｝で｛解決｝｛かいけつ｝できます。

    reverse :: [a] -> [a]
    reverse lst = reverse' [] lst
      where
        reverse' :: [a] -> [a] -> [a]
        reverse' acc (x:xs) = reverse' (x : acc) xs
        reverse' acc []     = acc

* `reverse'` ← 「ヘルパー｛関数｝｛かんすう｝」
* `acc` ← アキュミュレイター

> `(:)`だけ｛使｝｛つか｝いますので｛早｝｛はや｝いです。

C-Reverse-09-Final
------------------

｛最終版｝｛さいしゅうばん｝：

    reverse :: [a] -> [a]
    reverse = reverse' []
      where
        reverse' :: [a] -> [a] -> [a]
        reverse' acc (x:xs) = reverse' (x : acc) xs
        reverse' acc _      = acc

> カリー｛化｝｛か｝のおかげで`lst`が｛必要｝｛ひつよう｝ないです。
> ワイルドカード「_」で｛置｝｛お｝き｛換｝｛か｝えました。

C-Reverse-10-TailRecursion
--------------------------

｛末尾再帰｝｛まつびさいき｝？

    reverse :: [a] -> [a]
    reverse = reverse' []
      where
        reverse' :: [a] -> [a] -> [a]
        reverse' acc (x:xs) = reverse' (x : acc) xs
        reverse' acc _      = acc

> ｛関数型言語｝｛かんすうがたげんご｝の｛経験｝｛けいけん｝を
> ｛持｝｛も｝っている｛方｝｛かた｝は｛末尾再帰｝｛まつびさいき｝が
> ｛知｝｛し｝っています。
> ｛他｝｛ほか｝の｛言語｝｛げんご｝に｛大切｝｛たいせつ｝です。
> Haskellは｛遅延評価｝｛ちえんひょうか｝を｛用｝｛もち｝いて
> ｛複雑｝｛ふくざつ｝になります。
> ｛遅延評価｝｛ちえんひょうか｝を｛用｝｛もち｝いない｛時｝｛とき｝に
> ｛大切｝｛たいせつ｝です。

D-Closing-01-Practice
---------------------

｛演習｝｛えんしゅう｝｛問題｝｛もんだい｝で｛練習｝｛れんしゅう｝しましょう！

｛何｝｛なに｝か｛分｝｛わ｝からなかったら、｛質問｝｛しつもん｝してください。