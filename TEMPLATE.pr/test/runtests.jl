using TEMPLATE

for ba in readdir()

    if isdir(ba) || ba == "runtests.jl"

        continue

    end

    @info "🎬 Running $ba"

    run(`julia --project $ba`)

end

# ----------------------------------------------------------------------------------------------- #
