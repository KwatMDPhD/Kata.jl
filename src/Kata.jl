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

  - `style`: "code" | "human" | "date" | "datehuman".

# Flags

  - `--live`: = false.
"""
@cast function name(style; live::Bool = false)

    d1 = pwd()

    re = r"\.(git|key|numbers|pages)$"

    for (d2, _, ba_) in walkdir(d1)

        if contains(d2, re)

            continue

        end

        for ba in ba_

            f1 = joinpath(d2, ba)

            p1, ex = splitext(ba)

            ex = lowercase(ex)

            if ex == ".jpeg"

                ex = ".jpg"

            end

            p2 = if style == "code"

                Nucleus.Tex.make_low(Nucleus.Tex.update_space(p1))

            elseif style == "human"

                Nucleus.Tex.update_space(Nucleus.Tex.make_title(p1))

            elseif style == "date" || style == "datehuman"

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

                    if mi < p1[1:min(lastindex(p1), 19)]

                        da = mi

                    end

                end

                te = Nucleus.Tex.make_title(p1)

                if isempty(da)

                    te

                elseif style == "date"

                    da

                else

                    "$da $te"

                end

            end

            f2 = joinpath(d2, "$p2$ex")

            if f1 == f2

                continue

            end

            if live

                mv(lowercase(f1) == lowercase(f2) ? mv(f1, "$(f2)_") : f1, f2)

            end

            @info "$(Nucleus.Path.text(f1, d1)) 🛸 $(Nucleus.Path.text(f2, d1))."

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

    ar_ = String[]

    for re in (
        "\\.git/.*",
        "package\\.json",
        "node_modules/.*",
        "public/.*",
        "build/.*",
        "output/.*",
        "Medicine\\.pr/.*",
        "gene_set/.*",
    )

        push!(ar_, "-not")

        push!(ar_, "-regex")

        push!(ar_, ".*$re")

    end

    pr = joinpath(readchomp(`brew --prefix`), "lib", "node_modules", "prettier-plugin-")

    run(
        pipeline(
            `find -E . -type f -regex ".*\.(json|html|md)" $ar_ -print0`,
            `xargs -0 prettier --plugin $(pr)tailwindcss/dist/index.mjs --write`,
        ),
    )

end

function update(ex)

    d1 = pwd()

    for (d2, ba_, _) in walkdir(d1)

        if !(".git" in ba_)

            continue

        end

        cd(d2)

        @info "📍 $(Nucleus.Path.text(d2, d1))."

        eval(ex)

        cd(d1)

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

        # TODO
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
    "26e7aedd-919a-4e26-a588-02a954578843" => string(uuid4()),
    "AUTHOR" => readchomp(`git config user.name`)

end

"""
Make a package or project.

# Arguments

  - `name`: ".jl" | ".pr".
"""
@cast function make(name)

    cd(cp(path(name), joinpath(pwd(), name)))

    for (be, af) in make_pair(name)

        rename(be, af)

        rewrite(be, af)

    end

end

"""
Match a package to its template.
"""
@cast function match()

    d1 = pwd()

    d2 = path(d1)

    pa_ = make_pair(basename(d1))

    id = lastindex(d2) + 2

    for (d3, b1_, b2_) in walkdir(d2), ba_ in (b1_, b2_), ba in ba_

        @assert ispath(joinpath(d3[id:end], replace(ba, pa_...)))

    end

    de = "# $('-'^95) #"

    for (f2, de, bo_) in (
        ("README.md", "---", [false, true]),
        (".gitignore", de, [true, false]),
        (joinpath("src", "TEMPLATE.jl"), de, [true, false]),
        (joinpath("test", "runtests.jl"), de, [true, false]),
    )

        f1 = joinpath(d1, replace(f2, pa_...))

        s1_ = split(read(f1, String), de)

        s2_ = split(replace(read(joinpath(d2, f2), String), pa_...), de)

        @assert lastindex(s1_) == lastindex(s2_)

        if s1_ == map!(ifelse, s2_, bo_, s2_, s1_)

            continue

        end

        write(f1, join(s2_, de))

        @info "🍡 Transplanted $(Nucleus.Path.text(f1, d1))."

    end

end

"""
"""
@main

end
