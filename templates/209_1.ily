%{
  Leopold Mozart: Violin School (1756)

  Score block template - three systems
%}

\version "2.19.80"

\score {
  <<
    \new Staff = "one" \with {
      \override VerticalAxisGroup.default-staff-staff-spacing =
      #'((basic-distance . 21))
    } \one
    \new PianoStaff <<
      \new Staff = "upper" \with {
        \consists Metronome_mark_engraver
      } \upper
      \new Staff = "lower" \lower
    >>
    \new FiguredBass = "figures" \bassFigures
  >>
}

\layout {
  \context {
    \Score
    \remove Metronome_mark_engraver
    \omit SystemStartBar
  }
}