module Cats.Category.One where

open import Data.Unit using (⊤ ; tt)

open import Cats.Category


One : Category _ _ _
One = record
    { Obj = ⊤
    ; _⇒_ = λ _ _ → ⊤
    ; _≈_ = λ _ _ → ⊤
    ; id = tt
    ; _∘_ = λ _ _ → tt
    ; ≈-equiv
        = record
        { refl = tt
        ; sym = λ _ → tt
        ; trans = λ _ _ → tt
        }
    ; ∘-preserves-≈ = λ _ _ → tt
    ; id-identity-r = tt
    ; id-identity-l = tt
    ; ∘-assoc = λ _ _ _ → tt
    }