using Comonicon: @cast

using JuliaFormatter: format

using Omics

"""
Delete bad files.
"""
@cast function delete()

    run(`find -E . -iregex ".*DS[_ ]Store" -delete`)

end

"""
Rename files and directories.

# Arguments

  - `before`:
  - `after`:
"""
@cast function rename(before, after)

    run(pipeline(`find . -print0`, `xargs -0 rename --subst-all $before $after`))

end

"""
Name files automatically.

# Arguments

  - `style`: "code" | "human" | "date" | "datehuman".

# Flags

  - `--live`:
"""
@cast function name(style; live::Bool = false)

    wo = pwd()

    for (ro, di_, fi_) in walkdir(wo)

        if contains(ro, ".git") ||
           contains(ro, ".key") ||
           contains(ro, ".numbers") ||
           contains(ro, ".pages")

            continue

        end

        for fi in fi_

            pa = joinpath(ro, fi)

            pr, ex = splitext(fi)

            ex = lowercase(ex)

            if ex == ".jpeg"

                ex = ".jpg"

            end

            p2 = joinpath(
                ro,
                if style == "code"

                    "$(Omics.Strin.lower(pr))$ex"

                elseif style == "human"

                    "$(Omics.Strin.title(pr))$ex"

                elseif style == "date" || style == "datehuman"

                    da = ""

                    if ex == ".png" ||
                       ex == ".heic" ||
                       ex == ".jpg" ||
                       ex == ".mov" ||
                       ex == ".mp4"

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

                    if isempty(da)

                        "$(Omics.Strin.title(pr))$ex"

                    elseif style == "date"

                        "$da$ex"

                    else

                        "$da $(Omics.Strin.title(pr))$ex"

                    end

                else

                    error("$style is neither code, human, date, nor datehuman.")

                end,
            )

            if pa == p2

                continue

            end

            @info "$(_shorten(pa, wo)) ➡️  $(_shorten(p2, wo))."

            if live

                mv(lowercase(pa) == lowercase(p2) ? mv(pa, "$(p2)_") : pa, p2)

            end

        end

    end

end

"""
Rewrite files.

# Arguments

  - `before`:
  - `after`:
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

    br = readchomp(`brew --prefix`)

    run(
        pipeline(
            `find -E . -type f -size -2M -iregex ".*\.(json|yaml|toml|html|md)" -print0`,
            `xargs -0 prettier --plugin $br/lib/node_modules/prettier-plugin-toml/lib/index.js --plugin $br/lib/node_modules/prettier-plugin-tailwindcss/dist/index.mjs --write`,
        ),
    )

    format(".")

end
