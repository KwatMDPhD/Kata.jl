module He

const P1 = pkgdir(He, "in")

const P2 = pkgdir(He, "ou")

# ---- #

using UUIDs: uuid4

function name()

    nd = length(pwd()) + 2

    for (p1, s1_, s2_) in walkdir()

        if contains(p1, ".git") ||
                contains(p1, ".key") ||
                contains(p1, ".numbers") ||
                contains(p1, ".pages")

            continue

        end

        p2 = p1[nd:end]

        for s3_ in (s1_, s2_), s1 in s3_

            if startswith(s1, '.') || !isone(count(isuppercase, s1))

                @info "🚨 $(joinpath(p2, s1))"

            end

            s2 = replace(
                s1,
                r"^\s+" => "",
                r"\s+$" => "",
                r"\s{2,}" => ' ',
                r"(?<=\d)th"i => "th",
                (
                    Regex(s3, "i") => s3 for s3 in
                        ("1st", "2nd", "3rd", "'d", "'m", "'re", "'s", "'ve")
                )...,
                (
                    Regex("(?<= )$s3(?= )", "i") => s3 for s3 in (
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

            if s1 != s2

                @info "📛 $p2\n$s1\n$s2"

            end

        end

    end

    return

end

const PA = pkgdir(He, "NAME.jl")

const IN = length(PA) + 2

function pair(st)

    return "NAME" => splitext(st)[1],
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

    for (p2, s1_, s2_) in walkdir(PA), s3_ in (s1_, s2_), st in s3_

        if st == "Manifest.toml"

            continue

        end

        p3 = joinpath(p2[IN:end], replace(st, pa_[1]))

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
