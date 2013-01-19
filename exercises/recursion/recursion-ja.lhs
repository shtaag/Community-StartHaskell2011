再帰の練習問題
==============

再帰関数の定義を練習するために、以下の`Prelude`で定義されている関数を再帰を
用いて定義せよ。（リスト内包表記と`map`と`foldr`などな高階関数を使わずに
定義せよ。）

これらの練習問題は6個のセットに分類されている。あるセットの問題を混乱せずに
早く解決できれば、そのセットの残りの問題を読み飛ばして、次のセットの問題をして
良い。

このファイルは文芸的プログラミングの形式で書かれている。このファイルに関数を
実装せよ。「GHC 7.0.3」以上が必要。例題：

    > factorial :: Int -> Int
    > factorial = undefined

問題を解決するために、「`undefined`」の行を削除して、定義のコードの各行の
先頭に「`>`」を入れる必要：

    > factorial :: Int -> Int
    > factorial n | n >= 2    = factorial' 1 n
    >             | n >= 0    = 1
    >             | otherwise = error "factorial of negative"
    >   where
    >     factorial' :: Int -> Int -> Int
    >     factorial' acc n | n < 2     = acc
    >                      | otherwise = factorial' (acc * n) (n - 1)

次のモジュール定義とインポートは無視して良い。

> module Main (main) where
>
> -- base
> import Control.Exception
> import Data.Char (isSpace)
> import Prelude hiding ((++), (!!), all, and, any, break, concat, concatMap,
>                        drop, dropWhile, elem, filter, foldl, foldr, init,
>                        last, length, lines, map, minimum, maximum, notElem,
>                        or, product, reverse, scanl, scanr, span, splitAt,
>                        sum, take, takeWhile, unlines, until, unwords, unzip,
>                        unzip3, words, zip, zip3, zipWith, zipWith3)
> import qualified Prelude ((++), concat, concatMap, map, take)
>
> -- hunit
> import Test.HUnit

HUnitのパッケージを使って、テストも付いている。`cabal install hunit`の
コマンドでコマンドラインからHUnitをインストールできる。一つの問題のテストを
実行するには、以下に定義されている関数`runTests`を使う。GHCiにコピー・アンド・
ペーストするために、各問題のコマンドを用意してある。

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

複数の問題のテストを実行するために以下の定義`tests`を使える。実行したい
テストを非コメント化せよ。

> tests :: [[Test]]
> tests = [
>     appendTests
>   --, concatTests
>   --, mapTests
>   --, concatMapTests
>   --, filterTests
>   --, untilTests
>   --, andTests
>   --, orTests
>   --, anyTests
>   --, allTests
>   --, elemTests
>   --, notElemTests
>   --, zipTests
>   --, zip3Tests
>   --, zipWithTests
>   --, zipWith3Tests
>   --, unlinesTests
>   --, unwordsTests
>   --, lastTests
>   --, initTests
>   --, takeTests
>   --, dropTests
>   --, takeWhileTests
>   --, dropWhileTests
>   --, indexTests
>   --, sumTests
>   --, productTests
>   --, maximumTests
>   --, minimumTests
>   --, lengthTests
>   --, reverseTests
>   --, linesTests
>   --, wordsTests
>   --, splitAtTests
>   --, spanTests
>   --, breakTests
>   --, unzipTests
>   --, unzip3Tests
>   , foldlTests
>   , foldrTests
>   --, scanlTests
>   --, scanrTests
>   ]

`tests`のテストを実行するには`main`を使う。

> main :: IO Counts
> main = runTests $ Prelude.concat tests

次の定義は無視して良い。

> assertError :: String -> a -> Assertion
> assertError msg x = handleJust errorCalls (const $ return ()) $ do
>     evaluate x
>     assertFailure $ msg Prelude.++ ": error not thrown"
>   where
>     errorCalls (ErrorCall _) = Just ()

テストのいくつかを実行する時に、時間がかかるが、正しく定義されている問題は
沢山メモリが必要ない。以下の定数を変更すると、テストのサイズを変更できる。

> large :: Int
> large = 2 ^ 24

セット1
-------

1. [(++)](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:-43--43-)

> (++) :: [a] -> [a] -> [a]
> (++) xs ys = foldr (:) ys xs
> -- (++) [] ys = ys
> -- (++) xs [] = xs
> -- (++) (x : xs) ys = x : (xs ++ ys)

テストのコマンド： `runTests appendTests`

