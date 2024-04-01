using BioLab

di = "/Users/kwat/iClou"

for (ro, di_, fi_) in walkdir(di)

    if any(contains(ro, st) for st in ("TODO", ".key", "Kz", "benchmarks"))

        continue

    end

    for fi in fi_

        so = joinpath(ro, fi)

        if startswith(fi, '.')

            continue

        end

        pr, ex = splitext(fi)

        ex = lowercase(ex)

        if ex == ".jpg"

            ex = ".jpeg"

        end

        if pr != "_"

            pr = BioLab.String.title(pr)

        end

        de = joinpath(ro, "ex")

        if so != de

            println("de")

            #run(`mv de`)

        end

    end

end
