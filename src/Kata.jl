module Kata

using Comonicon: @main

function _shorten(pa, wo = pwd())

    pa[(lastindex(wo) + 2):end]

end

include("filesystem.jl")

include("git.jl")

include("template.jl")

"""
Command-line program for organizing the file system 🗄️✨
"""
@main

end
