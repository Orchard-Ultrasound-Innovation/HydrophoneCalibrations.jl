include("get_preamp_lower_gain.jl")
include("get_preamp_upper_gain.jl")
include("get_calibration_HGL0200_1364.jl")
include("get_calibration_HGL0200_1656.jl")
include("get_calibration_HNR0500_1663.jl")


function get_calibration(hydro_id)
    if hydro_id == :HGL0200_1364
        get_calibration_HGL0200_1364()
    elseif hydro_id == :HGL0200_1656
        get_calibration_HGL0200_1656()
    elseif hydro_id == :HNR0500_1663
        get_calibration_HNR0500_1663()
    else
        error("Unknown id: $hydro_id")
    end
end
