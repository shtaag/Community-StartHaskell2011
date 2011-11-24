「プログラミングHaskell」：｛第｝｛だい｝10｛章｝｛しょう｝：｛問題｝｛もんだい｝4
==================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝いている。このファイルの｛中｝｛なか｝に｛関数｝｛かんすう｝を
｛定義｝｛ていぎ｝して、｛含｝｛ふく｝まれているテストで
｛確認｝｛かくにん｝せよ。

「GHC 7.0.3」｛以上｝｛いじょう｝が｛必要｝｛ひつよう｝。

｛次｝｛つぎ｝のインポートを｛無視｝｛むし｝する。

> -- base
> import Control.Exception (ErrorCall(..), evaluate, handleJust)
>
> -- hunit
> import Test.HUnit

Treeの｛定義｝｛ていぎ｝
------------------------

> data Tree = Leaf Int | Node Tree Tree
>   deriving (Eq)

> instance Show Tree where
>   show (Leaf v)   = '(' : show v ++ ")"
>   show (Node l r) = '(' : show l ++ show r ++ ")"

｛問題｝｛もんだい｝
--------------------

`halve`を｛定義｝｛ていぎ｝せよ。

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

`balance`を｛定義｝｛ていぎ｝せよ。

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

サポートのコード
----------------

｛次｝｛つぎ｝の｛定義｝｛ていぎ｝はテストの｛実行｝｛じっこう｝するための
｛定義｝｛ていぎ｝だ。｛以下｝｛いか｝のコードを｛無視｝｛むし｝する。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> assertError :: String -> a -> Assertion
> assertError msg x = handleJust errorCalls (const $ return ()) $ do
>     evaluate x
>     assertFailure $ msg Prelude.++ ": error not thrown"
>   where
>     errorCalls (ErrorCall _) = Just ()
