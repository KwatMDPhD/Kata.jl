module Help

const P1 = pkgdir(Help, "in")

const P2 = pkgdir(Help, "ou")

for pa in filter!(!=("Help.jl"), readdir(pkgdir(Help, "src")))

    include(pa)

end

# ---- #

function (@main)(ARGS)

    st = ARGS[1]

    um = length(ARGS)

    if st == "log"

        Tree.log()

    elseif st == "template"

        if um == 2

            Template.write2(ARGS[2])

        elseif isone(um)

            Template.write2()

        end

    end

    return

end

end
