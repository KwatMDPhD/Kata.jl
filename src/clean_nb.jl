function clean_nb(pa; ke_ar...)

    println("Formatting ", pa)

    nb = OnePiece.dict.read(pa)

    me = nb["metadata"]

    ju = me["language_info"]["name"] == "julia"

    if ju

        me["language_info"]["version"] = string(VERSION)

        me["kernelspec"]["name"] = "julia-$(VERSION.major).$(VERSION.minor)"

    else

        println("Language is not julia.")

    end

    ce_ = []

    for ce in nb["cells"]

        if ce["cell_type"] == "code"

            co = join(ce["source"])

            if isempty(strip(co))

                continue

            end

            ce["execution_count"] = nothing

            ce["outputs"] = []

            if ju

                li_ = split(JuliaFormatter.format_text(co; ke_ar...), "\n")

                ce["source"] = [string.(li_[1:(end - 1)], "\n"); li_[end]]

            end

            ce["metadata"] = Dict()

        end

        push!(ce_, ce)

    end

    nb["cells"] = ce_

    nb = OnePiece.dict.sort_recursively!(nb)

    OnePiece.dict.write(pa, nb, id = 1)

end
