\version "2.19.81"

% Print an example number above the clef, using \annotateClef internally
% If the command is followed by a \clef *this* one is annotated,
% otherwise a treble clef is implicitly used.
% (This also means that if clefs should be omitted
% no example number will be printed.

\include "annotate-clef.ily"

exampleNumber =
#(define-music-function (text music)(markup? ly:music?)
   (let
    ;; test if "music" is a clef or any other music
    ((explicit-clef
      (let ((element (ly:music-property music 'element)))
        (and (not (null? element))
             (let ((elements (ly:music-property element 'elements)))
               (and elements
                    (eq? 'clefGlyph (ly:music-property (first elements) 'element))))))))
    #{
      \annotateClef #text ""
      #(if explicit-clef
           music
           #{
             \clef treble
             #music
           #})
    #}))

% Print a parenthesized text "before" the next note
% (while the "before" is achieved through right-aligning)
exampleIndex =
#(define-music-function (text)(markup?)
   #{
     s1*0
     -\tweak self-alignment-X #1.4
     ^#(format "(~a)" text)
   #})

