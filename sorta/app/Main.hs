{-# LANGUAGE ImportQualifiedPost #-}

module Main where

import Control.Monad
import Data.Attoparsec.Text
import Data.Functor
import Data.List (group)
import Data.Text qualified as T
import Data.Text.IO qualified as T
import Options.Applicative
import Params
import System.Directory
import Text.Subtitles.SRT
import Turtle qualified as Tu

generalizeFileName :: Text -> Text
generalizeFileName t =
    let
        a = Tu.ends ".en.srt"
        b = Tu.ends (("." *> Tu.many Tu.anyChar) $> ".en.srt")
        c = Tu.chars
     in
        -- head is safe here is c always matches
        head $ Tu.match (a <|> b <|> c) t

toText :: [Line] -> Text
toText ls = T.intercalate "\n" (head <$> group (concatMap clean ls))
  where
    clean :: Line -> [Text]
    clean = T.lines . T.strip . dialog

main :: IO ()
main = do
    (Params path) <- cmdLineParser
    absPath <- makeAbsolute path
    let modPath = T.unpack . generalizeFileName . T.pack $ absPath
    ex <- doesFileExist . T.unpack . generalizeFileName . T.pack $ modPath
    unless ex $ print ("file not found: " <> modPath)
    text <- T.readFile modPath
    case parseOnly parseSRT text of
        Left err -> print err
        Right xs -> putStrLn . unpack . toText $ xs
