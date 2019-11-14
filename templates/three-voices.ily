%{
  Leopold Mozart: Violin School (1756)

  Score block template - one System, three voices
%}

\version "2.19.80"

\score {
  <<
    \new Staff <<
      \new Voice = "one" {
        \voiceOne
        \musicOrEmpty one
      }
      \new Voice = "two" {
        \voiceTwo
        \musicOrEmpty two
      }
      \new Voice = "three" {
        \voiceThree
        \musicOrEmpty three
      }
    >>
    \new FiguredBass = "figures" \musicOrEmpty bassFigures
  >>
}