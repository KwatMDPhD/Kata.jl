using TEMPLATE

for st in sort!(
    filter!(st -> st != "runtests.jl" && !isdir(st), readdir());
    by = st -> parse(Int, split(st, '.'; limit = 2)[1]),
)

    @info "🎬 Running $st"

    run(`julia --project $st`)

end

# ------------------------------------ #
