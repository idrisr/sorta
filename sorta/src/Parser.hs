{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE TypeApplications #-}

module Parser where

import Data.Fixed
import Data.Text (pack, strip)
import Data.Time.Clock
import Text.Trifecta
import Types hiding (count)

parseSubtitle :: Parser Subtitle
parseSubtitle = do
    c <- parseCount
    t <- parseTimerange
    _ <- newline
    s <- manyTill anyChar (try (count 2 newline))
    pure $ Subtitle c t ((strip . pack) (filter (/= '\CR') s))

parseCount :: Parser Integer
parseCount = token decimal

parseTimerange :: Parser Timerange
parseTimerange = do
    b <- parseTimestamp
    _ <- string " --> "
    Timerange b <$> parseTimestamp

twoDigits :: Parser Int
twoDigits = do
    digits <- count 2 digit
    pure (read digits :: Int)

threeDigits :: Parser Int
threeDigits = do
    digits <- count 3 digit
    pure . read @Int $ digits

parseTimestamp :: Parser Timestamp
parseTimestamp = do
    h <- twoDigits
    _ <- char ':'
    m <- twoDigits
    _ <- char ':'
    s <- twoDigits
    _ <- char ','
    ms <- threeDigits
    let
        timeSum :: Pico
        timeSum =
            MkFixed . (* 1_000_000_000) . toInteger $
                ( h * 3600 * 1000
                    + m * 60 * 1000
                    + s * 1000
                    + ms
                )
    pure . Timestamp . secondsToNominalDiffTime $ timeSum
