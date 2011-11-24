「｛数｝｛かぞ｝え｛上｝｛あ｝げ」ゲーム
========================================

このファイルは｛文芸的｝｛ぶんげいてき｝プログラミングの｛形式｝｛けいしき｝で
｛書｝｛か｝いている。このファイルを｛自分｝｛じぶん｝のパソコンにダウンロード
して、`CountUp.lhs`に｛名付｝｛なづ｝けよ。ファイルにある`undefined`
｛関数｝｛かんすう｝を｛消｝｛け｝して、｛自分｝｛じぶん｝の
｛定義｝｛ていぎ｝で｛実装｝｛じっそう｝せよ。｛含｝｛ふく｝まれているテストで
｛自分｝｛じぶん｝の｛定義｝｛ていぎ｝を｛確認｝｛かくにん｝せよ。
｛全｝｛すべ｝てのテストを｛受｝｛う｝かったらゲームをコンパイルして
｛遊｝｛あそ｝べることができるようになる。

｛依存関係｝｛いぞんかんけい｝：

    * GHC 7.0.3 ｛以上｝｛いじょう｝ (Haskell Platform 2011.2.0.1 ｛以上｝｛いじょう｝)
    * HUnit (インストールするコマンド： `cabal install hunit`)
    * Haskeline (インストールするコマンド： `cabal install haskeline`)

｛概要｝｛がいよう｝
--------------------

「｛数｝｛かぞ｝え｛上｝｛あ｝げ」ゲームは、｛昔｝｛むかし｝、Mixiの
｛数学｝｛すうがく｝コミュニティーで｛遊｝｛あそ｝んだゲームだ。プレーヤーは、
｛一定｝｛いってい｝の｛数字｝｛すうじ｝（｛大体｝｛だいたい｝
｛現在｝｛げんざい｝の｛年月日｝｛ねんがっぴ｝）と｛演算子｝｛えんざんし｝を
｛使｝｛つか｝って、｛目標｝｛もくひょう｝の｛値｝｛あたい｝になる
｛関数｝｛かんすう｝を｛作｝｛つく｝る。｛各｝｛かく｝｛関数｝｛かんすう｝は
｛全｝｛すべ｝ての｛数字｝｛すうじ｝を｛一回｝｛いっかい｝ずつ｛使｝｛つか｝う
｛必要｝｛ひつよう｝。｛目標｝｛もくひょう｝の｛値｝｛あたい｝は0から
｛始｝｛はじ｝まって、｛正当｝｛せいとう｝な｛関数｝｛かんすう｝を
｛見｝｛み｝つかると｛目標｝｛もくひょう｝の｛値｝｛あたい｝を
｛増加｝｛ぞうか｝させる。

｛例｝｛れい｝：｛数字｝｛すうじ｝が`20111116`と｛目標｝｛もくひょう｝の
｛値｝｛あたい｝が`121`だたら、`(20-(6+1+1+1))^(1+1)`が｛正当｝｛せいとう｝な
｛関数｝｛かんすう｝だ。

この｛練習｝｛れんしゅう｝｛問題｝｛もんだい｝にHaskellでこのゲームを
｛開発｝｛かいはつ｝する。

｛次｝｛つぎ｝のモジュール｛宣言｝｛せんげん｝とインポートを｛無視｝｛むし｝
する。

