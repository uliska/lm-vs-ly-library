%{
  Leopold Mozart: Violin School (1756)

  edition-engraver integration

%}

\version "2.19.80"

\loadPackage edition-engraver
\consistToContexts #edition-engraver Score.Staff.Voice.FiguredBass

% \mod
% Wrapper around \editionMod for more efficient encoding in the edition's context
%
% - edition
%   target edition. Default: #'global
% - measure
% - moment measure and (zero-based) moment in measure
%   moment can be given as a fraction or a full "moment"
% - context
%   context to be addressed.
%   symbol-list?, implicitly prepended wtih <example> to address the current example
%   which may become relevant if multiple examples should be compiled in one run.
%   default: #'(<example> Voice A) which is implicitly used in regular cases.
% - expression
%   arbitrary ly:music? expression if supported by edition-engraver
%
% Example:
% \mod 1 0/4 \override NoteHead.color = #red
#(define (fraction-or-moment? obj)
   (or (fraction? obj)
       (ly:moment? obj)))
mod =
#(define-void-function (edition measure moment context expression)
   ((symbol? 'global) integer? fraction-or-moment? (symbol-list? '(Voice A)) ly:music?)
   (editionMod edition measure moment
     (append (list (string->symbol current_example)) context) expression))