> appendTests :: [Test]
> appendTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "[1,2] ++ [3,4]" [1,2,3,4] ([1,2] ++ [3,4])
>   , assertEqual "[] ++ [1,2]" [1,2] ([] ++ [1,2])
>   , assertEqual "[1,2] ++ []" [1,2] ([1,2] ++ [])
>   , assertEqual "[] ++ []" ([] :: [Int]) ([] ++ [])
>   -- 無限／大きなテスト
>   , assertEqual "take 3 (cycle [1,2] ++ [3,4])"
>                 [1,2,1] (Prelude.take 3 (cycle [1,2] ++ [3,4]))
>   , assertEqual "take 3 ([1,2] ++ (cycle [3,4]))"
>                 [1,2,3] (Prelude.take 3 ([1,2] ++ (cycle [3,4])))
>   ]

2. [concat](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:concat)

> concat :: [[a]] -> [a]
> concat = undefined

テストのコマンド： `runTests concatTests`

> concatTests :: [Test]
> concatTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "concat [[1,2],[3],[]]" [1,2,3] (concat [[1,2],[3],[]])
>   , assertEqual "concat [[1],[2,3],[]]" [1,2,3] (concat [[1],[2,3],[]])
>   , assertEqual "concat [[],[1],[2,3]]" [1,2,3] (concat [[],[1],[2,3]])
>   , assertEqual "concat []" ([] :: [Int]) (concat [])
>   , assertEqual "concat [[]]" ([] :: [Int]) (concat [[]])
>   -- 無限／大きなテスト
>   , assertEqual "take 5 (concat [[1,2], cycle [3,4], []])"
>                 [1,2,3,4,3] (Prelude.take 5 (concat [[1,2], cycle [3,4], []]))
>   ]

3. [map](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:map)

> map :: (a -> b) -> [a] -> [b]
> map = undefined

テストのコマンド： `runTests mapTests`

> mapTests :: [Test]
> mapTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "map (\\x -> x + 1) [1,2,3]"
>                 [2,3,4] (map (\x -> x + 1) [1,2,3])
>   , assertEqual "map (\\x -> x + 1) []" [] (map (\x -> x + 1) [])
>   -- 無限／大きなテスト
>   , assertEqual "take 5 (map (\\x -> x + 1) [1..])"
>                 [2,3,4,5,6] (Prelude.take 5 (map (\x -> x + 1) [1..]))
>   ]

4. [concatMap](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:concatMap)

> concatMap :: (a -> [b]) -> [a] -> [b]
> concatMap = undefined

テストのコマンド： `runTests concatMapTests`

> concatMapTests :: [Test]
> concatMapTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "concatMap (\\x -> [x, -x]) [1,2]"
>                 [1,-1,2,-2] (concatMap (\x -> [x, -x]) [1,2])
>   , assertEqual "concatMap (\\x -> [x, -x]) []"
>                 [] (concatMap (\x -> [x, -x]) [])
>   -- 無限／大きなテスト
>   , assertEqual "take 3 (concatMap (\\x -> [x, -x])"
>                 [1,-1,2] (Prelude.take 3 (concatMap (\x -> [x, -x]) [1..]))
>   ]

5. [filter](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:filter)

> filter :: (a -> Bool) -> [a] -> [a]
> filter = undefined

テストのコマンド： `runTests filterTests`

> filterTests :: [Test]
> filterTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "filter even [1,2,3,4]" [2,4] (filter even [1,2,3,4])
>   , assertEqual "filter even [1,3,5]" [] (filter even [1,3,5])
>   , assertEqual "filter even []" ([] :: [Int]) (filter even [])
>   -- 無限／大きなテスト
>   , assertEqual "take 5 (filter even [1..])"
>                 [2,4,6,8,10] (Prelude.take 5 (filter even [1..]))
>   ]

6. [until](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:until)

> until :: (a -> Bool) -> (a -> a) -> a -> a
> until = undefined

テストのコマンド： `runTests untilTests`

> untilTests :: [Test]
> untilTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "until (<= 1.0) (/ 2) 100.0"
>                 0.78125 (until (<= 1.0) (/ 2) 100.0)
>   ]

7. [and](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:and)

> and :: [Bool] -> Bool
> and = undefined

テストのコマンド： `runTests andTests`

> andTests :: [Test]
> andTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "and [True,True,True]" True (and [True,True,True])
>   , assertEqual "and [True,False,True]" False (and [True,False,True])
>   , assertEqual "and []" True (and [])
>   -- 無限／大きなテスト
>   , assertEqual "and (cycle [True,False])" False (and (cycle [True,False]))
>   , assertEqual "and (replicate (2 ^ 24) True)"
>                 True (and (replicate (2 ^ 24) True))
>   ]

8. [or](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:or)

> or :: [Bool] -> Bool
> or = undefined

テストのコマンド： `runTests orTests`

