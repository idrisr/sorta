{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeApplications #-}

module TestTimeStamp (testTimeStamps) where

import Data.Fixed
import Data.Text
import Data.Time.Clock
import Parser (parseTimestamp)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck hiding (Failure, Fixed, Success)
import Text.RawString.QQ
import Types
import Util

-- This module is for testing parsing timestamps
-- start with a unit test, then do roundtrip property tests

testTimeStamps :: TestTree
testTimeStamps = testGroup "timestamps" [testTimeStamp0, testTimeStamp1, qcPropSub]

qcPropSub :: TestTree
qcPropSub =
    testGroup
        "Subtitle"
        [ testProperty "gen -> print -> parse" $ propPrintParse parseTimestamp (unpack . formatTime)
        ]

testTimeStamp0 :: TestTree
testTimeStamp0 =
    testCase "timestamp" $
        let sut = subTime01s
            got = parseTest parseTimestamp sut
            wot = Right subTime01
         in (@=?) wot got

testTimeStamp1 :: TestTree
testTimeStamp1 =
    testCase "timestamp" $
        let sut = subTime02s
            got = parseTest parseTimestamp sut
            wot = Right subTime02
         in (@=?) wot got

subTime01s :: String
subTime01s = [r|00:12:06,560|]

subTime01 :: Timestamp
subTime01 = Timestamp . secondsToNominalDiffTime $ t
  where
    t :: Pico
    t = 12 * 60 + 6 + 560 / 1000

subTime02s :: String
subTime02s = [r|00:12:11,279|]

subTime02 :: Timestamp
subTime02 = Timestamp . secondsToNominalDiffTime $ t
  where
    t :: Pico
    t = 12 * 60 + 11 + 279 / 1000
