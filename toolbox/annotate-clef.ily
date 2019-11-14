\version "2.19.81"

% Print annotations to clefs, horizontally centered both above and below the clef.
% The option defines the (minimum) padding outside of the outer staff lines.
annotateClef =
#(define-music-function (padding text-above text-below) ((number? 1) markup? markup?)
   #{
     \once \override Staff.Clef.before-line-breaking =
     #(lambda (grob)
        (let*
         ((stencil (ly:clef::print grob))
          ;; minimal distance between center staff line and markup
          (padding-threshold
           (+ 2 (getOption '(mozart clef-annotation-staff-padding))))
          ;; reference point of the original clef
          (vpos (/ (ly:grob-property grob 'staff-position) 2))
          ;; upper and lower edges of the clef
          (vextent (ly:stencil-extent stencil Y))
          (clef-top (+ vpos (cdr vextent)))
          (clef-bottom (+ vpos (car vextent)))
          ;; calculate padding acknowledging distance to clef *and* to staff
          (padding-top (max padding (- padding-threshold clef-top)))
          (padding-bottom (max padding (+ padding-threshold clef-bottom)))
          ;; create stencil for upper text and horizontal shift for centering
          (markup-stencil-above (grob-interpret-markup grob text-above))
          (shift-above (- (interval-center (ly:stencil-extent stencil X))
                   (interval-center (ly:stencil-extent markup-stencil-above X))))
          ;; create stencil for lower text
          (markup-stencil-below (grob-interpret-markup grob text-below))
          (shift-below (- (interval-center (ly:stencil-extent stencil X))
                   (interval-center (ly:stencil-extent markup-stencil-below X))))
          ;; combine the three stencils
          (new-stencil
           (ly:stencil-combine-at-edge
            (ly:stencil-combine-at-edge
             stencil Y DOWN
             (ly:stencil-translate-axis markup-stencil-below shift-below X)
             padding-bottom)
            Y UP
            (ly:stencil-translate-axis markup-stencil-above shift-above X)
            padding-top)))
         (ly:grob-set-property! grob 'stencil new-stencil)))
   #})
