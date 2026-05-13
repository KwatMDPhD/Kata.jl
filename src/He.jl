module He

const P1 = pkgdir(He, "in")

const P2 = pkgdir(He, "ou")

# ---- #

using UUIDs: uuid4

function name()

    for (p1, s1_, s2_) in walkdir()

        if contains(p1, ".git") ||
                contains(p1, ".key") ||
                contains(p1, ".numbers") ||
                contains(p1, ".pages")

            continue

        end

        p2 = p1[(lenght(p1) + 2):end]

        for s3_ in (s1_, s2_), s1 in s3_

            if startswith(s1, '.') || !isone(count(isuppercase, s1))

                @info "🚨 $p2 $s1"

            end

            s2 = replace(
                s1, r"^\s+" => "",
                r"\s+$" => "",
                r"\s{2,}" => ' ',
                r"(?<=\d)th"i => "th",
                (Regex(s3, "i") => s3 for s3 in ("1st", "2nd", "3rd", "'d", "'m", "'re", "'s", "'ve"))...,
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
                )...
            )

            if s1 != s2

                @info "🚨 $p2\n$s1\n$s2"

            end

        end

    end

    return

end

const PA = pkgdir(He, "NAME.jl")

function pair(st)

    return "NAME" => splitext(st)[1], "UUID" => "$(uuid4())", "AUTHORS" => readchomp(`git config user.name`)

end

function make(name)

    cd(cp(PA, joinpath(pwd(), name)))

    for (s1, s2) in pair(name)

        run(
            pipeline(
                `find . -print0`,
                `xargs -0 rename --subst-all $s1 $s2`,
            ),
        )

        run(
            pipeline(
                `rg --no-ignore --files-with-matches $s1`,
                `xargs sed -i '' "s/$s1/$s2/g"`,
            ),
        )

    end

    return

end

function match()

    p1 = pwd()

    pa_ = pair(basename(p1))

    nd = length(PA) + 2

    for (p2, s1_, s2_) in walkdir(PA), s3_ in (s1_, s2_), st in s3_

        @assert st == "Manifest.toml" ||
            ispath(joinpath(p2[nd:end], replace(st, pa_[1]))) st

    end

    for p2 in (
            ".gitignore",
            joinpath("src", "NAME.jl"),
            joinpath("test", "runtests.jl"),
        )

        p3 = joinpath(p1, replace(p2, pa_[1]))

        s1 = read(joinpath(PA, p2), String)

        s2 = read(p3, String)

        s3 = join((split(s1; limit = 2)[1], split(s2; limit = 2)[2]), "# ---- #")

        if s2 == s3

            continue

        end

        write(p3, s3)

        @info "🍡 $(p3[(length(p1) + 2):end])"

    end

    return

end

function (@main)(ARGS)

    @info ARGS

    st = ARGS[1]

    if st == "name"

        name()

    elseif st == "make"

        make(ARGS[2])

    elseif st == "match"

        match()

    end

end

end
