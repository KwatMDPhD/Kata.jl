module Clean

using Comonicon: @main

using JuliaFormatter: format_file, format_text

using BioLab

BioLab.@include

"""
Command-line program for cleaning `Julia` files (`.jl`) and `Jupyter Notebook`s (`.ipynb`) 🧹

# Arguments

  - `paths`: `.jl` or `.ipynb` paths.
"""
@main function clean(paths...)

    ke_ar = BioLab.Dict.symbolize(BioLab.Dict.read(joinpath(@__DIR__, "JuliaFormatter.toml")))

    for pa in paths

        println("🧹 $pa")

        ex = splitext(pa)[2]

        if ex == ".jl"

            format_file(pa; ke_ar...)

        elseif ex == ".ipynb"

            _clean_nb(pa; ke_ar...)

        else

            error()

        end

    end

end

end
