module Cats.Category.Slice where

open import Data.Product using (_,_ ; proj₁ ; proj₂)
open import Level
open import Relation.Binary using (IsEquivalence ; _Preserves₂_⟶_⟶_)

open import Cats.Category

module _ {lo la l≈} (C : Category lo la l≈) (X : Category.Obj C) where

  infixr 9 _∘_
  infixr 4 _≈_


  private
    module C = Category C
    module ≈ = C.≈


  record Obj : Set (lo ⊔ la) where
    constructor mkObj
    field
      {Dom} : C.Obj
      arr : Dom C.⇒ X

  open Obj


  record _⇒_ (f g : Obj) : Set (la ⊔ l≈) where
    field
      dom : Dom f C.⇒ Dom g
      commute : arr f C.≈ arr g C.∘ dom

  open _⇒_


  record _≈_ {A B} (F G : A ⇒ B) : Set l≈ where -- [1]
    constructor ≈-i
    field
      dom : dom F C.≈ dom G

  -- [1] This could also be defined as
  --
  --   F ≈ G = dom F C.≈ dom G
  --
  -- but Agda was then giving me very strange unsolved metas in _/_ below.


  id : ∀ {A} → A ⇒ A
  id = record { dom = C.id ; commute = ≈.sym C.id-r }


  _∘_ : ∀ {A B C} → (B ⇒ C) → (A ⇒ B) → (A ⇒ C)
  _∘_ {F} {G} {H}
    record { dom = F-dom ; commute = F-commute}
    record { dom = G-dom ; commute = G-commute}
      = record
      { dom = F-dom C.∘ G-dom
      ; commute
          = begin
              arr F
            ≈⟨ G-commute ⟩
              arr G C.∘ G-dom
            ≈⟨ C.∘-resp-l F-commute ⟩
              (arr H C.∘ F-dom) C.∘ G-dom
            ≈⟨ C.assoc ⟩
              arr H C.∘ F-dom C.∘ G-dom
            ∎
      }
    where
      open C.≈-Reasoning


  ≈-equiv : ∀ {A B} → IsEquivalence (_≈_ {A} {B})
  ≈-equiv = record
      { refl = ≈-i ≈.refl
      ; sym = λ { (≈-i eq) → ≈-i (≈.sym eq) }
      ; trans = λ { (≈-i eq₁) (≈-i eq₂) → ≈-i (≈.trans eq₁ eq₂) }
      }


  ∘-preserves-≈ : ∀ {A B C} → _∘_ {A} {B} {C} Preserves₂ _≈_ ⟶ _≈_ ⟶ _≈_
  ∘-preserves-≈ (≈-i eq₁) (≈-i eq₂) = ≈-i (C.∘-resp eq₁ eq₂)


  id-identity-r : ∀ {A B} {F : A ⇒ B} → F ∘ id ≈ F
  id-identity-r = ≈-i C.id-r

  id-identity-l : ∀ {A B} {F : A ⇒ B} → id ∘ F ≈ F
  id-identity-l = ≈-i C.id-l


  ∘-assoc : ∀ {A B C D} {F : C ⇒ D} {G : B ⇒ C} {H : A ⇒ B}
    → (F ∘ G) ∘ H ≈ F ∘ (G ∘ H)
  ∘-assoc = ≈-i C.assoc


  instance _/_ : Category (la ⊔ lo) (l≈ ⊔ la) l≈
  _/_ = record
      { Obj = Obj
      ; _⇒_ = _⇒_
      ; _≈_ = _≈_
      ; id = id
      ; _∘_ = _∘_
      ; equiv = ≈-equiv
      ; ∘-resp = ∘-preserves-≈
      ; id-r = id-identity-r
      ; id-l = id-identity-l
      ; assoc = ∘-assoc
      }


  open Category _/_ using (IsTerminal ; IsUnique ; ∃!-intro)


  One : Obj
  One = mkObj C.id


  One-Terminal : IsTerminal One
  One-Terminal Y@(mkObj f)
      = ∃!-intro F _ F-Unique
    where
      F : Y ⇒ One
      F = record { dom = f ; commute = C.≈.sym C.id-l }

      F-Unique : IsUnique F
      F-Unique {record { dom = g ; commute = commute }} _
          = ≈-i (≈.trans commute C.id-l)
