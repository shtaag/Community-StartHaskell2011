補足演習問題：第2章
===================

_プログラミングHaskell_の第2章のための補足演習問題です。本にある演習問題
（ページ18）を最初に解決してください。

問題6
-----

次の式に括弧を付けてください。

1. `a * a + 2 * a * b + b * b`
2. `a ^ 2 - 2 * a * b + b ^ 2`

問題7
-----

華氏温度から摂氏温度に変換する関数`degFtoC`を定義してください。

    C = (F - 32) * 5/9

以下の使用例を示してください。

    > degFtoC 32
    0.0
    > degFtoC 212
    100.0
    > degFtoC 77
    25.0

摂氏温度から華氏温度に変換する関数`degCtoF`を定義してください。

以下の使用例を示してください。

    > degCtoF 0
    32.0
    > degCtoF 100
    212.0
    > degCtoF 25
    77.0

問題8
-----

この章で紹介したライブラリ関数を使って、リストの最後の*n*個の要素を取り出す
関数`takeLast`を定義してください。

以下の使用例を示してください。

    > takeLast 3 [1,2,3,4,5]
    [3,4,5]
    > takeLast 2 [1,2]
    [1,2]

さらに他の定義を考えて、`takeLast'`を定義して、同じ使用例を示してください。