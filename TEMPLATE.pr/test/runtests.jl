using TEMPLATE

for ba in readdir(@__DIR__)

    if isdir(ba) || ba == "runtests.jl"

        continue

    end

    jl = joinpath(@__DIR__, ba)

    @info "🎬 Running $jl"

    run(`julia --project $jl`)

end

# ----------------------------------------------------------------------------------------------- #
