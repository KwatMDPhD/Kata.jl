using Comonicon: @cast

using UUIDs: uuid4

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
Match a package to the template.
"""
@cast function match()

    ma = pwd()

    re_ = _plan_replacement(basename(ma))

    uc = lastindex(_TE) + 2

    for (ro, di_, fi_) in walkdir(_TE), na_ in (fi_, di_), na in na_

        nr = replace(na, re_...)

        if !ispath(joinpath(ma, ro[uc:end], nr))

            error("$nr is missing.")

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

            error("$pa splits unequally.")

        end

        map!(ifelse, r1_, rs_, r1_, r2_)

        if r1_ == r2_

            continue

        end

        write(p2, join(r1_, de))

        @info "🍡 Transplanted $(_shorten(p2))."

    end

end
