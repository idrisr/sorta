module Main (main) where

import Test.Tasty
import TestSubtitle
import TestTimerange (testTimeranges)
import TestTimestamp (testTimeStamps)

allTests :: TestTree
allTests =
    testGroup
        "all"
        [ testTimeStamps
        , testTimeranges
        , testSubtitles
        ]

main :: IO ()
main = defaultMain allTests
