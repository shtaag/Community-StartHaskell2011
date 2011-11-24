「プログラミングHaskell」：第10章：問題7
========================================

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで
確認せよ。

次のインポートを無視する。

> -- hunit
> import Test.HUnit

問題
----

乗算を扱えるように仮想マシンを拡張せよ。

> data Expr = Val Int
>           | Add Expr Expr

> data Op = EVAL Expr
>         | ADD Int

> type Cont = [Op]

> eval :: Expr -> Cont -> Int
> eval (Val n) c    = exec c n
> eval (Add x y) c  = eval x (EVAL y : c)

> exec :: Cont -> Int -> Int
> exec [] n           = n
> exec (EVAL y : c) n = eval y (ADD n : c)
> exec (ADD n : c) m  = exec c (n + m)

> value :: Expr -> Int
> value e = eval e []

以下は本にある式の例だ。新しい機能を使う式を加えて、以下のテストも加えよ。

> e1 :: Expr
> e1 = Add (Add (Val 2) (Val 3)) (Val 4)

テストのコマンド： `runTests valueTests`

> valueTests :: [Test]
> valueTests = map TestCase
>   [ assertEqual "e1" 9 (value e1)
>   ]

サポートのコード
----------------

次の定義はテストの実行するための定義だ。以下のコードを無視する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
