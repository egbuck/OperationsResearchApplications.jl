@testset "search_ora" begin
    categories = ["Production Process"]
    cat_apps = Dict("Production Process" => ["Example A"])
    # test that all categories can be searched
    for c in categories
        @test search_ora(c) == cat_apps[c]
    end
    # test that uppercase arg is fine
    @test search_ora(uppercase(categories[1])) == cat_apps[categories[1]]

    # test that lowercase arg is fine
    @test search_ora(lowercase(categories[1])) == cat_apps[categories[1]]

    # test that throws ArgumentError when cat not exist
    @test_throws ArgumentError search_ora("This shouldn't exist")

    # test that works with no argument (lists categories)
    @test search_ora() == categories

end