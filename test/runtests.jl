using TestItemRunner

@testitem "MutableScopedValue" begin
    using ScopedValues: ScopedValues, ScopedValue

    # Test constructors
    @test MutableScopedValue{Float64}() isa MutableScopedValue{Float64}
    @test MutableScopedValue{Float64}(3.0) isa MutableScopedValue{Float64}
    @test MutableScopedValue(3.0) isa MutableScopedValue{Float64}

    # Test isassigned 
    @test !isassigned(MutableScopedValue{Function}())

    sv = MutableScopedValue{Float64}(3.0)

    @test sv[] == 3

    sv[] = 15
    @test sv[] == 15

    ScopedValues.with(sv => 1.0) do
        @test sv[] === 1.0
    end
    MutableScopedValues.with(sv => 1.0) do
        @test sv[] === 1.0
    end

    sc = ScopedValue{Float64}(4.0)
    MutableScopedValues.with(sc => 1.0, sv => 2.0) do
        @test sc[] === 1.0
        @test sv[] === 2.0
    end
end

@testitem "DocTests" begin
    using Documenter
    Documenter.doctest(MutableScopedValues; manual = false)
end

@run_package_tests verbose = true