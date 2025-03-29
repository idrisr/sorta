module Types where

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
    { count :: Int
    , timeRange :: SRTTime
    , subtitle :: Text
    }

data SRTTime = SRTTime
    { begin :: NominalDiffTime
    , end :: NominalDiffTime
    }

-- 00:00:00,310 --> 00:00:00,320

instance Buildable SRTTime where
    build (SRTTime b e) =
        formatTime b
            |+ " --> "
            +| formatTime e
            |+ "\n"

instance Show Subtitle where
    show = fmt . build

instance Buildable Subtitle where
    build (Subtitle c t s) =
        c
            |+ "\n"
            +| build t
            +| s
            |+ "\n"

-- not a huge fan of this.
formatTime :: (FormatTime a) => a -> Text
formatTime s = map f $ fromBuilder . timeF "%02H:%02M:%03Es" $ s
  where
    f c = if c == '.' then ',' else c

instance Arbitrary SRTTime where
    arbitrary = do
        let s = secondsToNominalDiffTime <$> positive
        let e = secondsToNominalDiffTime <$> positive
        SRTTime <$> s <*> ((+) <$> s <*> e)

instance Arbitrary Subtitle where
    arbitrary =
        Subtitle
            <$> positive
            <*> arbitrary
            <*> arbitrary
