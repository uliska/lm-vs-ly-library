\version "2.21.0"

% Barline with arbitrary number of dashes on either side
#(define
  (dashed-repeat grob)
  (let*
   ((thickness (getOption '(mozart dashed-repeat-thickness)))
    ;; retrieve from abused grob properties
    (left-dashes (ly:grob-property grob 'thickness))
    (right-dashes (ly:grob-property grob 'thick-thickness))
    ;; map to populate dashes from inside out
    (positions (list 3 2 4 1 5 0 6 -1))
    ;; initialize the path with the vertical double barline
    (path
     (list
      (list 'moveto (* thickness -1) 0) (list 'lineto (* thickness -1) 4)
      (list 'moveto thickness 0) (list 'lineto thickness 4)))
    ;; add path segments for one small dash
    (dash
     (lambda (side pos)
       (let*
        ((start-x (* side (+ thickness 0.6)))
         (end-x (+ start-x (* side 0.6)))
         (start-y (- pos 0.4))
         (end-y (- start-y 0.15)))
        (list
         (list 'moveto start-x start-y)
         (list 'lineto end-x end-y))))))
   ;; process both directions and add the requested number
   ;; of dashes on each side
   (for-each
    (lambda (dir)
      (let* ((dash-count (if (= dir LEFT) left-dashes right-dashes)))
        (for-each
         (lambda (index)
           (append! path (dash dir (list-ref positions index))))
         (iota dash-count))))
    (list LEFT RIGHT))
   (ly:stencil-translate-axis
    (grob-interpret-markup grob
      (markup
       #:override '(line-cap-style . butt)
       (#:path thickness path)))
    -2 Y)))

\registerOption mozart.dashed-repeat-thickness 0.35
dashedRepeatBar =
#(define-music-function (dashes-l-r)(pair?)
   #{
     % May be necessary when used at the start of a score (046_1)
     \once \omit Staff.BarLine
     \grace s128
     % Abuse the two numerical properties ...
     % because we need to have the values locally,
     % otherwise the last occurence will be used for all instances
     \once \override Staff.BarLine.thickness = #(car dashes-l-r)
     \once \override Staff.BarLine.thick-thickness = #(cdr dashes-l-r)
     \once \override Staff.BarLine.stencil = #dashed-repeat
     \bar "|"
   #})

% Create a barline with fermatas centered above and below
% Special care has to be taken about the X-extent (to prevent cropping)
% and the protruding stafflines (as triggered by the X-extent)
#(define (fermata-bar grob)
   (let*
    ((stencil (ly:bar-line::print grob))
     (x-offset (interval-center (ly:stencil-extent stencil X)))
     (fermata-above (grob-interpret-markup grob #{ \markup \musicglyph "scripts.ufermata" #}))
     (fermata-below (grob-interpret-markup grob #{ \markup \musicglyph "scripts.dfermata" #}))
     (fermata-x-extent (ly:stencil-extent fermata-above X))
     (fermata-width (interval-length fermata-x-extent))
     (barline-width (interval-length (ly:stencil-extent stencil X)))
     ;; length of the system to the right of the barline, below the fermata
     (system-remaining-width (- (/ fermata-width 2) (/ barline-width 2)))
     ;; a whiteout rectangle to hide the remaining staff-lines
     (whiteout
      (grob-interpret-markup grob
        #{
          \markup {
            \with-color #white
            \filled-box
            #`(0 . ,(+ system-remaining-width 0.1))
            #'(-2.1 . 2.1)
            #0
          }
        #}))
     ;; Combine the "new" stencil from
     ;; - original barline
     ;; - fermatas above and below
     ;; - whiteout rectangle
     (new-stencil
      ;; whiteout
      (ly:stencil-combine-at-edge
       ;; fermata above
       (ly:stencil-combine-at-edge
        ;; fermata below
        (ly:stencil-combine-at-edge
         stencil Y DOWN
         (ly:stencil-translate-axis fermata-below x-offset X)
         1)
        Y UP
        (ly:stencil-translate-axis fermata-above x-offset X)
        1)
       X RIGHT
       whiteout
       (* -1 system-remaining-width))))
    (ly:grob-set-property! grob 'X-extent
      ;; Set the resulting X-extent to the dimensions of the fermata,
      ;; which has to take into account that the fermata is offset
      ;; by half the width of the barline (reference point is the
      ;; right edge of the barline).
      (let ((half-barline (/ barline-width 2)))
        (cons
         (+ (car fermata-x-extent) half-barline)
         (+ (cdr fermata-x-extent) half-barline))))
    ;      fermata-x-extent)
    (ly:grob-set-property! grob 'stencil new-stencil)
    ))

fermataBar =
#(define-music-function (barline)(string?)
   #{
     \once \override Staff.BarLine.before-line-breaking = #fermata-bar
     \bar #barline
   #})


