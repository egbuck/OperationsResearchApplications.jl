using JuMP;           # Julia Mathematical Programming
using Cbc;            # Free Solver
import JSON;          # To Read In Model Parameters
using DataFrames;     # process_prods.csv
using CSV;            # process_prods.csv

"""
Model Formulation:
    Max sell_price ∙ Sell - convert_cost ∙ Convert - (raw_mat_cost + raw_process_cost) * RawPurchase
    s.t.
        convert_time ∙ Convert + raw_process_time * RawPurchase ≤ max_time
        raw_yield[p] * RawPurchase = Produce[p] ∀p∈products
        Sell[p] ≤ max_demand[p] ∀p∈products
        ∑{pair[2]=p}(Convert[pair]) + Produce[p] = Sell[p] + ∑{pair[1]=p}(Convert[pair]) ∀p∈products
        All Dec. Vars. ≥ 0 and Integer
"""
function model_prod(params::Dict, process_df::DataFrame)
    # Model object
    lpModel = Model(optimizer_with_attributes(Cbc.Optimizer, "seconds"=>3600))

    # Define Groups
    pairs = [x for x in process_df[:, "FromTo"]]
    products = params["Product Names"]
    # Decision Variables
    @variables(lpModel, begin
        RawPurchase>=0, Int
        Sell[products]>=0, Int
        Produce[products]>=0, Int
        Convert[pairs]>=0, Int
    end)

    # Constraint - Max Time
    @constraint(lpModel, 
        sum(process_df[process_df.FromTo .== pair, "Time"][1] * Convert[pair] for pair in pairs) + 
        params["Process Raw"]["Time"] * RawPurchase <= params["Max Time"])

    # Other Constraints
    for (ind, p) in enumerate(products)
        # Max Demand
        @constraint(lpModel, Sell[p] <= params["Max Demand"][ind])
        # RawPurchase to Produce Relation
        @constraint(lpModel, params["Process Raw"]["Yield"][ind] * RawPurchase == Produce[p])
        # Produce, Sell, & Convert Relation - Yield NOT implemented yet
        @constraint(lpModel, sum(Convert[pair] for pair in pairs if pair[(findfirst(isequal(','), pair)+2):(end-1)] == p) + Produce[p] == 
            Sell[p] + sum(Convert[pair] for pair in pairs if pair[2:(findfirst(isequal(','), pair)-1)] == p))
    end

    # Objective Function
    @objective(lpModel, Max, sum(params["Sell Prices"][ind] * Sell[p] for (ind, p) in enumerate(products)) -
        (params["Process Raw"]["Cost"] + params["Raw Material Cost"]) * RawPurchase - 
        sum(Convert[pair] * process_df[process_df.FromTo .== pair, "Cost"][1] for pair in pairs)
    )
    # Save model into file
    open("model.lp", "w") do f
        print(f, lpModel)
    end

    # Optimize model and save solution into txt file
    JuMP.optimize!(lpModel)
    open("solution.txt", "w") do f
        println(f, "Termination Status: $(termination_status(lpModel))")
        println(f, "Profit (objective): $(objective_value(lpModel))")
        println(f, "Lbs of Raw Material Purchased: $(value(lpModel[:RawPurchase]))")
        for p in products
            println(f, "Sold $(value(Sell[p])) oz. of $(p)")
        end
        for p in products
            println(f, "Produced $(value(Produce[p])) oz. of $(p)")
        end
        for pair in pairs
            p1 = pair[2:(findfirst(isequal(','), pair)-1)] 
            p2 = pair[(findfirst(isequal(','), pair)+2):length(pair)] 
            println(f, "Converted $(value(Convert[pair])) oz. of $(p1) to $(p2)")
        end
    end
end

function read_params(file_path::String)::Dict
    dict = Dict()
    io = open(file_path, "r")
    dict = JSON.parse(io)
    close(io)
    return dict
end

function main()
    if size(ARGS)==0
        param_file, df_file = "example_data/params.json", "example_data/process_prods.csv"
    elseif size(ARGS)==2
        param_file, df_file = ARGS[1], ARGS[2]
    else
        throw(ArgumentError("2 or 0 Command Line Arguments Must Be Given:\n2 for {params_file_path} {process_df_path}\n0 to run with example data"))
    end
    parameters = read_params("params.json")
    process_df = DataFrame(CSV.File("process_prods.csv")) 
    process_df[!, "FromTo"] = "(" .* process_df[!, "From"] .* ", " .* process_df[!, "To"] .* ")" 
    model_prod(parameters, process_df)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
