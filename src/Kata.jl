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

  - `style`: "code" | "human" | "datehuman" | "date".

# Flags

  - `--live`: = false.
"""
@cast function name(style; live::Bool = false)

    re = r"\.(git|key|numbers|pages)$"

    for (di, _, ba_) in walkdir(pwd())

        if contains(di, re)

            continue

        end

        for ba in ba_

            f1 = joinpath(di, ba)

            sp, ex = splitext(ba)

            ex = lowercase(ex)

            if ex == ".jpeg"

                ex = ".jpg"

            end

            st = if style == "code"

                Nucleus.Tex.text_low(Nucleus.Tex.update_space(sp))

            elseif style == "human"

                Nucleus.Tex.update_space(Nucleus.Tex.text_title(sp))

            elseif style == "datehuman" || style == "date"

                da = ""

                if ex == ".png" ||
                   ex == ".heic" ||
                   ex == ".jpg" ||
                   ex == ".mov" ||
                   ex == ".mp4"

                    mi = minimum(
                        sp -> replace(
                            Nucleus.Strin.get_end(sp, '\t'),
                            "00 00 00" => "__ __ __",
                        ),
                        eachsplit(
                            readchomp(
                                `exiftool -tab -dateFormat "%Y %m %d %H %M %S" -FileModifyDate -DateCreated -DateTimeOriginal -CreateDate -CreationDate $f1`,
                            ),
                            '\n',
                        ),
                    )

                    if mi < sp[1:min(lastindex(sp), 19)]

                        da = mi

                    end

                end

                st = Nucleus.Tex.text_title(sp)

                if isempty(da)

                    st

                elseif style == "date"

                    da

                else

                    "$da $st"

                end

            end

            f2 = joinpath(di, "$st$ex")

            if f1 == f2

                continue

            end

            if live

                mv(lowercase(f1) == lowercase(f2) ? mv(f1, "$(f2)_") : f1, f2)

            end

            @info "$(Nucleus.Path.text(f1)) 🛸 $(Nucleus.Path.text(f2))."

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
        "build/.*",
        "output/.*",
        "Medicine\\.pr/.*",
        "gene_set/.*",
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

function update(ex)

    pw = pwd()

    for (di, ba_, _) in walkdir(pw)

        if !(".git" in ba_)

            continue

        end

        cd(di)

        @info "👉 $(Nucleus.Path.text(di, pw))."

        eval(ex)

        cd(pw)

    end

end

"""
git fetch, status, and diff.
"""
@cast function festdi()

    update(quote

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

    update(quote

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

    id = lastindex(te) + 2

    for (di, b1_, b2_) in walkdir(te), ba_ in (b1_, b2_), ba in ba_

        @assert ispath(joinpath(di[id:end], replace(ba, pa_...)))

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

        @info "🍡 Transplanted $(Nucleus.Path.text(f1))."

    end

end

@main

end
