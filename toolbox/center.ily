\version "2.19.82"

% Center a (markup) stencil against an (original) MultiMeasureRest grob
#(define (center-stencil rest-grob markup-stencil)
   (let*
    ((rest-stencil (ly:multi-measure-rest::print rest-grob))
     (centered-markup-stencil (ly:stencil-aligned-to markup-stencil X 0))
     (rest-offset (interval-center (ly:stencil-extent rest-stencil X))))
    ;; return the self-centered time stencil offset by the rest's offset
    (ly:stencil-translate-axis centered-markup-stencil rest-offset X)))

% Configure the staff-padding for the annotations
\registerOption mozart.centered.staff-padding-up 1
\registerOption mozart.centered.staff-padding-down 1

#(define (annotate-centered rest-grob markup-stencil upper-padding upper lower-padding lower)
   (let*
    ((base-stencil (center-stencil rest-grob markup-stencil))
     (base-y-extent (ly:stencil-extent base-stencil Y))
     (upper-offset (- 2 (cdr base-y-extent)))
     (lower-offset (+ (car base-y-extent) 2))
     (upper-stencil
      (center-stencil rest-grob
        (grob-interpret-markup rest-grob
          (markup
           #:override '(baseline-skip . 2.5) upper))))
     (lower-stencil
      (center-stencil rest-grob
        (grob-interpret-markup rest-grob
          (markup
           #:override '(baseline-skip . 2.5) lower))))
     (combined-stencil
      (ly:stencil-combine-at-edge
       (ly:stencil-combine-at-edge
        base-stencil Y DOWN
        lower-stencil
        (+ lower-offset lower-padding))
       Y UP
       upper-stencil
       (+ upper-offset upper-padding))))
    combined-stencil))

% Center some (annotated) music in a measure

% Wrap the music in a bare \markup \score context
% and return its stencil
getBareScoreMarkupStencil =
#(define-scheme-function (grob music)(ly:grob? ly:music?)
   (grob-interpret-markup grob
     #{
       \markup \score {
         \new Staff = "centered" {
           % Necessary to remove some offset to the right
           % (caused by the regular system-start gap)
           \once \override NoteColumn.X-offset = -2
           $music
         }
         \layout {
           ragged-right = ##t
           \context {
             \Score
             \omit StaffSymbol
             \omit Clef
             \omit TimeSignature
             \omit KeySignature
             \omit BarLine
           }
         }
       }
     #}))

% Fake transparent ascenders and descenders to force proper alignment
#(define-markup-command (ascender-descender-placeholder layout props) ()
  (let* ((sten (interpret-markup layout props #{
            \markup \transparent \overlay { X g } #} ))
         (yex (ly:stencil-extent sten Y)))
    (ly:make-stencil (ly:stencil-expr sten) empty-interval yex)))

#(define-markup-command (Xg layout props arg) (markup?)
  (interpret-markup layout props #{ \markup \concat {
    \ascender-descender-placeholder $arg } #} ))


annotateCenteredMusic =
#(with-options define-music-function (music)(ly:music?)
   `(strict
     (? above ,markup? ,(markup #:null))
     (? below ,markup? ,(markup #:null))
     (? horizontal-padding ,number? 2)
     )
   ;; Store data in a closure to drag it over from the music-function stage
   ;; to before-line-breaking and stencil
   (let ((upper
          ;; apply \Xg (ascender/descender placeholder) for non-null markups
          ;; NOTE:
          ;; in multiline markups the \Xg markup command has to be applied
          ;; manually at one point in the last line if that last line
          ;; doesn't contain a descender!
          (let ((original (assq-ref props 'above)))
            (if (equal? original (markup #:null))
                original
                (markup #:Xg original))))
         (lower
          (let ((original (assq-ref props 'below)))
            (if (equal? original (markup #:null))
                original
                (markup #:Xg original))))
         (music-stil #f)
         (upper-stil #f)
         (lower-stil #f)
         (upper-padding (getOption '(mozart centered staff-padding-up)))
         (lower-padding (getOption '(mozart centered staff-padding-down)))
         (horizontal-padding (assq-ref props 'horizontal-padding)))
     #{
       \tweak before-line-breaking
       #(lambda (grob)
          ;; Create the three markup stencils *now* and store it in the closure
          ;; so we can use its dimensions to affect the layout.
          (set! music-stil #{ \getBareScoreMarkupStencil #grob #music #})
          (set! upper-stil (grob-interpret-markup grob upper))
;                             #{ \markup \Xg Test #}))
          (set! lower-stil (grob-interpret-markup grob lower))
;                             #{ \markup \Xg $lower #}))
          (let*
           ((max-text-width
             (max
              (interval-length (ly:stencil-extent upper-stil X))
              (interval-length (ly:stencil-extent lower-stil X))))
            (music-width (interval-length (ly:stencil-extent music-stil X)))
            (width-diff
             (abs (/ (- max-text-width music-width) 2)))
            (dummy (ly:message "Music width: ~a" width-diff))
            )
;           (ly:grob-set-property! grob 'bound-padding (- width-diff 2)))

          (ly:grob-set-property! grob 'Y-extent
            ;; Include the markups in the Y-extent of the MMR
            ;; so it won't get cut off the page
            (cons
             (min
              (- 0 2 lower-padding (interval-length (ly:stencil-extent lower-stil Y)))
              (car (ly:stencil-extent music-stil Y)))
             (max
              (+ 2 upper-padding (interval-length (ly:stencil-extent upper-stil Y)))
              (cdr (ly:stencil-extent music-stil Y)))
              ))

          (ly:grob-set-property! grob 'minimum-length
            ;; widen the measure to encompass music content, upper, and lower markup
            ; TODO: This still is confused by leading Clef/Time/Key
            (+ horizontal-padding
              (max
               (interval-length (ly:stencil-extent upper-stil X))
               (interval-length (ly:stencil-extent lower-stil X))
               (interval-length (ly:stencil-extent music-stil X)))))
;          (ly:grob-set-property! grob 'bound-padding
;            (/ (abs (-
;                     (interval-length (ly:stencil-extent lower-stil X))
;                     (interval-length (ly:stencil-extent music-stil X)))
;                     ) 2))

          ))
       \tweak stencil
       #(lambda (grob)
          ;; Replace the MMR stencil with the combined stencil created earlier
          (annotate-centered grob music-stil
            upper-padding upper lower-padding lower))
       R1
     #}))
