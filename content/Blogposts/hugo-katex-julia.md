---
title: "Hugo and Julia"
date: 2017-06-02T23:25:03+02:00
draft: false
---

While looking into setting *some* blogging environment for GsoC 2017 (playing around with HTML files by hand gets old quickly…), I stumbled upon [Hugo](https://gohugo.io). I guess Jekyll would’ve been the obvious choice, but seemed a bit too unwieldy for me.

Getting Hugo running is super easy – it even includes a webserver with live reload for convenient development! Customization is a bit more involved though: Finding a theme over at [themes.gohugo.io](https://themes.gohugo.io) is kinda fun and all, but I wasn’t completly happy with any of the themes I tried. cocoa EH is pretty cool though, so I’m using a slightly modified version here.

Since this blog is likely to contain some math, either $\KaTeX$ or MathJax needed to be included. The Hugo docs mention only MathJax, but since it’d be loaded on the fly anyways instead of run in the build step, I decided to just use $\KaTeX$ instead (as you may have guessed by now). Getting that running involved some minor hacking in the theme files, specifically adding a call to
```
renderMathInElement(document.body, {delimiters: [
  {left: "\\begin{align}", right: "\\end{align}", display: true}, // block math
  {left: "$", right: "$", display: false} // inline math
]})
```
in the footer (and obviously getting the correct files from the CDN). Which brings me to the next topic: Support for Julia syntax highlighting. All that is needed is the addition of
```
highlightjslanguages = ["julia", "all other languages you want highlighted"]
```
to your config.toml and you’re good to go!

The next hour I spent procrastinating creating a logo for the blog, which I’m surprisingly happy with.

Of course there still are a couple of things to do: Setting about automatic deployment via rsync or something similar, getting the styling sorted, filling the other categories, and moving over my old websites content. Also possibly hosting this on github pages… maybe.
