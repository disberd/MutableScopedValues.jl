using TestItemRunner

@testitem "ScopedRefValue" begin
    using ScopedValues: ScopedValues, ScopedValue

    # Test constructors
    @test ScopedRefValue{Float64}() isa ScopedRefValue{Float64}
    @test ScopedRefValue{Float64}(3.0) isa ScopedRefValue{Float64}

    # Test isassigned 
    @test !isassigned(ScopedRefValue{Function}())

    sv = ScopedRefValue{Float64}(3.0)

    @test sv[] == 3

    sv[] = 15
    @test sv[] == 15

    ScopedValues.with(sv => 1.0) do
        @test sv[] === 1.0
    end
    ScopedRefValues.with(sv => 1.0) do
        @test sv[] === 1.0
    end

    sc = ScopedValue{Float64}(4.0)
    ScopedRefValues.with(sc => 1.0, sv => 2.0) do
        @test sc[] === 1.0
        @test sv[] === 2.0
    end
end

@run_package_tests verbose = true