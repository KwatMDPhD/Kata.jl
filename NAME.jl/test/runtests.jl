using NAME

function number(pa)

    return parse(Int, split(pa, '.'; limit = 2)[1])

end

for pa in sort!(filter!(!=("runtests.jl"), readdir()); by = number)

    @info "🎬 $pa"

    run(`julia --project $pa`)

end

# ---- #
