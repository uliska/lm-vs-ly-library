\version "2.19.80"

\registerOption mozart.special-noteheads.flag-offset 2.7

offsetStemFlag = {
  \override Flag.stencil = #old-straight-flag
  \override Stem.X-offset = 0.7
  \override Stem.Y-offset = 0.25
  \override Flag.Y-offset = 
  #(lambda (grob)
     (ly:grob-set-property! grob 'Y-offset
       (getOption '(mozart special-noteheads flag-offset))))
}

whitehead = {
  \once \offsetStemFlag
  \once \override NoteHead.stencil = #ly:text-interface::print
  \once \override NoteHead.text =
  #(markup #:fontsize 3 #:musicglyph "noteheads.s1neomensural")
}

blackhead = {
  \once \offsetStemFlag
  \once \override NoteHead.stencil = #ly:text-interface::print
  \once \override NoteHead.text =
  #(markup #:fontsize 3 #:musicglyph "noteheads.s2neomensural")
}