> module Main where
>
> -- base (Haskell Platform)
> import Control.Exception (ErrorCall(..), evaluate, handleJust)
> import Control.Monad (Monad(..), MonadPlus(..), replicateM)
> import Data.Char (isAlpha, isAlphaNum, isDigit, isLower, isSpace, isUpper,
>                   ord)
> import Data.List (sort)
> import System.IO (hFlush, stdout)
>
> -- transformers (Haskell Platform)
> import Control.Monad.IO.Class (liftIO)
>
> -- time (Haskell Platform)
> import Data.Time.Clock (getCurrentTime)
> import Data.Time.Format (formatTime)
>
> -- old-locale (Haskell Platform)
> import System.Locale (defaultTimeLocale)
>
> -- random (Haskell Platform)
> import System.Random (getStdRandom, randomR)
>
> -- hunit (http://hackage.haskell.org/package/HUnit)
> import Test.HUnit (Assertion(..), Counts(..), Test(..), assertEqual,
>                    assertFailure, runTestTT)
>
> -- haskeline (http://hackage.haskell.org/package/haskeline)
> import System.Console.Haskeline (InputT(..), defaultSettings, getInputLine,
>                                  outputStrLn, runInputT)

｛関数｝｛かんすう｝
--------------------

「｛数｝｛かぞ｝え｛上｝｛あ｝げ」ゲームは、｛整数｝｛せいすう｝のゲームだ。
｛次｝｛つぎ｝のデータ｛構造｝｛こうぞう｝で｛宣言｝｛せんげん｝している
｛演算子｝｛えんざんし｝を｛使｝｛つか｝って｛関数｝｛かんすう｝を
｛作｝｛つく｝る。

> data Func = Val Int        -- ｛値｝｛あたい｝
>           | Add Func Func  -- ｛和算｝｛わさん｝(+)
>           | Sub Func Func  -- ｛減算｝｛げんざん｝(-)
>           | Mul Func Func  -- ｛乗算｝｛じょうざん｝(*)
>           | Div Func Func  -- ｛整数｝｛せいすう｝の｛除算｝｛じょざん｝(/)
>           | Mod Func Func  -- モジュロ｛演算｝｛えんざん｝(%)
>           | Pow Func Func  -- ｛累乗｝｛るいじょう｝｛演算｝｛えんざん｝(^)
>           | Fac Func       -- ｛階乗｝｛かいじょう｝｛演算｝｛えんざん｝(_!)
>           | Abs Func       -- ｛絶対値｝｛ぜったいち｝(|_|)
>   deriving (Eq)

テストのために`Eq`のインスタンスを｛自動｝｛じどう｝｛導出｝｛どうしゅつ｝
する。｛二｝｛ふた｝つの｛関数｝｛かんすう｝が｛全｝｛まった｝く
｛同｝｛おな｝じ｛構文木｝｛こうぶんぎ｝があったら｛同等｝｛どうとう｝だ。
｛例｝｛たと｝えば、`(1 + 2) + 3`と`1 + (2 + 3)`の｛構文木｝｛こうぶんぎ｝が
｛異｝｛こと｝なるので｛同等｝｛どうとう｝ではないだ。

Show
----

`Func`のための`Show`インスタンス｛宣言｝｛せんげん｝の`show :: Func -> String`
｛関数｝｛かんすう｝を｛定義｝｛ていぎ｝せよ。｛以下｝｛いか｝の
｛場合｝｛ばあい｝｛以外｝｛いがい｝、いつも｛括弧｝｛かっこ｝を
｛付｝｛つ｝けよ。

    * ｛関数｝｛かんすう｝｛全体｝｛ぜんたい｝は｛括弧｝｛かっこ｝が
      ｛必要｝｛ひつよう｝ない
    * ｛絶対値｝｛ぜったいち｝の｛中｝｛なか｝の｛関数｝｛かんすう｝は
      ｛括弧｝｛かっこ｝が｛必要｝｛ひつよう｝ない

｛具体的｝｛ぐたいてき｝な｛実例｝｛じつれい｝は｛以下｝｛いか｝のテストに
ある。

> instance Show Func where
>   show = undefined

テストのコマンド： `runTests showTests`

> showTests :: [Test]
> showTests = map TestCase
>   [ assertShow "1" (Val 1)
>   , assertShow "-1" (Val (-1))
>   , assertShow "1 + 2" (Add (Val 1) (Val 2))
>   , assertShow "1 - 2" (Sub (Val 1) (Val 2))
>   , assertShow "1 * 2" (Mul (Val 1) (Val 2))
>   , assertShow "4 / 2" (Div (Val 4) (Val 2))
>   , assertShow "4 % 3" (Mod (Val 4) (Val 3))
>   , assertShow "4 ^ 2" (Pow (Val 4) (Val 2))
>   , assertShow "4!" (Fac (Val 4))
>   , assertShow "|-2|" (Abs (Val (-2)))
>   , assertShow "(3 - 2)!" (Fac (Sub (Val 3) (Val 2)))
>   , assertShow "|2 - 3|!" (Fac (Abs (Sub (Val 2) (Val 3))))
>   , assertShow "(|2 - 5|!)!" (Fac (Fac (Abs (Sub (Val 2) (Val 5)))))
>   , assertShow "(4 - 3) * (2 + 1)"
>                (Mul (Sub (Val 4) (Val 3)) (Add (Val 2) (Val 1)))
>   , assertShow "(4 / 2) ^ (3 % 2)"
>                (Pow (Div (Val 4) (Val 2)) (Mod (Val 3) (Val 2)))
>   , assertShow "((6 + 1) ^ (4 / 2)) % ((5 * (3!)) - 7)"
>                (Mod (Pow (Add (Val 6) (Val 1)) (Div (Val 4) (Val 2)))
>                     (Sub (Mul (Val 5) (Fac (Val 3))) (Val 7)))
>   ]
>   where
>     assertShow :: Show a => String -> a -> Assertion
>     assertShow s = assertEqual s s . show

Read
----

｛第｝｛だい｝8｛章｝｛しょう｝のパーサー・ライブラリを｛使｝｛つか｝って、
｛関数｝｛かんすう｝のパーサーを｛実装｝｛じっそう｝せよ。（パーサー・
ライブラリはこのファイルの｛下｝｛した｝に｛付｝｛つ｝いてる。）`show`の
｛実装｝｛じっそう｝に｛沢山｝｛たくさん｝｛括弧｝｛かっこ｝を｛使｝｛つか｝う
けどこのパーサーは｛括弧｝｛かっこ｝がない｛関数｝｛かんすう｝を
｛取｝｛と｝り｛込｝｛こ｝む｛必要｝｛ひつよう｝。｛以下｝｛いか｝の
｛結合性｝｛けつごうせい｝と｛束縛｝｛そくばく｝の
｛優先順位｝｛ゆうせんじゅんい｝を｛使｝｛つか｝えよ。

    * (+), (-): ｛最｝｛もっと｝も｛弱｝｛よわ｝い｛束縛｝｛そくばく｝、
      ｛左結合｝｛ひだりけつごう｝
    * (*), (/), (%): ｛中｝｛ちゅう｝｛束縛｝｛そくばく｝、
      ｛左結合｝｛ひだりけつごう｝
    * (^): ｛最｝｛もっと｝も｛強｝｛つよ｝い｛束縛｝｛そくばく｝、
      ｛右結合｝｛みぎけつごう｝

> func :: Parser Func
> func = undefined

｛次｝｛つぎ｝は`Func`のための`Read`インスタンス｛宣言｝｛せんげん｝だ。

> instance Read Func where
>   readsPrec _ = parse func

テストのコマンド： `runTests readTests`

> readTests :: [Test]
> readTests = map TestCase
>   [ assertRead "1" (Val 1)
>   , assertRead "-1" (Val (-1))
>   , assertRead "1 + 2" (Add (Val 1) (Val 2))
>   , assertRead "1 - 2" (Sub (Val 1) (Val 2))
>   , assertRead "1 * 2" (Mul (Val 1) (Val 2))
>   , assertRead "4 / 2" (Div (Val 4) (Val 2))
>   , assertRead "4 % 3" (Mod (Val 4) (Val 3))
>   , assertRead "4 ^ 2" (Pow (Val 4) (Val 2))
>   , assertRead "4!" (Fac (Val 4))
>   , assertRead "|-2|" (Abs (Val (-2)))
>   , assertRead "(3 - 2)!" (Fac (Sub (Val 3) (Val 2)))
>   , assertRead "|2 - 3|!" (Fac (Abs (Sub (Val 2) (Val 3))))
>   , assertRead "(|2 - 5|!)!" (Fac (Fac (Abs (Sub (Val 2) (Val 5)))))
>   , assertRead "1 - 2 + 3" (Add (Sub (Val 1) (Val 2)) (Val 3))
>   , assertRead "4 / 2 * 2" (Mul (Div (Val 4) (Val 2)) (Val 2))
>   , assertRead "3 ^ 2 ^ 2" (Pow (Val 3) (Pow (Val 2) (Val 2)))
>   , assertRead "(4 - 3) * (2 + 1)"
>                (Mul (Sub (Val 4) (Val 3)) (Add (Val 2) (Val 1)))
>   , assertRead "(4 / 2) ^ (3 % 2)"
>                (Pow (Div (Val 4) (Val 2)) (Mod (Val 3) (Val 2)))
>   , assertRead "((6 + 1) ^ (4 / 2)) % ((5 * (3!)) - 7)"
>                (Mod (Pow (Add (Val 6) (Val 1)) (Div (Val 4) (Val 2)))
>                     (Sub (Mul (Val 5) (Fac (Val 3))) (Val 7)))
>   , assertRead "2--1" (Sub (Val 2) (Val (-1)))
>   , assertRead "2 + 3 !" (Add (Val 2) (Fac (Val 3)))
>   , assertRead "|(3-2)|" (Abs (Sub (Val 3) (Val 2)))
>   , assertRead "|2-5|!" (Fac (Abs (Sub (Val 2) (Val 5))))
>   , assertRead "1+2 * 3-4"
>                (Sub (Add (Val 1) (Mul (Val 2) (Val 3))) (Val 4))
>   , assertRead "4+3 % 2-1"
>                (Sub (Add (Val 4) (Mod (Val 3) (Val 2))) (Val 1))
>   , assertRead "1*2 ^ 3/4"
>                (Div (Mul (Val 1) (Pow (Val 2) (Val 3))) (Val 4))
>   , assertRead " | 1 * 2 | ^ 3/4 "
>                (Div (Pow (Abs (Mul (Val 1) (Val 2))) (Val 3)) (Val 4))
>   , assertRead "2 - 3 ^ | 3 - 5 | / 3 % 2 + 1 * 3!"
>                (Add (Sub (Val 2)
>                          (Mod (Div (Pow (Val 3) (Abs (Sub (Val 3) (Val 5))))
>                                    (Val 3))
>                               (Val 2)))
>                     (Mul (Val 1) (Fac (Val 3))))
>   , assertFail "(3 - 2|"
>   , assertFail "(3 - ) 2"
>   , assertFail "3 ( - 2)"
>   , assertFail "+ 3"
>   , assertFail "1 -"
>   ]
>   where
>     assertRead :: String -> Func -> Assertion
>     assertRead s f = assertEqual s f (read s)
>     assertFail :: String -> Assertion
>     assertFail s = assertError s (read s :: Func)

｛数字｝｛すうじ｝
------------------

｛関数｝｛かんすう｝に｛使｝｛つか｝っている｛数字｝｛すうじ｝を
｛戻｝｛もど｝る｛関数｝｛かんすう｝`digits`を｛定義｝｛ていぎ｝せよ。
`12`という｛値｝｛あたい｝は｛二｝｛ふた｝つの｛数字｝｛すうじ｝（`1`と`2`）を
｛使｝｛つか｝う。｛戻｝｛もど｝り｛値｝｛ち｝はソート｛純｝｛じゅん｝の
リストにする。`Data.List`からインポートされた`sort :: Ord a => [a] -> [a]`
｛関数｝｛かんすう｝を｛使｝｛つか｝うと｛良｝｛よ｝い。

> digits :: Func -> [Int]
> digits = undefined

テストのコマンド： `runTests digitsTests`

> digitsTests :: [Test]
> digitsTests = map TestCase
>   [ assertDigits [1] (Val 1)
>   , assertDigits [1] (Val (-1))
>   , assertDigits [1,2] (Add (Val 1) (Val 2))
>   , assertDigits [1,2] (Add (Val 2) (Val 1))
>   , assertDigits [1,2] (Sub (Val 1) (Val 2))
>   , assertDigits [1,2] (Mul (Val 1) (Val 2))
>   , assertDigits [2,4] (Div (Val 4) (Val 2))
>   , assertDigits [3,4] (Mod (Val 4) (Val 3))
>   , assertDigits [2,4] (Pow (Val 4) (Val 2))
>   , assertDigits [4] (Fac (Val 4))
>   , assertDigits [2] (Abs (Val (-2)))
>   , assertDigits [1,2,3,4] (Mul (Sub (Val 4) (Val 3)) (Add (Val 2) (Val 1)))
>   , assertDigits [1,2,3,4] (Pow (Div (Val 4) (Val 2)) (Mod (Val 3) (Val 1)))
>   , assertDigits [1,2,3,4,5,6,7]
>                  (Mod (Pow (Add (Val 6) (Val 1)) (Div (Val 4) (Val 2)))
>                       (Sub (Mul (Val 5) (Fac (Val 3))) (Val 7)))
>   , assertDigits [0,1,1,2,2,3] (Add (Val 123) (Val 201))
>   ]
>   where
>     assertDigits :: [Int] -> Func -> Assertion
>     assertDigits xs f = assertEqual (show f) xs (digits f)

｛評価｝｛ひょうか｝
--------------------

｛関数｝｛かんすう｝を｛評価｝｛ひょうか｝する｛関数｝｛かんすう｝`eval`を
｛定義｝｛ていぎ｝せよ。｛正当｝｛せいとう｝ではない｛関数｝｛かんすう｝も
あるので、`eval`の｛戻｝｛もど｝り｛値｝｛ち｝の｛型｝｛かた｝は`Maybe Int`
だ。｛正当｝｛せいとう｝な｛関数｝｛かんすう｝だったら、`Just`を
｛使｝｛つか｝って｛値｝｛あたい｝を｛戻｝｛もど｝せよ。｛以下｝｛いか｝の
｛場合｝｛ばあい｝に`Nothing`を｛戻｝｛もど｝せよ。

    * ｛評価｝｛ひょうか｝する｛値｝｛あたい｝は｛整数｝｛せいすう｝ではない
    * 0の｛除算｝｛じょざん｝かモジュロ
    * マイナスの｛階乗｝｛かいじょう｝

`Maybe`はモナドのインスタンスだから、do｛記法｝｛きほう｝を｛使｝｛つか｝って
`eval`を｛定義｝｛ていぎ｝できる。こういう`Maybe`の
｛使｝｛つか｝い｛方｝｛かた｝は｛本｝｛ほん｝に｛書｝｛か｝いてない。
｛最初｝｛さいしょ｝にdo｛記法｝｛きほう｝を｛使｝｛つか｝えず`eval`を
｛普通｝｛ふつう｝に｛定義｝｛ていぎ｝することをお｛勧｝｛すす｝めする。
この｛定義｝｛ていぎ｝が｛全｝｛すべ｝てのテストを｛合格｝｛ごうかく｝したら
do｛記法｝｛きほう｝を｛使｝｛つか｝ってみても｛良｝｛よ｝い。

> eval :: Func -> Maybe Int
> eval = undefined

テストのコマンド： `runTests evalTests`

> evalTests :: [Test]
> evalTests = map TestCase
>   [ assertEval 1 (Val 1)
>   , assertEval (-1) (Val (-1))
>   , assertEval 3 (Add (Val 1) (Val 2))
>   , assertEval (-1) (Sub (Val 1) (Val 2))
>   , assertEval 2 (Mul (Val 1) (Val 2))
>   , assertEval 2 (Div (Val 4) (Val 2))
>   , assertEval 1 (Mod (Val 4) (Val 3))
>   , assertEval 16 (Pow (Val 4) (Val 2))
>   , assertEval 24 (Fac (Val 4))
>   , assertEval 2 (Abs (Val (-2)))
>   , assertEval 1 (Fac (Sub (Val 3) (Val 2)))
>   , assertEval 1 (Fac (Abs (Sub (Val 2) (Val 3))))
>   , assertEval 720 (Fac (Fac (Abs (Sub (Val 2) (Val 5)))))
>   , assertEval 3 (Mul (Sub (Val 4) (Val 3)) (Add (Val 2) (Val 1)))
>   , assertEval 2 (Pow (Div (Val 4) (Val 2)) (Mod (Val 3) (Val 2)))
>   , assertEval 3 (Mod (Pow (Add (Val 6) (Val 1)) (Div (Val 4) (Val 2)))
>                       (Sub (Mul (Val 5) (Fac (Val 3))) (Val 7)))
>   , assertEval 3 (Add (Val 1) (Sub (Mul (Val 2) (Val 3)) (Val 4)))
>   , assertEval 4 (Add (Val 4) (Sub (Mod (Val 3) (Val 2)) (Val 1)))
>   , assertEval 2 (Mul (Val 1) (Div (Pow (Val 2) (Val 3)) (Val 4)))
>   , assertEval 2 (Div (Pow (Abs (Mul (Val 1) (Val 2))) (Val 3)) (Val 4))
>   , assertEval 7 (Add (Sub (Val 2)
>                            (Mod (Div (Pow (Val 3)
>                                           (Abs (Sub (Val 3) (Val 5))))
>                                      (Val 3))
>                                 (Val 2)))
>                       (Mul (Val 1) (Fac (Val 3))))
>   , assertFail (Div (Val 1) (Val 0))
>   , assertFail (Div (Val 1) (Add (Val 1) (Val (-1))))
>   , assertFail (Div (Val 3) (Val 2))
>   , assertFail (Div (Val 3) (Add (Val 1) (Val 1)))
>   , assertFail (Mul (Val 4) (Div (Val 3) (Val 2)))
>   , assertFail (Mod (Val 3) (Val 0))
>   , assertEval (-2) (Mod (Val 7) (Val (-3)))
>   , assertEval 1 (Pow (Val 13) (Val 0))
>   , assertFail (Pow (Val 13) (Val (-1)))
>   , assertEval 1 (Fac (Val 0))
>   , assertFail (Fac (Val (-1)))
>   ]
>   where
>     assertEval :: Int -> Func -> Assertion
>     assertEval x f = assertEqual (show f) (Just x) (eval f)
>     assertFail :: Func -> Assertion
>     assertFail f = assertEqual (show f) Nothing (eval f)

Play
----

ゲームのメイン・ループの｛関数｝｛かんすう｝`play :: String -> Int -> IO ()`を
｛定義｝｛ていぎ｝せよ。｛最初｝｛さいしょ｝の｛引数｝｛ひきすう｝は`String`の
｛型｝｛かた｝で｛数字｝｛すうじ｝のリストだ。｛二番目｝｛にばんめ｝の
｛引数｝｛ひきすう｝は｛現在｝｛げんざい｝の｛目標｝｛もくひょう｝の
｛値｝｛あたい｝だ。この｛関数｝｛かんすう｝は`IO`モナドに
｛入｝｛はい｝っているが、｛画面｝｛がめん｝に｛文字列｝｛もじれつ｝を
｛表示｝｛ひょうじ｝するために`putStrLn`｛関数｝｛かんすう｝を
｛使｝｛つか｝って、プレーヤーが｛入力｝｛にゅうりょく｝した
｛文字列｝｛もじれつ｝を｛受｝｛う｝け｛取｝｛と｝るために`getLine`
｛関数｝｛かんすう｝を｛使｝｛つか｝う。

プレーヤーが｛数字｝｛すうじ｝と｛現在｝｛げんざい｝の｛目標｝｛もくひょう｝の
｛値｝｛あたい｝が｛分｝｛わ｝かるために、この｛関数｝｛かんすう｝が
｛最初｝｛さいしょ｝にプロンプトを｛表示｝｛ひょうじ｝する。
｛例｝｛たと｝えば、｛数字｝｛すうじ｝が`20111116`と｛現在｝｛げんざい｝の
｛目標｝｛もくひょう｝の｛値｝｛あたい｝が`0`だったら、｛次｝｛つぎ｝のような
プロンプトを｛表示｝｛ひょうじ｝する。

    {20111116} 0:

プレーヤーが｛同｝｛おな｝じ｛行｝｛ぎょう｝に｛入力｝｛にゅうりょく｝できる
ため、`putStr`でプロンプトを｛表示｝｛ひょうじ｝してから`hFlush stdout`を
｛実行｝｛じっこう｝する。それから`getLine`を｛使｝｛つか｝って、
｛入力｝｛にゅうりょく｝した｛文字列｝｛もじれつ｝を
｛受｝｛う｝け｛取｝｛と｝る。

プレーヤーが「quit」を｛入力｝｛にゅうりょく｝したら｛止｝｛と｝まる。
｛他｝｛ほか｝の｛値｝｛あたい｝だったら、パーサーで｛関数｝｛かんすう｝に
｛変換｝｛へんかん｝して（エラーの｛場合｝｛ばあい｝：「parse error」を
｛表示｝｛ひょうじ｝）、｛関数｝｛かんすう｝を｛評価｝｛ひょうか｝して
（｛正当｝｛せいとう｝ではない｛場合｝｛ばあい｝：「invalid function」を
｛表示｝｛ひょうじ｝）、｛現在｝｛げんざい｝の｛目標｝｛もくひょう｝の
｛値｝｛あたい｝と｛同等｝｛どうとう｝であることを｛確認｝｛かくにん｝して
（｛同等｝｛どうとう｝ではない｛場合｝｛ばあい｝：「not equal to target」を
｛表示｝｛ひょうじ｝）、｛関数｝｛かんすう｝の｛数字｝｛すうじ｝が
｛正当｝｛せいとう｝であることを｛確認｝｛かくにん｝する（そうではない
｛場合｝｛ばあい｝：「invalid digits」を｛表示｝｛ひょうじ｝）。
｛何｝｛なに｝かが｛正｝｛ただ｝しくなかったら、すぐに｛同｝｛おな｝じ
｛目標｝｛もくひょう｝の｛値｝｛あたい｝で｛再帰｝｛さいき｝する。
｛全｝｛すべ｝てが｛正｝｛ただ｝しかったら、｛増加｝｛ぞうか｝した
｛目標｝｛もくひょう｝の｛値｝｛あたい｝で｛再帰｝｛さいき｝する。

> play :: String -> Int -> IO ()
> play = undefined

この｛実装｝｛じっそう｝の｛問題｝｛もんだい｝は`getLine`が
｛入力｝｛にゅうりょく｝する｛時｝｛とき｝に｛編集｝｛へんしゅう｝することが
できない。｛例｝｛たと｝えば、｛忘｝｛わす｝れた｛括弧｝｛かっこ｝を
｛入｝｛い｝れることができなくて｛面倒｝｛めんどう｝くさいだ。

｛入力｝｛にゅうりょく｝する｛時｝｛とき｝に｛編集｝｛へんしゅう｝することが
できるために、｛私｝｛わたし｝がhaskelineライブラリを｛使｝｛つか｝って
｛他｝｛ほか｝の`play`｛関数｝｛かんすう｝を｛定義｝｛ていぎ｝した。この
ファイルの｛全｝｛すべ｝てのテストを｛合格｝｛ごうかく｝したら、`main`
｛関数｝｛かんすう｝でゲームを｛遊｝｛あそ｝ぶことができる。

サポートのコード
----------------

｛以下｝｛いか｝のコードはテストするための｛定義｝｛ていぎ｝と`main`
｛関数｝｛かんすう｝とhaskeline｛版｝｛ばん｝の`play`｛関数｝｛かんすう｝と
パーサーのライブラリだ。このコードを｛編集｝｛へんしゅう｝する
｛必要｝｛ひつよう｝がない。

テストするための｛定義｝｛ていぎ｝：

> allTests :: [Test]
> allTests = showTests ++ readTests ++ digitsTests ++ evalTests

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> assertError :: String -> a -> Assertion
> assertError msg x = handleJust errorCalls (const $ return ()) $ do
>     evaluate x
>     assertFailure $ msg ++ ": error not thrown"
>   where
>     errorCalls (ErrorCall _) = Just ()

`main`｛関数｝｛かんすう｝：

> main :: IO ()
> main = runInputT defaultSettings title
>   where
>     title :: InputT IO ()
>     title = do outputStrLn "The Count Up Game"
>                check
>     check :: InputT IO ()
>     check = do outputStrLn "Checking unit tests..."
>                counts <- liftIO $ runTests allTests
>                if errors counts + failures counts == 0
>                  then menu
>                  else outputStrLn "Not all tests passed; stopping."
>     menu :: InputT IO ()
>     menu = do minput <- getInputLine
>                           "Play (d)efault, (r)andom, or (c)ustom game? "
>               case minput of
>                 Just "r" -> randomGame
>                 Just "c" -> customGame
>                 _        -> defaultGame

> instructions :: InputT IO ()
> instructions = outputStrLn "Type 'quit' to quit."

> getDate :: IO String
> getDate = do time <- getCurrentTime
>              return $ formatTime defaultTimeLocale "%Y%m%d" time

> defaultGame :: InputT IO ()
> defaultGame = do date <- liftIO getDate
>                  instructions
>                  playH date 0

> randomGame :: InputT IO ()
> randomGame = do count <- liftIO $ getStdRandom (randomR (6, 12))
>                 xs <- liftIO $ replicateM count
>                         (getStdRandom (randomR ((0,9) :: (Int,Int))))
>                 start <- liftIO $ getStdRandom (randomR (0, 100))
>                 instructions
>                 playH (concatMap show (sort xs)) start

> customGame :: InputT IO ()
> customGame = getDigits
>   where
>     getDigits = do date <- liftIO getDate
>                    mdigits <- getInputLine $
>                                 "Enter digits (" ++ date ++ "): "
>                    case mdigits of
>                      Just ""     -> getStart date
>                      Just digits -> checkDigits digits
>                      Nothing     -> getStart date
>     checkDigits :: String -> InputT IO ()
>     checkDigits digits = if (not . null . filter (not . isDigit)) digits
>                            then do outputStrLn "invalid digits"
>                                    getDigits
>                            else getStart digits
>     getStart :: String -> InputT IO ()
>     getStart digits = do mstart <- getInputLine "Enter start (0): "
>                          case mstart of
>                            Just ""    -> playH digits 0
>                            Just start -> checkStart digits start
>                            Nothing    -> playH digits 0
>     checkStart :: String -> String -> InputT IO ()
>     checkStart digits start = case parse int start of
>                                 [(s,"")] -> playH digits s
>                                 _        -> do outputStrLn "invalid start"
>                                                getStart digits

Haskeline｛版｝｛ばん｝の`play`｛関数｝｛かんすう｝：

+-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-+
|                                                                            |
| 自分で`play`を正しく定義する前に`playH`を見ない方が良い。                  |
|                                                                            |
+-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-注意-+

> playH :: String -> Int -> InputT IO ()
> playH cs = prompt
>   where
>     xs :: [Int]
>     xs = sort . map ((+ (-48)) . ord) $ cs
>     prompt :: Int -> InputT IO ()
>     prompt target =
>       do minput <- getInputLine $ '{' : cs ++ "} " ++ show target ++ ": "
>          case minput of
>            Just "quit" -> return ()
>            Nothing     -> return ()
>            Just input  -> checkParse target (parse func input)
>     checkParse :: Int -> [(Func,String)] -> InputT IO ()
>     checkParse target [(f,"")] = checkEval target f (eval f)
>     checkParse target _        = do outputStrLn "parse error"
>                                     prompt target
>     checkEval :: Int -> Func -> Maybe Int -> InputT IO ()
>     checkEval target f (Just x)
>       | x == target = checkDigits target f
>       | otherwise   = do outputStrLn "not equal to target"
>                          prompt target
>     checkEval target _ _ = do outputStrLn "invalid function"
>                               prompt target
>     checkDigits :: Int -> Func -> InputT IO ()
>     checkDigits target f
>       | digits f == xs = prompt (target + 1)
>       | otherwise      = do outputStrLn "invalid digits"
>                             prompt target

「プログラミングHaskell」の｛第｝｛だい｝8｛章｝｛しょう｝のパーサー・
ライブラリは｛以下｝｛いか｝にある。

> newtype Parser a =  P (String -> [(a, String)])
> instance Monad Parser where
>    return v = P (\inp -> [(v, inp)])
>    p >>= f  = P (\inp -> case parse p inp of
>                            []        -> []
>                            [(v,out)] -> parse (f v) out)
> instance MonadPlus Parser where
>    mzero       = P (\inp -> [])
>    p `mplus` q = P (\inp -> case parse p inp of
>                               []        -> parse q inp
>                               [(v,out)] -> [(v,out)])

> failure :: Parser a
> failure = mzero

> item :: Parser Char
> item = P (\inp -> case inp of
>                     []     -> []
>                     (x:xs) -> [(x,xs)])

> parse :: Parser a -> String -> [(a,String)]
> parse (P p) inp =  p inp

> (+++) :: Parser a -> Parser a -> Parser a
> p +++ q = p `mplus` q
> infixr 5 +++

> sat :: (Char -> Bool) -> Parser Char
> sat p = do x <- item
>            if p x then return x else failure

> digit, lower, upper, letter, alphanum :: Parser Char
> digit    = sat isDigit
> lower    = sat isLower
> upper    = sat isUpper
> letter   = sat isAlpha
> alphanum = sat isAlphaNum

> char :: Char -> Parser Char
> char x = sat (== x)

> string :: String -> Parser String
> string []     = return []
> string (x:xs) = do char x
>                    string xs
>                    return (x:xs)

> many :: Parser a -> Parser [a]
> many p = many1 p +++ return []

> many1 :: Parser a -> Parser [a]
> many1 p = do v <- p
>              vs <- many p
>              return (v:vs)

> ident :: Parser String
> ident = do x <- lower
>            xs <- many alphanum
>            return (x:xs)

> nat, int :: Parser Int
> nat = do xs <- many1 digit
>          return (read xs)
> int = do char '-'
>          n <- nat
>          return (-n)
>         +++ nat

> space :: Parser ()
> space = do many (sat isSpace)
>            return ()

> token :: Parser a -> Parser a
> token p = do space
>              v <- p
>              space
>              return v

> identifier :: Parser String
> identifier = token ident

> natural, integer :: Parser Int
> natural = token nat
> integer = token int

> symbol :: String -> Parser String
> symbol xs = token (string xs)
