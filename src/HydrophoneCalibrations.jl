module HydrophoneCalibrations

export volt_to_pressure, volt_to_pressure_and_phase, calibration

calibration(::Val{:empty}) = []

function __init__()
    if isdir("calibration")
        include("calibration/config.jl")
    end
end

function get_calibration(hydro_id, preamp_id = :empty)
    return calibration(Val(hydro_id)), calibration(Val(preamp_id))
end

include("volt_to_pressure.jl")

end
