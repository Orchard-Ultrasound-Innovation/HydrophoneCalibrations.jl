module HydrophoneCalibrations

using Interpolations
using Unitful


export volt_to_pressure, volt_to_pressure_and_phase, calibration
export parse_onda

const data_loaded = Ref{Bool}()

include("configuration_loading.jl")
include("volt_to_pressure.jl")
include("onda_file_parsing.jl")

end
