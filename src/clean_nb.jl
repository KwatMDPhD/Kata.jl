function clean_nb(pa::String)

    println("Formatting ", pa)

    nb = DictExtension.read(pa)

    la = nb["metadata"]["language_info"]

    ju = la["name"] == "julia"

    if ju

        la["version"] = string(VERSION)

    else

        println("Language is not Julia.")

    end

    for ce in nb["cells"]

        if ce["cell_type"] == "code"

            ce["execution_count"] = nothing

            ce["outputs"] = []

            if ju

                li_ = split(format_text(join(ce["source"])), '\n')

                ce["source"] = [string.(li_[1:end-1], "\n"); li_[end]]

            end

        end

    end

    nb = DictExtension.sort_recursively!(nb)

    js = string(pa, ".json")

    DictExtension.write(js, nb; id = 1)

    mv(js, pa; force = true)

    return nb

end
