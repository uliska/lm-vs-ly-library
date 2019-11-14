\version "2.19.81"

% Produziere ein "leeres" System

\layout {
  \context {
    \Staff
    \omit Clef
    \omit TimeSignature
    \omit StaffSymbol
  }
  \context {
    \Score
    \omit BarLine
  }
}
