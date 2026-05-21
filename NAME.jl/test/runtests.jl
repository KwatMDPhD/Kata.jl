using NAME

for pa in readdir(pkgdir(NAME, "test"))

    if pa == "runtests.jl"

        continue

    end

    @info "🎬 $pa"

    run(`julia --project $pa`)

end

# ---- #
