module Cats.Category.Constructions.Equalizer where

open import Level

open import Cats.Category.Base
open import Cats.Util.Conv

import Cats.Category.Constructions.Mono as Mono
import Cats.Category.Constructions.Unique as Unique


module Build {lo la l≈} (Cat : Category lo la l≈) where

  private open module Cat = Category Cat
  open Cat.≈-Reasoning
  open Mono.Build Cat
  open Unique.Build Cat


  record IsEqualizer {A B} (f g : A ⇒ B) {E} (e : E ⇒ A)
    : Set (lo ⊔ la ⊔ l≈)
    where
    field
      equalizes : f ∘ e ≈ g ∘ e
      universal : ∀ {Z} (z : Z ⇒ A)
        → f ∘ z ≈ g ∘ z
        → ∃![ u ] (e ∘ u ≈ z)


  record Equalizer {A B} (f g : A ⇒ B) : Set (lo ⊔ la ⊔ l≈) where
    field
      {E} : Obj
      e : E ⇒ A
      isEqualizer : IsEqualizer f g e

    open IsEqualizer isEqualizer public


  instance
    HasObj-Equalizer : ∀ {A B} {f g : A ⇒ B}
      → HasObj (Equalizer f g) lo la l≈
    HasObj-Equalizer = record { Cat = Cat ; _ᴼ = Equalizer.E }


    HasArrow-Equalizer : ∀ {A B} {f g : A ⇒ B}
      → HasArrow (Equalizer f g) lo la l≈
    HasArrow-Equalizer = record { Cat = Cat ; _⃗ = Equalizer.e }


  equalizer→mono : ∀ {A B} {f g : A ⇒ B} {E} {e : E ⇒ A}
    → IsEqualizer f g e
    → IsMono e
  equalizer→mono {f = f} {g} {E} {e} eql {Z} {i} {j} e∘i≈e∘j
      = ∃!→≈ (universal (e ∘ j) lemma) e∘i≈e∘j ≈.refl
    where
      open IsEqualizer eql

      lemma : f ∘ e ∘ j ≈ g ∘ e ∘ j
      lemma
          = begin
              f ∘ e ∘ j
            ≈⟨ unassoc ⟩
              (f ∘ e) ∘ j
            ≈⟨ ∘-resp-l equalizes ⟩
              (g ∘ e) ∘ j
            ≈⟨ assoc ⟩
              g ∘ e ∘ j
            ∎
