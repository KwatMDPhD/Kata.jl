function clean_nb(pa::String)

    println("Formatting ", pa)

    nb = DictExtension.read(pa)

    la = nb["metadata"]["language_info"]

    if la["name"] == "julia"

        la["version"] = string(VERSION)

        for ce in nb["cells"]

            if ce["cell_type"] == "code"

                li_ = split(format_text(join(ce["source"])), '\n')

                ce["source"] = [string.(li_[1:end-1], "\n"); li_[end]]

                ce["execution_count"] = nothing

                ce["outputs"] = []

            end

        end

    end

    nb = DictExtension.sort_recursively!(nb)

    js = string(pa, ".json")

    DictExtension.write(js, nb; id = 1)

    mv(js, pa; force = true)

    return nb

end