> orTests :: [Test]
> orTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "or [False,True,False]" True (or [False,True,False])
>   , assertEqual "or [False,False,False]" False (or [False,False,False])
>   , assertEqual "or []" False (or [])
>   -- 無限／大きなテスト
>   , assertEqual "or (cycle [False,True])" True (or (cycle [False,True]))
>   , assertEqual "or (replicate (2 ^ 24) False)"
>                 False (or (replicate (2 ^ 24) False))
>   ]

9. [any](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:any)

> any :: (a -> Bool) -> [a] -> Bool
> any = undefined

テストのコマンド： `runTests anyTests`

> anyTests :: [Test]
> anyTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "any even [1,2,3]" True (any even [1,2,3])
>   , assertEqual "any even [1,3,5]" False (any even [1,3,5])
>   , assertEqual "any even []" False (any even [])
>   -- 無限／大きなテスト
>   , assertEqual "any even [1..]" True (any even [1..])
>   , assertEqual "any even [2 * x + 1 | x <- [1..large]]"
>                 False (any even [2 * x + 1 | x <- [1..large]])
>   ]

10. [all](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:all)

> all :: (a -> Bool) -> [a] -> Bool
> all = undefined

テストのコマンド： `runTests allTests`

> allTests :: [Test]
> allTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "all even [2,4,6]" True (all even [2,4,6])
>   , assertEqual "all even [2,5,7]" False (all even [2,5,7])
>   , assertEqual "all even []" True (all even [])
>   -- 無限／大きなテスト
>   , assertEqual "all even [1..]" False (all even [1..])
>   , assertEqual "all even [2 * x | x <- [1..large]]"
>                 True (all even [2 * x | x <- [1..large]])
>   ]

11. [elem](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:elem)

> elem :: Eq a => a -> [a] -> Bool
> elem = undefined

テストのコマンド： `runTests elemTests`

> elemTests :: [Test]
> elemTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "2 `elem` [1,2,3]" True (2 `elem` [1,2,3])
>   , assertEqual "4 `elem` [1,2,3]" False (4 `elem` [1,2,3])
>   , assertEqual "1 `elem` []" False (1 `elem` [])
>   -- 無限／大きなテスト
>   , assertEqual "1331 `elem` [1..]" True (1331 `elem` [1..])
>   , assertEqual "1331 `elem` [2 * x | x <- [1..large]]"
>                 False (1331 `elem` [2 * x | x <- [1..large]])
>   ]

12. [notElem](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:notElem)

> notElem :: Eq a => a -> [a] -> Bool
> notElem = undefined

テストのコマンド： `runTests notElemTests`

> notElemTests :: [Test]
> notElemTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "2 `notElem` [1,2,3]" False (2 `notElem` [1,2,3])
>   , assertEqual "4 `notElem` [1,2,3]" True (4 `notElem` [1,2,3])
>   , assertEqual "1 `notElem` []" True (1 `notElem` [])
>   -- 無限／大きなテスト
>   , assertEqual "1331 `notElem` [1..]" False (1331 `notElem` [1..])
>   , assertEqual "1331 `notElem` [2 * x | x <- [1..large]]"
>                 True (1331 `notElem` [2 * x | x <- [1..large]])
>   ]

13. [zip](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:zip)

> zip :: [a] -> [b] -> [(a, b)]
> zip = undefined

テストのコマンド： `runTests zipTests`

> zipTests :: [Test]
> zipTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "zip \"abc\" [1,2,3]"
>                 [('a',1),('b',2),('c',3)] (zip "abc" [1,2,3])
>   , assertEqual "zip \"abc\" [1,2]"
>                 [('a',1),('b',2)] (zip "abc" [1,2])
>   , assertEqual "zip \"ab\" [1,2,3]"
>                 [('a',1),('b',2)] (zip "ab" [1,2,3])
>   , assertEqual "zip \"abc\" []"
>                 ([] :: [(Char, Int)]) (zip "abc" [])
>   , assertEqual "zip \"\" [1,2,3]" [] (zip "" [1,2,3])
>   -- 無限／大きなテスト
>   , assertEqual "zip \"abc\" [1..]"
>                 [('a',1),('b',2),('c',3)] (zip "abc" [1..])
>   , assertEqual "zip [1..] \"abc\""
>                 [(1,'a'),(2,'b'),(3,'c')] (zip [1..] "abc")
>   , assertEqual "take 3 (zip [1..] [2..])"
>                 [(1,2),(2,3),(3,4)] (Prelude.take 3 (zip [1..] [2..]))
>   ]

14. [zip3](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:zip3)

> zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
> zip3 = undefined

テストのコマンド： `runTests zip3Tests`

