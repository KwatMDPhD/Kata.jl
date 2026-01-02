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

    run(`find -E . -iregex ".*ds[ _]store" -delete`)

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

function lo(st, pa)

    ba = basename(pa)

    if !isempty(ba) && (startswith(ba, '.') || !isone(count(isuppercase, ba)))

        @info "$st$pa."

    end

end

"""
Name files automatically.

# Arguments

  - `style`: "code" | "human" | "datehuman"

# Flags

  - `--live`: = false
"""
@cast function name(style; live::Bool = false)

    @assert style == "code" || style == "human" || style == "datehuman"

    for (di, _, ba_) in walkdir()

        if contains(di, r"\.(Trash|git|tmp)")

            continue

        end

        if style == "human" || style == "datehuman"

            lo("🚨📁 ", Public.path_short(di))

        end

        if contains(di, r"\.(key|numbers|pages)")

            continue

        end

        for ba in ba_

            f1 = joinpath(di, ba)

            s1, ex = splitext(ba)

            s1 = Public.text_space(s1)

            in_ = findfirst(r"^[\d_ ]+", s1)

            s2, s3 = if isnothing(in_)

                "", s1

            else

                strip(s1[in_]), s1[(in_[end] + 1):end]

            end

            ex = lowercase(ex)

            if ex == ".jpeg"

                ex = ".jpg"

            end

            ch = if style == "code"

                s2 = Public.text_low(s2)

                s3 = Public.text_low(s3)

                '_'

            elseif style == "human" || style == "datehuman"

                s2 = Public.text_title(s2)

                if style == "datehuman" && (
                    ex == ".heic" ||
                    ex == ".jpg" ||
                    ex == ".png" ||
                    ex == ".mov" ||
                    ex == ".mp4"
                )

                    s4 = minimum(
                        replace(
                            rsplit(sp, '\t'; limit = 2)[2],
                            "00 00 00" => "__ __ __",
                        ) for sp in eachsplit(
                            readchomp(
                                `exiftool -tab -dateFormat "%Y %m %d %H %M %S" -CreateDate -CreationDate -DateCreated -DateTimeOriginal -FileModifyDate $f1`,
                            ),
                            '\n',
                        )
                    )

                    if isempty(s2) || s4 < s2

                        s2 = s4

                    end

                end

                s3 = Public.text_title(s3)

                lo("🚨📜 ", s3)

                ' '

            end

            if isempty(s2) || isempty(s3)

                ch = ""

            end

            f2 = joinpath(di, "$s2$ch$s3$ex")

            if f1 == f2

                continue

            end

            if live

                if lowercase(f1) == lowercase(f2)

                    f1 = mv(f1, "$(f2)_")

                end

                mv(f1, f2)

            end

            f1 = Public.path_short(f1)

            f2 = Public.path_short(f2)

            @info "📛\n$f1\n$f2"

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
            `xargs sed -i "" "s/$before/$after/g"`,
        ),
    )

end

"""
Beautify .jl, .sh, .json, .toml, .html, .md, and .lua.
"""
@cast function beautify()

    format(".")

    di = joinpath(readchomp(`brew --prefix`), "lib", "node_modules")

    run(
        pipeline(
            `find -E . -type f -regex ".*\.(sh|json|toml|html|md|lua)" -not -regex ".*(\\.git/.*|package\\.json|node_modules/.*|public/.*|Manifest\\.toml|ou/.*)" -print0`,
            `xargs -0 prettier --plugin $di/prettier-plugin-sh/lib/index.js --plugin $di/prettier-plugin-toml/lib/index.js --plugin $di/prettier-plugin-tailwindcss/dist/index.mjs --plugin $di/@prettier/plugin-lua/src/index.js --write`,
        ),
    )

end

function update(s1, ex)

    pw = pwd()

    for (di, _, _) in walkdir()

        if !isdir(joinpath(di, ".git"))

            continue

        end

        cd(di)

        s2 = Public.path_short(di, pw)

        @info "$s1 $s2"

        eval(ex)

    end

    cd(pw)

end

"""
git fetch, status, and diff.
"""
@cast function festdi()

    update("👉", quote

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

    update("👍", quote

        run(`git add -A`)

        me = $message

        if success(run(`git commit --message $me`; wait = false))

            run(`git push`)

        end

    end)

end

function path(pa)

    st = pa[(end - 1):end]

    pkgdir(Kata, "TEMPLATE.$st")

end

function make_pair(ba)

    uu = uuid4()

    "TEMPLATE" => ba[1:(end - 3)],
    "11111111-1111-1111-1111-111111111111" => "$uu",
    "AUTHOR" => readchomp(`git config user.name`)

end

"""
Make a package or project.

# Arguments

  - `name`: ".jl" | ".pr"
"""
@cast function make(name)

    cd(cp(path(name), joinpath(pwd(), name)))

    for (s1, s2) in make_pair(name)

        rename(s1, s2)

        rewrite(s1, s2)

    end

end

"""
Match a package to its template.
"""
@cast function match()

    pw = pwd()

    te = path(pw)

    pa_ = make_pair(basename(pw))

    nd = length(te) + 2

    for (di, b1_, b2_) in walkdir(te), ba_ in (b1_, b2_), ba in ba_

        @assert ispath(joinpath(di[nd:end], replace(ba, pa_...)))

    end

    de = '-' ^ 36

    de = "# $de #"

    bo_ = [true, false]

    for (pa, de, bo_) in (
        ("README.md", "---", [false, true]),
        (".gitignore", de, bo_),
        (joinpath("src", "TEMPLATE.jl"), de, bo_),
        (joinpath("test", "runtests.jl"), de, bo_),
    )

        s1_ = split(replace(read(joinpath(te, pa), String), pa_...), de)

        fi = joinpath(pw, replace(pa, pa_...))

        s2_ = split(read(fi, String), de)

        @assert length(s1_) == length(s2_)

        if map!(ifelse, s1_, bo_, s1_, s2_) == s2_

            continue

        end

        write(fi, join(s1_, de))

        fi = Public.path_short(fi)

        @info "🍡 $fi."

    end

end

@main

end
