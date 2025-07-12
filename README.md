# MutableScopedValues

[![Build Status](https://github.com/disberd/MutableScopedValues.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/disberd/MutableScopedValues.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/disberd/MutableScopedValues.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/disberd/MutableScopedValues.jl)

This package introduces the `MutableScopedValue` type which combines a `RefValue` and a `ScopedValue`. It aims to have the basic functionality of a `ScopedValue` but allow to also change it's value persistently outside of `ScopedValues.with` blocks.

It also defines a custom `with` method to allow mixing `ScopedValue`s and `MutableScopedValue`s within the same `with` call

This repo was initially named `ScopedRefValues` but was modified after the feeedback in https://discourse.julialang.org/t/change-scopedvalue-default-outside-of-with/130631

# Examples
```julia
julia> using MutableScopedValues

julia> sv = MutableScopedValue{Float64}(3.0);

julia> sv[]
3.0

julia> sv[] = 5
5

julia> sv[]
5.0

julia> with(() -> sv[], sv => 1.0) # Setting with `with` has precedence over `setindex!`
1.0
```

See the docstring for more details