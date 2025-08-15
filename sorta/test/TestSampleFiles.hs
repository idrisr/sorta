module TestSampleFiles where

import Parser
import System.Directory
import System.FilePath
import Test.Tasty
import Test.Tasty.HUnit
import Text.Trifecta

fileParse :: FilePath -> TestTree
fileParse f = testCase f $ do
    result <- parseFromFile (some parseSubtitle) f
    case result of
        Nothing -> assertFailure f
        Just _ -> pure ()

fileTests :: IO TestTree
fileTests = do
    files <- listDirectory "data"
    absFiles <- mapM makeAbsolute $ ("data" </>) <$> files
    pure $ testGroup "file" $ fileParse <$> absFiles
