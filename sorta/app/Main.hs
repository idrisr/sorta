{-# LANGUAGE ImportQualifiedPost #-}

module Main where

import Data.List (group)
import Data.Text qualified as T
import Data.Time
import Data.Time.Format.Internal
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

filterSubs :: [Subtitle] -> Maybe [Subtitle]
filterSubs xs = do
    s <- startTime
    e <- endTime
    pure . filter (overlap s e) $ xs
  where
    overlap :: NominalDiffTime -> NominalDiffTime -> Subtitle -> Bool
    overlap a b (Subtitle _ (Timerange (Timestamp c) (Timestamp d)) _) = not $ (b < c && b < d) || (a > c) && (a > d)

-- 28 : 00
-- 33 : 50

startTime :: Maybe NominalDiffTime
startTime = buildTime defaultTimeLocale [('H', "0"), ('M', "31"), ('S', "57")]

endTime :: Maybe NominalDiffTime
endTime = buildTime defaultTimeLocale [('H', "0"), ('M', "38"), ('S', "00")]

getSubs :: FilePath -> IO (Maybe [Subtitle])
getSubs f = do
    absPath <- makeAbsolute f
    result <- parseFromFile (many parseSubtitle) absPath
    case result of
        Nothing -> pure Nothing
        Just a -> case filterSubs a of
            Nothing -> pure Nothing
            Just c -> pure . pure $ c

main :: IO ()
main = do
    (Params path) <- cmdLineParser
    absPath <- makeAbsolute path
    result <- parseFromFile (many parseSubtitle) absPath
    case result of
        Nothing -> exitFailure
        Just a -> putStrLn . unpack . toText $ a
