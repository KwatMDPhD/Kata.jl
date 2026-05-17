module He

const P1 = pkgdir(He, "in")

const P2 = pkgdir(He, "ou")

# ---- #

using UUIDs: uuid4

function path(pa)

    return pa[(length(pwd()) + 2):end]

end

function name()

    for (p1, p1_, p2_) in walkdir()

        if contains(p1, ".git") ||
                contains(p1, ".key") ||
                contains(p1, ".numbers") ||
                contains(p1, ".pages")

            continue

        end

        p2 = path(p1)

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
                r"1st"i => "1st",
                r"2nd"i => "2nd",
                r"3rd"i => "3rd",
                r"'d"i => "'d",
                r"'m"i => "'m",
                r"'re"i => "'re",
                r"'s"i => "'s",
                r"'ve"i => "'ve",
                r"(?<= )a(?= )"i => 'a',
                r"(?<= )an(?= )"i => "an",
                r"(?<= )and(?= )"i => "and",
                r"(?<= )as(?= )"i => "as",
                r"(?<= )at(?= )"i => "at",
                r"(?<= )but(?= )"i => "but",
                r"(?<= )by(?= )"i => "by",
                r"(?<= )for(?= )"i => "for",
                r"(?<= )from(?= )"i => "from",
                r"(?<= )in(?= )"i => "in",
                r"(?<= )into(?= )"i => "into",
                r"(?<= )nor(?= )"i => "nor",
                r"(?<= )of(?= )"i => "of",
                r"(?<= )off(?= )"i => "off",
                r"(?<= )on(?= )"i => "on",
                r"(?<= )onto(?= )"i => "onto",
                r"(?<= )or(?= )"i => "or",
                r"(?<= )out(?= )"i => "out",
                r"(?<= )over(?= )"i => "over",
                r"(?<= )the(?= )"i => "the",
                r"(?<= )to(?= )"i => "to",
                r"(?<= )up(?= )"i => "up",
                r"(?<= )vs(?= )"i => "vs",
                r"(?<= )with(?= )"i => "with",
            )

            if p3 != p4

                @info "📛 $p2\n$p3\n$p4"

            end

        end

    end

    return

end

const P3 = pkgdir(He, "NAME.jl")

function write2(s1, s2)

    s3 = "s/$s1/$s2/g"

    run(pipeline(`find . -print0`, `xargs -0 rename $s3`))

    run(
        pipeline(
            `rg --no-ignore --files-with-matches $s1`,
            `xargs sed -i '' $s3`,
        ),
    )

    return

end

function make(name)

    cd(cp(P3, joinpath(pwd(), name)))

    write2("NAME", splitext(name)[1])

    write2("11111111-1111-1111-1111-111111111111", uuid4())

    write2("AUTHORS", readchomp(`git config user.name`))

    return

end

function write3(p1, s1)

    p2 = joinpath(pwd(), replace(p1, "NAME" => s1))

    s2 = read(p2, String)

    s3 = "$(replace(split(read(joinpath(P3, p1), String), "# ---- #"; limit = 2)[1], "NAME" => s1))# ---- #$(split(s2, "# ---- #"; limit = 2)[2])"

    if s2 == s3

        return

    end

    write(p2, s3)

    @info "🍡 $(path(p2))"

    return

end

function match()

    st = splitext(basename(pwd()))[1]

    nd = length(P3) + 2

    for (p1, p1_, p2_) in walkdir(P3), p3_ in (p1_, p2_), p2 in p3_

        if p2 == "Manifest.toml"

            continue

        end

        p3 = joinpath(p1[nd:end], replace(p2, "NAME" => st))

        @assert ispath(p3) p3

    end

    write3(".gitignore", st)

    write3(joinpath("src", "NAME.jl"), st)

    write3(joinpath("test", "runtests.jl"), st)

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
