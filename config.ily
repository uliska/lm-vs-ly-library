\version "2.19.80"

% User-facing configuration file
% Default for the options registered and documented in internal/options.ily
% can be overriden here.

% Export targets for annotations
\setOption scholarly.annotate.export-targets #'(console)

% "editions" to which edition mods may be applied.
% NOTE: Currently there's only 'default and 'global
%\setOption mozart.config.targets #'(default)

% Behaviour of \doubleBar
%\setOption mozart.config.print-double-bars ##t

% Handling of original breaks
%\setOption mozart.config.use-original-breaks #'ignore

% Color to be used for emendations.
%\setOption scholarly.annotate.colors.critical-remark #magenta

% Default staff padding used to vertically align bowing indications
% (and elements annotating slurs)
%\setOption mozart.markup-staff-padding 2.5

% Default staff padding for annotated clefs
% A clef annotation will have *at least* this distance
% between the annotation and the clef *or* the staff
%\setOption mozart.clef-annotation-staff-padding 1

% Default staff padding used for vertically aligning dynamics to a baseline
%\setOption mozart.dynamic-padding 4

% Configure the appearance of measure-brackets
%\setOption mozart.measure-brackets.staff-padding 4
%\setOption mozart.measure-brackets.text-padding 0

% Option to be used to force direction-dependent staff-padding
% in the staff-padding-by-direction callback function.
% This can be used to force grobs to different common baselines
% depending on the direction.
%\setOption mozart.staff-padding-by-direction #'(0 . 0)
