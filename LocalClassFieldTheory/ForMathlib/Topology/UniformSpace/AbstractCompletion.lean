import Topology.UniformSpace.AbstractCompletion

#align_import for_mathlib.topology.uniform_space.abstract_completion

/-! 
# Abstract completion
Let `f : α → β` be a continuous function between a uniform space `α` and a regular topological 
space `β`, and let `pkg, pkg'` be two abstract completions of `α`. The main result is that 
if for every point `a : pkg` the filter `f.map (coe⁻¹ (𝓝 a))` obtained by pushing forward with `f`
the preimage in `α` of `𝓝 a` tends to `𝓝 (f.extend a : β)`, then the comparison map
between `pkg` and `pkg'` composed with the extension of `f` to `pkg`` coincides with the
extension of `f` to `pkg'` -/


namespace AbstractCompletion

open scoped Topology

variable {α β : Type _} [UniformSpace α] [TopologicalSpace β]

variable (pkg : AbstractCompletion α) (pkg' : AbstractCompletion α)

/-- The topological space underlying a uniform space -/
def topPkg : TopologicalSpace pkg.Space :=
  pkg.uniformStruct.toTopologicalSpace

attribute [local instance] top_pkg

theorem extend_compare_extend [T3Space β] (f : α → β) (cont_f : Continuous f)
    (hf :
      ∀ a : pkg.Space,
        Filter.Tendsto f (Filter.comap pkg.coe (𝓝 a)) (𝓝 ((pkg.DenseInducing.extend f) a))) :
    pkg.DenseInducing.extend f ∘ pkg'.compare pkg = pkg'.DenseInducing.extend f :=
  by
  have : ∀ x : α, (pkg.dense_inducing.extend f ∘ pkg'.compare pkg) (pkg'.coe x) = f x :=
    by
    intro a
    rw [Function.comp_apply, compare_coe]
    apply DenseInducing.extend_eq _ cont_f
  refine' (DenseInducing.extend_unique (AbstractCompletion.denseInducing _) this _).symm
  letI := pkg'.uniform_struct
  letI := pkg.uniform_struct
  refine' Continuous.comp _ (uniform_continuous_compare pkg' pkg).Continuous
  apply DenseInducing.continuous_extend
  use fun a => ⟨(pkg.dense_inducing.extend f) a, hf a⟩

end AbstractCompletion

