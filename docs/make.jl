using HydrophoneCalibrations
using Documenter

DocMeta.setdocmeta!(HydrophoneCalibrations, :DocTestSetup, :(using HydrophoneCalibrations); recursive=true)

makedocs(;
    modules=[HydrophoneCalibrations],
    authors="Morten F. Rasmussen <10264458+mofii@users.noreply.github.com> and contributors",
    repo="https://github.com/mofii/HydrophoneCalibrations.jl/blob/{commit}{path}#{line}",
    sitename="HydrophoneCalibrations.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mofii.github.io/HydrophoneCalibrations.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mofii/HydrophoneCalibrations.jl",
)
