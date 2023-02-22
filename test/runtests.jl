using BioLab

using Clean

function copy_for_cleaning(fi)

    di = joinpath(@__DIR__, fi)

    di, cp(di, di[1:(end - 1)]; force = true)

end

function _diff(di, fi)

    try

        run(`diff $di $fi`)

    catch

    end

end

BioLab.String.print_header()

di, jl = copy_for_cleaning("dirty.jl_")

Clean.clean(jl)

_diff(di, jl)

BioLab.String.print_header()

di, nb = copy_for_cleaning("dirty.ipynb_")

Clean.clean(nb)

_diff(di, nb)

BioLab.String.print_header()

Clean.clean(jl, nb)

BioLab.String.print_header()

di, nb = copy_for_cleaning("Untitled.ipynb_")

Clean.clean(nb)

_diff(di, nb)
