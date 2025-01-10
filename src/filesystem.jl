using Comonicon: @cast

using JuliaFormatter: format

using Omics

"""
Delete bad files.
"""
@cast function delete()

    run(`find -E . -iregex ".*\.ds[_ ]store" -delete`)

end

"""
Rename files and directories.
"""
@cast function rename(before, after)

    run(pipeline(`find . -print0`, `xargs -0 rename --subst-all $before $after`))

end

"""
Name files automatically.

# Args

  - `style`: "code" | "human" | "date" | "datehuman".
"""
@cast function name(style; live::Bool = false)

    wo = pwd()

    rc = r"\.(git|key|numbers|pages)$"

    re = r"\.(png|heic|jpg|mov|mp4)$"

    for (ro, di_, fi_) in walkdir(wo)

        if contains(ro, rc)

            continue

        end

        for fi in fi_

            pr, ex = splitext(fi)

            ex = lowercase(ex)

            if ex == ".jpeg"

                ex = ".jpg"

            end

            pa = joinpath(ro, fi)

            pt = joinpath(
                ro,
                if style == "code"

                    "$(Omics.Strin.lower(pr))$ex"

                elseif style == "human"

                    "$(Omics.Strin.title(pr))$ex"

                elseif style == "date" || style == "datehuman"

                    da = ""

                    if contains(ex, re)

                        mi = minimum(
                            li -> replace(
                                split(li, '\t'; limit = 2)[2],
                                "00 00 00" => "__ __ __",
                            ),
                            eachsplit(
                                readchomp(
                                    `exiftool -tab -dateFormat "%Y %m %d %H %M %S" -FileModifyDate -DateCreated -DateTimeOriginal -CreateDate -CreationDate $pa`,
                                ),
                                '\n',
                            ),
                        )

                        if mi < pr[1:min(lastindex(pr), 19)]

                            da = mi

                        end

                    end

                    ti = Omics.Strin.title(pr)

                    if isempty(da)

                        "$ti$ex"

                    elseif style == "date"

                        "$da$ex"

                    else

                        "$da $ti$ex"

                    end

                end,
            )

            if pa == pt

                continue

            end

            @info "$(Omics.Path.shorten(pa, wo)) 🛸 $(Omics.Path.shorten(pt, wo))."

            if live

                mv(lowercase(pa) == lowercase(pt) ? mv(pa, "$(pt)_") : pa, pt)

            end

        end

    end

end

"""
Rewrite files.
"""
@cast function rewrite(before, after)

    run(
        pipeline(
            `rg --no-ignore --files-with-matches $before`,
            `xargs sed -i "" "s/$before/$after/g"`,
        ),
    )

end

"""
Beautify web and .jl files.
"""
@cast function beautify()

    pr = joinpath(readchomp(`brew --prefix`), "lib", "node_modules", "prettier-plugin-")

    run(
        pipeline(
            `find -E . -type f -iregex ".*\.(json|yaml|toml|html|md)" -print0`,
            `xargs -0 prettier --plugin $(pr)toml/lib/index.js --plugin $(pr)tailwindcss/dist/index.mjs --write`,
        ),
    )

    format(".")

end
