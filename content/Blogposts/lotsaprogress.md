---
title: "Lots of GSoC Progress"
date: 2017-08-10T23:25:03+02:00
draft: false
---

Alright, it’s been ages since my latest blogpost, and lots has happened in the meantime:
![search](/img/Blogposts/lotsaprogress/search.png)

That’s the current state of Juno’s fancy new search pane. You can search docstrings in all currently loaded modules (or just in all installed modules), which will be fully rendered (yay $\KaTeX$, yay syntax highlighting). Links are mostly functional: Those with Documenter.jl’s `@ref` syntax will start a new search, others will just open their target in your default browser.

Clicking on the function name will bring you to the definition in the source code (mostly…), clicking on the module name in the upper right will open an overview over the module/package.

## Installation

For those of you who like to live on the bleeding edge, here is how to get the new goodies (if you already have a working Juno installation):
```
# clone Julia packages
julia> Pkg.clone("https://github.com/pfitzseb/DocSeeker.jl")
julia> Pkg.checkout("StringDistances")
julia> Pkg.checkout("Atom", "sp/docpane")
# clone, install, and link Atom packages
git clone git@github.com:JunoLab/atom-julia-client.git
cd atom-julia-client
git checkout sp/docpane
apm install
apm link -d
cd ..
git clone git@github.com:JunoLab/atom-ink.git
cd ./atom-ink
git checkout sp/docpane
apm install
apm link -d
# start with `-d` for the new functionality and without to get the latest release
atom -d
```
Once that is done, you can open the docpane with the `Julia Client: Show Docpane`-command. For search in all installed packages you’ll need to call `Julia Client: Regenerate Doc Cache` to generate the cache (this will probably take quite some time, and will eventually be automated).
