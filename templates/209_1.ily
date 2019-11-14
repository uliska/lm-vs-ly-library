%{
  Leopold Mozart: Violin School (1756)

  Score block template for the individual example 1756_209_1
  This is needed to fake two separate examples with text in between
  but perfect horizontal alignment.
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