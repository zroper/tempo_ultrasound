% HOTEXPR.M - Establish a HOT link to a TEMPO expression
%
% Usage: hotexpr
%
% We automatically receive notifications when the value of the
% expression changes.
%
% MATLAB asks TEMPO to automatically send updates whenever the value of a
% TEMPO expression changes.
%
% Here, we just receive and display the value TEMPO sends.  But you
% can do whatever you want in MATLAB when the expression changes.
%
% Expression can be a simple protocol or local variable or some
% complex formula involving both protocol and local variables.
%
% TEMPO's DDE server evaluates the expression periodically (ie appx 20 Hz)
% and sends its new value if there is a change.
%
% Run TEMPO/Win before running this MATLAB script.
%
% SYNOPSIS
%       hotexpr                   Run this script
%
% IN
%       HOTexpr                   Set this matlab string variable to the expression
%                                   you want to monitor
%
% OUT
%       value of expression as it changes.
%
% SEE ALSO
%   Matlab's online documentation Ch 5 Using the MATLAB Engine, p5-14
%   \matlab\help\techdoc\apiref
%   \matlab\help\techdoc\pdfdocs\apiguide.pdf
%   \matlab\help\techdoc\pdfdocs\apiref.pdf


% Change HOTexpr to monitor any protocol or local variable
% or any expression of them.
% This must be a valid expression for your protocol.

HOTexpr = '$query';



HOTservice = 'TEMPO';
HOTtopic = 'EXPR';                      % Connect to a database
HOTconver = ddeinit(HOTservice, HOTtopic);  % From TEMPO to MATLAB
                          
% This function will be evaluated by MATLAB each time we receive notification
% that the expression has changed.  Here, we simply display the value
% but you can do more fancy things like download the data, analyze it and
% display it.

HOTcallback = 'disp(tempoBuf)';        % Just display the information received from TEMPO

% NewValue contains the name of the MATLAB variable that receives the epoch
% count. By specifying a value, we create a HOT link instead of a WARM link.
% In a WARM link, only the callback is called and we don't receive the
% actual epoch count.  Thus, an event in TEMPO (i.e., a database collection)
% can trigger execution of a callback function in MATLAB).  See ddeadv()
% documentation for more information.

newValue = 'tempoBuf';                  % Matlab variable into which value will be stored

    resultType = 1;                     % STRING: Matlab interprets TEMPO's response as a string
%   resultType = 0;                     % NUMERIC: Matlab interprets TEMPO's response as numeric

format = [1 resultType];                % 1=CF_TEXT, Result:NUMERIC=0, STRING=1
timeout = 3000;                         % (ms) timeout to establish advisory link

% Now establish an advisory link to TEMPO.

t = sprintf('TEMPO expression being monitored: %s', HOTexpr);
disp(t);                                % Display the title on Matlab's command line


rc = ddeadv(HOTconver, HOTexpr, HOTcallback, newValue, format, timeout);

% Put up a dialog with a button that allows user to close the link.
%
% The CLOSE button's callback is a (MATLAB callback) string that is
% evaluated when the user clicks the button.  This string closes the
% link to TEMPO and terminates the conversation.

c = uicontrol('String', '&Close', ...
        'Position', [5 5 80 30], ...
        'Callback', 'rc = ddeunadv(HOTconver, HOTexpr); ddeterm(HOTconver); close;');
