%{
  Leopold Mozart: Violin School (1756) - Markup commands

  Globally available options

  In this file the options are registered and documented.
  Users should *not* overwrite this file but rather set the options
  in <root>/config.ily

%}

\version "2.19.80"

% Active edition-engraver edition(s)
% The edition #'global is always active.
% With this option additional editions can be appended to that.
\registerOption mozart.config.targets #'(default)

% Color to be used for emendations.
\setOption scholarly.annotate.colors.critical-remark #magenta
\setOption scholarly.annotate.color-anchor ##f

% Behandlung von mit \originalBreak kodierten originalen Umbrüchen.
% Mögliche Werte:
% - #'ignore (Default)
%   ignoriere Umbrüche
% - #'use
%   wende originale Umbrüche an
% - #'show
%   zeige originale Umbrüche durch gestrichelte Linie an
\registerOption mozart.config.use-original-breaks #'ignore

% behaviour of \doubleBar
% Printing of double barlines can be suppressed here.
\registerOption mozart.config.print-double-bars ##t

% Default staff padding used to vertically align bowing indications
% (and elements annotating slurs)
\registerOption mozart.markup-staff-padding 2.5

% Default staff padding for annotated clefs
% A clef annotation will have *at least* this distance
% between the annotation and the clef *or* the staff
\registerOption mozart.clef-annotation-staff-padding 1

% Default staff padding used for vertically aligning dynamics to a baseline
\registerOption mozart.dynamic-padding 4

% Configure the appearance of measure-brackets
\registerOption mozart.measure-brackets.staff-padding 4
\registerOption mozart.measure-brackets.text-padding 0

% Option to be used to force direction-dependent staff-padding
% in the staff-padding-by-direction callback function.
% This can be used to force grobs to different common baselines
% depending on the direction.
\registerOption mozart.staff-padding-by-direction #'(0 . 0)


% Load file with user overrides
\include "../config.ily"
