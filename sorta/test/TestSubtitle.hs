{-# LANGUAGE QuasiQuotes #-}

module TestSubtitle where

import Data.Text
import Fmt
import Parser (parseSubtitle, parseTimerange)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck hiding (Failure, Fixed, Success)
import Text.RawString.QQ
import Text.Trifecta hiding (parseTest)
import Types
import Util

testSubtitles :: TestTree
testSubtitles = testGroup "subtitles" [testSubtitle01, qcSubtitle]

testSubtitle01 :: TestTree
testSubtitle01 =
    testCase "subtitle 1" $
        let sut = subtitle01s
            got = parseTest parseSubtitle sut
            wot = Right subtitle01
         in (@=?) wot got

qcSubtitle :: TestTree
qcSubtitle =
    testGroup
        "subtitle"
        [ testProperty "gen -> print -> parse" $ propPrintParse parseSubtitle (fmt . build)
        ]

subtitle01s :: String
subtitle01s =
    [r|5
00:00:03,600 --> 00:00:05,910
into today's video where we're going to
talk about cloud in it this is a

|]

text01s :: Text
text01s =
    [r|into today's video where we're going to
talk about cloud in it this is a|]

subtitle01 :: Subtitle
subtitle01 = Subtitle 5 range text01s
  where
    range =
        Timerange
            (mkTimestamp 0 0 3 600)
            (mkTimestamp 0 0 5 910)
