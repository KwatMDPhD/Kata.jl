module Kata

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

using LeMoString: lower, title

const _TE = pkgdir(Kata, "NAME.jl")

function _is_skip(pa)

    any(sk -> occursin(sk, pa), (".git", ".key", ".numbers"))

end

function _move(ro, n1, n2, li)

    ba = basename(ro)

    @info "$n1 ➡️  $n2."

    if li

        p1 = joinpath(ro, n1)

        p2 = joinpath(ro, n2)

        mv(if lowercase(n1) == lowercase(n2)

            mv(p1, "$(p2)_")

        else

            p1

        end, p2)

    end

end

"""
Style file and directory names.

# Arguments

  - `how`: "human" | "code".

# Flags

  - `--live`:
"""
@cast function style(how; live::Bool = false)

    fu = if how == "human"

        title

    elseif how == "code"

        lower

    else

        error("`how` is not \"human\" | \"code\".")

    end

    for (ro, di_, fi_) in walkdir(pwd())

        if _is_skip(ro)

            continue

        end

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

                _move(ro, fi, f2, live)

            end

        end

    end

end

function _get_exiftool(fi, ar)

    chomp(read(`exiftool $ar $fi`, String))

end

"""
Date file names with a prefix.

# Flags

  - `--live`:
"""
@cast function date(; live::Bool = false)

    for (ro, di_, fi_) in walkdir(pwd())

        if _is_skip(ro)

            continue

        end

        for fi in fi_

            pr, ex = splitext(fi)

            if ex == ".jpg" || ex == ".heic" || ex == ".mov" || ex == ".mp4"

                pa = joinpath(ro, fi)

                da_ = Tuple(split(da, ": "; limit = 2)[2] for da in (
                    _get_exiftool(pa, "-CreateDate"),
                    _get_exiftool(pa, "-CreationDate"),
                ) if !isempty(da))

                if isempty(da_)

                    @info "❌ $pa."

                else

                    da = Base.replace(split(minimum(da_), '-'; limit = 2)[1], ':' => ' ')

                    if pr != da

                        _move(ro, fi, "$da$ex", live)

                    end

                end

            end

        end

    end

end

"""
Rename file and directory names.

# Arguments

  - `before`:
  - `after`:
"""
@cast function rename(before, after)

    run(pipeline(`find . -print0`, `xargs -0 rename --subst-all $before $after`))

end

"""
Replace file contents.

# Arguments

  - `before`:
  - `after`:
"""
@cast function replace(before, after)

    run(pipeline(
        `rg --no-ignore --files-with-matches $before`,
        `xargs sed -i "" "s/$before/$after/g"`,
    ))

end

"""
Format .(json|yaml|md|html|css|scss|js|jsx|ts|tsx).
"""
@cast function format_web()

    run(pipeline(
        `find -E . -type f -size -1M -regex ".*\.(json|yaml|md|html|css|scss|js|jsx|ts|tsx)" -print0`,
        `xargs -0 prettier --write`,
    ))

end

"""
Format .jl.
"""
@cast function format_jl()

    format(".")

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
Reset a package based on the template.
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

                error("$mp is missing.")

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

            error("split lengths differ.")

        end

        map!(ifelse, r1_, rs_, r1_, r2_)

        if r1_ != r2_

            write(p2, join(r1_, de))

            @info "Transplanted $p2."

        end

    end

end

"""
Command-line program for organizing the file system 🗄️✨
"""
@main

end
