module He

const P1 = pkgdir(He, "in")

const P2 = pkgdir(He, "ou")

# ---- #

using UUIDs: uuid4

function name()

    nd = length(pwd()) + 2

    for (p1, p1_, p2_) in walkdir()

        if contains(p1, ".git") ||
                contains(p1, ".key") ||
                contains(p1, ".numbers") ||
                contains(p1, ".pages")

            continue

        end

        p2 = p1[nd:end]

        for p3_ in (p1_, p2_), p3 in p3_

            if startswith(p3, '.') || !isone(count(isuppercase, p3))

                @info "🚨 $(joinpath(p2, p3))"

            end

            p4 = replace(
                p3,
                r"^\s+" => "",
                r"\s+$" => "",
                r"\s{2,}" => ' ',
                r"(?<=\d)th"i => "th",
                (
                    Regex(st, "i") => st for st in
                        ("1st", "2nd", "3rd", "'d", "'m", "'re", "'s", "'ve")
                )...,
                (
                    Regex("(?<= )$st(?= )", "i") => st for st in (
                            "a",
                            "an",
                            "and",
                            "as",
                            "at",
                            "but",
                            "by",
                            "for",
                            "from",
                            "in",
                            "into",
                            "nor",
                            "of",
                            "off",
                            "on",
                            "onto",
                            "or",
                            "out",
                            "over",
                            "the",
                            "to",
                            "up",
                            "vs",
                            "with",
                        )
                )...,
            )

            if p3 != p4

                @info "📛 $p2\n$p3\n$p4"

            end

        end

    end

    return

end

const PA = pkgdir(He, "NAME.jl")

const IN = length(PA) + 2

function pair(pa)

    return "NAME" => splitext(pa)[1],
        "11111111-1111-1111-1111-111111111111" => "$(uuid4())",
        "AUTHORS" => readchomp(`git config user.name`)

end

function make(name)

    cd(cp(PA, joinpath(pwd(), name)))

    for (s1, s2) in pair(name)

        s3 = "s/$s1/$s2/g"

        run(pipeline(`find . -print0`, `xargs -0 rename $s3`))

        run(
            pipeline(
                `rg --no-ignore --files-with-matches $s1`,
                `xargs sed -i '' $s3`,
            ),
        )

    end

    return

end

const ST = "# ---- #"

function match()

    p1 = pwd()

    nd = length(p1) + 2

    pa_ = pair(basename(p1))

    for (p2, p1_, p2_) in walkdir(PA), p3_ in (p1_, p2_), p2 in p3_

        if p2 == "Manifest.toml"

            continue

        end

        p3 = joinpath(p2[IN:end], replace(p2, pa_[1]))

        @assert ispath(p3) p3

    end

    for p2 in (
            ".gitignore",
            joinpath("src", "NAME.jl"),
            joinpath("test", "runtests.jl"),
        )

        p3 = joinpath(p1, replace(p2, pa_[1]))

        s1 = read(p3, String)

        s2 = "$(split(replace(read(joinpath(PA, p2), String), pa_...), ST; limit = 2)[1])$ST$(split(s1, ST; limit = 2)[2])"

        if s1 == s2

            continue

        end

        write(p3, s2)

        @info "🍡 $(p3[nd:end])"

    end

    return

end

function (@main)(ARGS)

    st = ARGS[1]

    if st == "name"

        name()

    elseif st == "make"

        make(ARGS[2])

    elseif st == "match"

        match()

    end

    return

end

end
