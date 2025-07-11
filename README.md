# ScopedRefValues

[![Build Status](https://github.com/disberd/ScopedRefValues.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/disberd/ScopedRefValues.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/disberd/ScopedRefValues.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/disberd/ScopedRefValues.jl)

This package introduces the `ScopedRefValue` type which combines a `RefValue` and a `ScopedValue`. It aims to have the basic functionality of a `ScopedValue` but allow to also change it's value persistently outside of `ScopedValues.with` blocks.

It also defines a custom `with` method to allow mixing `ScopedValue`s and `ScopedRefValue`s within the same `with` call

# Examples
```julia
julia> using ScopedRefValues

julia> sv = ScopedRefValue{Float64}(3.0);

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