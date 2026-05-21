module NAME

const P1 = pkgdir(NAME, "in")

const P2 = pkgdir(NAME, "ou")

for pa in readdir(pkgdir(NAME, "src"))

    if pa != "NAME.jl"

        include(pa)

    end

end

# ---- #

end
