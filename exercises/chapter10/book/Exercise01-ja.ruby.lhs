「プログラミングHaskell」：｛第｝｛だい｝10｛章｝｛しょう｝：｛問題｝｛もんだい｝1
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝いている。このファイルの｛中｝｛なか｝に｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝して、｛含｝｛ふく｝まれているテストで
｛確認｝｛かくにん｝せよ。

｛次｝｛つぎ｝のインポートを｛無視｝｛むし｝する。

> -- hunit
> import Test.HUnit

｛本｝｛ほん｝にある｛定義｝｛ていぎ｝
--------------------------------------

｛次｝｛つぎ｝の｛定義｝｛ていぎ｝は｛本｝｛ほん｝で｛定義｝｛ていぎ｝して
ある。

> data Nat = Zero | Succ Nat
>   deriving (Eq)

テストのために`Eq`のインスタンスを｛自動｝｛じどう｝｛導出｝｛どうしゅつ｝
する。

> nat2int :: Nat -> Int
> nat2int Zero = 0
> nat2int (Succ n) = 1 + nat2int n

> int2nat :: Int -> Nat
> int2nat 0 = Zero
> int2nat n = Succ (int2nat (n - 1))

> add :: Nat -> Nat -> Nat
> add Zero n     = n
> add (Succ m) n = Succ (add m n)

テストのために`Show`のインスタンスを｛定義｝｛ていぎ｝する。

> instance Show Nat where
>   show n = '{' : show (nat2int n) ++ "}"

mult
----

`mult`を｛定義｝｛ていぎ｝せよ：

> mult :: Nat -> Nat -> Nat
> mult = undefined

テストのコマンド： `runTests multTests`

> multTests :: [Test]
> multTests = map TestCase
>   [ assertMult "3 x 0" 0 3 0
>   , assertMult "3 x 1" 3 3 1
>   , assertMult "3 x 4" 12 3 4
>   , assertMult "0 x 3" 0 0 3
>   , assertMult "1 x 3" 3 1 3
>   , assertMult "4 x 3" 12 4 3
>   ]
>   where
>     assertMult :: String -> Int -> Int -> Int -> Assertion
>     assertMult s p x y = assertEqual s (int2nat p)
>                            (int2nat x `mult` int2nat y)

サポートのコード
----------------

｛次｝｛つぎ｝の｛定義｝｛ていぎ｝はテストの｛実行｝｛じっこう｝するための
｛定義｝｛ていぎ｝だ。｛以下｝｛いか｝のコードを｛無視｝｛むし｝する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
