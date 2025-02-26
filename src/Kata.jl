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

    di = pwd()

    r1 = r"\.(git|key|numbers|pages)$"

    r2 = r"\.(png|heic|jpg|mov|mp4)$"

    for (ro, _, fi_) in walkdir(di)

        if contains(ro, r1)

            continue

        end

        for fi in fi_

            p1 = joinpath(ro, fi)

            pr, ex = splitext(fi)

            ex = lowercase(ex)

            if ex == ".jpeg"

                ex = ".jpg"

            end

            p2 = joinpath(
                ro,
                if style == "code"

                    "$(Nucleus.Tex.make_low(Nucleus.Tex.update_space(pr)))$ex"

                elseif style == "human"

                    "$(Nucleus.Tex.update_space(Nucleus.Tex.make_title(pr)))$ex"

                elseif style == "date" || style == "datehuman"

                    da = ""

                    if contains(ex, r2)

                        mi = minimum(
                            li -> replace(
                                Nucleus.Strin.get_end(li, '\t'),
                                "00 00 00" => "__ __ __",
                            ),
                            eachsplit(
                                readchomp(
                                    `exiftool -tab -dateFormat "%Y %m %d %H %M %S" -FileModifyDate -DateCreated -DateTimeOriginal -CreateDate -CreationDate $p1`,
                                ),
                                '\n',
                            ),
                        )

                        if mi < pr[1:min(lastindex(pr), 19)]

                            da = mi

                        end

                    end

                    te = Nucleus.Tex.make_title(pr)

                    if isempty(da)

                        "$te$ex"

                    elseif style == "date"

                        "$da$ex"

                    else

                        "$da $te$ex"

                    end

                end,
            )

            if p1 == p2

                continue

            end

            if live

                mv(lowercase(p1) == lowercase(p2) ? mv(p1, "$(p2)_") : p1, p2)

            end

            @info "$(Nucleus.Path.text(p1, di)) 🛸 $(Nucleus.Path.text(p2, di))."

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

    for r2 in (
        "\\.git/.*",
        "package\\.json",
        "node_modules/.*",
        "public/.*",
        "Manifest\\.toml",
        "Project\\.toml",
        "output/.*",
        "Medicine\\.pr/.*",
        "gene_set/.*",
    )

        push!(ar_, "-not")

        push!(ar_, "-regex")

        push!(ar_, ".*$r2")

    end

    pr = joinpath(readchomp(`brew --prefix`), "lib", "node_modules", "prettier-plugin-")

    run(
        pipeline(
            `find -E . -type f -regex ".*\.(json|yaml|toml|html|md)" $ar_ -print0`,
            `xargs -0 prettier --plugin $(pr)toml/lib/index.js --plugin $(pr)tailwindcss/dist/index.mjs --write`,
        ),
    )

end

function _git(ex)

    di = pwd()

    for (ro, di_, _) in walkdir(di)

        if !(".git" in di_)

            continue

        end

        cd(ro)

        @info "📍 $(Nucleus.Path.text(ro, di))."

        eval(ex)

        cd(di)

    end

end

"""
git fetch, status, and diff.
"""
@cast function festdi()

    _git(quote

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

    _git(quote

        run(`git add -A`)

        me = $message

        if success(run(`git commit -m $me`; wait = false))

            run(`git push`)

        end

    end)

end

function _template(ba)

    pkgdir(Kata, "TEMPLATE.$(ba[(end - 1):end])")

end

function _plan_replacement(ba)

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

    di = pwd()

    cd(cp(_template(name), joinpath(di, name)))

    for (be, af) in _plan_replacement(name)

        rename(be, af)

        rewrite(be, af)

    end

end

"""
Match a package to its template.
"""
@cast function match()

    d1 = pwd()

    d2 = _template(d1)

    re_ = _plan_replacement(basename(d1))

    id = lastindex(d2) + 2

    for (ro, di_, fi_) in walkdir(d2), ba_ in (di_, fi_), ba in ba_

        @assert ispath(joinpath(ro[id:end], replace(ba, re_...)))

    end

    e1 = "# $('-'^95) #"

    for (fi, e2, bo_) in (
        ("README.md", "---", [false, true]),
        (".gitignore", e1, [true, false]),
        (joinpath("src", "TEMPLATE.jl"), e1, [true, false]),
        (joinpath("test", "runtests.jl"), e1, [true, false]),
    )

        p1 = joinpath(d1, replace(fi, re_...))

        s1_ = split(read(p1, String), e2)

        s2_ = split(replace(read(joinpath(d2, fi), String), re_...), e2)

        @assert lastindex(s1_) == lastindex(s2_)

        s3_ = map(ifelse, bo_, s2_, s1_)

        if s1_ == s3_

            continue

        end

        write(p1, join(s3_, e2))

        @info "🍡 Transplanted $(Nucleus.Path.text(p1, d1))."

    end

end

"""
"""
@main

end
