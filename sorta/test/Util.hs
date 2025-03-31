module Util where

import Data.Fixed
import Data.Time.Clock
import Text.Trifecta hiding (parseTest)
import Types

parseTest :: Parser a -> String -> Either String a
parseTest parser s =
    let res = parseString parser mempty s
     in case res of
            Success a -> Right a
            Failure e -> Left . show $ e

propPrintParse :: (Eq a, Show a) => Parser a -> (a -> String) -> a -> Bool
propPrintParse parser f a =
    let res = parseString parser mempty (f a)
     in case res of
            Success a' -> a == a'
            Failure _ -> False

mkTimestamp :: Pico -> Pico -> Pico -> Pico -> Timestamp
mkTimestamp h m s ms = Timestamp . secondsToNominalDiffTime $ t
  where
    t :: Pico
    t = h * 3600 + m * 60 + s + ms / 1000
