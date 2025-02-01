module Kata

# ----------------------------------------------------------------------------------------------- #

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

using Omics

"""
Delete bad files.
"""
@cast function delete()

    run(`find -E . -iregex ".*\.ds[_ ]store" -delete`)

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

  - `--live`: = false.
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

                    "$(Omics.Strin.stri(Omics.Strin.lower(pr)))$ex"

                elseif style == "human"

                    "$(Omics.Strin.stri(Omics.Strin.title(pr)))$ex"

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

            @info "$(Omics.Path.shorten(pa, wo)) 🛸 $(Omics.Path.shorten(pt, wo))"

            if live

                mv(lowercase(pa) == lowercase(pt) ? mv(pa, "$(pt)_") : pa, pt)

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
Beautify .jl and web files.
"""
@cast function beautify()

    format(".")

    pr = joinpath(readchomp(`brew --prefix`), "lib", "node_modules", "prettier-plugin-")

    run(
        pipeline(
            # TODO: Shorten.
            `find -E . -type f -iregex ".*\.(json|yaml|toml|html|md)" -not -iregex ".*node_modules/.*" -not -iregex ".*Manifest.toml" -not -iregex ".*output/.*" -not -iregex ".*Medicine\.pr/.*" -print0`,
            `xargs -0 prettier --plugin $(pr)toml/lib/index.js --plugin $(pr)tailwindcss/dist/index.mjs --write`,
        ),
    )

end

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
git fetch, status, and diff.
"""
@cast function festdi()

    _git(quote

        run(`git fetch`)

        run(`git status`)

        run(`git diff`)

    end)

end

"""
git add, commit, and push.

# Arguments

  - `message`:
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

function _template(na)

    pkgdir(Kata, "TEMPLATE.$(na[(end - 1):end])")

end

function _plan_replacement(na)

    "TEMPLATE" => na[1:(end - 3)],
    "e8386f20-3e60-497e-8358-52c6451f91c7" => string(uuid4()),
    "AUTHOR" => readchomp(`git config user.name`)

end

"""
Make a package or project.

# Arguments

  - `name`: ".jl" | ".pr".
"""
@cast function make(name)

    wo = pwd()

    cd(cp(_template(name), joinpath(wo, name)))

    for (be, af) in _plan_replacement(name)

        rename(be, af)

        rewrite(be, af)

    end

end

"""
Match a package to its template.
"""
@cast function match()

    wo = pwd()

    te = _template(wo)

    re_ = _plan_replacement(basename(wo))

    be = lastindex(te) + 2

    for (ro, di_, fi_) in walkdir(te), na_ in (fi_, di_), na in na_

        nm = replace(na, re_...)

        if !ispath(ro[be:end], nm)

            error("$nm is missing.")

        end

    end

    de = "# $('-'^95) #"

    for (rl, dl, te_) in (
        ("README.md", "---", [false, true]),
        (".gitignore", de, [true, false]),
        (joinpath("src", "TEMPLATE.jl"), de, [true, false]),
        (joinpath("test", "runtests.jl"), de, [true, false]),
    )

        tm_ = split(replace(read(joinpath(te, rl), String), re_...), dl)

        rt = replace(rl, re_...)

        pa = joinpath(wo, rt)

        ac_ = split(read(pa, String), dl)

        if lastindex(tm_) != lastindex(ac_)

            error("$rt splits unequally.")

        end

        map!(ifelse, tm_, te_, tm_, ac_)

        if tm_ == ac_

            continue

        end

        write(pa, join(tm_, dl))

        @info "🍡 Transplanted $(Omics.Path.shorten(pa, wo))."

    end

end

"""
"""
@main

end
