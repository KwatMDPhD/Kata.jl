using Clean

function copy_for_cleaning(fi)

    di = joinpath(@__DIR__, "dirty.jl_")

    di, cp(di, di[1:(end - 1)], force = true)

end

jl = copy_for_cleaning("dirty.jl_")[2]

Clean.clean(jl)

nb = copy_for_cleaning("dirty.ipynb_")[2]

Clean.clean(nb)

Clean.clean(jl, nb)

di, nb = copy_for_cleaning("Untitled.jl_")

Clean.clean(nb)

try

    run(`diff $di $nb`)

catch

end
