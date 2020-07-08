using OperationsResearchApplications
using Test

const testdir = dirname(@__FILE__)

const tests = [
    "search_ora"
]

@testset "OperationsResearchApplications" begin
    # Write your tests here.
    for t in tests
        @info "Testing $t"
        tp = joinpath(testdir, "$(t).jl")
        include(tp)
    end
end
