include("onda/preamp/get_calibration_AH2020_1238_0dB.jl")
include("onda/preamp/get_calibration_AH2020_1238_20dB.jl")
include("onda/hydrophone/get_calibration_HGL0200_2322.jl")

include("precision_acoustics/get_calibration_PA_3197.jl")

function get_calibration(hydro_id, preamp_id)
    if hydro_id == :PA_3197
        return get_calibration_PA_3197(), []
    elseif hydro_id == :Onda_HGL0200_2322
        return get_calibration_HGL0200_2322(), get_preamp_data(preamp_id)
    end
    error("Unknown id: $hydro_id")
end


function combine_gains()
    uniqueindex(arr) = unique(i -> arr[i], 1:length(arr))

    preamp1 = [] #get_preamp_lower_gain()
    preamp2 = [] #get_preamp_upper_gain()

    preamp_tot = [preamp1; preamp2]
    sort!(preamp_tot; dims=1)
    uniq_idx = uniqueindex(preamp_tot[:,1])
    preamp_data = preamp_tot[uniq_idx, :]

    return preamp_data
end

function get_preamp_data(preamp_id)
    if preamp_id == :Onda_AH2020_1238_0dB
        get_calibration_AH2020_1238_0dB()
    elseif preamp_id == :Onda_AH2020_1238_20dB
        get_calibration_AH2020_1238_20dB()
    else
        error("Not found: $preamp_id")
    end
end