> zip3Tests :: [Test]
> zip3Tests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "zip3 \"abc\" [1,2,3] [False,True,False]"
>                 [('a',1,False),('b',2,True),('c',3,False)]
>                 (zip3 "abc" [1,2,3] [False,True,False])
>   , assertEqual "zip3 \"abc\" [1,2,3] [False, True]"
>                 [('a',1,False),('b',2,True)]
>                 (zip3 "abc" [1,2,3] [False, True])
>   , assertEqual "zip3 \"abc\" [1,2] [False,True,False]"
>                 [('a',1,False),('b',2,True)]
>                 (zip3 "abc" [1,2] [False,True,False])
>   , assertEqual "zip3 \"ab\" [1,2,3] [False,True,False]"
>                 [('a',1,False),('b',2,True)]
>                 (zip3 "ab" [1,2,3] [False,True,False])
>   , assertEqual "zip3 \"abc\" [1,2,3] []"
>                 ([] :: [(Char, Int, Bool)])
>                 (zip3 "abc" [1,2,3] [])
>   , assertEqual "zip3 \"abc\" [] [False,True,False]"
>                 ([] :: [(Char, Int, Bool)])
>                 (zip3 "abc" [] [False,True,False])
>   , assertEqual "zip3 \"\" [1,2,3] [False,True,False]"
>                 [] (zip3 "" [1,2,3] [False,True,False])
>   -- 無限／大きなテスト
>   , assertEqual "zip3 \"abc\" [1,2,3] (cycle [False,True])"
>                 [('a',1,False),('b',2,True),('c',3,False)]
>                 (zip3 "abc" [1,2,3] (cycle [False,True]))
>   , assertEqual "zip3 \"abc\" [1..] (cycle [False,True])"
>                 [('a',1,False),('b',2,True),('c',3,False)]
>                 (zip3 "abc" [1..] (cycle [False,True]))
>   , assertEqual
>       "take 3 (zip3 (cycle ['a'..'z']) [1..] (cycle [False,True]))"
>       [('a',1,False),('b',2,True),('c',3,False)]
>       (Prelude.take 3 (zip3 (cycle ['a'..'z']) [1..] (cycle [False,True])))
>   ]

15. [zipWith](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:zipWith)

> zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
> zipWith = undefined

テストのコマンド： `runTests zipWithTests`

> zipWithTests :: [Test]
> zipWithTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "zipWith (+) [1,2,3] [4,5,6]"
>                 [5,7,9] (zipWith (+) [1,2,3] [4,5,6])
>   , assertEqual "zipWith (+) [1,2,3] [4,5]"
>                 [5,7] (zipWith (+) [1,2,3] [4,5])
>   , assertEqual "zipWith (+) [1,2] [4,5,6]"
>                 [5,7] (zipWith (+) [1,2] [4,5,6])
>   , assertEqual "zipWith (+) [] []"
>                 [] (zipWith (+) [] [])
>   -- 無限／大きなテスト
>   , assertEqual "zipWith (+) [1,2,3] (cycle [1,0])"
>                 [2,2,4] (zipWith (+) [1,2,3] (cycle [1,0]))
>   , assertEqual "take 3 (zipWith (+) [1..] (cycle [1,0]))"
>                 [2,2,4] (Prelude.take 3 (zipWith (+) [1..] (cycle [1,0])))
>   ]

16. [zipWith3](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:zipWith3)

> zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
> zipWith3 = undefined

テストのコマンド： `runTests zipWith3Tests`

> zipWith3Tests :: [Test]
> zipWith3Tests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "zipWith3 (\\a b c -> a*b+c) [1,2,3] [4,5,6] [7,8,9]"
>                 [11,18,27]
>                 (zipWith3 (\a b c -> a*b+c) [1,2,3] [4,5,6] [7,8,9])
>   , assertEqual "zipWith3 (\\a b c -> a*b+c) [1,2,3] [4,5,6] [7,8]"
>                 [11,18]
>                 (zipWith3 (\a b c -> a*b+c) [1,2,3] [4,5,6] [7,8])
>   , assertEqual "zipWith3 (\\a b c -> a*b+c) [1,2,3] [4,5] [7,8,9]"
>                 [11,18]
>                 (zipWith3 (\a b c -> a*b+c) [1,2,3] [4,5] [7,8,9])
>   , assertEqual "zipWith3 (\\a b c -> a*b+c) [1,2] [4,5,6] [7,8,9]"
>                 [11,18]
>                 (zipWith3 (\a b c -> a*b+c) [1,2] [4,5,6] [7,8,9])
>   , assertEqual "zipWith3 (\\a b c -> a*b+c) [] [] []"
>                 []
>                 (zipWith3 (\a b c -> a*b+c) [] [] [])
>   -- 無限／大きなテスト
>   , assertEqual "zipWith3 (\\a b c -> a*b+c) [1,2,3] [4,5,6] [7..]"
>                 [11,18,27]
>                 (zipWith3 (\a b c -> a*b+c) [1,2,3] [4,5,6] [7..])
>   , assertEqual "zipWith3 (\\a b c -> a*b+c) [1,2,3] [4..] [7..]"
>                 [11,18,27]
>                 (zipWith3 (\a b c -> a*b+c) [1,2,3] [4..] [7..])
>   , assertEqual "take 3 (zipWith3 (\\a b c -> a*b+c) [1..] [4..] [7..])"
>                 [11,18,27]
>                 (Prelude.take 3 (zipWith3 (\a b c -> a*b+c)
>                                           [1..] [4..] [7..]))
>   ]

