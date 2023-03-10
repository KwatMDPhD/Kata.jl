using Test

using BioLab

using Clean

# --------------------------------------------- #

function copy_for_cleaning(na)

    pa = joinpath(@__DIR__, na)

    return pa, cp(pa, pa[1:(end - 1)]; force = true)

end

# --------------------------------------------- #

function diff(pa1, pa2)

    try

        run(`diff $pa1 $pa2`)

    catch

    end

    return nothing

end

# --------------------------------------------- #

for na in ("dirty.jl_", "dirty.ipynb_", "Untitled.ipynb_")

    BioLab.print_header(na)

    di, co = copy_for_cleaning(na)

    Clean.clean(co)

    # @code_warntype Clean.clean(co)

    diff(di, co)

end
