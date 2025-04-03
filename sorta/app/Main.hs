{-# LANGUAGE ImportQualifiedPost #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use for_" #-}

module Main where

import Control.Monad
import Data.Attoparsec.Text
import Data.Functor
import Data.List (group)
import Data.Text qualified as T
import Data.Text.IO qualified as T
import Fmt
import Options.Applicative
import Params
import Parser
import System.Directory
import System.Exit
import Text.Subtitles.SRT
import Text.Trifecta
import Turtle qualified as Tu

generalizeFileName :: Text -> Text
generalizeFileName t =
    let
        a = Tu.ends ".en.srt"
        b = Tu.ends (("." *> Tu.many Tu.anyChar) $> ".en.srt")
        c = Tu.chars
     in
        -- head is safe here as c always matches
        head $ Tu.match (a <|> b <|> c) t

toText :: [Line] -> Text
toText ls = T.intercalate "\n" (head <$> group (concatMap clean ls))
  where
    clean :: Line -> [Text]
    clean = T.lines . T.strip . dialog

main2 :: IO ()
main2 = do
    (Params path) <- cmdLineParser
    absPath <- makeAbsolute path
    let modPath = T.unpack . generalizeFileName . T.pack $ absPath
    ex <- doesFileExist . T.unpack . generalizeFileName . T.pack $ modPath
    unless ex $ print ("file not found: " <> modPath)
    t <- T.readFile modPath
    case parseOnly parseSRT t of
        Left e -> print e
        Right xs -> putStrLn . unpack . toText $ xs

main :: IO ()
main = do
    (Params path) <- cmdLineParser
    absPath <- makeAbsolute path
    result <- parseFromFile (many parseSubtitle) absPath
    case result of
        Nothing -> exitFailure
        Just a -> mapM_ (fmt . build) a
