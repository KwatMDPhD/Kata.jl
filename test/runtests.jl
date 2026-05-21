using Help

for pa in readdir(pkgdir(Help, "test"))

    if pa == "runtests.jl"

        continue

    end

    @info "🎬 $pa"

    run(`julia --project $pa`)

end

# ---- #
