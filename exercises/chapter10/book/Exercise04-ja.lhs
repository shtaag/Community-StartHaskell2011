「プログラミングHaskell」：第10章：問題4
========================================

このファイルは文芸的プログラミングの形式で書かれている。このファイルに関数を
実装して、含まれているテストで確認せよ。

「GHC 7.0.3」以上が必要。

次のインポートは無視してよい。

> -- base
> import Control.Exception (ErrorCall(..), evaluate, handleJust)
>
> -- hunit
> import Test.HUnit

Treeの定義
----------

> data Tree = Leaf Int | Node Tree Tree
>   deriving (Eq)

> instance Show Tree where
>   show (Leaf v)   = '(' : show v ++ ")"
>   show (Node l r) = '(' : show l ++ show r ++ ")"

問題
----

`halve`を定義せよ。

> halve :: [a] -> ([a], [a])
> halve = undefined

テストのコマンド： `runTests halveTests`

> halveTests :: [Test]
> halveTests = map TestCase
>   [ assertHalve ([],[]) []
>   , assertHalve ([],[1]) [1]
>   , assertHalve ([1],[2]) [1,2]
>   , assertHalve ([1],[2,3]) [1..3]
>   , assertHalve ([1,2],[3,4]) [1..4]
>   , assertHalve ([1..49],[50..99]) [1..99]
>   ]
>   where
>     assertHalve :: ([Int], [Int]) -> [Int] -> Assertion
>     assertHalve t l = assertEqual (show l) t (halve l)

`balance`を定義せよ。

> balance :: [Int] -> Tree
> balance = undefined

テストのコマンド： `runTests balanceTests`

> balanceTests :: [Test]
> balanceTests = map TestCase
>   [ assertError "[]" (balance [])
>   , assertBalance (Leaf 1) [1]
>   , assertBalance (Node (Leaf 1) (Leaf 2)) [1,2]
>   , assertBalance (Node (Leaf 1) (Node (Leaf 2) (Leaf 3))) [1..3]
>   , assertBalance (Node (Node (Leaf 1) (Leaf 2))
>                         (Node (Leaf 3) (Node (Leaf 4) (Leaf 5))))
>                   [1..5]
>   ]
>   where
>     assertBalance :: Tree -> [Int] -> Assertion
>     assertBalance t l = assertEqual (show l) t (balance l)

補助コード
----------------

次のものはテストの実行するための定義だ。これは無視してよい。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> assertError :: String -> a -> Assertion
> assertError msg x = handleJust errorCalls (const $ return ()) $ do
>     evaluate x
>     assertFailure $ msg Prelude.++ ": error not thrown"
>   where
>     errorCalls (ErrorCall _) = Just ()
