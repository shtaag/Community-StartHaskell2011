Resistance Network
==================

This is a literate Haskell file.  Implement your solution below.

> -- hunit
> import Test.HUnit

Data Type
---------

Implement a data type `Network` that models a network of resistors.  Resistors
and/or subnets can be in series or parallel with each other.  See the diagram
(`RNetwork.png`) for examples.

> data Network = Res Float | Ser [Network] | Par [Network]

Test Networks
-------------

Create a test network for each network in the diagram.

> test01 :: Network
> test01 = Res 2

> test02, test03, test04 :: Network
> test02 = Ser [Res 2]
> test03 = Ser [Res 2, Res 2]
> test04 = Ser [Res 2, Res 5, Res 7, Res 9]

> test05, test06, test07 :: Network
> test05 = Par [Res 2]
> test06 = Par [Res 2, Res 2]
> test07 = Par [Res 6, Res 8, Res 8, Res 12]

> test08, test09, test10, test11 :: Network
> test08 = Ser [Res 2, Par [Res 6, Res 12]]
> test09 = Par [Ser [Res 4, Par [Res 6, Res 12]], Res 8]
> test10 = Ser [Par [Res 2, Res 6, Res 6], Par [Res 8, Res 12]]
> test11 = Ser [Res 5, Par [Res 6, Ser [Res 4, Par [Res 6,
>                                                   Ser [Res 1, Res 2]]]]]

Resistance
----------

Write a function `resistance` that calculates the resistance of a `Network`
and some tests for it.  Note that the expected resistance for each network is
indicated in red in the diagram.  (Feel free to implement the tests first if
you are into TDD.)

The resistance of a resistor/subnet with resistance `A` that is in series with
a resistor/subnet with resistance `B` is `A + B`.  The resistance of a
resistor/subnet with resistance `A` that is paralell with a resistor/subnet
with resistance `B` is `1/(1/A + 1/B) == AB/(A + B)`.  Assume that the
resistance of the network/"wire" is insignificant.

> resistance :: Network -> Float
> resistance (Res r)  = r
> resistance (Ser ns) = sum . map resistance $ ns
> resistance (Par ns) = (1 /) . sum . map ((1 /) . resistance) $ ns

To test: `runTests resistanceTests`

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> resistanceTests :: [Test]
> resistanceTests = map TestCase
>   [ assertApproxEq "test01" 2 (resistance test01)
>   , assertApproxEq "test02" 2 (resistance test02)
>   , assertApproxEq "test03" 4 (resistance test03)
>   , assertApproxEq "test04" 23 (resistance test04)
>   , assertApproxEq "test05" 2 (resistance test05)
>   , assertApproxEq "test06" 1 (resistance test06)
>   , assertApproxEq "test07" 2 (resistance test07)
>   , assertApproxEq "test08" 6 (resistance test08)
>   , assertApproxEq "test09" 4 (resistance test09)
>   , assertApproxEq "test10" 6 (resistance test10)
>   , assertApproxEq "test11" 8 (resistance test11)
>   ]
>   where
>     assertApproxEq :: String -> Float -> Float -> Assertion
>     assertApproxEq s x y | approxEq 0.0001 x y = assertBool s True
>                          | otherwise           = assertEqual s x y

> approxEq :: Real a => a -> a -> a -> Bool
> approxEq d v1 v2 = (v2 > v1 - d) && (v2 < v1 + d)
