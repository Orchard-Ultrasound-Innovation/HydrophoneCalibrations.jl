# HydrophoneCalibrations

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://mofii.github.io/HydrophoneCalibrations.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://mofii.github.io/HydrophoneCalibrations.jl/dev)
[![Build Status](https://github.com/mofii/HydrophoneCalibrations.jl/workflows/CI/badge.svg)](https://github.com/mofii/HydrophoneCalibrations.jl/actions)
[![Build Status](https://travis-ci.com/mofii/HydrophoneCalibrations.jl.svg?branch=master)](https://travis-ci.com/mofii/HydrophoneCalibrations.jl)
[![Coverage](https://codecov.io/gh/mofii/HydrophoneCalibrations.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/mofii/HydrophoneCalibrations.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

# Installation
HydrophoneCalibrations can be installed using the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run

```julia
pkg> add HydrophoneCalibrations
```

# Using this library
This library 

```julia
using HydrophoneCalibrations
# Separate Hydrophone and Preamplifier
volt_to_pressure_and_phase(1e6, :Onda_HGL0200_2322, :Onda_AH2020_1238_20dB)

# Hydrophone and Preamplifier are single unit
volt_to_pressure_and_phase(1e6, :PA_3197)
```
# Loading your configuration data
By default this package looks in "./calibration/config.jl" for your
hydrophone and preamplifier calibration data.

To add your calibration data create functions in the following style:

```julia
"""
`MyHydrophone`
"""
function calibration(::Val{:MyHydrophone})
    return [
        { Your data goes here }
    ]
end

"""
`MyPreamplifier`
"""
function calibration(::Val{:MyPreamplifier})
    return [
        { Your data goes here }
    ]
end
```

Now :MyHydrophone and :MyPreamplifier are available in the code and you
should be able to use them:
```julia
using HydrophoneCalibrations
# Separate Hydrophone and Preamplifier
volt_to_pressure_and_phase(1e6, :MyHydrophone, :MyPreamplifier)
```

To make sure your device is loaded you can run:
```julia
julia>using HydrophoneCalibrations
help>calibration

  MyHydrophone

  ────────────────────────────────────────────────────────────────────────────────

  MyPreamplifier
```


See the calibration folder in this repo for an example of how to structure your calibration data when you have multiple devices.

