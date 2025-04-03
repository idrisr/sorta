{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module Types where

import Data.Fixed
import Data.Text
import Data.Time (FormatTime)
import Data.Time.Clock
import Fmt
import Fmt.Internal.Core
import Test.QuickCheck
import Test.QuickCheck.Instances.Num
import Test.QuickCheck.Instances.Text ()
import Test.QuickCheck.Instances.Time ()
import Prelude hiding (all, concat, last, map, null)

data Subtitle = Subtitle
    { count :: Integer
    , timeRange :: Timerange
    , subtitle :: Text
    }
    deriving (Eq, Show)

newtype Timestamp = Timestamp NominalDiffTime
    deriving (Eq, Num, FormatTime, Ord, Show)

data Timerange = Timerange
    { begin :: Timestamp
    , end :: Timestamp
    }
    deriving (Eq, Show)

-- 00:00:00,310 --> 00:00:00,320
instance Buildable Timerange where
    build (Timerange b e) =
        formatTime b
            |+ " --> "
            +| formatTime e
            |+ "\n"

instance Buildable Subtitle where
    build (Subtitle c t s) =
        c
            |+ "\n"
            +| build t
            +| s
            |+ "\n\n"

-- Function to filter consecutive newlines from Text
filterConsecutiveNewlines :: Text -> Text
filterConsecutiveNewlines t = concat . Prelude.filter g $ ts
  where
    ts = groupBy (\a b -> a == '\n' && b == '\n') t
    g = not . all (== '\n')

-- Define a custom generator that filters out Text values ending with a newline
genTextWithoutNewline :: Gen Text
genTextWithoutNewline = do
    txt <- filterConsecutiveNewlines <$> arbitrary @Text
    pure . strip . Data.Text.filter (/= '\CR') $ txt

instance Arbitrary Timestamp where
    arbitrary =
        Timestamp . secondsToNominalDiffTime . MkFixed
            <$> ((* 1_000_000_000) <$> positive @Integer)

-- not a huge fan of this.
formatTime :: (FormatTime a) => a -> Text
formatTime s = map f $ fromBuilder . timeF "%02H:%02M:%03ES" $ s
  where
    f c = if c == '.' then ',' else c

instance Arbitrary Timerange where
    arbitrary = Timerange <$> arbitrary <*> arbitrary

instance Arbitrary Subtitle where
    arbitrary =
        Subtitle
            <$> positive
            <*> arbitrary
            <*> genTextWithoutNewline
