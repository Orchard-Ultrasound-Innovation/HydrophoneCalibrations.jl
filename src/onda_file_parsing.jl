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
