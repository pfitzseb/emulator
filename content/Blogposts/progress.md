---
title: "Progress (kinda) "
date: 2017-06-08T23:25:03+02:00
draft: false
---

Haven’t written anything up for quite a while now, mostly due to a somewhat stressful week in uni – lots of things to do, “reunion” party of my research group to attend and so on. I did make *some* progress on GSoC, and also made some PRs to get Juno set up for the nearing Julia 0.6 release. `Plots.jl` in particular needs some love to get around world age issues, so I’ll try my hand at an implementation of `Requires.jl` based backend loading.

## GSoC
`DocSeeker.jl` (dog seeker?) lives on my Uni’s gitlab server for now, and I have implemented `searchbinding` and `searchdocs`, which do the obvious. Both of those use the same `score`ing function, which is super bad at the moment:
```
# TODO: Be a bit more intelligent about this.
function score(needle::String, s::String)
  words = split(s, ['\n', ' '])
  score = 0.0
  for w in words
    d = levenshtein(needle, w)
    d > 5 && continue
    score += 1/d
  end
  score
end
```
Fun fact: The `TODO` on the first line basically includes everything I wanted to get done this month… I `planned` to read up on searching/scoring algorithms for quite some time now, but for some reason never got around to actually go paper-hunting…

This feels a bit like I’m actually doing some [structured procrastinating](http://www.structuredprocrastination.com/) now (thanks [@haampie](https://github.com/haampie) for sharing that link on slack), what with all the GSoC-unrelated Juno/Julia work. Oh well… maybe I should just look for all the remaining deprecation warnings in Juno and fix them?

## Blog

This blog now uses my very own theme: [kakao](https://github.com/pfitzseb/kakao). Made some tweaks to Cocoa-EH to get rid of the super annoying FOUT (**f**lash **o**f **u**nstyled **t**ext) that happened because of the unnecessarily complex way of using Google Fonts. I also got rid of the shipped font (dunno about copyright, and it didn’t look that great). In related news: kakao has spread to another GSoCer, [shivin9](https://shivin9.github.io/blog/).
