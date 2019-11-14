%{
  Leopold Mozart: Violin School (1756)

  Custom articulations

%}

\version "2.19.80"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First define the appearance and default properties of the articulations

% \strich
% vertical stroke which can partially be seen as a meta sign,
% a bowing indication or an actual articulation.
% (see https://github.com/ism-dme/lm-vs-ly/issues/23)
%
#(define strich-stencil
   (lambda (grob)
     (grob-interpret-markup grob
       #{
         \markup \path #0.19
         #`((moveto 0 0)
            (lineto 0 0.75))
       #})))
#(define strich-list
   `("strich" .
      ((avoid-slur . inside)
       (padding . 0.5)
       (stencil . ,strich-stencil)
       (side-relative-direction . ,DOWN)
       (toward-stem-shift . 1))))

% \asterisk
% star used as a reference mark
%
#(define asterisk-list
   `("asterisk"
      . ((stencil . ,ly:text-interface::print)
         (text . ,#{ \markup \musicglyph "pedal.*" #})
         (padding . 0.5)
         (avoid-slur . around)
         (direction . ,DOWN)
         (script-priority . 125)
         )))

% \t
% Leopold Mozart's indication of a trill: "t."
%
#(define (make-trill-list name text)
   `(,name
      . ((stencil . ,ly:text-interface::print)
         (text . ,#{ \markup \normal-text \fontsize #-1 #text #})
         (padding . 0.5)
         (avoid-slur . inside)
         (direction . ,UP)
         ;; Set to a value < 100 to force closer than Fingering
         (script-priority . 75)
         ;; center over stem when on stem side
         (toward-stem-shift . 0.75)
         )))

#(define trill-list (make-trill-list "trill" "t."))
#(define trill-list-brief (make-trill-list "trill-brief" "t:"))

%% A macro setting the lists from above in the copy of `default-script-alist´
%% For now, every new script has to be inserted in a single run.
%% TODO
%% Probably better to do simpler list processing with append, cons etc
#(define-macro (set-my-script-alist! ls-1 ls-2)
   "Creates a new key-value-pair, taken from ls-2, in ls-1"
   `(set! ,ls-1
          (if (and (pair? ,ls-2) (pair? (cadr ,ls-2)))
              (assoc-set! ,ls-1 (car ,ls-2) (cdr ,ls-2))
              (begin
               (ly:warning (_"Unsuitable list\n\t~a \n\tdetected, ignoring. ") ,ls-2)
               ,ls-1))))

#(set-my-script-alist! default-script-alist strich-list)
#(set-my-script-alist! default-script-alist asterisk-list)
#(set-my-script-alist! default-script-alist trill-list)
#(set-my-script-alist! default-script-alist trill-list-brief)

\layout {
  \context {
    \Score
    scriptDefinitions = #default-script-alist
  }
}

% Create actual articulations from the definitions
strich = #(make-articulation "strich")
asterisk-artic = #(make-articulation "asterisk")
trill-artic = #(make-articulation "trill")
trill-artic-brief = #(make-articulation "trill-brief")

% Wrapper around the asterisk-articulation
% By default we want this to be on the notehead side.
% If an exception is desired \asterisk-artic has to be used explicitly

#(define (calc-note-head-side grob)
   (* -1 (stem-direction grob)))

asterisk =
#(define-event-function ()()
   (let ((current-padding (get-current-markup-staff-padding)))
     #{
       % As staff-padding affects the baseline, staff-padding has to be
       % increased for direction DOWN
       -\tweak staff-padding
       #(lambda (grob)(staff-padding-by-direction grob current-padding))
       -\tweak direction #calc-note-head-side
       % Necessary to force original size when used in grace music
       -\tweak font-size 0
       -\asterisk-artic
     #}))

% Event function wrapper for trill
t =
#(define-event-function ()()
   #{
     -\trill-artic
   #})

tr =
#(define-event-function ()()
   #{
     -\trill-artic-brief
   #})
