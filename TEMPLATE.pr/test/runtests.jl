using TEMPLATE

for ba in sort!(
    filter!(ba -> ba != "runtests.jl" && !isdir(ba), readdir());
    by = ba -> parse(Int, split(ba, '.'; limit = 2)[1]),
)

    @info "🎬 Running $ba"

    run(`julia --project $ba`)

end

# ----------------------------------------------------------------------------------------------- #
