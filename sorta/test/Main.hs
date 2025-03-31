module Main (main) where

import Test.Tasty
import TestTimerange (testTimeranges)
import TestTimestamp (testTimeStamps)

allTests :: TestTree
allTests = testGroup "all" [testTimeStamps, testTimeranges]

main :: IO ()
main = defaultMain allTests
