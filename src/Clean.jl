module Clean

using Comonicon: @main
using JuliaFormatter: format_file, format_text
using OnePiece.extension.dict: read, sort_recursively!, write

include("clean_jl.jl")

include("clean_nb.jl")

"""
Command-line program for cleaning `Julia` files (`.jl`) and `Jupyter notebook`s (`.ipynb`)

# Arguments

  - `pa_`: `.jl` or `.ipynb` paths
"""
@main function clean(pa_...)

    for pa in pa_

        ex = splitext(pa)[2]

        if ex == ".jl"

            clean_jl(pa)

        elseif ex == ".ipynb"

            clean_nb(pa)

        end

    end

end

end