17. [unlines](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:unlines)

簡単にするために、プラットフォームにかかわらず、改行コードを`'\n'`にする。

> unlines :: [String] -> String
> unlines = undefined

テストのコマンド： `runTests unlinesTests`

> unlinesTests :: [Test]
> unlinesTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "unlines [\"one\",\"two\",\"three\"]"
>                 "one\ntwo\nthree\n"
>                 (unlines ["one","two","three"])
>   , assertEqual "unlines [\"one\"]" "one\n" (unlines ["one"])
>   , assertEqual "unlines []" "" (unlines [])
>   -- 無限／大きなテスト
>   , assertEqual "take 16 (unlines (cycle [\"one\", \"two\"]))"
>                 "one\ntwo\none\ntwo\n"
>                 (Prelude.take 16 (unlines (cycle ["one", "two"])))
>   ]

18. [unwords](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:unwords)

> unwords :: [String] -> String
> unwords = undefined

テストのコマンド： `runTests unwordsTests`

> unwordsTests :: [Test]
> unwordsTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "unwords [\"one\",\"two\",\"three\"]"
>                 "one two three"
>                 (unwords ["one","two","three"])
>   , assertEqual "unwords [\"one\"]" "one" (unwords ["one"])
>   , assertEqual "unwords []" "" (unwords [])
>   -- 無限／大きなテスト
>   , assertEqual "take 15 (unwords (cycle [\"one\", \"two\"]))"
>                 "one two one two"
>                 (Prelude.take 15 (unwords (cycle ["one", "two"])))
>   ]

セット2
-------

19. [last](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:last)

> last :: [a] -> a
> last = undefined

テストのコマンド： `runTests lastTests`

> lastTests :: [Test]
> lastTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "last [1,2,3]" 3 (last [1,2,3])
>   , assertError "last []" (last [])
>   -- 無限／大きなテスト
>   , assertEqual "last [1..large]" large (last [1..large])
>   ]

20. [init](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:init)

> init :: [a] -> [a]
> init = undefined

テストのコマンド： `runTests initTests`

> initTests :: [Test]
> initTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "init [1,2,3]" [1,2] (init [1,2,3])
>   , assertError "init []" (init [])
>   -- 無限／大きなテスト
>   , assertEqual "head (init [1..])" 1 (head (init [1..]))
>   ]

21. [take](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:take)

> take :: Int -> [a] -> [a]
> take = undefined

テストのコマンド： `runTests takeTests`

> takeTests :: [Test]
> takeTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "take 2 [1,2,3]" [1,2] (take 2 [1,2,3])
>   , assertEqual "take 0 [1,2,3]" [] (take 0 [1,2,3])
>   , assertEqual "take 4 [1,2,3]" [1,2,3] (take 4 [1,2,3])
>   , assertEqual "take (-1) [1,2,3]" [] (take (-1) [1,2,3])
>   -- 無限／大きなテスト
>   , assertEqual "head (take large [1..])" 1 (head (take large [1..]))
>   ]

22. [drop](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:drop)

> drop :: Int -> [a] -> [a]
> drop = undefined

テストのコマンド： `runTests dropTests`

> dropTests :: [Test]
> dropTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "drop 2 [1,2,3]" [3] (drop 2 [1,2,3])
>   , assertEqual "drop 0 [1,2,3]" [1,2,3] (drop 0 [1,2,3])
>   , assertEqual "drop 5 [1,2,3]" [] (drop 4 [1,2,3])
>   , assertEqual "drop (-1) [1,2,3]" [1,2,3] (drop (-1) [1,2,3])
>   -- 無限／大きなテスト
>   , assertEqual "head (drop 3 [1..])" 4 (head (drop 3 [1..]))
>   ]

23. [takeWhile](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:takeWhile)

> takeWhile :: (a -> Bool) -> [a] -> [a]
> takeWhile = undefined

