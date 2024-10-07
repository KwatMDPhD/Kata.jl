Command-line program for organizing the file system 🗄️✨

![Help](media/help.png)

## Install

#### 1. Download

```bash
git clone https://github.com/KwatMDPhD/Kata.jl
```

#### 2. Instantiate

```bash
cd Kata.jl &&

julia --project --eval "using Pkg; Pkg.instantiate()"
```

#### 3. Build

```bash
julia --project deps/build.jl
```

#### 4. Path

```bash
PATH=~/.julia/bin:$PATH
```

#### 5. Use

```bash
kata --help
```

## Useful

```bash
kata remove && kata format && for jl in *jl; do echo $jl; cd $jl; kata reset; julia --project --eval "using Pkg; Pkg.update()"; cd ..; done && kata diff; kata push "Commit message."
```

🎊

---

Made by [Kata](https://github.com/KwatMDPhD/Kata.jl) 🥋
