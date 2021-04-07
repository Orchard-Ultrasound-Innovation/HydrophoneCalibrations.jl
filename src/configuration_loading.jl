macro calibration(a, b)
    @eval begin
        """
        `$($a)`
        """
        calibration(::Val{$a}) = $b
    end
 end

 calibration(::Val{:empty}) = []

function load_config()
    if !data_loaded[]
        @info pwd()
        absolute_include(file) = include(joinpath(pwd(), file))

        if isfile("calibration/config.jl")
            absolute_include("calibration/config.jl")
        elseif isfile("../calibration/config.jl")
            absolute_include("../calibration/config.jl")
        else
            @info "No calibration folder found"
        end
        data_loaded[] = true
    end
end



function get_calibration(hydro_id, preamp_id = :empty)
    load_config()
    call_calibration(s) = Base.invokelatest(calibration, Val(s))
    return call_calibration(hydro_id), call_calibration(preamp_id)
end
