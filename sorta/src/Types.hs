{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE OverloadedStrings #-}

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
import Prelude hiding (map)

data Subtitle = Subtitle
    { count :: Integer
    , timeRange :: SubTime
    , subtitle :: Text
    }
    deriving (Eq)

newtype Timestamp = Timestamp NominalDiffTime
    deriving (Eq, Num, FormatTime, Ord, Show)

data SubTime = SubTime
    { begin :: Timestamp
    , end :: Timestamp
    }
    deriving (Eq)

-- 00:00:00,310 --> 00:00:00,320

instance Buildable SubTime where
    build (SubTime b e) =
        formatTime b
            |+ " --> "
            +| formatTime e
            |+ "\n"

instance Show Subtitle where
    show = fmt . build

instance Show SubTime where
    show = fmt . build

instance Buildable Subtitle where
    build (Subtitle c t s) =
        c
            |+ "\n"
            +| build t
            +| s
            |+ "\n"

instance Arbitrary Timestamp where
    arbitrary = Timestamp . secondsToNominalDiffTime . MkFixed <$> ((* 1_000_000_000) <$> positive :: Gen Integer)

-- not a huge fan of this.
formatTime :: (FormatTime a) => a -> Text
formatTime s = map f $ fromBuilder . timeF "%02H:%02M:%03ES" $ s
  where
    f c = if c == '.' then ',' else c

instance Arbitrary SubTime where
    arbitrary = do
        let s = Timestamp . secondsToNominalDiffTime <$> positive
        let e = Timestamp . secondsToNominalDiffTime <$> positive
        SubTime <$> s <*> ((+) <$> s <*> e)

instance Arbitrary Subtitle where
    arbitrary =
        Subtitle
            <$> positive
            <*> arbitrary
            <*> arbitrary
