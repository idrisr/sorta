{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeApplications #-}

module TestTimestamp (testTimeStamps) where

import Data.Text
import Parser (parseTimestamp)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck hiding (Failure, Fixed, Success)
import Text.RawString.QQ
import Types
import Util

testTimeStamps :: TestTree
testTimeStamps =
    testGroup
        "timestamps"
        [ testTimestamp0
        , testTimestamp1
        , qcPropSub
        ]

qcPropSub :: TestTree
qcPropSub =
    testGroup
        "timestamp"
        [ testProperty "gen -> print -> parse" $ propPrintParse parseTimestamp (unpack . formatTime)
        ]

testTimestamp0 :: TestTree
testTimestamp0 =
    testCase "timestamp" $
        let sut = subTime01s
            got = parseTest parseTimestamp sut
            wot = Right subTime01
         in (@=?) wot got

testTimestamp1 :: TestTree
testTimestamp1 =
    testCase "timestamp" $
        let sut = subTime02s
            got = parseTest parseTimestamp sut
            wot = Right subTime02
         in (@=?) wot got

subTime01s :: String
subTime01s = [r|00:12:06,560|]

subTime01 :: Timestamp
subTime01 = mkTimestamp 0 12 6 560

subTime02s :: String
subTime02s = [r|00:12:11,279|]

subTime02 :: Timestamp
subTime02 = mkTimestamp 0 12 11 279
