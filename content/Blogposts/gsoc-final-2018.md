---
title: "GSoC 2018 Summary"
date: 2018-08-06T07:40:56+01:00
---
The aims of this year's GSoC project were to *a)* get the [Juno IDE](http://junolab.org/) running
on [Julia](https://julialang.org/) v1.0 and *b)* integrate performance linting into the Juno UI.

Most of the work went into updating the various Julia packages in the [Juno stack](https://github.com/JunoLab), first for Julia 0.7 and then for Julia 1.0. There's also a unfinished
PR against [**@MikeInnes**](https://github.com/MikeInnes)' excellent package [Traceur.jl](https://github.com/MikeInnes/Traceur.jl), which provides performance linting in Julia.

Finding a nice user experience for getting performance tips in Juno was mostly a matter of updating the Atom packages Juno uses.

## Juno on Julia v1.0
Updating Juno for Julia 1.0 actually took more time than I would have liked. Then again, Julia itself
changed radically between 0.6 and 1.0, so I guess that was to be expected. Most of the progress was tracked
in this [meta-issue](https://github.com/JunoLab/Juno.jl/issues/127) (thanks again to everyone who tried
Juno with Julia 0.7 in that phase!), which culminated in PRs against basically every single package in the
Juno stack.

### Atom.jl
[Atom.jl](https://github.com/JunoLab/Atom.jl/pull/122) was not only updated to work on Julia 0.7, but also implements quite a few new features (see an [earlier blog post](https://pfitzseb.github.io/blogposts/juno-on-07/) for more information on that).

Juno is now fully compatible with the [TreeViews.jl](https://github.com/pfitzseb/TreeViews.jl) API, which
means that package authors don't have to depend on Juno.jl anymore to get custom pretty printing for their
own types:
![search](/img/Blogposts/gsoc-final-2018/treeviews.png)

----
Juno's Plot Pane is now fully integrated into `Base`'s display system. It is now sufficient to add the
proper `show` method for a custom type and it will be properly displayed in Juno. Again, this cuts down
the number of packages that need to depend on Juno.jl (or even Atom.jl) drastically.
![search](/img/Blogposts/gsoc-final-2018/plots.png)

----
Progress Bars now make use of the new logging infrastructure introduced in Julia 0.7, which means that
there is hopefully no external package left that needs to depend on the Juno stack.
![search](/img/Blogposts/gsoc-final-2018/progress.png)

----
[Juno.jl](https://github.com/JunoLab/Juno.jl/pull/144) is now mostly a thin wrapper and as such was only
updated to provide compatibility with the new version of Atom.jl. [CodeTools.jl](https://github.com/JunoLab/CodeTools.jl/pull/28) had to be updated to handle the new
package loading properly. [Hiccup.jl](https://github.com/JunoLab/Hiccup.jl), [Media.jl](https://github.com/JunoLab/Media.jl), and
[LNR.jl](https://github.com/JunoLab/Hiccup.jl) were also updated for Julia 1.0, but that mostly consisted of fixing deprecation warnings.

## Performance Linting
Most of the UI work in regards to performance linting happened in a [merged PR to ink](https://github.com/JunoLab/atom-ink/pull/165) and consists of a list of warnings (bottom of the screen), an inline popup which provides more information, and a new pane element for the results of `@code_warntype` etc:
![search](/img/Blogposts/gsoc-final-2018/linter.png)

There's also an (as of yet unmerged) branch in julia-client and Atom.jl to enable this functionality and
handle the communication with Traceur.jl, which provides the all the logic necessary for inspecting
the IR and generating warnings when suspicious patterns are found (like type instabilities, use of
global variables and many more).  

Unfortunately Traceur.jl depends on ASTInterpreter2.jl and Vinyl.jl, both of which don't work on Julia 1.0
yet. For that reason I have spent the last week of my GSoC project with transitioning Traceur.jl to use
[**@jrevels**](https://github.com/jrevels) awesome [Cassette.jl](https://github.com/jrevels/Cassette.jl),
which was released during JuliaCon. The relevant [PR](https://github.com/MikeInnes/Traceur.jl/pull/11) is
not merged yet, but that'll hopefully be done soon. At that point we will be able to tag a new Juno release
with performance linting enabled.

## Various Improvements
While working on updating Juno to Julia 1.0 I also stumbled upon a few other areas to work on:

- [Redesign](https://github.com/JunoLab/junolab.github.io/pull/11) of [junolab.org](http://junolab.org/) to better advertise the many of the features Juno provides but no one knows about.
- Plot Pane UX is now much better with regards to multiple plots.
- Juno's Workspace now allows easy filtering of names in the workspace.
- [TreeViews.jl](https://github.com/pfitzseb/TreeViews.jl) provides a mininmal API for defining a tree-like display for arbitrary types.
- [REPLTreeViews.jl](https://github.com/pfitzseb/REPLTreeViews.jl) (not registered yet) enables interactive rendering of those tree views in the REPL.
- [New autocompletion provider](https://github.com/JunoLab/Atom.jl/pull/125) (WIP), which is much more powerful than what we have so far.

## Upcoming Work
Of course this isn't the end of my involvement with Juno, and we already have a few plans for the future.

During JuliaCon I was talking to [David Anthoff](https://github.com/davidanthoff), one of the two guys
behind the [Julia integration into VSCode](https://github.com/JuliaEditorSupport/julia-vscode), and we came
up with a few ideas on how to share more code between the two backends (and come closer to feature parity).
This will require a complete redesign of Juno's internals, but in the end we'll get quite a few features
for free. I'll write up my thoughts on this in a future post.

Another big thing a few people (like Mike Innes and Chris Rackauckas) have bugged me about is better
support for remote work via `ssh`. This might need to be done in conjunction with the redesign mentioned
above, but I'm not totally sure what the best way forward is here.

Continuing the TreeViews.jl work from during the summer I want to finish the REPLTreeViews.jl renderer
(which definitely has a few big bugs right now) and implement a Jupyter renderer.

In my last blog post I mentioned a few improvements to Julia's REPL that would be very good to have and
would benefit everyone, not just Juno users. That's still something I want to spend some time on, but is
also a bit tedious due to the underdocumented (and definitely not self explanatory) REPL design.

[Tim Holy](https://github.com/timholy)'s [Revise.jl](https://github.com/timholy) works great on it's own,
but can also be used as a library which might make Juno's current core functionality more robust and also
enable things like method deletion which Juno can't really handle right now (except for re-evaluating the
whole module).

## Acknowledgements
I'd like to thank [Harsha](https://github.com/bmharsha) and [Mike](https://github.com/mikeinnes) for being
great mentors. Also a big shoutout to the whole Julia community, and especially all organizers of this year's
JuliaCon, which was a great experience, as well as The Julia Project and NumFocus for enabling me to go to JuliaCon.
