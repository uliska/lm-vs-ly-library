\version "2.19.80"

% Zentrale Konfigurationsdatei

% Export-Targets für Annotationen
\setOption scholarly.annotate.export-targets #'(console)

% "Editionen", auf die Mods angewandt werden.
% Verfügbare Editionen/Targets:
% - 'global (immer verfügbar)
%   Mods, die unabhängig vom Target anzuwenden sind
% - 'default (default)
%   Standard-Target (TODO: noch zu definieren!)
% - ...
%\setOption mozart.config.targets #'(default)

% Behandlung von doppelten Taktstrichen zum Beenden von Beispielen.
% Diese sollen kodiert und angezeigt werden. Bei Bedarf kann die
% Anzeige über diese Option deaktiviert werden.
%\setOption mozart.config.print-double-bars ##f

% Behandlung originaler Umbrüche.
% - default: #'ignore
% - #'use (respektiere originale Umbrüche)
% - #'show (zeige originale Umbrüche durch gestrichelte Linie an)
%\setOption mozart.config.use-original-breaks #'ignore
