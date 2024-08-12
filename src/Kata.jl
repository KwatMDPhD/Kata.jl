module Kata

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

using LeMoString: lower, title

const _TE = pkgdir(Kata, "NAME.jl")

"""
Remove bad files.
"""
@cast function remove()

    run(`find -E . -iregex ".*ds[ _]store" -delete`)

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

function _is_skip(pa)

    any(sk -> occursin(sk, pa), (".git", ".key", ".numbers", ".pages"))

end

function _move(p1, p2, li)

    @info "$p1 ➡️  $p2."

    if li

        mv(lowercase(p1) == lowercase(p2) ? mv(p1, "$(p2)_") : p1, p2)

    end

end

"""
Automatically name files and directories.

# Arguments

  - `style`: "human" | "code".

# Flags

  - `--live`:
"""
@cast function autoname(style; live::Bool = false)

    fu = style == "human" ? title : lower

    for (ro, di_, fi_) in walkdir(pwd())

        if !_is_skip(ro)

            for fi in fi_

                pr, ex = splitext(fi)

                if !isempty(ex)

                    ex = lowercase(ex)

                    if ex == ".jpeg"

                        ex = ".jpg"

                    end

                end

                f2 = "$(fu(pr))$ex"

                if fi != f2

                    _move(joinpath(ro, fi), joinpath(ro, f2), live)

                end

            end

        end

    end

end

function _get_exiftool(ar, fi)

    chomp(read(`exiftool $ar $fi`, String))

end

"""
Date media-file names with their creation date.

# Flags

  - `--only`:
  - `--live`:
"""
@cast function date(; only::Bool = false, live::Bool = false)

    for (ro, di_, fi_) in walkdir(pwd())

        if !_is_skip(ro)

            for fi in fi_

                pr, ex = splitext(fi)

                if !startswith(pr, r"\d{4} \d{2}") &&
                   (ex == ".jpg" || ex == ".heic" || ex == ".mov" || ex == ".mp4")

                    pa = joinpath(ro, fi)

                    da_ = Tuple(
                        split(da, ": "; limit = 2)[2] for da in (
                            _get_exiftool("-CreateDate", pa),
                            _get_exiftool("-CreationDate", pa),
                        ) if !isempty(da)
                    )

                    if !isempty(da_)

                        da = Base.replace(minimum(da_)[1:19], ':' => ' ')

                        if only

                            _move(joinpath(ro, fi), joinpath(ro, "$da$ex"), live)

                        else

                            _move(joinpath(ro, fi), joinpath(ro, "$da $fi"), live)

                        end

                    end

                end

            end

        end

    end

end

"""
Replace file contents.

# Arguments

  - `before`:
  - `after`:
"""
@cast function replace(before, after)

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
            `find -E . -type f -size -1M -regex ".*\.(json|yaml|md|html|css|scss|js|jsx|ts|tsx)" -print0`,
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

    for (ro, di_, fi_) in walkdir(pwd())

        if ".git" in di_

            cd(ro)

            @info "📍 $ro"

            run(`git fetch`)

            run(`git status`)

            run(`git diff`)

            cd(wo)

        end

    end

end

"""
`git` `add`, `commit`, `pull`, and `push`.

# Arguments

  - `message`:
"""
@cast function git_push(message)

    wo = pwd()

    for (ro, di_, fi_) in walkdir(pwd())

        if ".git" in di_

            cd(ro)

            @info "📍 $ro"

            run(`git add -A`)

            run(`git commit -m $message`)

            run(`git pull`)

            run(`git push`)

            cd(wo)

        end

    end

end

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

        replace(be, af)

    end

    cd(wo)

end

"""
Reset a package based on its template.
"""
@cast function reset()

    ma = pwd()

    re_ = _plan_replacement(basename(ma))

    nc = lastindex(_TE) + 2

    for (ro, di_, fi_) in walkdir(_TE)

        mr = joinpath(ma, ro[nc:end])

        for na_ in (fi_, di_), na in na_

            mp = joinpath(mr, Base.replace(na, re_...))

            if !ispath(mp)

                error()

            end

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

        r1_ = split(Base.replace(read(joinpath(_TE, pa), String), re_...), de)

        p2 = joinpath(ma, pa)

        r2_ = split(read(p2, String), de)

        if lastindex(r1_) != lastindex(r2_)

            error()

        end

        map!(ifelse, r1_, rs_, r1_, r2_)

        if r1_ != r2_

            write(p2, join(r1_, de))

            @info "🍡 Transplanted $p2."

        end

    end

end

"""
Command-line program for organizing the file system 🗄️✨
"""
@main

end
