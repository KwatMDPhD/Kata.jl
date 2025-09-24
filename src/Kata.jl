module Kata

# ----------------------------------------------------------------------------------------------- #

using Comonicon: @cast, @main

using JuliaFormatter: format

using UUIDs: uuid4

using Nucleus

"""
Delete bad files.
"""
@cast function delete()

    run(`find -E . -iregex ".*\.ds[_ ]store" -delete`)

end

"""
Rename files and directories.

# Arguments

  - `before`:
  - `after`:
"""
@cast function rename(before, after)

    run(pipeline(`find . -print0`, `xargs -0 rename --subst-all $before $after`))

end

"""
Name files automatically.

# Arguments

  - `style`: "code" | "human"

# Flags

  - `--live`: = false.
"""
@cast function name(style; live::Bool = false)

    for (di, _, ba_) in walkdir(pwd())

        if contains(di, r"\.(git|key|numbers|pages)(/|$)")

            continue

        end

        for b1 in ba_

            f1 = joinpath(di, b1)

            s1, e1 = splitext(Nucleus.Tex.text_strip(b1))

            in_ = findfirst(r"^[\d_ ]+", s1)

            s2, s3 = isnothing(in_) ? ("", s1) : (s1[in_], s1[(in_[end] + 1):end])

            s4 = endswith(s2, r"[_ ]") ? s2[1:(end - 1)] : s2

            e2 = lowercase(e1)

            e3 = e2 == ".jpeg" ? ".jpg" : e2

            s5, ch, s6 = if style == "code"

                Nucleus.Tex.text_low(s4), '_', Nucleus.Tex.text_low(s3)

            elseif style == "human"

                if e3 == ".png" ||
                   e3 == ".heic" ||
                   e3 == ".jpg" ||
                   e3 == ".mov" ||
                   e3 == ".mp4"

                    s5 = minimum(
                        replace(Nucleus.Strin.get_end(s5, '\t'), "00 00 00" => "__ __ __") for s5 in eachsplit(
                            readchomp(
                                `exiftool -tab -dateFormat "%Y %m %d %H %M %S" -FileModifyDate -DateCreated -DateTimeOriginal -CreateDate -CreationDate $f1`,
                            ),
                            '\n',
                        )
                    )

                    isempty(s4) || s5 < s4 ? s5 : s4

                else

                    s4

                end,
                ' ',
                Nucleus.Tex.text_title(s3)

            end

            b2 = "$s5$(isempty(s5) || isempty(s6) ? "" : ch)$s6$e3"

            if b1 == b2

                continue

            end

            f2 = joinpath(di, b2)

            em = b2[1] == '.' || 1 < count(isuppercase, b2) ? "🚨" : "🛸"

            if live

                mv(lowercase(f1) == lowercase(f2) ? mv(f1, "$(f2)_") : f1, f2)

            end

            @info "$(Nucleus.Path.text(f1)) $em $(Nucleus.Path.text(f2))."

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
Beautify .jl and web files.
"""
@cast function beautify()

    format(".")

    st_ = String[]

    for st in (
        "\\.git/.*",
        "package\\.json",
        "node_modules/.*",
        "public/.*",
        "Manifest\\.toml",
        "ou/.*",
    )

        push!(st_, "-not")

        push!(st_, "-regex")

        push!(st_, ".*$st")

    end

    no = joinpath(readchomp(`brew --prefix`), "lib", "node_modules")

    run(
        pipeline(
            `find -E . -type f -regex ".*\.(json|toml|html|md|sh|lua)" $st_ -print0`,
            `xargs -0 prettier \
    --plugin $no/prettier-plugin-toml/lib/index.js \
    --plugin $no/prettier-plugin-tailwindcss/dist/index.mjs \
    --plugin $no/prettier-plugin-sh/lib/index.js \
    --plugin $no/@prettier/plugin-lua/src/index.js \
    --write`,
        ),
    )

end

function update(st, ex)

    pw = pwd()

    for (di, ba_, _) in walkdir(pw)

        if !(".git" in ba_)

            continue

        end

        cd(di)

        @info "$st $(Nucleus.Path.text(di, pw))"

        eval(ex)

        cd(pw)

    end

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

    pkgdir(Kata, "TEMPLATE.$(pa[(end - 1):end])")

end

function make_pair(ba)

    "TEMPLATE" => ba[1:(end - 3)],
    "26e7aedd-919a-4e26-a588-02a954578843" => "$(uuid4())",
    "AUTHOR" => readchomp(`git config user.name`)

end

"""
Make a package or project.

# Arguments

  - `name`: ".jl" | ".pr".
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

    nd = lastindex(te) + 2

    for (di, b1_, b2_) in walkdir(te), ba_ in (b1_, b2_), ba in ba_

        @assert ispath(joinpath(di[nd:end], replace(ba, pa_...)))

    end

    de = "# $('-'^95) #"

    for (f2, de, bo_) in (
        ("README.md", "---", [false, true]),
        (".gitignore", de, [true, false]),
        (joinpath("src", "TEMPLATE.jl"), de, [true, false]),
        (joinpath("test", "runtests.jl"), de, [true, false]),
    )

        f1 = joinpath(pw, replace(f2, pa_...))

        s1_ = split(read(f1, String), de)

        s2_ = split(replace(read(joinpath(te, f2), String), pa_...), de)

        @assert lastindex(s1_) == lastindex(s2_)

        if s1_ == map!(ifelse, s2_, bo_, s2_, s1_)

            continue

        end

        write(f1, join(s2_, de))

        @info "🍡 $(Nucleus.Path.text(f1))."

    end

end

@main

end
