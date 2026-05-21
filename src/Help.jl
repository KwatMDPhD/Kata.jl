module Help

const P1 = pkgdir(Help, "in")

const P2 = pkgdir(Help, "ou")

# ---- #

include("Tree.jl")

include("Template.jl")

function (@main)(ARGS)

    st = ARGS[1]

    um = length(ARGS)

    if st == "log"

        Tree.log()

    elseif st == "template" && um == 2

        Template.write2(ARGS[2])

    elseif st == "template" && isone(um)

        Template.write2()

    else

        error(ARGS)

    end

    return

end

end
