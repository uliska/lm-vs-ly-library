\version "2.19.82"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Textual and graphical bowing indicators.
% Provides:
% - overrides of \upbow and \downbow
% - \bowAlignedText, like \upbow and \downbow for arbitrary text

#(define (create-bow text)
   (let ((current-padding (get-current-markup-staff-padding)))
     #{
       % Force horizontal padding
       -\tweak extra-spacing-width #(cons -0.0 0.4)
       % Prevent vertical stacking
       -\tweak outside-staff-priority ##f
       % calculate vertical position (won't work with \tweak staff-padding)
       % tweaking staff-padding to a callback causes wrong behaviour
       % (see https://lists.gnu.org/archive/html/lilypond-user/2019-01/msg00698.html)
       -\tweak before-line-breaking
       #(lambda (grob)
          (ly:grob-set-property! grob 'staff-padding
            (staff-padding-by-direction grob current-padding)))
       -\markup #text
     #}))

downbow =
#(define-event-function ()()
   (create-bow "her."))

upbow =
#(define-event-function ()()
   (create-bow "hin."))

% Create an arbitrary text whose vertical alignment
% behaves like bowing indications
bowAlignedText =
#(define-event-function (text)(markup?)
   (create-bow text))
