module Cats.Category.Setoids.Facts where


open import Cats.Category
open import Cats.Category.Setoids using (Setoids)
open import Cats.Category.Setoids.Facts.Exponentials using (hasExponentials)
open import Cats.Category.Setoids.Facts.Initial using (hasInitial)
open import Cats.Category.Setoids.Facts.Products
  using (hasProducts ; hasBinaryProducts)
open import Cats.Category.Setoids.Facts.Terminal using (hasTerminal)


instance
  isCCC : ∀ l → IsCCC (Setoids l l)
  isCCC l = record { hasFiniteProducts = record {} } -- [1]

-- [1] For no discernible reason, `record {}` doesn't work.
