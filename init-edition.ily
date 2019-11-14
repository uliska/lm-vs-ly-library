%{
  Leopold Mozart: Violin School (1756)

  Global entry file for example compilation - set up the infrastructure

%}

\version "2.19.80"

#(use-modules
  (ice-9 regex))

% Store the bare name of the current example (without path and file extension)
% Remove a -type suffix that may appear during batch compilation
current_example =
#(let*
  ((original (ly:parser-output-name))
   (matched (string-match "-.+" original)))
  (if matched
      (match:prefix matched)
      original))

% Pass the command line option -dsystems (as done by the Frescobaldi extension build script)
% to use lilypond-book-preamble to compile individual, cropped systems.
% The idea behind this is that regular compilation (e.g. while working in Frescobaldi)
% produces regular PDF output.
#(if (ly:get-option 'systems)
     (ly:parser-include-string "\\include \"lilypond-book-preamble.ly\""))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% activate openLilyLib packages
%
\include "oll-core/package.ily"
\loadPackage \with {
  modules = #'(system)
} grob-tools

% Functionality to load Tools and Templates
\loadModule oll-core.load.tools
\setOption oll-core.load.tools.directory
#(os-path-join (append (this-dir) '(toolbox)))

\loadModule oll-core.load.templates
\setOption oll-core.load.templates.directory
#(os-path-join (append (this-dir) '(templates)))

% activating alternative notation font Ross
% NOTE: This font has to be explicitly made available in the current LilyPond installation
\loadPackage notation-fonts

%
% scholarLY-Module
%
% critical annotations
\loadModule scholarly.annotate
% optionally visualize original line breaks
% NOTE: This hasn't been strictly encoded :-(
\loadModule scholarly.diplomatic-line-breaks

% edition-engraver
% apply tweaks from include files
\include "internal/edition-engraver.ily"

% openLilyLib
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define global (not tool-based) options, set defaults,
% and load user overrides
\include "internal/options.ily"

% Installiere die edition-engraver-Targets (entsprechend der
% Auswahl mit den Optionen)
% "install" the edition-engraver targets that should be used
% (according to selected options).
% NOTE: Currently only the 'global target is implemented
#(let
  ((targets (append '(global) (getOption '(mozart config targets)))))
  (for-each
   (lambda (edition)
     (addEdition edition))
   (if (list? targets)
       targets
       (list targets))))

% General appearance
\include "default-appearance.ily"

% TODO: define and load styles for alternative targets

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global tools
%
% The following files include globally available tools and commands
% These are available to *any* example without having to be loaded
% explicitly

\include "internal/utf32.ily"
\include "internal/markup-commands.ily"
\include "internal/original-breaks.ily"
\include "internal/staff-padding.ily"
\include "internal/articulations.ily"

% If a file <basename>-include.ily is present it will be included.
% This file is intended to hold any styling information, tool loading
% and other non-content data

\loadInclude "~a-include.ily"
