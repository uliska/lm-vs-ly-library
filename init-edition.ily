%{
  Leopold Mozart: Violin School (1756)

  Global entry file for example compilation - set up the infrastructure

%}

\version "2.19.80"

#(use-modules
  (ice-9 regex))

% Store the bare name of the current example (without path and file extension)
% Remove a -type suffix that may be used during batch compilation
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load openLilyLib packages
%

\include "oll-core/package.ily"

% grob-tools for system-related formatting
\loadPackage \with {
  modules = #'(system)
} grob-tools

% Functionality to load Tools and Templates
\loadModule oll-core.load.tools
\loadModule oll-core.load.templates

% support
% NOTE: The Ross font has to be explicitly made available
%       for the current LilyPond installation
\loadPackage notation-fonts

% scholarLY
%
% critical annotations
\loadModule scholarly.annotate
% optionally visualize or apply original line breaks
% NOTE: This hasn't been strictly encoded yet :-(
\loadModule scholarly.diplomatic-line-breaks

% edition-engraver
% apply tweaks from include files
%
\loadPackage edition-engraver
\include "internal/edition-engraver.ily"

% openLilyLib loading
%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configure openLilyLib packages
%

% Toolbox and templates are subdirectories of init-edition.ily
\setOption oll-core.load.tools.directory
#(os-path-join (append (this-dir) '(toolbox)))
\setOption oll-core.load.templates.directory
#(os-path-join (append (this-dir) '(templates)))


% register global options, set defaults,
% then load file with user overrides
\include "internal/options.ily"
\include "config.ily"

% "install" the edition-engraver targets that should be used
% (according to selected options).
% NOTE: Currently only the 'global target is implemented
#(let
  ((targets (append '(global) (getOption '(mozart config targets)))))
  (for-each
   (lambda (edition)
     (addEdition edition))
   targets))

% General stylesheet
% TODO: define and load styles for alternative targets
\include "default-appearance.ily"


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global tools
%
% The following files include globally available tools and commands
% These are available to *any* example without having to be loaded
% explicitly

\include "internal/utf32.ily" % NOTE: It is not clear whether this is actually still in use
\include "internal/markup-commands.ily"
\include "internal/original-breaks.ily"
\include "internal/staff-padding.ily"
\include "internal/articulations.ily"

% Conditionally include a file <basename>-include.ily if present on disk.
% This file is intended to hold any styling information, tool loading
% and other non-content data

\loadInclude "~a-include.ily"
