using Data

for jl in readdir(@__DIR__)

    if jl == "runtests.jl" || startswith(jl, '_')

        continue

    end

    jl = joinpath(@__DIR__, jl)

    @info "🎬 Running $jl"

    run(`julia --project $jl`)

end

# ----------------------------------------------------------------------------------------------- #
