using Clean

using Aqua: test_all, test_ambiguities

using Test: @test

test_all(Clean; ambiguities = false, deps_compat = false)

test_ambiguities(Clean)

# ----------------------------------------------------------------------------------------------- #
