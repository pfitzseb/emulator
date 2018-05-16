---
title: "Proper scoring!"
date: 2017-06-09T23:25:03+02:00
draft: false
---

Good news: I found the excellent [StringDistances.jl](https://github.com/matthieugomez/StringDistances.jl), which has some very useful comparison functions. This has kinda trivialized writing a good `score` function (not that I’m complaining):
```
# TODO: better string preprocessing.
function score(needle::String, s::Docs.DocStr)
  binding = split(string(get(s.data, :binding, "")), '.')[end]
  doc = lowercase(join(s.text, '\n'))
  (3*compare(Hamming(), needle, binding) + compare(TokenMax(Jaro()), lowercase(needle), doc))/4
end
```
For simple cases this works really well I think, but I haven’t had time for extensive testing yet. Looking through Documenter.jl’s as well as `Base.Docs`’ source code I decided that the dependency on Documenter.jl isn’t really necessary to keep. The transition to solely using `Base.Docs` has mostly simplified my code though, so that’s pretty neat (still using unexported functions obviously).

Searching all 2332 currently loaded docstrings takes about 0.5s for me – that is without caching anything though, which I expect to help a bit. Most of the time is spent in the two compare function calls though, so I’ll have to look into optimizing that a bit. Worst case is that I need to look into indexing the docstrings, but I hope it doesn’t come to that…
