「プログラミングHaskell」：｛第｝｛だい｝8｛章｝｛しょう｝：｛問題｝｛もんだい｝2
=================================================================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝かれている。このファイルに｛関数｝｛かんすう｝を
｛実装｝｛じっそう｝して、｛含｝｛ふく｝まれているテストで｛確認｝｛かくにん｝
せよ。

｛次｝｛つぎ｝のモジュール｛定義｝｛ていぎ｝とインポートを｛無視｝｛むし｝
する。

> module Main (main) where
>
> -- hunit
> import Test.HUnit
>
> -- local
> import Parsing

｛以下｝｛いか｝に｛答｝｛こた｝えを｛定義｝｛ていぎ｝せよ。

> comment :: Parser ()
> comment = undefined

テストのコマンド： `runTests commentTests`

> commentTests :: [Test]
> commentTests = map TestCase
>   [ assertEqual "parse comment \"-- Comment\""
>                 [((),"")]
>                 (parse comment "-- Comment")
>   , assertEqual "parse comment \"a-- Comment\""
>                 []
>                 (parse comment "a-- Comment")
>   , assertEqual "parse comment \"-- Comment\na\""
>                 [((),"\na")]
>                 (parse comment "-- Comment\na")
>   ]

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> main :: IO Counts
> main = runTests commentTests
