%{
  Leopold Mozart: Violin School (1756)

  Score block template - three systems
%}

\version "2.19.80"

\score {
  <<
    \new ChoirStaff \with {
      systemStartDelimiter = #'SystemStartBrace
    }
    <<
      \new Staff = "upper" \musicOrEmpty upper
      \new Staff = "middle" \musicOrEmpty middle
      \new Staff = "lower" \musicOrEmpty lower
    >>
    \new FiguredBass = "figures" \musicOrEmpty bassFigures
  >>
}
