module Help

const P1 = pkgdir(Help, "in")

const P2 = pkgdir(Help, "ou")

for pa in readdir(pkgdir(Help, "src"))

    if pa != "Help.jl"

        include(pa)

    end

end

# ---- #

function (@main)(ARGS)

    st = ARGS[1]

    um = length(ARGS)

    if st == "log"

        Tree.log()

    elseif st == "template"

        if um == 2

            Template.write(ARGS[2])

        elseif isone(um)

            Template.write()

        end

    end

    return

end

end
