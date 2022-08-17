function include_neighbor(fi)

    di, fi = splitdir(fi)

    for na in readdir(di)

        if !endswith(na, ".jl") || (na == fi)

            continue

        end

        include(na)

    end

end
