"""
    search_ora(category::String="")
    search_ora(title::String)

Searches for apps that are under the category.
    This will provide the titles of the apps (FUTURE: as well as links to the documentation/example problems).
    If category="" (default), then it lists all of the categories instead

## Examples

The following lists all apps under the category "production process"
```julia
matches = search_ora("production process")
```
"""
function search_ora(category::String = "")::Vector{String}
    pkg_path = dirname(@__FILE__)
    if category == ""
        my_list = [titlecase(replace(x, "_" => " ")) 
            for x in readdir(pkg_path) if isdir(pkg_path * "/" * x)]
        return my_list # list all folders
    end
    directory = lowercase(replace(category, " " => "_"))
    try
        return [titlecase(replace(x, "_" => " ")) for x in readdir(pkg_path * "\\" * directory)]
    catch e
        if isa(e, SystemError)
            throw(ArgumentError("Category $(directory[1:(end-1)]) does not exist!"))
                #"pkg_path: $(pkg_path).\n" *  
                #"files: $(readdir(pkg_path * "/" * directory))\n" * 
                #"Try search_apps() to list all categories."
        #else
        #    throw(e)
        end
    end
end