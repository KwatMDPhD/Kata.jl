module Kata

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

using LeMoString: lower, title

"""
Remove bad files.
"""
@cast function remove()

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

function _shorten(pa, wo = pwd())

    pa[(lastindex(wo) + 2):end]

end

"""
Automatically name files.

# Arguments

  - `style`: "code" | "human" | "date" | "datehuman".

# Flags

  - `--live`:
"""
@cast function autoname(style; live::Bool = false)

    for (ro, di_, fi_) in walkdir(pwd())

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

                    "$(lower(pr))$ex"

                elseif style == "human"

                    "$(title(pr))$ex"

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

                        "$(title(pr))$ex"

                    elseif style == "date"

                        "$da$ex"

                    else

                        "$da $(title(pr))$ex"

                    end

                else

                    error()

                end,
            )

            if pa == p2

                continue

            end

            @info "$(_shorten(pa)) ➡️  $(_shorten(p2))."

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
Format web files.
"""
@cast function format_web()

    run(
        pipeline(
            `find -E . -type f -size -1M -iregex ".*\.(json|yaml|md|html|css|scss|js|jsx|ts|tsx)" -print0`,
            `xargs -0 prettier --write`,
        ),
    )

end

"""
Format .jl.
"""
@cast function format_jl()

    format(".")

end

"""
`git` `fetch`, `status`, and `diff`.
"""
@cast function git_diff()

    wo = pwd()

    for (ro, di_, fi_) in walkdir(wo)

        if !(".git" in di_)

            continue

        end

        cd(ro)

        @info "📍 $(_shorten(ro, wo))"

        run(`git fetch`)

        run(`git status`)

        run(`git diff`)

        cd(wo)

    end

end

"""
`git` `add`, `commit`, and `push`.

# Arguments

  - `message`:
"""
@cast function git_push(message)

    wo = pwd()

    for (ro, di_, fi_) in walkdir(wo)

        if !(".git" in di_)

            continue

        end

        cd(ro)

        @info "📍 $(_shorten(ro, wo))"

        run(`git add -A`)

        if success(run(`git commit -m $message`; wait = false))

            run(`git push`)

        end

        cd(wo)

    end

end

const _TE = pkgdir(Kata, "NAME.jl")

function _plan_replacement(na)

    "NAME" => na[1:(end - 3)],
    "e8386f20-3e60-497e-8358-52c6451f91c7" => string(uuid4()),
    "AUTHOR" => readchomp(`git config user.name`)

end

"""
Make a new package from the template.

# Arguments

  - `name`: TitleCase.jl.
"""
@cast function make(name)

    wo = pwd()

    ma = cp(_TE, joinpath(wo, name))

    cd(ma)

    for (be, af) in _plan_replacement(name)

        rename(be, af)

        rewrite(be, af)

    end

    cd(wo)

end

"""
Reset a package based on its template.
"""
@cast function reset()

    ma = pwd()

    re_ = _plan_replacement(basename(ma))

    uc = lastindex(_TE) + 2

    for (ro, di_, fi_) in walkdir(_TE), na_ in (fi_, di_), na in na_

        if !ispath(joinpath(ma, ro[uc:end], replace(na, re_...)))

            error()

        end

    end

    for (pa, de, rs_) in (
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

        r1_ = split(replace(read(joinpath(_TE, pa), String), re_...), de)

        p2 = joinpath(ma, pa)

        r2_ = split(read(p2, String), de)

        if lastindex(r1_) != lastindex(r2_)

            error()

        end

        map!(ifelse, r1_, rs_, r1_, r2_)

        if r1_ == r2_

            continue

        end

        write(p2, join(r1_, de))

        @info "🍡 Transplanted $(_shorten(p2, ma))."

    end

end

"""
Command-line program for organizing the file system 🗄️✨
"""
@main

end
