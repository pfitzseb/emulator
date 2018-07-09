---
title: "Juno on 0.7"
date: 2018-07-09T16:41:42+02:00
---

Quite a few changes are coming with the 0.7 release of Juno.

### Workspace
The workspace pane is now a bit faster and there are a few quality of life improvements:

  - Workspace items can be fuzzy-filtered by name.
  - There's buttons for selecting the current module and refreshing the workspace pane.
  - Rendering performance is better now -- displaying all of `Base` doesn't nearly take as long *and* doesn't slow the rest of Atom to a crawl.

![workspace](/img/Blogposts/juno-on-07/workspace.png)

### Plot Pane
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

-----

All `show` methods whose return values end up in the plot pane are called with two (for now)
custom `IOContext` keys:

  - `:juno_plotsize` is an `Array` of the plot pane's current width/height in pixels. See `Juno.plotsize` for more info.
  - `:juno_colors` returns a `Dict{String, UInt32}` which contains a few named colors used by the current Atom syntax theme. See `Juno.syntaxcolors` for more info.

### Progress Meters
...

### Terminal Integration
...

## TreeViews.jl

[TreeViews.jl](https://github.com/pfitzseb/TreeViews.jl) provides a uniform API for
defining, well, tree views and ships a renderer for the REPL. Juno provides one as w
ell, which makes it possible for package authors to drop any dependencies on the Juno
stack and *still* get pretty rendering for their custom types.
