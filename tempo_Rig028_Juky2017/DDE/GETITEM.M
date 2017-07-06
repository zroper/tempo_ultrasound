function nValue = GetItem(db, dbfield)
%GETITEM - Retrieve the value of a database field from TEMPO
% Example of how to retrieve information about a database from TEMPO
%
% IN
%       db              A database number [1, ...]
%       dbfield         Name of field (See TOPIC DB in TEMPO Manual)
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
%       getitem(1, 'epochcount')    % get's DB 1's epoch count
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
%   TEMPO Reference Manual, Ch 3: Dynamic Data Exchange
%   Matlab's online documentation Ch 5 Using the MATLAB Engine, p5-14
%   \matlab\help\techdoc\apiref
%   \matlab\help\techdoc\pdfdocs\apiguide.pdf
%   \matlab\help\techdoc\pdfdocs\apiref.pdf

% OPEN CONVERSATION WITH TEMPO/Win.
% First run TEMPO/Win with the ACQUIRE protocol
% then run this from MATLAB.

service = 'TEMPO';                      % 'TEMPO' or 'COBALT' Service used to retrieve DB data
%service = 'COBALT';                      % 'TEMPO' or 'COBALT' Service used to retrieve DB data
topic = 'DB';                           % Topic used to retrieve DB data

channel = ddeinit(service, topic);      % Open channel to TEMPO

% Specify which database and which epoch we want to retrieve as the item.
% For DBDATA field, if the epoch is not specified, TEMPO returns the latest one.
% The result can be NUMERIC or STRING which tells Matlab how to intepret
% the buffer it receives from TEMPO.
% Note that when the result is NUMERIC, the TITLE and FILENAME fields can
% not be retrieved (because TEMPO sends them as a text string).

itemString = sprintf('%s %d', dbfield, db);

if (strcmp(dbfield, 'TITLE') | strcmp(dbfield, 'FILENAME'))
    resultType = 1;                     % STRING: Matlab interprets TEMPO's response as a string
else
    resultType = 0;                     % NUMERIC: Matlab interprets TEMPO's response as numeric
end

format = [1 resultType];                % 1=CF_TEXT, Result:NUMERIC=0, STRING=1
timeout = 3000;                         % timeout in ms

% Retrieve the data from TEMPO.  The actual data is stored as a matrix
% of integers.  The number of rows corresponds to the period (number of
% bins) in the database.  The columns corresponds to the channels acquired.

nValue = ddereq(channel, itemString, format, timeout);

% If you plan to access this topic many times, you should leave
% the channel open and get all the data you want before closing it.

ddeterm(channel);                       % Close channel to TEMPO
