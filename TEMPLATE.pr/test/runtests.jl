using TEMPLATE

for na in readdir(@__DIR__)

    if isdir(na) || na == "runtests.jl"

        continue

    end

    jl = joinpath(@__DIR__, na)

    @info "🎬 Running $jl"

    run(`julia --project $jl`)

end

# ----------------------------------------------------------------------------------------------- #
