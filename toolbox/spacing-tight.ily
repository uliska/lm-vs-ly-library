\version "2.19.81"

\include "_stretch-spacing.ly"

\layout {
  \context {
    \Score
    \override SpacingSpanner.common-shortest-duration =
    #(stretch-spacing -1)
  }
}