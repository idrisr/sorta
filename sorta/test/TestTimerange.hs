{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module TestTimerange where

import Fmt
import Parser
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck hiding (Failure, Fixed, Success)
import Text.RawString.QQ
import Types
import Util

testTimeranges :: TestTree
testTimeranges =
    testGroup
        "timeranges"
        [ testTimerange01
        , testTimerange02
        , qcProptimerange
        ]

qcProptimerange :: TestTree
qcProptimerange =
    testGroup
        "timerange"
        [ testProperty "gen -> print -> parse" $ propPrintParse parseTimerange (fmt . build)
        ]

testTimerange01 :: TestTree
testTimerange01 =
    testCase "timerange 1" $
        let sut = timerange01s
            got = parseTest parseTimerange sut
            wot = Right timerange01
         in (@=?) wot got

testTimerange02 :: TestTree
testTimerange02 =
    testCase "timerange 2" $
        let sut = timerange01s
            got = parseTest parseTimerange sut
            wot = Right timerange01
         in (@=?) wot got

timerange01s :: String
timerange01s =
    [r|00:00:04,880 --> 00:00:07,829|]

timerange01 :: Timerange
timerange01 =
    Timerange begin end
  where
    begin = mkTimestamp 0 0 4 880
    end = mkTimestamp 0 0 7 829

timerange02s :: String
timerange02s =
    [r|00:00:07,829 --> 00:00:07,839|]

timerange02 :: Timerange
timerange02 =
    Timerange begin end
  where
    begin = mkTimestamp 0 0 7 829
    end = mkTimestamp 0 0 7 839
