using Comonicon: @cast

function _git(ex)

    wo = pwd()

    for (ro, di_, fi_) in walkdir(wo)

        if !(".git" in di_)

            continue

        end

        cd(ro)

        @info "📍 $(Omics.Path.shorten(ro, wo))"

        eval(ex)

        cd(wo)

    end

end

"""
`git` `fetch`, `status`, and `diff`.
"""
@cast function festdi()

    _git(quote

        run(`git fetch`)

        run(`git status`)

        run(`git diff`)

    end)

end

"""
`git` `add`, `commit`, and `push`.
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
