{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use <$>" #-}
module Parser where

import Data.Text (pack)
import Data.Time.Clock
import Text.Trifecta
import Types hiding (count)

parseSubtitle :: Parser Subtitle
parseSubtitle = do
    c <- parseCount
    -- _ <- token newline
    t <- parseTimeRange
    _ <- newline
    s <- manyTill anyChar (try (count 2 newline))
    pure $ Subtitle c t (pack s)

parseCount :: Parser Integer
parseCount = token decimal

parseTimeRange :: Parser SubTime
parseTimeRange = do
    b <- timestampParser
    _ <- string " --> "
    e <- timestampParser
    pure $ SubTime b e

-- Parse a two-digit number (e.g., "00" or "12")
twoDigits :: Parser Int
twoDigits = do
    -- Parse exactly two digits and convert to an Int
    digits <- count 2 digit
    pure (read digits :: Int)

-- Parse a three-digit number (e.g., "320")
threeDigits :: Parser Int
threeDigits = do
    digits <- count 3 digit
    pure (read digits :: Int)

-- Parse the full timestamp (e . g ., "00:00:00,320")
timestampParser :: Parser NominalDiffTime
timestampParser = do
    h <- twoDigits
    _ <- char ':'
    m <- twoDigits
    _ <- char ':'
    s <- twoDigits
    _ <- char ','
    _ <- threeDigits -- fixme
    let timeSum = h * 3600 + m * 60 + s -- + ms / 1000
    pure . fromIntegral $ timeSum
