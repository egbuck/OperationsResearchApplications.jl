module OperationsResearchApplications

# export key functions
export search, run

"""
    OperationsResearchApplications

A collection of different applications (apps) of Operations Research (OR).

These apps are tagged by both the subject area of the application (ex: manufacturing, supply chain, etc.) and the model(s) that they employ (LP, MILP, Simulation, etc.)
"""

struct App
    title::String
    code_path::String
    documentation::String
end

include("search.jl")  # search for apps based on title, area tags, or model types

function run(app::App)
    include(app.code_path)
end

end