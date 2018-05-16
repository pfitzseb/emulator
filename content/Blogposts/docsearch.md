---
title: "Pondering: Searching for Docs"
date: 2017-06-02T23:30:03+02:00
publishdate: 2017-06-02T23:30:03+02:00
draft: false
---

## Initial Thoughts
There are four situations for searching docstrings:

  1.  Search in a *user specified* package.
  2.  Search in all *currently loaded* packages.
  3.  Search in all *installed* packages.
  4.  Search in all *registered* packages.

The last one is obviously more difficult than the others, so it’s only a stretch goal for my GSoC :)

Now, the question is how the search should be implemented. First step has to be gathering all relevant bindings; defining “relevant” here isn’t super obvious, since Julia packages don’t have to export a binding for it to belong to the official API.

The first two points could easily be addressed by using introspection to get all docstrings in a package:
```
using Documenter
Documenter.DocSystem.getdocs.(names(Base, true))
```
The above command takes something like 0.15s on my system, which probably is fast enough.

That said, the third point is a bit less obvious to solve: Do we actually want to load all packages just to get their docstrings? A package being broken and not loading seems like the least of the problems, because you couldn’t use it then anyways. Loading all packages will take a a long time in all but the most minimal installations though.

This might not be much of a problem if the docstring database is only populated infrequently and from a different Julia process, but still seems kind of inefficient.

The alternative would be to use the excellent Tokenizer.jl package doing minimal parsing of every source file in ~/.julia/v0.x/.*/src. This would almost certainly be faster, but also involves a much more complex implementation. One disadvantage of “gathering” docstrings statically is that no dynamism is possible whatsoever (meaning all user defined docstrings in a session wouldn’t be possible).

## Caching Docstrings

Regardless of whether the static or the dynamic approach is used, some caching of docstrings in necessary to enable quick searches. The obvious choice (for me at least, who knows next to nothing about databases and search engines) is an SQLite DB. So let’s create an in-memory DB and populate it by hand:
```
using SQLite

db = SQLite.DB()

SQLite.query(db,
  """
  CREATE TABLE DOCS(
    MODULE         TEXT,
    BINDING        TEXT,
    DOCSTRING      TEXT,
    PATH           TEXT,
    LINENUMBER     INT
  )
  """)

SQLite.query(db,
  """
  INSERT INTO DOCS (MODULE, BINDING, DOCSTRING, PATH, LINENUMBER)
    VALUES (?, ?, ?, ?, ?)
  """, values = ["Base", ":foo2", "Foo docstring", "foo.jl", 12])

SQLite.query(db, "SELECT * FROM DOCS")
```
Uhoh, [indeterminstic segfaults](https://github.com/JuliaDatabases/SQLite.jl/issues/125). Yay.

Well, whatever, I’ll just save the data in a Julia data structure (which I can persist with JLD2.jl or even just serialize) and write my own fuzzy matcher instead of relying on SQLite’s FTS5.
