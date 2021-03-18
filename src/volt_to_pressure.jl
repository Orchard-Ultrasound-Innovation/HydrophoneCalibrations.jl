using Interpolations

include("calibration/data.jl")

MHz_to_Hz(Hz) = Hz * 1_000_000

interp(x, v, f0) = LinearInterpolation(x, v)(f0)
"""
    volt_to_pressure(15e6; hydrophone_id = :Onda_HGL0200_2322, preamp_id = :Onda_AH2020_1238_20dB)
    volt_to_pressure(15e6; hydrophone_id = :PA_3197)

# Arguments
- `f0`: Frequency in Hz.
- `hydrophone_id`: Currently accepts two: :Onda_HGL0200_2322, :PA_3197.
- `preamp_id`: Only for :Onda_HGL0200_2322. Choices are: :Onda_AH2020_1238_0dB, :Onda_AH2020_1238_20dB.
# Returns
- `factor`: conversion factor in form of pascal/volt.
"""
function volt_to_pressure(
    f0; hydrophone_id::Symbol = hydrophone_id
)
    calibration_data, preamp_data = get_calibration(
        hydrophone_id
    )

    @assert isempty(preamp_data)


    hydro_freq = MHz_to_Hz(calibration_data[:, 1])
    hydro_sens_dB = calibration_data[:, 2]

    hydro_sens_at_f0_dB = interp(hydro_freq, hydro_sens_dB, f0)

    return convert_sens_to_factor(hydro_sens_at_f0_dB)
end

function volt_to_pressure(
    f0; hydrophone_id::Symbol = hydrophone_id; preamp_id::Symbol = preamp_id
)
    factor, _ = volt_to_pressure_and_phase(
       f0; hydrophone_id = hydrophone_id, preamp_id = preamp_id
    )
    return factor
end

function volt_to_pressure_and_phase(
    f0; hydrophone_id::Symbol = hydrophone_id; preamp_id::Symbol = preamp_id
)

    calibration_data, preamp_data = get_calibration(
        hydrophone_id, preamp_id
    )

    @assert !isempty(preamp_data)

    hydro_freq = MHz_to_Hz(calibration_data[:, 1])
    hydro_sens_dB = calibration_data[:, 2]
    hydro_sens_at_f0_dB = interp(hydro_freq, hydro_sens_dB, f0)


    preamp_freq = MHz_to_Hz(preamp_data[:,1])
    preamp_gain_dB = preamp_data[:, 2]
    preamp_phase = preamp_data[:, 3]
    preamp_cap = preamp_data[:, 4]

    hydro_cap = calibration_data[:, 5]

    amp_gain_f0_dB = interp(preamp_freq, preamp_gain_dB, f0)
    amp_cap_at_f0 = interp(preamp_freq, preamp_cap, f0)
    hydro_cap_at_f0 = interp(hydro_freq, hydro_cap, f0)

    # Voltage division
    volt_div = hydro_cap_at_f0 ./ (hydro_cap_at_f0 + amp_cap_at_f0)
    volt_div_dB = 20*log10(volt_div)

    # Combine result
    combined_sens_dB = hydro_sens_at_f0_dB + amp_gain_f0_dB + volt_div_dB 
    return convert_sens_to_factor(combined_sens_dB), preamp_phase
end

function convert_sens_to_factor(sensitivity_dB)
    sensitivity_linear = 10 .^ ((1.0 * sensitivity_dB+120)/20.0)
    factor = 1 ./ sensitivity_linear
    return factor
end