テストのコマンド： `runTests takeWhileTests`

> takeWhileTests :: [Test]
> takeWhileTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "takeWhile even [2,4,5,6]" [2,4] (takeWhile even [2,4,5,6])
>   , assertEqual "takeWhile even [1,2,3]" [] (takeWhile even [1,2,3])
>   , assertEqual "takeWhile even [2,4,6]" [2,4,6] (takeWhile even [2,4,6])
>   , assertEqual "takeWhile even []" [] (takeWhile even [])
>   -- 無限／大きなテスト
>   , assertEqual "head (takeWhile (> 0) [1..])"
>                 1
>                 (head (takeWhile (> 0) [1..]))
>   ]

24. [dropWhile](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:dropWhile)

> dropWhile :: (a -> Bool) -> [a] -> [a]
> dropWhile = undefined

テストのコマンド： `runTests dropWhileTests`

> dropWhileTests :: [Test]
> dropWhileTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "dropWhile even [2,4,5,6]" [5,6] (dropWhile even [2,4,5,6])
>   , assertEqual "dropWhile even [1,2,3]" [1,2,3] (dropWhile even [1,2,3])
>   , assertEqual "dropWhile even [2,4,6]" [] (dropWhile even [2,4,6])
>   , assertEqual "dropWhile even []" [] (dropWhile even [])
>   -- 無限／大きなテスト
>   , assertEqual "head (dropWhile even (cycle [2,4,6,9]))"
>                 9
>                 (head (dropWhile even (cycle [2,4,6,9])))
>   ]

セット3
-------

25. [(!!)](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:-33--33-)

> (!!) :: [a] -> Int -> a
> (!!) = undefined

テストのコマンド： `runTests indexTests`

> indexTests :: [Test]
> indexTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "[1,2,3] !! 0" 1 ([1,2,3] !! 0)
>   , assertEqual "[1,2,3] !! 1" 2 ([1,2,3] !! 1)
>   , assertEqual "[1,2,3] !! 2" 3 ([1,2,3] !! 2)
>   , assertError "[1,2,3] !! (-1)" ([1,2,3] !! (-1))
>   , assertError "[1,2,3] !! 3" ([1,2,3] !! 3)
>   -- 無限／大きなテスト
>   , assertEqual "[1..] !! large" large ([0..] !! large)
>   ]

セット4
-------

このセットの問題には、アキュムレータを用いて定義せよ。

26. [sum](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:sum)

> sum :: Num a => [a] -> a
> sum = undefined

テストのコマンド： `runTests sumTests`

> sumTests :: [Test]
> sumTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "sum [1,2,3,4]" 10 (sum [1,2,3,4])
>   , assertEqual "sum [1,-1,2,-2]" 0 (sum [1,-1,2,-2])
>   , assertEqual "sum []" 0 (sum [])
>   -- 無限／大きなテスト - 末尾再帰が必要です
>   --, assertEqual "sum (concatMap (\\n -> [n,-n]) [1..large])"
>   --              0
>   --              (sum (Prelude.concatMap (\n -> [n,-n]) [1..large]))
>   ]

27. [product](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:product)

> product :: Num a => [a] -> a
> product = undefined

テストのコマンド： `runTests productTests`

> productTests :: [Test]
> productTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "product [1,2,3,4]" 24 (product [1,2,3,4])
>   , assertEqual "product [1,-1,2,-2]" 4 (product [1,-1,2,-2])
>   , assertEqual "product [0,1,2]" 0 (product [0,1,2])
>   , assertEqual "product []" 1 (product [])
>   -- 無限／大きなテスト - 末尾再帰が必要です
>   --, assertEqual
>   --    "product (concatMap (\\n -> let n2 = 2*n in [n2,1/n2]) [1..large])"
>   --    1.0
>   --    (product (concatMap (\n -> let n2 = 2*n in [n2,1/n2]) [1..large]))
>   ]

28. [maximum](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:maximum)

> maximum :: Ord a => [a] -> a
> maximum = undefined

テストのコマンド： `runTests maximumTests`

> maximumTests :: [Test]
> maximumTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "maximum [1,5,9,3,7]" 9 (maximum [1,5,9,3,7])
>   , assertError "maximum []" (maximum ([] :: [Int]))
>   -- 無限／大きなテスト
>   , assertEqual "maximum [1..large]" large (maximum [1..large])
>   ]

29. [minimum](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:minimum)

> minimum :: Ord a => [a] -> a
> minimum = undefined

テストのコマンド： `runTests minimumTests`

