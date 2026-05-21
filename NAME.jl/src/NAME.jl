module NAME

const P1 = pkgdir(NAME, "in")

const P2 = pkgdir(NAME, "ou")

for pa in filter!(!=("NAME.jl"), readdir(pkgdir(NAME, "src")))

    include(pa)

end

# ---- #

end
