"""
    search(area_tags::Array{String}, model_tags::Array{String})
    search(title::String)

Searches for apps that have both the area_tag(s) and the model_tag(s).
    This will provide the title of the app(s) (FUTURE: as well as links to the documentation/example problems).
Search for app with title, and then return that app

## Examples

The following searches for an app applied to manufacturing, and is a MILP model
    matches = search(["Manufacting"], ["MILP"]) # not in julia prompt since not implemented
"""
function search(area_tags::Vector{String}, model_tags::Vector{String})::Array{String}
    return Array{String}
end

function search(title::String)::App
    return App(title, 
        title * "/" * title * ".jl", 
        title * "/" * title * ".md")
end