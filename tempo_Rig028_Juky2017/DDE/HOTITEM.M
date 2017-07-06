% HOTITEM.M - Establish a HOT link to a TEMPO database item
%
% Usage: hotitem
%
% We automatically receive notifications when the item changes
%
% MATLAB asks TEMPO to automatically send updates whenever a DB field
% changes.  Here, we just receive and display the value TEMPO sends.  But you
% can do whatever you want in MATLAB when the field changes (i.e., download
% the new epoch, analyze and display it; see hotdb.m)
%
% Run TEMPO/Win before running this MATLAB script.
%
% IN
%       db              A database number [1, ...]
%       itemString      Name of field (See TOPIC DB in TEMPO Manual)
%                       'format'
%                       'type'
%                       'epochcount'
%                       'maxepochcount'
%                       'handle'
%                       'period'
%                       'extent'
%                       'offset'
%                       'cancel'
%                       'skip'
%                       'nchannels'
%                       'firstchannel'
%                       'dirty'
%                       'speed'
%                       'speedunits'
%                       'tag'
%                       'filename'
%                       'title'
%                       'epochdata'
%                       'hzero'
%
% OUT
%       value of field
%
% EXAMPLE
%       hotitem(1, 'epochcount')    % get's DB 1's epoch count when it changes
%
% OUT
%       value of field
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
% SEE ALSO
%   Matlab's online documentation Ch 5 Using the MATLAB Engine, p5-14
%   \matlab\help\techdoc\apiref
%   \matlab\help\techdoc\pdfdocs\apiguide.pdf
%   \matlab\help\techdoc\pdfdocs\apiref.pdf

db = 1;                                 % Database to monitor
dbfield = 'EPOCHCOUNT';

HOTDBitem = sprintf('%s %d', dbfield, db);  % DB field and number

HOTDBservice = 'TEMPO';                 % 'TEMPO' or 'COBALT'
%HOTDBservice = 'COBALT';               % 'TEMPO' or 'COBALT'
HOTDBtopic = 'DB';                      % Connect to a database
HOTDBconver = ddeinit(HOTDBservice, HOTDBtopic);  % From TEMPO to MATLAB
                          
% This function will be evaluated by MATLAB each time we receive notification
% that the database has changed.  Here, we simply display the epoch count
% but you can do more fancy things like download the data, analyze it and
% display it.

%HOTDBcallback = 'Analyze(db, 0)';       % Call our analysis function (or any Matlab command)
HOTDBcallback = 'disp(tempoBuf)';        % Just display the information received from TEMPO

% NewValue contains the name of the MATLAB variable that receives the epoch
% count. By specifying a value, we create a HOT link instead of a WARM link.
% In a WARM link, only the callback is called and we don't receive the
% actual epoch count.  Thus, an event in TEMPO (i.e., a database collection)
% can trigger execution of a callback function in MATLAB).  See ddeadv()
% documentation for more information.

newValue = 'tempoBuf';                  % Matlab variable into which value will be stored

if (strcmp(dbfield, 'TITLE') | strcmp(dbfield, 'FILENAME'))
    resultType = 1;                     % STRING: Matlab interprets TEMPO's response as a string
else
    resultType = 0;                     % NUMERIC: Matlab interprets TEMPO's response as numeric
end

format = [1 resultType];                % 1=CF_TEXT, Result:NUMERIC=0, STRING=1
timeout = 3000;                         % (ms) timeout to establish advisory link

% Now establish an advisory link to TEMPO.

t = sprintf('TEMPO Database %d Item %s being monitored', db, HOTDBitem);
disp(t);                        % Display the title on Matlab's command line


rc = ddeadv(HOTDBconver, HOTDBitem, HOTDBcallback, newValue, format, timeout);

% Put up a dialog with a button that allows user to close the link.
%
% The CLOSE button's callback is a (MATLAB callback) string that is
% evaluated when the user clicks the button.  This string closes the
% link to TEMPO and terminates the conversation.

c = uicontrol('String', '&Close', ...
        'Position', [5 5 80 30], ...
        'Callback', 'rc = ddeunadv(HOTDBconver, HOTDBitem); ddeterm(HOTDBconver); close;');
