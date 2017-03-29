module Data.Finance.Money
  ( Discrete(..)
  , showDiscrete
  ) where

import Data.Finance.Currency (kind Currency, class Currency, CProxy(..), decimals)
import Data.Generic (class Generic, gShow)
import Data.Module (class LeftModule, class RightModule)
import Data.Newtype (class Newtype)
import Prelude

-- | An amount of money in the smallest discrete unit of a particular currency.
-- | For example, `wrap 256 :: Discrete GBP` would represent £2.56, whereas
-- | `wrap 256 :: Discrete JPY` would represent ¥256. If you want to work with
-- | higher granularity, you can define your own currency type.
newtype Discrete (c :: Currency) = Discrete Int
derive newtype instance eqDiscrete  :: Eq (Discrete c)
derive newtype instance ordDiscrete :: Ord (Discrete c)
derive instance genericDiscrete     :: Generic (Discrete c)
derive instance newtypeDiscrete     :: Newtype (Discrete c) _
instance showDiscreteInstance :: Show (Discrete c) where show = gShow

instance leftModuleDiscrete :: LeftModule (Discrete c) Int where
  mzeroL = Discrete 0
  maddL (Discrete a) (Discrete b) = Discrete (a + b)
  msubL (Discrete a) (Discrete b) = Discrete (a - b)
  mmulL a            (Discrete b) = Discrete (a * b)

instance rightModuleDiscrete :: RightModule (Discrete c) Int where
  mzeroR = Discrete 0
  maddR (Discrete a) (Discrete b) = Discrete (a + b)
  msubR (Discrete a) (Discrete b) = Discrete (a - b)
  mmulR (Discrete a) b            = Discrete (a * b)

showDiscrete :: ∀ c. (Currency c) => Discrete c -> String
showDiscrete (Discrete n) = showDiscrete' n (decimals (CProxy :: CProxy c))

foreign import showDiscrete' :: Int -> Int -> String
