# TODO: Remove 
using Dierckx
using Interpolations

include("calibration/data.jl")
"""
# Arguments
- `f0`: Frequency. 1-20MHz supported
- `hydrophone_id`: Currently accepts three: HGL0200_1364, HGL0200_1656, and HNR0500_1663
# Returns
- `factor`: conversion factor in form Pressure/Volt 
`# TODO: Optional outputs`
- `phase_out`: 
- `preamp_gain_out`
- `hydro_sense_out`
"""
function volt_to_pressure(f0, hydrophone_id=:HGL0200_1364)
    calibration_data = get_calibration(hydrophone_id)
    no_preamp_used = hydrophone_id == :HNR0500_1663

    # TODO: Change to hydro_cal_f
    data_f = calibration_data[:, 1] * 1e6
    data_sens_dB = calibration_data[:, 2]

    if no_preamp_used
        sensitivity_at_f0_dB = LinearInterpolation(data_d, data_sens_dB, f0)
        sensitivity_at_f0_dB2 = Spline1D(data_d, data_sens_dB, f0)
        sensitivity = 10.^((sensitivity_at_f0_dB+120)/20)
        factor = 1./sensitivity
        return factor
    else
        preamp1 = get_preamp_lower_gain()
        preamp2 = get_preamp_upper_gain()

        preamp_tot = [preamp1; preamp2]
        _, uniq_idx = unique(preamp_tot[:,1])
        preamp_data = preamp_tot[unq_idx, :]

        preamp_f = preamp_data[:,1] * 1e6
        preamp_gain_dB = preamp_data[:, 2]
        preamp_phase = preamp_data[:, 3]
        preamp_c = preamp_data[:, 4]

        data_c = calibration_data[:, 5]
        amp_gain_f0_dB = LinearInterpolation(preamp_f, preamp_gain_dB, f0)
        amp_c = LinearInterpolation(preamp_f, preamp_c, f0)
        hydro_c = LinearInterpolation(data_f, data_sens_dB, f0)

        # Voltage division
        volt_div = hydro_c ./ (hydro_c + amp_c)
        volt_div_dB = 20*log10(volt_div)

        # Combine result
    end


end
