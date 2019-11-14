%{
  Leopold Mozart: Violin School (1756)

  Global layout/appearance specification

%}

\version "2.19.80"

#(set-default-paper-size "b5")
#(set-global-staff-size 18)
\paper {
  indent = 0\cm
  left-margin = 1\cm
  right-margin = 1\cm
  ragged-right = ##f
  ragged-last = ##t
  tagline = ##f
}

% Document font settings.
% Note that all fonts have to be installed,
% the (commercial) Ross notation font even within the LilyPond instance
% https://www.musictypefoundry.com/product/mtf-ross
% https://github.com/ism-dme/lm-vs-ly/issues/6
\useNotationFont \with {
  roman = "Georgia"
  sans = "Arial"
} ross

\layout {
  \context {
    \Voice
    \override Flag.stencil = #modern-straight-flag
    \override Stem.details.beamed-minimum-free-lengths = #'(2 2.5 2.5)
    \override Beam.damping = 10

    \override TupletNumber.whiteout = 1
    \override TupletBracket.bracket-visibility = #'if-no-beam
    \dynamicDown
  }
  \context {
    \Staff
    \omit MultiMeasureRestNumber
    \override Clef.full-size-change = ##t
  }
  \context {
    \Score
    % The edition-engraver edition root is addressed by the current example name
    \editionID ##f #(list (string->symbol current_example))
    \remove Bar_number_engraver
    % automatic beaming is completely deactivated to force correct encoding
    % for a potential future MusicXML export
    \autoBeamOff
    % Font name is set explicitly because font-series override
    % doesn't seem to work with MetronomeMark
    \override MetronomeMark.font-name = "Arial"
    % define order of elements around barlines
    \override BreakAlignment.break-align-orders =
    ##((left-edge
         cue-end-clef
         ambitus
         breathing-sign
         staff-bar
         clef
         cue-clef
         key-cancellation
         key-signature
         time-signature
         custos)
       (left-edge
         cue-end-clef
         ambitus
         breathing-sign
         staff-bar
         clef
         cue-clef
         key-cancellation
         key-signature
         time-signature
         custos)
       (left-edge
         cue-end-clef
         ambitus
         breathing-sign
         clef
         cue-clef
         staff-bar
         key-cancellation
         key-signature
         time-signature
         custos))
  }
}