> minimumTests :: [Test]
> minimumTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "minimum [1,5,9,3,7]" 1 (minimum [9,5,1,7,3])
>   , assertError "minimum []" (minimum ([] :: [Int]))
>   -- 無限／大きなテスト
>   , assertEqual "minimum [1..large]" 1 (minimum [1..large])
>   ]

30. [length](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:length)

> length :: [a] -> Int
> length = undefined

テストのコマンド： `runTests lengthTests`

> lengthTests :: [Test]
> lengthTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "length [1,2,3]" 3 (length [1,2,3])
>   , assertEqual "length []" 0 (length [])
>   -- 無限／大きなテスト - 末尾再帰が必要です
>   --, assertEqual "length [1..large]" large (length [1..large])
>   ]

31. [reverse](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:reverse)

> reverse :: [a] -> [a]
> reverse = undefined

テストのコマンド： `runTests reverseTests`

> reverseTests :: [Test]
> reverseTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "reverse [1,2,3]" [3,2,1] (reverse [1,2,3])
>   , assertEqual "reverse []" ([] :: [Int]) (reverse [])
>   -- 無限／大きなテスト
>   , assertEqual "head (reverse [1..large])"
>                 large
>                 (head (reverse [1..large]))
>   ]

32. [lines](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:lines)

簡単にするために、プラットフォームにかかわらず、改行コードを`'\n'`にする。

> lines :: String -> [String]
> lines = undefined

テストのコマンド： `runTests linesTests`

> linesTests :: [Test]
> linesTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "lines \"one\\ntwo\\nthree\\n\""
>                 ["one","two","three"]
>                 (lines "one\ntwo\nthree\n")
>   , assertEqual "lines \"\\n\\none\\n\\ntwo\\n\\nthree\\n\\n\""
>                 ["","","one","","two","","three",""]
>                 (lines "\n\none\n\ntwo\n\nthree\n\n")
>   , assertEqual "lines \"\\n\"" [""] (lines "\n")
>   -- 無限／大きなテスト
>   , assertEqual "head (lines (concat (repeat \"one\\n\")))"
>                 "one"
>                 (head (lines (Prelude.concat (repeat "one\n"))))
>   ]

33. [words](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:words)

`Data.Char`で定義されている関数`isSpace`を使うと良い。

> words :: String -> [String]
> words = undefined

テストのコマンド： `runTests wordsTests`

> wordsTests :: [Test]
> wordsTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "words \"one two three\""
>                 ["one","two","three"]
>                 (words "one two three")
>   , assertEqual "words \" one\\ttwo\\nthree \""
>                 ["one","two","three"]
>                 (words " one\ttwo\nthree ")
>   , assertEqual "words \"i\\n \\t\\n\\n\\t \"" [] (words "\n \t\n\n\t ")
>   -- 無限／大きなテスト
>   , assertEqual "head (words (concat (repeat \" one\")))"
>                 "one"
>                 (head (words (Prelude.concat (repeat " one"))))
>   ]

セット5
-------

34. [splitAt](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:splitAt)

> splitAt :: Int -> [a] -> ([a], [a])
> splitAt = undefined

テストのコマンド： `runTests splitAtTests`

> splitAtTests :: [Test]
> splitAtTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "splitAt 1 [1,2,3]" ([1],[2,3]) (splitAt 1 [1,2,3])
>   , assertEqual "splitAt 0 [1,2,3]" ([],[1,2,3]) (splitAt 0 [1,2,3])
>   , assertEqual "splitAt 4 [1,2,3]" ([1,2,3],[]) (splitAt 4 [1,2,3])
>   , assertEqual "splitAt (-1) [1,2,3]" ([],[1,2,3]) (splitAt (-1) [1,2,3])
>   -- 無限／大きなテスト
>   , assertEqual "head (fst (splitAt large [1..]))"
>                 1
>                 (head (fst (splitAt large [1..])))
>   ]

35. [span](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:span)

> span :: (a -> Bool) -> [a] -> ([a], [a])
> span = undefined

テストのコマンド： `runTests spanTests`

> spanTests :: [Test]
> spanTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "span even [2,4,6,9]" ([2,4,6],[9]) (span even [2,4,6,9])
>   , assertEqual "span even [1,3,5,8]" ([],[1,3,5,8]) (span even [1,3,5,8])
>   , assertEqual "span even []" ([],[]) (span even [])
>   -- 無限／大きなテスト
>   , assertEqual "head (fst (span (> 0) [1..]))"
>                 1
>                 (head (fst (span (> 0) [1..])))
>   ]

36. [break](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:break)

> break :: (a -> Bool) -> [a] -> ([a], [a])
> break = undefined

テストのコマンド： `runTests breakTests`

