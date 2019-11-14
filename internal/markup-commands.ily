%{
  Leopold Mozart: Violin School (1756) - Markup commands

  Globally available shorthands and functions dealing with markup

%}

\version "2.19.80"

% \sans-italic shorthand to be used *inside* a \markup
#(define-markup-command
  (sans-italic layout props text)(markup?)
  (interpret-markup layout props
    (markup #:sans #:italic text)))

% Primitive implementation of letterspacing (which isn't present in LilyPond).
% Simply inject space chars between all the letters.
#(define-markup-command
  (letterspaced layout props text)(string?)
  (let*
   (;; convert string to list of raw UTF-32 numbers
    (utf-chars (string->utf32 text))
    ;; Interleave spaces (32) between the characters
    (spaced-list
     (let ((result '()))
       (for-each
        (lambda (elt)
          (set! result (cons elt result))
          (set! result (cons 8202 result)))
        utf-chars)
       ;; reverse the list (which has been reversed through the cons-es
       ;; and strip the surplus space that is now at the head of the list
       (reverse result)))
    (spaced-text (utf32->string spaced-list))
    )
   (interpret-markup layout props
     (markup (utf32->string spaced-list)))))

#(define-markup-command (double-underline layout props args)
  (markup?) #:properties ((offset 3) (gap 3))
  (interpret-markup layout props
    (markup #:override (cons 'offset (+ offset gap)) #:underline
            #:override (cons 'offset offset) #:underline args)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Dynamics
%
% All dynamics are implemented as markups
% because staff-padding makes them align to the characters' *baselines*
% (as opposed to their top).
%
% Optionally merge dynamic with regular characters to allow for mixed dynamics
dynamic-string =
#(define-music-function (input)(string?)
   (let*
    ((padding (getOption '(mozart dynamic-padding)))
     (chars (string->list input))
     (merge-list
      (lambda (lst1 lst2)
        (cond ((null? lst1) lst2) ; if the first list is empty, return the second
          ((null? lst2) lst1)     ; if the second list is empty, return the first
          (else (cons (car lst1)  ; otherwise `cons` the first element of the first list
                  (merge-list lst2 (cdr lst1))))))) ; and interleave the lists
     ;; This is inspired by
     ;; https://github.com/openlilylib/snippets/tree/master/input-shorthands/easy-custom-dynamics
     (formatted
      (map
       (lambda (char)
         (let ((str (string char)))
           (if (string-match "^[mrzfps]*$" str)
               (markup #:dynamic str)
               ;               (markup #:hspace 2)
               (markup #:normal-text #:italic str))))
       chars)))
    #{
      -\tweak staff-padding #padding
      _\markup #(list-join formatted (markup #:hspace -0.5))
    #}))

% All used dynamics have to be redefined here:
p =
#(define-music-function ()()
   (dynamic-string "p"))
"f" =
#(define-music-function ()()
   (dynamic-string "f"))
fp =
#(define-music-function ()()
   (dynamic-string "fp"))

% Format a "flat" in markup
Flat = \markup \concat { \hspace #-0.35 \raise #0.5 \fontsize #-1 \flat \hspace #-0.6 }

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bass figure accidentals
%
% Accidentals in bass figures are deemed too small, therefore they
% have to be replaced with the following markups
figureSharp =
#(define-music-function (duration)(ly:duration?)
   #{
     \figuremode {
       \once \override BassFigure.font-size = 2
       \once \override BassFigure.extra-offset = #'(0 . 0.5)
       #(make-music
         'EventChord
         'elements
         (list (make-music
                'BassFigureEvent
                'duration
                duration
                'alteration
                1/2)))
     }
   #})

% Customized natural in bass figures
figureNatural =
#(define-music-function (duration)(ly:duration?)
   #{
     \figuremode {
       \once \override BassFigure.font-size = 2
       \once \override BassFigure.extra-offset = #'(0 . 0.5)
       #(make-music
         'EventChord
         'elements
         (list (make-music
                'BassFigureEvent
                'duration
                duration
                'alteration
                0)))
     }
   #})


% Paragraph references, put in brackets
ref =
#(define-event-function (paren target)((boolean? #t) string?)
   (make-music 'TextScriptEvent 'text
     (markup (if paren (string-append "(" target ")" )
                 target))))

% replacement for \finger when textual elements are present besides numbers
fingerPlain =
#(define-music-function (size text)((number? -2) markup?)
   #{
     \tweak font-encoding #'latin1
     \tweak font-size #size
     \finger #text
   #})

% Place a normally formatted text over a barline
barlineComment =
#(define-music-function (text)(markup?)
   #{ \mark \markup \normalsize #text #})


#(define (align-text-to-staff grob)
   "Determine the grob's horizontal distance from the staff symbol
    and offset the grob by that amount to align it with the left edge."
   (let*
    ((offset (* -1 (oll:grob-system-position grob X))))
    (ly:grob-set-property! grob 'extra-offset (cons offset  0))))

#(define (align-text-padded-to-staff grob)
   "Determine the grob's horizontal distance from the staff symbol
    and offset the grob by that amount to align it with the left edge.
    Finally add some padding between the systemstartbar and the text"
   (let*
    ((offset (* -1 (oll:grob-system-position grob X))))
    (ly:grob-set-property! grob 'extra-offset (cons (+ 1 offset)  0))))

% Some text right to the staff's end
afterStaffText =
#(define-music-function (text)(markup?)
   #{
     s32
     \stopStaff
     s32
     \once \omit Stem
     \once \omit Flag
     \once \override NoteHead.stencil = #ly:text-interface::print
     \once \override NoteHead.text = #text
     a
   #})
