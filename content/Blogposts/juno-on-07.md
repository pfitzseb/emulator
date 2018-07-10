---
title: "Towards Juno 0.7"
date: 2018-07-09T16:41:42+02:00
---

Quite a few changes are coming with Juno 0.7 (which will be compatible with the upcoming Julia 0.7).

## Workspace Pane
The workspace pane is now a bit faster and there are a few quality of life improvements:

  - Workspace items can be fuzzy-filtered by name.
  - There's buttons for selecting the current module and refreshing the workspace pane.
  - Rendering performance is better now -- displaying all of `Base` doesn't nearly take as long *and* doesn't slow the rest of Atom to a crawl.

![workspace](/img/Blogposts/juno-on-07/workspace.png)

## Plot Pane
Most of these changes are relevant to package authors, but the UI has seen a few improvements as well.

Previous versions of Juno provided a history of plots, as long as those were images and
nothing else. This is now also the case for interactive plots.

-----

The plot pane picks up `show` methods with `image/xxx` mimetypes, so there's no need to
depend on Juno.jl and define custom `render` methods any more. These images are displayed
with basic pan and zoom capabilities:

![basic plot](/img/Blogposts/juno-on-07/dumb_plot.png)

-----

It's also possible to provide a `show` method for the `application/juno+plotpane` mime
type, which allows rendering of arbitrary HTML in a [`<webview>`](https://electronjs.org/docs/api/webview-tag)
element.

![rich plot](/img/Blogposts/juno-on-07/smart_plot.png)

Note that you can use arbitrary [data URLs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URIs) in your
custom `show` method; if whatever is printed to `io` does not start with `data:` then Juno
falls back to `data:text/html` (which is what happens in the above screenshot).

Since it is possible to exectue arbitrary JS code in a `webview` a package can set up
communication channels between Julia and the plot pane in whatever way it's authors want. The
transition to this new display system also resulted in the removal of Blink.jl from the
Juno stack, which significantly improves load times at the cost of packages having to set up
the aforementioned communication themselves.

-----

All `show` methods whose return values end up in the plot pane are called with two (for now)
custom `IOContext` keys:

  - `:juno_plotsize` is an `Array` of the plot pane's current width/height in pixels. See `Juno.plotsize` for more info.
  - `:juno_colors` returns a `Dict{String, UInt32}` which contains a few named colors used by the current Atom syntax theme. See `Juno.syntaxcolors` for more info.

## Progress Meters
The integrated progress display now makes use of the [shiny new logging functionality](https://docs.julialang.org/en/latest/stdlib/Logging/) in Base. This means that
there's no need to depend on Juno.jl anymore for getting a progress bar -- it's sufficicent
to send a log message of an arbitrary level (though I'd recommend `-1` or smaller so it's not
picked up by the default logger and spams the REPL) with a `progress` argument:
```julia
@logmsg -1 "making progress" progress=0.5 # or progress=NaN, or progress="done"
```
For convenience, Juno.jl does still expose `progress` and `@progress`, which work the same as
in previous versions (but still use the debugging framework internally).

See [here](https://github.com/JunoLab/Atom.jl/blob/857aa7c31e508789e434b5c2a4ba708f4f208565/src/progress.jl#L8-L25) for additional docs (until those find their way into the official Juno docs).


## Terminal Integration
Juno's terminal integration has steadily gotten better as well -- mostly due to improvements
to improvements to the underlying [xterm.js](https://github.com/xtermjs/xterm.js) library:

- Styling changes are applied to terminals instantly (no need to restart Atom when changing from a dark to a light theme).
- Default colors are *much* more readable on light backgrounds. They'll most likely be customizable in the near future.
- A terminal's tab title reflects what is going on in the terminal (as long as the shell sends the appropriate escape sequences, that is).
- Link detection works even with wrapped lines.

![terminal](/img/Blogposts/juno-on-07/terminal.png)

# TreeViews.jl

[TreeViews.jl](https://github.com/pfitzseb/TreeViews.jl) provides a uniform API for
defining, well, tree views. It also ships a renderer for the REPL, while Juno provides one for
rich inline display. This makes it possible for package authors to drop any dependencies on
the Juno stack and *still* get pretty rendering for their custom types:

![treeviews](/img/Blogposts/juno-on-07/treeviews.png)

The REPL renderer still needs a bit of work (and tests), but the actual API works pretty well
already and is only [7 LoC plus documentation](https://github.com/pfitzseb/TreeViews.jl/blob/master/src/TreeViews.jl).

# Traceur.jl
Unfortunately I didn't yet make much progress on updating Traceur.jl to work on Julia 0.7 --
mostly because ASTInterpreter2.jl is a rather complex package. I'm pretty confident I'll
make some progress on this during the next week though.
