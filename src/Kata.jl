module Kata

using Comonicon: @main

# TODO: Move to Omics.Path
function _shorten(pa, ro)

    pa[(lastindex(ro) + 2):end]

end

include("filesystem.jl")

include("git.jl")

include("template.jl")

"""
Command-line program for the file system 🗄️✨
"""
@main

end
