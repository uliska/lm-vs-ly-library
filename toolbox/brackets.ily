\version "2.19.80"

% Create horizontal brackets with included text.
% If no text is desired an empty string has to be given.

% 1) Regular horizontal bracket (attached to *notes*)
% By default the bracket is above the staff, otherwise
% #DOWN has to be given as optional argument.

startBracket =
#(define-event-function (direction text)((ly:dir? UP) markup?)
   #{
     -\tweak HorizontalBracketText.text #text
     -\tweak HorizontalBracketText.font-series #'bold
     -\tweak HorizontalBracketText.direction #(* -1 direction)
     -\tweak HorizontalBracketText.Y-offset #(if (= direction UP) -2.5 1)
     -\tweak direction #direction
     \startGroup
   #})

stopBracket = \stopGroup

% 2) measure-based horizontal brackets
% Based on code by David Nalesnik:
% http://lists.gnu.org/archive/html/lilypond-user/2014-10/msg00446.html
% (referenced from http://lists.gnu.org/archive/html/lilypond-user/2019-02/msg00084.html)
% Note that support for broken spanners has deliberately been removed.
%
% Use \startMeasureBracket "text" *before* the first note. The bracket will
% attach itself to the barlines (or right after the time signature at staff start)
% and center the given text in bold underneath the bracket.
%
% \startCenteredHeading will print the bold centere heading without the bracket

#(define (measure-bracket-stencil grob has-bracket text)
   ;; stencil override that determines the width of a MeasureCounter
   ;; and creates the annotated bracket
   (let*
    ((ref-point (ly:grob-system grob))
     (left-bound (ly:spanner-bound grob LEFT))
     (right-bound (ly:spanner-bound grob RIGHT))
     (elts-L (ly:grob-array->list (ly:grob-object left-bound 'elements)))
     (elts-R (ly:grob-array->list (ly:grob-object right-bound 'elements)))
     (break-alignment-L
      (filter
       (lambda (elt) (grob::has-interface elt 'break-alignment-interface))
       elts-L))
     (break-alignment-R
      (filter
       (lambda (elt) (grob::has-interface elt 'break-alignment-interface))
       elts-R))
     (break-alignment-L-ext (ly:grob-extent (car break-alignment-L) ref-point X))
     (break-alignment-R-ext (ly:grob-extent (car break-alignment-R) ref-point X))
     (width (- (car break-alignment-R-ext) (cdr break-alignment-L-ext)))
     (heading (ly:stencil-aligned-to
               (grob-interpret-markup grob (markup text))
               X CENTER))
     (heading-centered
      (ly:stencil-translate-axis
       heading
       (+ (interval-length break-alignment-L-ext)
         (* 0.5
           (- (car break-alignment-R-ext)
             (cdr break-alignment-L-ext))))
       X))
     (bracket-path
      (markup #:path 0.2
        `((moveto 0 0)
          (lineto 0 1)
          (lineto ,width 1)
          (lineto ,width 0))))
     (bracket
      (ly:stencil-translate-axis
       (grob-interpret-markup grob bracket-path)
       (interval-length break-alignment-L-ext)
       X))
     (combined-stencil
      (ly:stencil-combine-at-edge
       heading-centered Y UP bracket
       (getOption '(mozart measure-brackets text-padding)))))
    (if has-bracket
        combined-stencil
        heading-centered)))

#(define-public (Measure_attached_spanner_engraver context)
   (let ((span '())
         (finished '())
         (event-start '())
         (event-stop '()))
     (make-engraver
      (listeners ((measure-counter-event engraver event)
                  (if (= START (ly:event-property event 'span-direction))
                      (set! event-start event)
                      (set! event-stop event))))
      ((process-music trans)
       (if (ly:stream-event? event-stop)
           (if (null? span)
               (ly:warning "You're trying to end a measure-attached spanner but you haven't started one.")
               (begin (set! finished span)
                 (ly:engraver-announce-end-grob trans finished event-start)
                 (set! span '())
                 (set! event-stop '()))))
       (if (ly:stream-event? event-start)
           (begin (set! span (ly:engraver-make-grob trans 'MeasureCounter event-start))
             (set! event-start '()))))
      ((stop-translation-timestep trans)
       (if (and (ly:spanner? span)
                (null? (ly:spanner-bound span LEFT))
                (moment<=? (ly:context-property context 'measurePosition) ZERO-MOMENT))
           ; NOTE: the following does not work--BUG? It will cause regtest
           ; scheme-text-spanner.ly to crash!
           ;(set! (ly:spanner-bound span LEFT)
           ;   (ly:context-property context 'currentcommandColumn))
           (ly:spanner-set-bound! span LEFT
             (ly:context-property context 'currentCommandColumn)))
       (if (and (ly:spanner? finished)
                (moment<=? (ly:context-property context 'measurePosition) ZERO-MOMENT))
           (begin
            (if (null? (ly:spanner-bound finished RIGHT))
                (ly:spanner-set-bound! finished RIGHT
                  (ly:context-property context 'currentCommandColumn)))
            (set! finished '())
            (set! event-start '())
            (set! event-stop '()))))
      ((finalize trans)
       (if (ly:spanner? finished)
           (begin
            (if (null? (ly:spanner-bound finished RIGHT))
                (set! (ly:spanner-bound finished RIGHT)
                      (ly:context-property context 'currentCommandColumn)))
            (set! finished '())))
       (if (ly:spanner? span)
           (begin
            (ly:warning "I think there's a dangling measure-attached spanner :-(")
            (ly:grob-suicide! span)
            (set! span '())))))))

% Central entry point for both commands
#(define start-measure-bracket
   (define-music-function (has-bracket text)((boolean? #t) markup?)
     #{
       \override Staff.MeasureCounter.staff-padding =
       \getOption mozart.measure-brackets.staff-padding
       \override Staff.MeasureCounter.outside-staff-horizontal-padding = #0
       \override Staff.MeasureCounter.stencil =
       #(lambda (grob) (measure-bracket-stencil grob has-bracket text ))
       \startMeasureCount
     #}))

startMeasureBracket =
#(define-music-function (text)(markup?)
   (start-measure-bracket #t #{ \markup \bold #text #}))

stopMeasureBracket = \stopMeasureCount

measureBracket =
#(define-music-function (text music)(markup? ly:music?)
   #{
     \startMeasureBracket #text
     #music
     \stopMeasureBracket
   #})


startCenteredHeading =
#(define-music-function (text)(markup?)
   (start-measure-bracket #f #{ \markup \bold #text #}))

stopCenteredHeading = \stopMeasureCount

centeredHeading =
#(define-music-function (text music)(markup? ly:music?)
   #{
     \startCenteredHeading #text
     #music
     \stopCenteredHeading
   #})


startCenteredText =
#(define-music-function (text)(markup?)
   (start-measure-bracket #f #{ \markup #text #}))

stopCenteredText = \stopMeasureCount

centeredText =
#(define-music-function (text music)(markup? ly:music?)
   #{
     \textLengthOn
     \startCenteredText #text
     #music
     \stopCenteredText
     \textLengthOff
   #})


% Install both bracket options in the Voice and Staff contexts
\layout {
  \context {
    \Voice
    \consists "Horizontal_bracket_engraver"
    \override HorizontalBracket.bracket-flare = #'(0 . 0)
    \override HorizontalBracket.staff-padding = 4.5
  }
  \context {
    \Staff
    \consists #Measure_attached_spanner_engraver
    \override MeasureCounter.font-encoding = #'latin1
    \override MeasureCounter.font-size = 0
  }
}
