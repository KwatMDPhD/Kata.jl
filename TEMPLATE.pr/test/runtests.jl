using TEMPLATE

for jl in readdir(; join = true)

    if jl == @__FILE__

        continue

    end

    @info "🎬 Running $jl"

    run(`julia --project $jl`)

end

# ----------------------------------------------------------------------------------------------- #
