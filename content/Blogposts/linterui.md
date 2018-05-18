---
title: "Performance Linter UI"
date: 2018-05-17T09:41:53+02:00
draft: false
---

Dynamic performance linting can easily be done with [Traceur.jl](https://github.com/MikeInnes/Traceur.jl) and the `@trace` macro, which prints any warnings directly to the REPL:
```julia-repl
julia> @trace naive_sum([1.0, 2.0])
(Base.indexed_next)(::Tuple{Int64,Bool}, ::Int64, ::Int64) at tuple.jl:54
  returns Tuple{Union{Bool, Int64},Int64}
(naive_sum)(::Array{Float64,1}) at /home/basti/Documents/test.jl:211
  s is assigned as Int64 at line 211
  s is assigned as Float64 at line 213
  dynamic dispatch to s + x at line 213
  returns Union{Float64, Int64}
3.0
```
This works fine, but obviously isn't ideal for an IDE such as Juno. Fortunately, Traceur.jl provides an API that outputs those warnings in a structured way:
```julia-repl
julia> Traceur.warnings(() -> naive_sum([1.0, 2.0]))
5-element Array{Traceur.Warning,1}:
 Traceur.Warning(Traceur.DynamicCall{Base.#indexed_next,Tuple{Tuple{Int64,Bool},Int64,Int64}}(Base.indexed_next, ((0, false), 1, 1)), -1, "returns Tuple{Union{Bool, Int64},Int64}")
 Traceur.Warning(Traceur.DynamicCall{#naive_sum,Tuple{Array{Float64,1}}}(naive_sum, ([1.0],)), 211, "s is assigned as Int64")
 Traceur.Warning(Traceur.DynamicCall{#naive_sum,Tuple{Array{Float64,1}}}(naive_sum, ([1.0],)), 213, "s is assigned as Float64")
 Traceur.Warning(Traceur.DynamicCall{#naive_sum,Tuple{Array{Float64,1}}}(naive_sum, ([1.0],)), 213, "dynamic dispatch to s + x")
 Traceur.Warning(Traceur.DynamicCall{#naive_sum,Tuple{Array{Float64,1}}}(naive_sum, ([1.0],)), -1, "returns Union{Float64, Int64}")
```
Displaying these properly in Juno will be what I spend the first couple of weeks of this years GSoC on.

Atom does have some packages for more traditional linting, namely [linter](https://github.com/steelbrain/linter) for the logic and [linter-ui-default](https://github.com/steelbrain/linter-ui-default) for the UI elements. I'm not entirely sure yet if I'll end up using them for the final design, but for quickly iterating they're very well suited.

## Concept

Integrating the linter package is super easy on the Atom side. And here's the code for the Julia side -- surprisingly simple as well:

![concept](/img/Blogposts/linterui/example.png)

There are still some issues to figure out, but this seems pretty neat for a first pass.

## Wrapping Traceur.jl's output

With a bit of glue code for converting `Traceur.Warning`s into the `Message`s taken by linter we get a pretty UI:

![concept](/img/Blogposts/linterui/traceur.png)
