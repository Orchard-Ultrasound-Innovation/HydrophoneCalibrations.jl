using HydrophoneCalibrations
using HydrophoneCalibrations.Unitful
using Test

@testset "HydrophoneCalibrations.jl" begin
    ans1 = volt_to_pressure(1e6, :Onda_HGL0200_2322, :Onda_AH2020_1238_20dB)
    @test isapprox(ans1, 4.199097064139323e6u"Pa/V")

    ans2 = volt_to_pressure(1e6, :PA_3197)
    @test isapprox(ans2, 1.995262314968879e-8u"Pa/V")
end

