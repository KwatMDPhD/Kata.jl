When cleaning `.ipynb`, `clean-jl` removes empty cells, clears outputs, and formats code using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl).

## Use

```bash
clean-jl luffy.jl
```

```bash
clean-jl zoro.ipynb
```

```bash
clean-jl nami.jl usopp.ipynb
```

```bash
find -E . -regex ".*/*\.(jl|ipynb)" -type f -print0 | xargs -0 clean-jl
```

## Install

```bash
git clone https://github.com/KwatMDPhD/Clean.jl &&

cd Clean.jl &&

julia --project --eval "using Pkg; Pkg.instantiate()" &&

julia --project deps/build.jl
```

:point_up: commands install `clean-jl` into `~/.julia/bin`.

If not already, add the `bin` to the path by adding :point_down: to the profile (`~/.zshrc`, `~/.rc`, ...)

```bash
PATH=~/.julia/bin:$PATH
```

Start a new shell to load the updated profile.

Test installation

```bash
clean-jl --version
```

:tada:

---

## :wave: :cowboy_hat_face: Howdy

To report a bug, request a feature, or leave a comment, just [submit an issue](https://github.com/KwatMDPhD/Clean.jl/issues/new/choose).

Powered by https://github.com/KwatMDPhD/Kata.jl
