\version "2.19.80"

% Create grace notes (and variants) that are printed before the barline
% Hack provided by David Kastrup and pointed to by "Thomas Morley"

#(define (apply-pre-bar-grace function content)
   (function #{ \bar "" #content \bar "|" #}))

preBarGrace =
#(define-music-function (content)(ly:music?)
   (apply-pre-bar-grace grace content))

preBarAppoggiatura =
#(define-music-function (content)(ly:music?)
   (apply-pre-bar-grace appoggiatura content))

preBarAcciaccatura =
#(define-music-function (content)(ly:music?)
   (apply-pre-bar-grace acciaccatura content))

