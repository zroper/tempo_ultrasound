% HOTDB.M - Example of how to establish a HOT connection to receive a
% notification that a TEMPO database has been updated.
%
% MATLAB asks TEMPO automatically send updates whenever a DB epoch count
% changes.  Here, we just receive and display the epoch count.  But you
% can do whatever you want in MATLAB when a database changes (i.e., download
% the new epoch, analyze and display it).
%
% Run TEMPO/Win before running this MATLAB script.
%
% NOTE
%   To use with TEMPO, set:
%
%           service='TEMPO'
%
%   To use with COBALT, set:
%
%           service='COBALT'
%

DB = 1;                                 % Database to monitor

HOTDBservice = 'TEMPO';                 % 'TEMPO' or 'COBALT'
%HOTDBservice = 'COBALT';                 % 'TEMPO' or 'COBALT'
HOTDBtopic = 'DB';                      % This establishes a hot connection
HOTDBconver = ddeinit(HOTDBservice, HOTDBtopic);  % From TEMPO to MATLAB

HOTDBitem = sprintf('EPOCHCOUNT %d', DB);  % TEMPO will tell us when epoch count changes

% This function will be evaluated by MATLAB each time we receive notification
% that the database has changed.  Here, we simply display the epoch count
% but you can do more fancy things like download the data, analyze it and
% display it.

HOTDBcallback = 'Analyze(DB, 0)';       % Call our analysis function

% NewValue contains the name of the MATLAB variable that receives the epoch
% count. By specifying a value, we create a HOT link instead of a WARM link.
% In a WARM link, only the callback is called and we don't receive the
% actual epoch count.  Thus, an event in TEMPO (i.e., a database collection)
% can trigger execution of a callback function in MATLAB).  See ddeadv()
% documentation for more information.

newValue = 'nEpochs';

format = [1 0];                         % Format of data
timeout = 3000;                         % (ms) timeout to establish advisory link

% Now establish an advisory link to TEMPO.

rc = ddeadv(HOTDBconver, HOTDBitem, HOTDBcallback, newValue, format, timeout);

% Put up a dialog with a button that allows user to close the link.
%
% The CLOSE button's callback is a (MATLAB callback) string that is
% evaluated when the user clicks the button.  This string closes the
% link to TEMPO and terminates the conversation.

c = uicontrol('String', '&Close', ...
        'Position', [5 5 80 30], ...
        'Callback', 'rc = ddeunadv(HOTDBconver, HOTDBitem); ddeterm(HOTDBconver); close;');
