%{
  Leopold Mozart: Violin School (1756)

  Score block template - one system, four voices
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
      \new Voice = "four" {
        \voiceFour
        \musicOrEmpty four
      }
    >>
    \new FiguredBass = "figures" \musicOrEmpty bassFigures
  >>
}