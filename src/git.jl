using Comonicon: @cast

"""
`git` `fetch`, `status`, and `diff`.
"""
@cast function festdi()

    wo = pwd()

    for (ro, di_, fi_) in walkdir(wo)

        if !(".git" in di_)

            continue

        end

        cd(ro)

        @info "📍 $(_shorten(ro, wo))"

        run(`git fetch`)

        run(`git status`)

        run(`git diff`)

        cd(wo)

    end

end

"""
`git` `add`, `commit`, and `push`.

# Arguments

  - `message`:
"""
@cast function adcopu(message)

    wo = pwd()

    for (ro, di_, fi_) in walkdir(wo)

        if !(".git" in di_)

            continue

        end

        cd(ro)

        @info "📍 $(_shorten(ro, wo))"

        run(`git add -A`)

        if success(run(`git commit -m $message`; wait = false))

            run(`git push`)

        end

        cd(wo)

    end

end
