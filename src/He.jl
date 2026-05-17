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

function make(pa)

    cd(cp(P3, pa))

    mv(joinpath("src", "NAME.jl"), joinpath("src", pa))

    st = readchomp(`git config user.name`)

    run(
        pipeline(
            `find . -type f -print0`,
            `xargs -0 sed -i '' -e s/NAME/$(splitext(pa)[1])/g -e s/11111111-1111-1111-1111-111111111111/$(uuid4())/g -e s/AUTHORS/$st/g`,
        ),
    )

    return

end

function write2(fu, p1, p2)

    s1 = read(p2, String)

    s2 = "$(fu(split(read(p1, String), "# ---- #"; limit = 2)[1]))# ---- #$(split(s1, "# ---- #"; limit = 2)[2])"

    if s1 != s2

        write(p2, s2)

        @info "🍡 $(path(p2))"

    end

    return

end

function match()

    p1 = basename(pwd())

    pa = "NAME" => splitext(p1)[1]

    nd = length(P3) + 2

    for (p2, p1_, p2_) in walkdir(P3), p3_ in (p1_, p2_), p3 in p3_

        if p3 == "Manifest.toml"

            continue

        end

        p4 = joinpath(p2[nd:end], replace(p3, pa))

        @assert ispath(p4) p4

    end

    write2(identity, joinpath(P3, ".gitignore"), ".gitignore")

    write2(
        st -> replace(st, pa),
        joinpath(P3, "src", "NAME.jl"),
        joinpath("src", p1),
    )

    write2(
        st -> replace(st, pa),
        joinpath(P3, "test", "runtests.jl"),
        joinpath("test", "runtests.jl"),
    )

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
