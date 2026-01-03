module Kata

# ------------------------------------ #

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

using Public

"""
Delete bad files.
"""
@cast function delete()

    run(`find -E . -iregex '.*ds[ _]store' -delete`)

end

"""
Rename files and directories.

# Arguments

  - `before`:
  - `after`:
"""
@cast function rename(before, after)

    run(
        pipeline(
            `find . -print0`,
            `xargs -0 rename --subst-all $before $after`,
        ),
    )

end

function text_extension(s1)

    s2 = lowercase(s1)

    if s2 == "jpeg"

        "jpg"

    else

        s2

    end

end

function log(s1, pa)

    s2 = basename(pa)

    if startswith(s2, '.') || !isone(count(isuppercase, s2))

        @info "$s1$pa."

    end

end

"""
Name files automatically.

# Flags

  - `--live`: = false
"""
@cast function name(; live::Bool = false)

    for (p1, _, st_) in walkdir()

        if contains(p1, ".tmp") ||
           contains(p1, ".Trash") ||
           contains(p1, ".git")

            continue

        end

        log("🚨📁 ", Public.path_short(p1))

        if contains(p1, ".key") ||
           contains(p1, ".numbers") ||
           contains(p1, ".pages")

            continue

        end

        for s1 in st_

            p2 = joinpath(p1, s1)

            s2, s3 = splitext(Public.text_space(s1))

            in_ = findfirst(r"^[\d ]+", s2)

            s4, s5 = if isnothing(in_)

                "", s2

            else

                strip(s2[in_]), s2[(in_[end] + 1):end]

            end

            s6 = text_extension(s3)

            if s6 == ".heic" ||
               s6 == ".jpg" ||
               s6 == ".png" ||
               s6 == ".mov" ||
               s6 == ".mp4"

                s7 = minimum(
                    replace(
                        rsplit(s9, '\t'; limit = 2)[2],
                        "00 00 00" => "__ __ __",
                    ) for s9 in eachsplit(
                        readchomp(
                            `exiftool -tab -dateFormat '%Y %m %d %H %M %S' -CreateDate -CreationDate -DateCreated -DateTimeOriginal -FileModifyDate $p2`,
                        ),
                        '\n',
                    )
                )

                if isempty(s4) || s7 < s4

                    s4 = s7

                end

            end

            s8 = if isempty(s4) || isempty(s5)

                ""

            else

                ' '

            end

            p3 = joinpath(p1, "$s4$s8$s5$s6")

            log("🚨📜 ", p3)

            if p2 == p3

                continue

            end

            if live

                p4 = if lowercase(p2) == lowercase(p3)

                    mv(p2, "$(p3)_")

                else

                    p2

                end

                mv(p4, p3)

            end

            p5 = Public.path_short(p4)

            p6 = Public.path_short(p3)

            @info "📛\n$p5\n$p6"

        end

    end

end

"""
Rewrite files.

# Arguments

  - `before`:
  - `after`:
"""
@cast function rewrite(before, after)

    run(
        pipeline(
            `rg --no-ignore --files-with-matches $before`,
            `xargs sed -i '' 's/$before/$after/g'`,
        ),
    )

end

"""
Beautify .jl, .json, .html, .md, .sh, .toml, and .lua.
"""
@cast function beautify()

    format(".")

    pa = joinpath(readchomp(`brew --prefix`), "lib", "node_modules")

    run(
        pipeline(
            `find -E . -type f -regex '.*\.(json|html|md|sh|toml|lua)' ! -regex '.*/(\.git|node_modules|public|ou)/.*' ! -regex '.*/(package\.json|Manifest\.toml)$' -print0`,
            `xargs -0 prettier --plugin $pa/prettier-plugin-sh/lib/index.js --plugin $pa/prettier-plugin-toml/lib/index.js --plugin $pa/prettier-plugin-tailwindcss/dist/index.mjs --plugin $pa/@prettier/plugin-lua/src/index.js --write`,
        ),
    )

end

function update(s1, ex)

    p1 = pwd()

    for (p2, _, _) in walkdir()

        if !isdir(joinpath(p2, ".git"))

            continue

        end

        cd(p2)

        p3 = Public.path_short(p2, p1)

        @info "$s1 $p3"

        eval(ex)

    end

    cd(p1)

end

"""
git fetch, status, and diff.
"""
@cast function festdi()

    update("🪞", quote

        run(`git fetch`)

        run(`git status`)

        run(`git diff`)

    end)

end

"""
git add, commit, and push.

# Arguments

  - `message`:
"""
@cast function adcopu(message)

    update("👾", quote

        run(`git add -A`)

        me = $message

        if success(run(`git commit --message $me`; wait = false))

            run(`git push`)

        end

    end)

end

const PA = pkgdir(Kata, "TEMPLATE.jl")

function make_pair(st)

    uu = uuid4()

    "TEMPLATE" => st[1:(end - 3)],
    "11111111-1111-1111-1111-111111111111" => "$uu",
    "AUTHOR" => readchomp(`git config user.name`)

end

"""
Make a package.

# Arguments

  - `name`: ".jl"
"""
@cast function make(name)

    cd(cp(PA, joinpath(pwd(), name)))

    for (s1, s2) in make_pair(name)

        rename(s1, s2)

        rewrite(s1, s2)

    end

end

"""
Match a package to its template.
"""
@cast function match()

    p1 = pwd()

    pa_ = make_pair(basename(p1))

    nd = length(PA) + 2

    for (p2, s1_, s2_) in walkdir(PA), s3_ in (s1_, s2_), s2 in s3_

        @assert ispath(joinpath(p2[nd:end], replace(s2, pa_...)))

    end

    s1 = "# ------------------------------------ #"

    bo_ = [true, false]

    for (p2, s2, bo_) in (
        ("README.md", "---", [false, true]),
        (".gitignore", s1, bo_),
        (joinpath("src", "TEMPLATE.jl"), s1, bo_),
        (joinpath("test", "runtests.jl"), s1, bo_),
    )

        s1_ = split(replace(read(joinpath(PA, p2), String), pa_...), s2)

        p3 = joinpath(p1, replace(p2, pa_...))

        s2_ = split(read(p3, String), s2)

        @assert length(s1_) == length(s2_)

        if map!(ifelse, s1_, bo_, s1_, s2_) == s2_

            continue

        end

        write(p3, join(s1_, s2))

        p4 = Public.path_short(p3)

        @info "🍡 $p4."

    end

end

@main

end
