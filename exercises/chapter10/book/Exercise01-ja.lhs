「プログラミングHaskell」：第10章：問題1
========================================

このファイルは文芸的プログラミングの形式で書いている。このファイルの中に関数を
定義して、含まれているテストで確認せよ。

次のインポートを無視する。

> -- hunit
> import Test.HUnit

本にある定義
------------

次の定義は本で定義してある。

> data Nat = Zero | Succ Nat
>   deriving (Eq)

テストのために`Eq`のインスタンスを自動導出する。

> nat2int :: Nat -> Int
> nat2int Zero = 0
> nat2int (Succ n) = 1 + nat2int n

> int2nat :: Int -> Nat
> int2nat 0 = Zero
> int2nat n = Succ (int2nat (n - 1))

> add :: Nat -> Nat -> Nat
> add Zero n     = n
> add (Succ m) n = Succ (add m n)

テストのために`Show`のインスタンスを定義する。

> instance Show Nat where
>   show n = '{' : show (nat2int n) ++ "}"

mult
----

`mult`を定義せよ：

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

次の定義はテストの実行するための定義だ。以下のコードを無視する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts
