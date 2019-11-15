# Leopold Mozart: Violin School &ndash; LilyPond Library
LilyPond library for the DME digital edition of Leopold Mozart's Violin School (1756)

The [Digital Mozart Edition](https://dme.mozarteum.at/) has released a
[digital edition](https://dme.mozarteum.at/text-editions/violinschule/) of
Leopold Mozart's Violin School of 1756. The music examples in this edition have been
engraved with [GNU LilyPond](http://lilypond.org). This repository makes the library
of LilyPond functionality used in the edition publicly available. Without the
*content* repository - which isn't ready for a public release yet - this can't be
used to recompile the examples, but it may serve as a basis to build upon. It is
also referenced in a 
[series of posts](http://lilypondblog.org/category/productions/leopold-mozart-violinschule/)
describing the infrastructure.

The repository itself does not provide a usage manual, but the files themselves are
extensively commented. The functionalty is based on [openLilyLib](https://github.com/openlilylib),
and the relevant dependencies can be determined from the starter file
[init-edition.ily](init-edition.ily).

The code in this repository is distributed under the free MIT license (see [LICENSE](LICENSE)),
and its development has been commissioned and funded by the Digital Mozart Edition
and the [Stiftung Mozarteum Salzburg](https://mozarteum.at/).
