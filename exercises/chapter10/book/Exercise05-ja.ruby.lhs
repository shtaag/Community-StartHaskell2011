「プログラミングHaskell」：｛第｝｛だい｝10｛章｝｛しょう｝：｛問題｝｛もんだい｝5
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛次｝｛つぎ｝のインポートは｛無視｝｛むし｝して｛良｝｛よ｝い。

> -- hunit
> import Test.HUnit

ヘルパー｛関数｝｛かんすう｝
----------------------------

｛次｝｛つぎ｝のものは｛本｝｛ほん｝で｛定義｝｛ていぎ｝してある。

> type Assoc k v = [(k, v)]

> find :: Eq k => k -> Assoc k v -> v
> find k t = head [v | (k', v) <- t, k == k']

> bools :: Int -> [[Bool]]
> bools 0 = [[]]
> bools n = map (False :) bss ++ map (True :) bss
>   where
>     bss = bools (n - 1)

> rmdups :: Eq a => [a] -> [a]
> rmdups []     = []
> rmdups (x:xs) = x : rmdups (filter (/= x) xs)

｛問題｝｛もんだい｝
--------------------

｛恒真式｝｛こうしんしき｝かどうか｛検査｝｛けんさ｝する｛関数｝｛かんすう｝を
｛拡張｝｛かくちょう｝して、｛命題｝｛めいだい｝に｛論理和｝｛ろんりわ｝と
｛同値｝｛どうち｝が｛使｝｛つか｝えるようにせよ。

> data Prop = Const Bool
>           | Var Char
>           | Not Prop
>           | And Prop Prop
>           | Imply Prop Prop

> type Subst = Assoc Char Bool

> eval :: Subst -> Prop -> Bool
> eval _ (Const b)   = b
> eval s (Var x)     = find x s
> eval s (Not p)     = not (eval s p)
> eval s (And p q)   = eval s p && eval s q
> eval s (Imply p q) = eval s p <= eval s q

> vars :: Prop -> [Char]
> vars (Const _)   = []
> vars (Var x)     = [x]
> vars (Not p)     = vars p
> vars (And p q)   = vars p ++ vars q
> vars (Imply p q) = vars p ++ vars q

> substs :: Prop -> [Subst]
> substs p = map (zip vs) (bools (length vs))
>   where
>     vs = rmdups (vars p)

> isTaut :: Prop -> Bool
> isTaut p = and [eval s p | s <- substs p]

｛以下｝｛いか｝は｛本｝｛ほん｝で｛定義｝｛ていぎ｝してある
｛命題｝｛めいだい｝だ。｛新｝｛あたら｝しい｛機能｝｛きのう｝を
｛使｝｛つか｝う｛命題｝｛めいだい｝を｛作成｝｛さくせい｝し、テストに
｛追加｝｛ついか｝して｛確認｝｛かくにん｝せよ。

> p1, p2, p3, p4 :: Prop
> p1 = And (Var 'A') (Not (Var 'A'))
> p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')
> p3 = Imply (Var 'A') (And (Var 'A') (Var 'B'))
> p4 = Imply (And (Var 'A') (Imply (Var 'A') (Var 'B'))) (Var 'B')

テストのコマンド： `runTests isTautTests`

> isTautTests :: [Test]
> isTautTests = map TestCase
>   [ assertEqual "p1" False (isTaut p1)
>   , assertEqual "p2" True (isTaut p2)
>   , assertEqual "p3" False (isTaut p3)
>   , assertEqual "p4" True (isTaut p4)
>   ]

｛補助｝｛ほじょ｝コード
------------------------

｛次｝｛つぎ｝のものはテストの｛実行｝｛じっこう｝するための｛定義｝｛ていぎ｝
だ。これは｛無視｝｛むし｝して｛良｝｛よ｝い。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
