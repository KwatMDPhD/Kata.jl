using Clean

function copy_for_clean(na)

    di = joinpath(@__DIR__, na)

    cp(di, replace(di, "dirty" => "clean")[1:(end - 1)], force = true)

end

jl = copy_for_clean("dirty.jl_")

Clean.clean(jl)

nb = copy_for_clean("dirty.ipynb_")

Clean.clean(nb)

Clean.clean(jl, nb)
