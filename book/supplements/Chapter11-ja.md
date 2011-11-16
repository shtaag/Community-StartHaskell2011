第11章：補足
============

Show
----

第10章に型クラスとインスタンスの宣言について習いました。他の重要なクラスは
`Prelude`で定義してある`Show`クラスです。このクラスのインスタンスは
`show :: a -> String`という関数を実装する必要です。この関数はある型`a`を
`String`に変換するものです。

140ページに定義してある型`Expr`を表示するようにできたら便利です。以下の通りに
できます。

    instance Show Expr where
      show (Val x)       = show x
      show (App Add x y) = '(' : show x ++ " + " ++ show y ++ ")"
      show (App Sub x y) = '(' : show x ++ " - " ++ show y ++ ")"
      show (App Mul x y) = '(' : show x ++ " * " ++ show y ++ ")"
      show (App Div x y) = '(' : show x ++ " / " ++ show y ++ ")"

タイミング
----------

この章には、経過時間でプログラムの効率性を計ります。Haskellの中で経過時間を
計るには、`System.CPUTime`から`getCPUTime`をインポートして、次の関数を使って
ください。

    timeIO :: Show a => a -> IO ()
    timeIO action = do t0 <- getCPUTime
                       putStrLn . show $ action
                       t1 <- getCPUTime
                       let td = fromIntegral (t1 - t0) / 10^12
                       putStrLn $ "Time elapsed: " ++ show td ++ " seconds"

この関数はあるアクションの実行の経過時間を計って、アクションの結果と経過時間を
両方表示されます。総当たり法の三つのテストは以下の通りに定義します。

    mainBF1 :: IO ()
    mainBF1 = timeIO . head $ solutions [1,3,7,10,25,50] 765

    mainBF2 :: IO ()
    mainBF2 = timeIO . length $ solutions [1,3,7,10,25,50] 765

    mainBF3 :: IO ()
    mainBF3 = timeIO . length $ solutions [1,3,7,10,25,50] 831

`mainBF1`には、最初の解のみを計算するために`head`を使います。遅延評価の
おかげで他の解を計算しません。`mainBF2`と`mainBF3`には、全ての解を計算させる
ために`length`を使います。

他の方法をテストするための関数は上と同じようにして、ただ適用な`solutions`
関数を使います。

GHCiの中ではなくて、コマンドラインからテストします。これをするために、テスト
したい関数を`main`に定義します。

    main :: IO ()
    main = mainBF1

`ghc -O2 Filename.hs`というコマンドでコンパイルとリンクさせて、生成された実行
ファイルを起動します。
