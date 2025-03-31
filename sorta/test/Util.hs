module Util where

import Text.Trifecta hiding (parseTest)

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
