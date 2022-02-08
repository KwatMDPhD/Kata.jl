function clean_nb(pa; ke_ar...)

    println("Formatting ", pa)

    nb = read(pa)

    me = nb["metadata"]

    ju = me["language_info"]["name"] == "julia"

    if ju

        me["language_info"]["version"] = string(VERSION)

        me["kernelspec"]["name"] = string("julia-", VERSION.major, ".", VERSION.minor)

    else

        println("Language is not julia.")

    end

    ce_ = []

    for ce in nb["cells"]

        if ce["cell_type"] == "code"

            co = join(ce["source"])

            if strip(co) == ""

                continue

            end

            ce["execution_count"] = nothing

            ce["outputs"] = []

            if ju

                li_ = split(format_text(co; ke_ar...), "\n")

                ce["source"] = [string.(li_[1:(end - 1)], "\n"); li_[end]]

            end

        end

        push!(ce_, ce)

    end

    nb["cells"] = ce_

    nb = sort_recursively!(nb)

    js = string(pa, ".json")

    write(js, nb; id = 1)

    mv(js, pa; force = true)

end
