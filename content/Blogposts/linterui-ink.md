---
title: "Updated Linter UI"
date: 2018-06-10T20:34:30+02:00
---
Okay, so last blogpost I started investigating whether it makes sense to use `linter-ui-default`
to display performance advice. There were three main problems:

  1. The default settings are bad for this use case, which means Juno would need to extensively
     reconfigure an external package.
  2. Lots of linters for other languages use `linter-ui-default`, so any config changes
     Juno makes would be reflected there as well.
  3. It's not quite as configurable as I'd have liked it to be.

For these reasons I decided to implement a custom [Linter UI and linting logic](https://github.com/JunoLab/atom-ink/commits/sp/linterUI), which, while relatively similar
to the one provided by `linter-ui-default`, allows a much greater degree of customization.

The screenshot below shows `ink`'s shiny new UI elements: In-editor linting advice on the left,
a global linting overview in the bottom pane, and a prototype of a nicer `@code_warntype`
(or `@code_llvm`/`@code_native`) display on the right:

![ui](/img/Blogposts/linterui-ink/ui.png)


## What brings the future?

Now that the UI is passable and Julia 0.7 is in alpha, I'm going to spend my time on a couple of things:

### Update Juno and dependencies for 0.7
Juno is mostly in a [good state already](https://github.com/JunoLab/Juno.jl/issues/127); the two big
remaining items right now are a) interactive plots in a post-Blink.jl world and b) integration of
Juno's progress meters into Base's new logging framework.

The 'dependencies' point mentioned above crucially includes Traceur.jl and ASTInterpreter2.jl,
which are vital for performance linting *and* Juno's debugger.


### Look into possible improvements to Traceur.jl

The current implementation already provides a lot of performance feedback and advice,
but I'll nevertheless look for opportunities to add new passes that do more sophisticated
analysis.

Also, as you can see in the screenshot above, Traceur.jl currently does not emit
any information about the column(s) the error occurs in, so that would be good to add
as well.

It would also be cool if Traceur.jl could suggest fixes for common mistakes, but
currently I'm not sure how feasible that is.


### Deprecations.jl integration

It would be awesome if Juno could help transition packages to Julia 0.7. This is already (kinda)
possible via [FemtoCleaner.jl](https://github.com/JuliaComputing/FemtoCleaner.jl), but
IDE integration for [Deprecations.jl](https://github.com/JuliaComputing/Deprecations.jl) shouldn't
be too hard and could nicely leverage the linting UI presented above.

### Interactive REPL display
I already spent some time finding a way to display complex type instances in the REPL
(built on top of the awesome [TerminalMenus.jl](https://github.com/nick-paul/TerminalMenus.jl)),
which currently looks like this for a DifferentialEquations.jl return type:

![ui](/img/Blogposts/linterui-ink/interactive.gif)

I'll spend some time on polishing this, add tests, and hopefully get a PR accepted
which integrates this into Julia (TerminalMenus.jl is already a part of 0.7, so the hurdle
shouldn't be too high).


### General REPL improvements

Juno's (and probably VSCode's) REPL integration is not very robust and digs deep
into implementation details and undocumented methods to enable a couple of things:

- Evaluation in the context of a module different from `Main`.
- Proper async printing.
- Programmatic evaluation of code in the REPL from a different `Task`.

I'll hopefully find the time to get support for those things into Base, and
there's already a [PR](https://github.com/JuliaLang/julia/pull/26930) that enables
module-aware autocompletions, which would go very well with the features proposed
above.
