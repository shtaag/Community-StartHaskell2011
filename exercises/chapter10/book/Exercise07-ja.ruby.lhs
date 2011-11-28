「プログラミングHaskell」：｛第｝｛だい｝10｛章｝｛しょう｝：｛問題｝｛もんだい｝7
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛次｝｛つぎ｝のインポートは｛無視｝｛むし｝して｛良｝｛よ｝い。

> -- hunit
> import Test.HUnit

｛問題｝｛もんだい｝
--------------------

｛乗算｝｛じょうざん｝を｛扱｝｛あつか｝えるように｛仮想｝｛かそう｝マシンを
｛拡張｝｛かくちょう｝せよ。

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

｛以下｝｛いか｝は｛本｝｛ほん｝にある｛式｝｛しき｝の｛例｝｛れい｝だ。
｛新｝｛あたら｝しい｛機能｝｛きのう｝を｛使｝｛つか｝う｛式｝｛しき｝を
｛作成｝｛さくせい｝し、テストに｛追加｝｛ついか｝して｛確認｝｛かくにん｝
せよ。

> e1 :: Expr
> e1 = Add (Add (Val 2) (Val 3)) (Val 4)

テストのコマンド： `runTests valueTests`

> valueTests :: [Test]
> valueTests = map TestCase
>   [ assertEqual "e1" 9 (value e1)
>   ]

｛補助｝｛ほじょ｝コード
------------------------

｛次｝｛つぎ｝のものはテストの｛実行｝｛じっこう｝するための｛定義｝｛ていぎ｝
だ。これは｛無視｝｛むし｝して｛良｝｛よ｝い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
