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

            error()

        end

        map!(ifelse, tm_, te_, tm_, ac_)

        if tm_ == ac_

            continue

        end

        write(pa, join(tm_, de))

        @info "🍡 Transplanted $(Omics.Path.shorten(pa, wo))."

    end

end
