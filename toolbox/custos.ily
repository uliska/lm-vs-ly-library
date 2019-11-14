\version "2.19.80"

% Common overrides to define the appearance of a custos
custosOverrides = {
  \once \override NoteHead.stencil = #ly:text-interface::print
  \once \override NoteHead.text =
  #(markup #:fontsize 3.5 #:musicglyph "custodes.mensural.u0")
  \once \omit Stem
  \once \omit Flag
  \once \omit Dots

  % Make sure the note column has exactly the same width as the glyph
  % (the value '4' has been determined by trial and error)
  \once \override NoteColumn.before-line-breaking =
  #(lambda (grob) (ly:grob-set-property! grob 'X-extent '(0 . 4)))
}

% Create a manual pitched "custos" glyph
custos =
#(define-music-function (pitch)(ly:pitch?)
   #{
     \custosOverrides
     % return a "note"
     % In case the example continues after the custos it is relevant
     % that the "musical" duration is 1/32 - which is done in order to
     % have a very short duration because it seems only possible to
     % *widen* the note column to a given width
     #(make-music
       'NoteEvent
       'duration
       (ly:make-duration 5)
       'pitch pitch)
   #})

% Create a custos followed by a double bar.
% Two things have to be done for that:
% - create some space after the custos
% - Make sure the double barline starts a new measure at zero
custosWithDoubleBar =
#(define-music-function (duration pitch)((ly:duration? (ly:make-duration 4)) ly:pitch?)
   (ly:message "Duration: ~a" duration)
   #{
     \custos #pitch
     #(make-music
       'SkipEvent
       'duration
       duration)
     \partial 1*0
     \doubleBar
   #})

% Create a custos followed by a line break.
% This requires resetting the measure time with a new zero-length partial.
custosWithLineBreak =
#(define-music-function (pitch)(ly:pitch?)
   #{
     \custos #pitch
     \bar ""
     \partial 1*0
     \break
   #})

% Create a multi-voice custos in a chord construct
% This is sort of a hack because it simply applies the styling overrides
% and then issues the unprocessed music input, but it should work well enough ...
chordCustos =
#(define-music-function (music)(ly:music?)
   #{
     \custosOverrides
     #music
   #})

