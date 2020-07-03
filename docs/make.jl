using OperationsResearchApplications
using Documenter

makedocs(;
    modules=[OperationsResearchApplications],
    authors="Ethan Buck",
    repo="https://github.com/egbuck/OperationsResearchApplications.jl/blob/{commit}{path}#L{line}",
    sitename="OperationsResearchApplications.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://egbuck.github.io/OperationsResearchApplications.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/egbuck/OperationsResearchApplications.jl",
)
