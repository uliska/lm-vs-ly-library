%{
  Leopold Mozart: Violin School (1756)

  Handling staff-padding calculations

%}

\version "2.19.80"

% Try aligning all textual indicators on a common baseline.
% By default this is at 2.5 staff spaces above and 3.5 staff spaces
% below the staff. The option refers to the padding *above* the staff.

#(define (calc-staff-padding grob staff-padding)
   "Calculate the staff-padding value of a grob.
    This has to be done in a callback since it seems to be
    the only solution to both align texts to the baseline
    (using staff-padding) *and* to adjust upper and lower
    padding. See
    http://lists.gnu.org/archive/html/lilypond-user/2018-10/msg00267.html"
   (let ((dir (ly:grob-property grob 'direction)))
     (if (> dir 0)
         staff-padding
         ; NOTE: It is somewhat arbitrary to have lower texts
         ; pad by exactly 1 staff space more than above
         ; TODO: Calculate by creating a "Tq" markup and measuring its Y-extent
         (+ 1 staff-padding))))

\registerOption mozart.staff-padding-by-direction ##f
#(define (get-current-markup-staff-padding)
   "Determine the current (at the time of parsing, e.g. of a music function)
    staff-padding for markups. This is either the pair stored in
    mozart.staff-padding-by-direction or a calculated pair using
    mozart.markup-staff-padding and offsetting the lower value by 1."
   (or (getOption '(mozart staff-padding-by-direction))
     (let ((current-padding (getOption '(mozart markup-staff-padding))))
       (cons current-padding (+ 1 current-padding)))))

#(define (staff-padding-by-direction grob paddings)
   "Set the staff-padding of a grob depending on its direction.
    This is necessary to force grobs on common baseline that are
    different above and below the staff."
     (if (= (ly:grob-property grob 'direction) 1)
         (car paddings)
         (cdr paddings)))
