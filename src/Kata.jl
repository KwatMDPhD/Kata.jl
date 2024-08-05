module Kata

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

const _TE = pkgdir(Kata, "NAME.jl")

function _strip(st)

    return Base.replace(st, r" +" => ' ')

end

function _title(st)

    return _strip(Base.replace(
        join(if isuppercase(c1)
            c1
        else
            c2
        end for (c1, c2) in zip(st, titlecase(Base.replace(st, '_' => ' ')))),
        r"'m"i => "'m",
        r"'re"i => "'re",
        r"'s"i => "'s",
        r"'ve"i => "'ve",
        r"'d"i => "'d",
        r"1st"i => "1st",
        r"2nd"i => "2nd",
        r"3rd"i => "3rd",
        r"(?<=\d)th"i => "th",
        r" a "i => " a ",
        r" an "i => " an ",
        r" the "i => " the ",
        r" and "i => " and ",
        r" but "i => " but ",
        r" or "i => " or ",
        r" nor "i => " nor ",
        r" at "i => " at ",
        r" by "i => " by ",
        r" for "i => " for ",
        r" from "i => " from ",
        r" in "i => " in ",
        r" into "i => " into ",
        r" of "i => " of ",
        r" off "i => " off ",
        r" on "i => " on ",
        r" onto "i => " onto ",
        r" out "i => " out ",
        r" over "i => " over ",
        r" to "i => " to ",
        r" up "i => " up ",
        r" with "i => " with ",
        r" as "i => " as ",
        r" vs "i => " vs ",
    ))

end

function _lower(st)

    return _strip(lowercase(Base.replace(st, r"[^._0-9A-Za-z]" => '_')))

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

        _title

    elseif how == "code"

        _lower

    else

        error("`how` is not \"human\" | \"code\".")

    end

    sk_ = ".git", ".key"

    for (ro, di_, fi_) in walkdir(pwd())

        if any(sk -> occursin(sk, ro), sk_)

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

                @info "$fi --> $f2."

                if live

                    pa = joinpath(ro, fi)

                    p2 = joinpath(ro, f2)

                    mv(if lowercase(fi) == lowercase(f2)

                        mv(pa, "$(p2)_")

                    else

                        pa

                    end, p2)

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

    return nothing

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

    return nothing

end

"""
Format .(json|yaml|md|html|css|scss|js|jsx|ts|tsx).
"""
@cast function format_web()

    run(pipeline(
        `find -E . -type f -size -1M -regex ".*\.(json|yaml|md|html|css|scss|js|jsx|ts|tsx)" -print0`,
        `xargs -0 prettier --write`,
    ))

    return nothing

end

"""
Format .jl.
"""
@cast function format_jl()

    format(".")

    return nothing

end

function _plan_replacement(na)

    return "NAME" => na[1:(end - 3)],
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

    return cd(wo)

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

            @info "Transplanting $p2"

            write(p2, join(r1_, de))

        end

    end

end

"""
Command-line program for organizing file systems 🗄️
"""
@main

end
