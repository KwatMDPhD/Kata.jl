module Template

using Base: write as Basewrite

using UUIDs: uuid4

const PA = pkgdir(Template, "NAME.jl")

const IN = length(PA) + 2

function write(pa)

    cd(cp(PA, pa))

    mv(joinpath("src", "NAME.jl"), joinpath("src", pa))

    run(
        pipeline(
            `find . -type f -print0`,
            `xargs -0 sed -i '' -e s/NAME/$(splitext(pa)[1])/g -e s/11111111-1111-1111-1111-111111111111/$(uuid4())/g`,
        ),
    )

    return

end

function write(s1, pa)

    s2 = read(pa, String)

    s3 = "$(split(s1, "# ---- #"; limit = 2)[1])# ---- #$(split(s2, "# ---- #"; limit = 2)[2])"

    if s2 == s3

        return

    end

    Basewrite(pa, s3)

    @info "🍡 $pa"

    return

end

function write()

    p1 = basename(pwd())

    for (p2, p1_, p2_) in walkdir(PA), p3_ in (p1_, p2_), p3 in p3_

        if p3 == "Manifest.toml"

            continue

        elseif p3 == "NAME.jl"

            p3 = p1

        end

        p4 = joinpath(p2[IN:end], p3)

        @assert ispath(p4) p4

    end

    write(read(joinpath(PA, ".gitignore"), String), ".gitignore")

    pa = "NAME" => splitext(p1)[1]

    write(
        replace(read(joinpath(PA, "src", "NAME.jl"), String), pa),
        joinpath("src", p1),
    )

    write(
        replace(read(joinpath(PA, "test", "runtests.jl"), String), pa),
        joinpath("test", "runtests.jl"),
    )

    return

end

end
