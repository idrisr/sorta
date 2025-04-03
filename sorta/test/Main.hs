module Main (main) where

import Test.Tasty
import TestSampleFiles
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
main = do
    f <- fileTests
    defaultMain $ testGroup "more" [allTests, f]
