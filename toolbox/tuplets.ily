\version "2.19.82"

hideTuplets = {
  \omit TupletNumber
  \omit TupletBracket
}

showTuplets = {
  \undo \omit TupletNumber
  \undo \omit TupletBracket
}