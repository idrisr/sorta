module Main (main) where

import Test.Tasty
import TestTimeStamp (testTimeStamps)

allTests :: TestTree
allTests = testGroup "all" [testTimeStamps]

main :: IO ()
main = defaultMain allTests
