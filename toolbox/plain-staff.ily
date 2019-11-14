\version "2.19.81"

% Produziere ein "leeres" Rastral

\layout {
  \context {
    \Staff
    \omit Clef
    \omit TimeSignature
  }
  \context {
    \Score
    \omit BarLine
  }
}