> breakTests :: [Test]
> breakTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "break even [1,3,6,8]" ([1,3],[6,8]) (break even [1,3,6,8])
>   , assertEqual "break even [2,4,7,9]" ([],[2,4,7,9]) (break even [2,4,7,9])
>   , assertEqual "break even []" ([],[]) (break even [])
>   -- 無限／大きなテスト
>   , assertEqual "head (fst (break (< 0) [1..]))"
>                 1
>                 (head (fst (break (< 0) [1..])))
>   ]

37. [unzip](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:unzip)

> unzip :: [(a, b)] -> ([a], [b])
> unzip = undefined

テストのコマンド： `runTests unzipTests`

> unzipTests :: [Test]
> unzipTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "unzip [(1,'a'),(2,'b'),(3,'c')]"
>                 ([1,2,3],"abc")
>                 (unzip [(1,'a'),(2,'b'),(3,'c')])
>   , assertEqual "unzip []" (([],[]) :: ([Int],[Char])) (unzip [])
>   -- 無限／大きなテスト
>   , assertEqual "head (fst (unzip [(x,x) | x <- [1..]]))"
>                 1
>                 (head (fst (unzip [(x,x) | x <- [1..]])))
>   ]

38. [unzip3](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:unzip3)

> unzip3 :: [(a, b, c)] -> ([a], [b], [c])
> unzip3 = undefined

テストのコマンド： `runTests unzip3Tests`

> unzip3Tests :: [Test]
> unzip3Tests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "unzip3 [(1,'a',True),(2,'b',False),(3,'c',True)]"
>                 ([1,2,3],"abc",[True,False,True])
>                 (unzip3 [(1,'a',True),(2,'b',False),(3,'c',True)])
>   , assertEqual "unzip3 []" (([],[],[]) :: ([Int],[Char],[Int])) (unzip3 [])
>   -- 無限／大きなテスト
>   , assertEqual "head ((\\(x,y,z) -> x) (unzip3 [(x,x,x) | x <- [1..]]))"
>                 1
>                 (head ((\(x,y,z) -> x) (unzip3 [(x,x,x) | x <- [1..]])))
>   ]

セット6
-------

39. [foldl](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:foldl)

> foldl :: (a -> b -> a) -> a -> [b] -> a
> foldl f x [] = x
> foldl f x (y : ys) = foldl f (f x y) ys

テストのコマンド： `runTests foldlTests`

> foldlTests :: [Test]
> foldlTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "foldl (+) 0 [1,2,3]" 6 (foldl (+) 0 [1,2,3])
>   , assertEqual "foldl (+) 0 []" 0 (foldl (+) 0 [])
>   , assertEqual "foldl (/) 1 [4,2,1]" 0.125 (foldl (/) 1 [4,2,1])
>   ]

40. [foldr](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:foldr)

> foldr :: (a -> b -> b) -> b -> [a] -> b
> foldr f x [] = x
> foldr f x (y : ys) = f y (foldr f x ys)

テストのコマンド： `runTests foldrTests`

> foldrTests :: [Test]
> foldrTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "foldr (+) 0 [1,2,3]" 6 (foldr (+) 0 [1,2,3])
>   , assertEqual "foldr (+) 0 []" 0 (foldr (+) 0 [])
>   , assertEqual "foldr (/) 1 [4,2,1]" 2 (foldr (/) 1 [4,2,1])
>   ]

41. [scanl](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:scanl)

> scanl :: (a -> b -> a) -> a -> [b] -> [a]
> scanl = undefined

テストのコマンド： `runTests scanlTests`

> scanlTests :: [Test]
> scanlTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "scanl (+) 0 [1,2,3]" [0,1,3,6] (scanl (+) 0 [1,2,3])
>   , assertEqual "scanl (+) 0 []" [0] (scanl (+) 0 [])
>   , assertEqual "scanl (/) 1 [4,2,1]"
>                 [1,0.25,0.125,0.125]
>                 (scanl (/) 1 [4,2,1])
>   ]

42. [scanr](http://haskell.org/ghc/docs/7.0-latest/html/libraries/base-4.3.1.0/Prelude.html#v:scanr)

> scanr :: (a -> b -> b) -> b -> [a] -> [b]
> scanr = undefined

テストのコマンド： `runTests scanrTests`

> scanrTests :: [Test]
> scanrTests = Prelude.map TestCase
>   -- 基本のテスト
>   [ assertEqual "scanr (+) 0 [1,2,3]" [6,5,3,0] (scanr (+) 0 [1,2,3])
>   , assertEqual "scanr (+) 0 []" [0] (scanr (+) 0 [])
>   , assertEqual "scanr (/) 1 [4,2,1]"
>                 [2,2,1,1]
>                 (scanr (/) 1 [4,2,1])
>   ]
