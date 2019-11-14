\version "2.19.81"

% This function can be used to add some additional padding at the paper top,
% which is sometimes necessary with annotated slurs (and maybe other functions
% that vertically add items after-line-breaking).
% NOTE: The padding will be included in the cropped result
paperTopPadding =
#(define-scheme-function (padding)(number?)
#{
  \markup \vspace #padding
#})

% This forces the elements mentioned above to the page's top.
% While it looks bad in regular engraving it will exactly
% include the elements in the cropped results
forceTopCropping = \markup \vspace #0
