using Events
using Test

@testset "simple" begin
    x = 42
    ee = Emitter()
    off1! = on!(ee, :inc) do v
        x += v
    end
    off2! = on!(ee, :inc) do v
        x += v
    end
    @test x == 42
    emit(ee, :inc, 1)
    @test x == 42 + 2
    off2!()
    emit(ee, :inc, 1)
    @test x == 42 + 3
end

@testset "mixed types" begin
    x = 0
    ee = Emitter()
    f(v::Int) = x += v
    f(v::AbstractString) = x += parse(Int, v)
    on!(f, ee, :inc)
    emit(ee, :inc, 1)
    emit(ee, :inc, "1")
    @test x == 2
end
