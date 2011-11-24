「プログラミングHaskell」：第10章：問題5
========================================

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで
確認せよ。

次のインポートを無視する。

> -- hunit
> import Test.HUnit

ヘルパー関数
------------

次の定義は本で定義してある。

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

問題
----

恒真式か検査する関数を拡張して、命題に論理和と同値が使えるようにせよ。

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

以下は本で定義してある命題だ。新しい機能を使う命題を加えて、以下のテストにも
加えよ。

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

サポートのコード
----------------

次の定義はテストの実行するための定義だ。以下のコードを無視する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
