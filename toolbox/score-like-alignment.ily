\version "2.19.82"

\paper {
  right-margin = #(* (toolOption 'right-margin 1) cm)
  ragged-last = ##f
}

\layout {
  \context {
    \Staff
    \override TimeSignature.break-visibility = #end-of-line-invisible
  }
}
