抵抗の回路
==========

このファイルは文芸的プログラミングの形式で書かれている。このファイルに関数を
実装せよ。

> -- hunit
> import Test.HUnit

型宣言
------

`Network`という抵抗器の回路を扱う型を宣言せよ。抵抗器又は回路の部分はそれぞれ
互いに直列か並列である。図（`RNetwork.png`）に例がある。

> data Network = Undefined

テストの回路
------------

各図にある例の回路を定義せよ。

抵抗
----

`Network`の抵抗を計算する関数`resistance`を定義して、テストも完成せよ。
各回路の抵抗は図に赤文字で書いてある。（テスト駆動開発の好きな方はテストを先に
作っても良い。）

抵抗`A`の抵抗器（又は回路）が抵抗`B`の抵抗器（又は回路）と直列であったら、
合計の抵抗は`A + B`だ。抵抗`A`の抵抗器（又は回路）が抵抗`B`の抵抗器（又は
回路）と並列であったら、合計の抵抗は`1/(1/A + 1/B) == AB/(A + B)`だ。
『ワイヤー』の抵抗は無視できるものとする。

> resistance :: Network -> Float
> resistance = undefined

テストのコマンド： `runTests resistanceTests`

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> resistanceTests :: [Test]
> resistanceTests = map TestCase
>   [
>   ]
