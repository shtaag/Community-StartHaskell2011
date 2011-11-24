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

> data Network = Undefined

Test Networks
-------------

Create a test network for each network in the diagram.

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
> resistance = undefined

To test: `runTests resistanceTests`

> runTests :: [Test] -> IO Counts
> runTests ts = runTestTT $ TestList ts

> resistanceTests :: [Test]
> resistanceTests = map TestCase
>   [
>   ]
