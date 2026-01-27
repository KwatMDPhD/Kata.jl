module Kata

const P1 = pkgdir(Kata, "in")

const P2 = pkgdir(Kata, "ou")

# ------------------------------------ #

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

########################################

function text(st, pa_)

    for pa in pa_

        st = replace(st, pa)

    end

    st

end

########################################

"""
"""
@cast function delete()

    run(`find . -name .DS_Store -delete`)

end

########################################

"""
"""
@cast function rename(before, after)

    run(
        pipeline(
            `find . -print0`,
            `xargs -0 rename --subst-all $before $after`,
        ),
    )

end

function log(s1, an)

    s2 = basename(an)

    if startswith(s2, '.') || !isone(count(isuppercase, s2))

        @info "🚨 $s1 $an"

    end

end

"""
"""
@cast function name(; live::Bool = false)

    nd = length(pwd()) + 2

    for (p1, _, st_) in walkdir()

        if contains(p1, ".tmp") ||
           contains(p1, ".Trash") ||
           contains(p1, ".git")

            continue

        end

        log("📁", p1[nd:end])

        if contains(p1, ".key") ||
           contains(p1, ".numbers") ||
           contains(p1, ".pages")

            continue

        end

        for s1 in st_

            p2 = joinpath(p1, s1)

            s2, s3 = splitext(strip(replace(s1, r"\s+" => ' ')))

            in_ = findfirst(r"^[\d\s]+", s2)

            s4, s5 = if isnothing(in_)

                "", s2

            else

                rstrip(s2[in_]), s2[(in_[end] + 1):end]

            end

            s3 = lowercase(s3)

            if s3 == ".jpeg"

                s3 = ".jpg"

            end

            if s3 == ".heic" ||
               s3 == ".jpg" ||
               s3 == ".png" ||
               s3 == ".mov" ||
               s3 == ".mp4"

                s6 = minimum(
                    # TODO: Use julia package
                    replace(rsplit(s7, '\t'; limit = 2)[2], "00 00 00" => '_') for s7 in eachsplit(
                        readchomp(
                            `exiftool -tab -dateFormat '%Y %m %d %H %M %S' -CreateDate -CreationDate -DateCreated -DateTimeOriginal -FileModifyDate $p2`,
                        ),
                        '\n',
                    )
                )

                if isempty(s4) || s6 < s4

                    s4 = s6

                end

            end

            s5 = uppercasefirst(s5)

            for pa_ in (
                ('_' => ' ', r"(?<=\d)th"i => "th"),
                (
                    Regex(s7, "i") => s7 for
                    s7 in ("1st", "2nd", "3rd", "'d", "'m", "'re", "'s", "'ve")
                ),
                (
                    Regex("(?<= )$s7(?= )", "i") => s7 for s7 in (
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
                ),
            )

                s5 = text(s5, pa_)

            end

            an = if isempty(s4) || isempty(s5)

                ""

            else

                ' '

            end

            p3 = joinpath(p1, "$s4$an$s5$s3")

            log("📜", p3)

            if p2 == p3

                continue

            end

            if live

                mv(mv(p2, "$(p3)_"), p3)

            end

            @info "📛\n$(p2[nd:end])\n$(p3[nd:end])"

        end

    end

end

########################################

"""
"""
@cast function rewrite(before, after)

    run(
        pipeline(
            `rg --no-ignore --files-with-matches $before`,
            `xargs sed -i '' "s/$before/$after/g"`,
        ),
    )

end

"""
"""
@cast function beautify()

    format(".")

    pa = joinpath(readchomp(`brew --prefix`), "lib", "node_modules")

    run(
        pipeline(
            `find -E . -type f -regex '.*\.(json|html|md|sh|toml|lua)' ! -regex '.*/(\.git|node_modules|public|ou)/.*' ! -regex '.*/(package\.json|Manifest\.toml|msigdb.*\.json)' -print0`,
            `xargs -0 prettier --plugin $pa/prettier-plugin-tailwindcss/dist/index.mjs --plugin $pa/prettier-plugin-sh/lib/index.js --plugin $pa/prettier-plugin-toml/lib/index.js --plugin $pa/@prettier/plugin-lua/src/index.js --write`,
        ),
    )

end

########################################

const PA = pkgdir(Kata, "TEMPLATE.jl")

const IN = length(PA) + 2

function pair(st)

    uu = uuid4()

    "TEMPLATE" => st[1:(end - 3)],
    "11111111-1111-1111-1111-111111111111" => "$uu",
    "AUTHOR" => readchomp(`git config user.name`)

end

"""
"""
@cast function make(name)

    cd(cp(PA, joinpath(pwd(), name)))

    for (s1, s2) in pair(name)

        rename(s1, s2)

        rewrite(s1, s2)

    end

end

const ST = "# ------------------------------------ " * '#'

const BO_ = [true, false]

"""
"""
@cast function match()

    p1 = pwd()

    pa_ = pair(basename(p1))

    for (p2, s1_, s2_) in walkdir(PA), s3_ in (s1_, s2_), st in s3_

        @assert st == "Manifest.toml" ||
                ispath(joinpath(p2[IN:end], text(st, pa_))) st

    end

    for (an, st, bo_) in (
        ("README.md", "---", [false, true]),
        (".gitignore", ST, BO_),
        (joinpath("src", "TEMPLATE.jl"), ST, BO_),
        (joinpath("test", "runtests.jl"), ST, BO_),
    )

        s1_ = split(text(read(joinpath(PA, an), String), pa_), st)

        p2 = joinpath(p1, text(an, pa_))

        s2_ = split(read(p2, String), st)

        @assert length(s1_) == length(s2_) p2

        if map!(ifelse, s1_, bo_, s1_, s2_) == s2_

            continue

        end

        write(p2, join(s1_, st))

        @info "🍡 $(p2[(length(p1) + 2):end])"

    end

end

########################################

function read2(st, ex)

    p1 = pwd()

    for (p2,) in walkdir()

        if !isdir(joinpath(p2, ".git"))

            continue

        end

        cd(p2)

        @info "$st $(p2[(length(p1) + 2):end])"

        eval(ex)

    end

    cd(p1)

end

"""
"""
@cast function fsd()

    read2("🪞", quote

        run(`git fetch`)

        run(`git status`)

        run(`git diff`)

    end)

end

"""
"""
@cast function acp(message)

    read2("👾", quote

        run(`git add -A`)

        st = $message

        if success(`git commit --message $st`)

            run(`git push`)

        end

    end)

end

@main

end
