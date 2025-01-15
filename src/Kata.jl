module Kata

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

using Omics

# ---- #

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

                else

                    error("$style is not code, human, date, or datehuman.")

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

# ---- #

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

# ---- #

function _git(ex)

    wo = pwd()

    for (ro, di_, fi_) in walkdir(wo)

        if !(".git" in di_)

            continue

        end

        cd(ro)

        @info "📍 $(Omics.Path.shorten(ro, wo))"

        eval(ex)

        cd(wo)

    end

end

"""
`git` `fetch`, `status`, and `diff`.
"""
@cast function festdi()

    _git(quote

        run(`git fetch`)

        run(`git status`)

        run(`git diff`)

    end)

end

"""
`git` `add`, `commit`, and `push`.
"""
@cast function adcopu(message)

    _git(quote

        run(`git add -A`)

        me = $message

        if success(run(`git commit -m $me`; wait = false))

            run(`git push`)

        end

    end)

end

# ---- #

const _TE = pkgdir(Kata, "NAME.jl")

function _plan_replacement(na)

    "NAME" => na[1:(end - 3)],
    "e8386f20-3e60-497e-8358-52c6451f91c7" => string(uuid4()),
    "AUTHOR" => readchomp(`git config user.name`)

end

"""
Make a new package from the template.
"""
@cast function make(name)

    wo = pwd()

    cd(cp(_TE, joinpath(wo, name)))

    for (be, af) in _plan_replacement(name)

        rename(be, af)

        rewrite(be, af)

    end

    cd(wo)

end

"""
Match a package to the template.
"""
@cast function match()

    wo = pwd()

    re_ = _plan_replacement(basename(wo))

    uc = lastindex(_TE) + 2

    for (ro, di_, fi_) in walkdir(_TE), na_ in (fi_, di_), na in na_

        nm = replace(na, re_...)

        if !ispath(joinpath(wo, ro[uc:end], nm))

            error("$nm is missing.")

        end

    end

    for (rl, de, te_) in (
        ("README.md", "---", [false, true]),
        (
            ".gitignore",
            "# ----------------------------------------------------------------------------------------------- #",
            [true, false],
        ),
        (
            joinpath("test", "runtests.jl"),
            "# ----------------------------------------------------------------------------------------------- #",
            [true, false],
        ),
    )

        tm_ = split(replace(read(joinpath(_TE, rl), String), re_...), de)

        pa = joinpath(wo, rl)

        ac_ = split(read(pa, String), de)

        if lastindex(tm_) != lastindex(ac_)

            error("$rl splits unequally.")

        end

        map!(ifelse, tm_, te_, tm_, ac_)

        if tm_ == ac_

            continue

        end

        write(pa, join(tm_, de))

        @info "🍡 Transplanted $(Omics.Path.shorten(pa, wo))."

    end

end

# ---- #

# TODO
@main

end
