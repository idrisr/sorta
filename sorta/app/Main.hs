{-# LANGUAGE ImportQualifiedPost #-}

module Main where

import Data.List (group)
import Data.Text qualified as T
import Options.Applicative
import Params
import Parser
import System.Directory
import System.Exit
import Text.Subtitles.SRT
import Text.Trifecta
import Types

toText :: [Subtitle] -> Text
toText ls = T.intercalate "\n" (head <$> group (concatMap clean ls))
  where
    clean :: Subtitle -> [Text]
    clean = T.lines . T.strip . subtitle

main :: IO ()
main = do
    (Params path) <- cmdLineParser
    absPath <- makeAbsolute path
    result <- parseFromFile (many parseSubtitle) absPath
    case result of
        Nothing -> exitFailure
        Just a -> putStrLn . unpack . toText $ a
