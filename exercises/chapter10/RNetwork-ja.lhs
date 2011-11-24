抵抗の回路
==========

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義せよ。

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

`Network`の抵抗を計算する関数`resistance`を定義して、テストも完成せよ。図に
各回路の抵抗は赤文字で書いてある。（テスト駆動開発の好きな方はテストを先に
作っても良い。）

抵抗`A`の抵抗器か回路の部分が抵抗`B`の抵抗器か回路の部分と直列であったら合計の
抵抗が`A + B`だ。抵抗`A`の抵抗器か回路の部分が抵抗`B`の抵抗器か回路の部分と
並列であったら合計の抵抗が`1/(1/A + 1/B) == AB/(A + B)`だ。『ワイヤー』の
抵抗はわずかな量であることを仮定せよ。

> resistance :: Network -> Float
> resistance = undefined

テストのコマンド： `runTests resistanceTests`

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> resistanceTests :: [Test]
> resistanceTests = map TestCase
>   [
>   ]
