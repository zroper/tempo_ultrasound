% HOTINFO.M - Establish a HOT link to a TEMPO SYSINFO field
%
% Usage: hotinfo
%
% We automatically receive notifications when the SYSINFO field changes
%
% MATLAB asks TEMPO to automatically send updates whenever a SYSINFO field
% changes.  Here, we just receive and display the value TEMPO sends.  But you
% can do whatever you want in MATLAB when the field changes.
%
% Run TEMPO/Win before running this MATLAB script.
%
% IN
%       itemString      Name of field
%           DATABASES           Max number of databases
%           ACHANNELS           Number of analog channels
%           CCHANNELS           Number of counter channels
%           ECHANNELS           Number of event channels
%           SPEED               Acquisition rate
%           ASETS               ASETS parameter
%           STATUS              Status register
%           CANCEL              Cancel register
%           CLOCK               =1 clock is ON, =0 clock is OFF
%           ANALOGBITS          =8, 12 or 16 bit analog card
%           LOST                Lost count
%
% OUT
%       value of field
%
% SEE ALSO
%   Matlab's online documentation Ch 5 Using the MATLAB Engine, p5-14
%   \matlab\help\techdoc\apiref
%   \matlab\help\techdoc\pdfdocs\apiguide.pdf
%   \matlab\help\techdoc\pdfdocs\apiref.pdf

HOTitem = 'clock';                      % field to monitor

HOTservice = 'TEMPO';
HOTtopic = 'SYSINFO';                   % Connect to a TEMPO's SYSINFO
HOTconver = ddeinit(HOTservice, HOTtopic);  % From TEMPO to MATLAB
                          
% This function will be evaluated by MATLAB each time we receive notification
% that the database has changed.  Here, we simply display the epoch count
% but you can do more fancy things like download the data, analyze it and
% display it.

HOTcallback = 'disp(tempoBuf)';         % Just display the information received from TEMPO

% NewValue contains the name of the MATLAB variable that receives the field
% value.  By specifying a value, we create a HOT link instead of a WARM link.
% In a WARM link, only the callback is called and we don't receive the
% actual epoch count.  Thus, an event in TEMPO (start/stop clock)
% can trigger execution of a callback function in MATLAB).  See ddeadv()
% documentation for more information.

newValue = 'tempoBuf';                  % Matlab variable into which value will be stored

%if (strcmp(HOTitem, 'title') | strcmp(HOTitem, 'filename'))
%    resultType = 1;                     % STRING: Matlab interprets TEMPO's response as a string
%else
%    resultType = 0;                     % NUMERIC: Matlab interprets TEMPO's response as numeric
%end
resultType = 0;                         % All SYSINFO fields are numeric

format = [1 resultType];                % 1=CF_TEXT, Result:NUMERIC=0, STRING=1
timeout = 3000;                         % (ms) timeout to establish advisory link

% Now establish an advisory link to TEMPO.

t = sprintf('TEMPO SYSINFO "%s" being monitored', HOTitem);
disp(t);                                % Display the title on Matlab's command line


rc = ddeadv(HOTconver, HOTitem, HOTcallback, newValue, format, timeout);

% Put up a dialog with a button that allows user to close the link.
%
% The CLOSE button's callback is a (MATLAB callback) string that is
% evaluated when the user clicks the button.  This string closes the
% link to TEMPO and terminates the conversation.

c = uicontrol('String', '&Close', ...
        'Position', [5 5 80 30], ...
        'Callback', 'rc = ddeunadv(HOTconver, HOTitem); ddeterm(HOTconver); close;');
