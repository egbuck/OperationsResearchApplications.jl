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
end

"""
    search(area_tags::Array{String}, model_tags::Array{String})

Searches for apps that have both the area_tag(s) and the model_tag(s).
    This will provide the title of the app(s) (FUTURE: as well as links to the documentation/example problems).

## Examples

The following searches for an app applied to manufacturing, and is a MILP model
    matches = search(["Manufacting"], ["MILP"]) # not in julia prompt since not implemented
"""
function search(title::String, area_tags::Array{String}, model_tags::Array{String})::Array{String}
    return Array{String}
end

function run(app::App)
    include(app.code_path)
end

end