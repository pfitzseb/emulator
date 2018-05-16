---
title: "Atom and Julia via LSP"
date: 2017-06-28T23:25:03+02:00
publishdate: 2017-06-28T23:25:03+02:00
draft: false
---

Yesterday I was looking into improving Juno’s autocompletion to include local variables natively (that is, without relying on Atom’s built in dumb autocomplete provider). Checking out the “competition” (that is, the Julia language server for VSCode), I noticed they have that feature – powered by the awesome CSTParser.jl. So originally I planned on stealing parts of their code and adding that functionality to CodeTools.jl.

Then, while talking with **@ZacLN** on the julia-vscode gitter, I decided to just quickly build a language-client for Julia on top of [atom-languageclient](https://github.com/atom/atom-languageclient). Which turned out to be surprisingly easy: The minimal implementation takes about [25 lines of code](https://github.com/pfitzseb/atom-julia-lsp-client/blob/master/lib/atom-julia-lsp-client.js).

And it actually works pretty well (the UI elements in that screenshot are powered by Nuclides [atom-ide-ui package](https://github.com/facebook-atom/atom-ide-ui)):

![foo](/img/Blogposts/atomlanguageclient/atom-lsp.png)

If you want to try this out, just
```julia
apm install atom-ide-ui
git clone git@github.com:pfitzseb/atom-julia-lsp-client.git
cd atom-julia-lsp-client
apm install
apm link -d
atom -d
```
and check out LanguageServer.jl in Julia:
```
Pkg.install("LanguageServer")
Pkg.checkout("LanguageServer")
```
You can even run it alongside Juno and should mostly get the best of both worlds (haven’t tried that extensively yet, but I don’t think there should be many problems).

All in all, it’s pretty awesome that this Just Works™. Sure, there are some glitches and bugs, but the Atom packages aren’t even officially released yet so that’s to be expected. Sometimes the language server also dies unexpectedly and stuff like that, but all in all I’m very happy by how easy this turned out to be.

My long term plan is to base Juno on the Julia language server, which would mean that the major Julia IDEs would run on the same backend code (excluding Eclipse, but who uses that anyways?). For that I’ll have to do some reading to understand the LSP design choices and of course the implementation on both the Atom and Julia sides, so this will most probably stay a bit of a side project in the foreseeable future.
