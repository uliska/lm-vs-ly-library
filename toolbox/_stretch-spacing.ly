\version "2.19.82"

% Internal "module", used in spacing-loose and spacing-tight
% Copied from oll-misc/layout/horizontal-spacing

stretch-spacing =
#(define-scheme-function (exponent)(number?)
   (lambda (grob)
       (let* ((func (assoc-get 'common-shortest-duration
                      (reverse (ly:grob-basic-properties grob))))
              (default-value (func grob))
              ;; When dealing with moments, we need to operate on an
              ;; exponential scale. We use 'inexact->exact' to make sure
              ;; that 'rationalize' will return an exact result as well.
              (factor (inexact->exact (expt 2 (- 0 exponent))))
              ;; The second argument to 'rationalize' has to be fairly
              ;; small to allow lots of stretching/squeezing.
              (multiplier (ly:make-moment (rationalize factor 1/2000))))
         (ly:moment-mul default-value multiplier))))
