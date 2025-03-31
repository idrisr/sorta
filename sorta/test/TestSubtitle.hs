{-# LANGUAGE QuasiQuotes #-}

module TestSubtitle where

import Parser (parseSubtitle, parseTimerange)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck hiding (Failure, Fixed, Success)
import Text.RawString.QQ
import Text.Trifecta hiding (parseTest)
import Util

tests :: TestTree
tests = testGroup "" [qcPropSub]

qcPropSub :: TestTree
qcPropSub =
    testGroup
        "Subtitle"
        [ testProperty "a == (parse . print) a" $ propPrintParse parseSubtitle show
        ]

qcPropSubTime :: TestTree
qcPropSubTime =
    testGroup
        "Subtitle"
        [ testProperty "a == (parse . print) a" $ propPrintParse parseTimerange show
        ]
