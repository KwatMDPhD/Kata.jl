module Clean

using Comonicon
using JuliaFormatter
using OnePiece

include("clean_nb.jl")

"""
Command-line program for cleaning `Julia` files (`.jl`) and `Jupyter notebook`s (`.ipynb`)

# Arguments

  - `pa_`: `.jl` or `.ipynb` paths
"""
@main function clean(pa_...)

    to = joinpath(homedir(), ".JuliaFormatter.toml")

    ke_ar = OnePiece.dict.symbolize(OnePiece.dict.read(to))

    for pa in pa_

        ex = splitext(pa)[2]

        if ex == ".jl"

            JuliaFormatter.format_file(pa; verbose = true, ke_ar...)

        elseif ex == ".ipynb"

            clean_nb(pa; ke_ar...)

        else

            error()

        end

    end

end

end
