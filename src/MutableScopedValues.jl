module MutableScopedValues

using ScopedValues: ScopedValues, ScopedValue

export MutableScopedValue, with

"""
    MutableScopedValue{T}()
    MutableScopedValue{T}(x)
    MutableScopedValue(x)

Structure that aims to have the basic functionality of a `ScopedValue` but allow to also change it's value persistently outside of `ScopedValues.with` blocks.

!!! note
    If one wants to mix `MutableScopedValue` and `ScopedValue` instances in the same call to `with`, the custom `MutableScopedValues.with` function must be used, otherwise `MutableScopedValue` also work with the `ScopedValues.with` function as a normal `ScopedValue`.

# Examples
```jldoctest
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
"""
struct MutableScopedValue{T}
    scoped::ScopedValue{Base.RefValue{T}}
    MutableScopedValue{T}(x::ScopedValue{Base.RefValue{T}}) where T = new{T}(x)
end

MutableScopedValue{T}() where T = MutableScopedValue{T}(ScopedValue(Ref{T}()))
MutableScopedValue{T}(x) where T = MutableScopedValue{T}(ScopedValue(Ref{T}(x)))
MutableScopedValue(x) = MutableScopedValue{typeof(x)}(x)

Base.setindex!(sv::MutableScopedValue, x) = return sv.scoped[][] = x

Base.getindex(sv::MutableScopedValue) = sv.scoped[][]

Base.isassigned(sv::MutableScopedValue) = isassigned(sv.scoped[])

"""
    with(f, pairs::Pair{<:Union{MutableScopedValue, ScopedValue}}...)

This is functionally equivalent to `ScopedValues.with` but we have a custom implementation to support mixed pairs with both `MutableScopedValue` and `ScopedValue` as first element without committing type piracy.

See also: [`ScopedValues.with`](@ref), [`MutableScopedValue`](@ref)
"""
function with(f, pairs::Pair{<:Union{MutableScopedValue, ScopedValue}}...)
    pairs = map(process_pair, pairs)
    ScopedValues.with(f, pairs...)
end
# We also add a method just for MutableScopedValue to ScopedValues.with
function ScopedValues.with(f, pair::Pair{<:MutableScopedValue}, rest::Pair{<:MutableScopedValue}...)
    pairs = map(process_pair, (pair, rest...))
    ScopedValues.with(f, pairs...)
end

# This is a function to process the pairs with MutableScopedValue for forwarding to ScopedValues.with
function process_pair(pair::Pair{MutableScopedValue{T}}) where T
    sv, val = pair
    ref = if val isa Base.RefValue{T}
        val
    else
        Ref{T}(val)
    end
    sv.scoped => ref
end
process_pair(pair) = pair

end # module
