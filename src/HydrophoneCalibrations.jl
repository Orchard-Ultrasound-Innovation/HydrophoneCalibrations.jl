module HydrophoneCalibrations

export volt_to_pressure, volt_to_pressure_and_phase, calibration
export parse_onda

macro calibration(a, b)
   @eval begin
       """
       `$($a)`
       """
       calibration(::Val{$a}) = $b
   end
end

calibration(::Val{:empty}) = []

function __init__()
    if isdir("calibration")
        include("calibration/config.jl")
    elseif isdir("../calibration")
        include("../calibration/config.jl")
    else
        @info "No calibration folder found"
    end
end

function get_calibration(hydro_id, preamp_id = :empty)
    return calibration(Val(hydro_id)), calibration(Val(preamp_id))
end

include("volt_to_pressure.jl")

"""
    parse_onda("name-of-calibration-file.txt")

Translates calibration text files from Onda
into the format required by this package.
"""
function parse_onda(name)
    file = readlines(name)
    info = Dict()
    count = 0

    function found(s, i) 
        return occursin(s, i) && !occursin("NONE", i) 
    end

    function keep(s, i) 
        if found(s, i)
            row = split(i)
            if length(row) == 2
                info[s] = row[2]
            else
                info[s] = row
            end
        end
    end

    for i in file
        count += 1
        keep("MFG", i)
        keep("MODEL", i)
        keep("SN", i)
        if occursin("HEADER_END", i)
            break
        end
    end

    info["DATA"] = file[count + 1:end]
    device = "$(info["MFG"])_$(info["MODEL"])_$(info["SN"])"
    device = replace(device, "-"=>"_")
    open("$device.jl", "w") do io
       println(io, "@calibration :$device [")
       for i in info["DATA"]
           println(io, i)
       end
       println(io, "]")
    end
end

end
