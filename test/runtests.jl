TE = joinpath(tempdir(), "Clean.test")

if isdir(TE)

    rm(TE, recursive = true)

end

mkdir(TE)

#using Revise
using Clean

jl = joinpath(@__DIR__, "runtests.jl")

Clean.clean(jl)

nb = joinpath(@__DIR__, "test.ipynb")

Clean.clean(nb)

Clean.clean(jl, nb, joinpath(dirname(@__DIR__), "src", "Clean.jl"))

nb_ = [na for na in readdir() if occursin(r".ipynb$", na) && na != "runtests.ipynb"]

if all(startswith.(nb_, r"^[0-9]+\."))

    sort!(nb_, by = nb -> parse(Int64, split(nb, '.')[1]))

end

for (id, nb) in enumerate(nb_)

    if id < 1

        continue

    end

    println("Running ", nb, " (", id, ")")

    run(
        `jupyter-nbconvert --log-level 40 --inplace --execute --ExecutePreprocessor.timeout=-1 --clear-output $nb`,
    )

end
