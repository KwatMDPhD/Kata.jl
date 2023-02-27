using BioLab

using Clean

function copy_for_cleaning(di)

    di = joinpath(@__DIR__, di)

    return di, cp(di, di[1:(end - 1)]; force = true)

end

function diff(di, fi)

    try

        run(`diff $di $fi`)

    catch

    end

    return nothing

end

for di in ("dirty.jl_", "dirty.ipynb_", "Untitled.ipynb_")

    BioLab.print_header(di)

    di, co = copy_for_cleaning(di)

    Clean.clean(co)

    # @code_warntype Clean.clean(co)

    diff(di, co)

end
