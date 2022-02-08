module Clean

using Comonicon: @main
using JuliaFormatter: format_file, format_text
using TOML: parsefile

using OnePiece.extension.dict: read, sort_recursively!, symbolize_key, write

include("clean_jl.jl")

include("clean_nb.jl")

"""
Command-line program for cleaning `Julia` files (`.jl`) and `Jupyter notebook`s (`.ipynb`)

# Arguments

  - `pa_`: `.jl` or `.ipynb` paths
"""
@main function clean(pa_...)

    to = joinpath(homedir(), ".JuliaFormatter.toml")

    ke_ar = symbolize_key(parsefile(to))

    for pa in pa_

        ex = splitext(pa)[2]

        if ex == ".jl"

            clean_jl(pa; ke_ar...)

        elseif ex == ".ipynb"

            clean_nb(pa; ke_ar...)

        end

    end

end

end
