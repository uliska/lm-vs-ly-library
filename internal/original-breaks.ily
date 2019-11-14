%{
  Leopold Mozart: Violin School (1756) - Markup commands

  Handling original breaks

%}

\version "2.19.80"

% Commands to encode original breaks in the printed edition.
% Depending on the options these may be ignored, used or displayed
% (through a short vertical line)
originalBreak =
#(define-music-function ()()
   (case (getOption '(mozart config use-original-breaks))
     ((use) #{ \bar "" \break #})
     ((show) #{ \diplomaticLineBreak #})
     ((ignore) #{ #})))

originalPageBreak =
#(define-music-function ()()
   (case (getOption '(mozart config use-original-breaks))
     ((use) #{ \bar "" \pageBreak #})
     ((show) #{ \diplomaticLineBreak #})
     ((ignore) #{ #})))

#(define (break-state? obj)
   (and (symbol? obj)
        (memq obj '(use show ignore))))
originalBreaks =
#(define-void-function (state)(break-state?)
   (setOption '(mozart config use-original-breaks) state))


% Encoding of double barlines in the printed edition
doubleBar =
#(define-music-function ()()
   (if (getOption '(mozart config print-double-bars))
       #{ \bar "||" #}
       #{ \bar "|" #}))
