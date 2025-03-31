{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

-- import Data.Text (unpack)
-- import Fmt
import Parser (parseSubtitle)
import Test.Tasty
import Test.Tasty.HUnit
import Text.RawString.QQ
import Text.Trifecta hiding (parseTest)

tests :: TestTree
tests = testGroup "" [testDummy]

parseTest :: Parser a -> String -> Either String a
parseTest parser s =
    let res = parseString parser mempty s
     in case res of
            Success a -> Right a
            Failure e -> Left . show $ e

testDummy :: TestTree
testDummy =
    testGroup
        "not going to parse"
        $ let f = parseTest
           in [ let sut = srt01
                    wot = Left "NO"
                    got = f parseSubtitle sut
                 in testCase sut $ wot @=? got
              ]

main :: IO ()
main = defaultMain tests

srt00 :: String
srt00 =
    [r|3
00:00:02,399 --> 00:00:05,110
if you want to learn how AI agents work 
if you want to learn how AI agents work 

|]

srt01 :: String
srt01 =
    [r|541
00:12:06,560 --> 00:12:11,279
helpful feel free to share with others
who might benefit and happy building

|]
