function nValue = GetInfo(itemString)
%GETINFO - Retrieve from TEMPO a SYSINFO value
% Example of how to retrieve SYSINFO information from TEMPO
%
% IN
%       itemString      Name of field (see DDESRV.TXT)
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

% OPEN CONVERSATION WITH TEMPO/Win.
% First run TEMPO/Win with the ACQUIRE protocol
% then run this from MATLAB.

service = 'TEMPO';                      % Service used to retrieve DB data
topic = 'SYSINFO';                      % Topic used to retrieve TEMPO system information
channel = ddeinit(service, topic);      % Open channel to TEMPO

% Specify which database and which epoch we want to retrieve as the item.
% For DBDATA field, if the epoch is not specified, TEMPO returns the latest one.
% The result can be NUMERIC or STRING which tells Matlab how to intepret
% the buffer it receives from TEMPO.
% Note that when the result is NUMERIC, the TITLE and FILENAME fields can
% not be retrieved (because TEMPO sends them as a text string).

%if (strcmp(itemString, 'title') | strcmp(itemString, 'filename'))
%    resultType = 1;                     % STRING: Matlab interprets TEMPO's response as a string
%else
%    resultType = 0;                     % NUMERIC: Matlab interprets TEMPO's response as numeric
%end
resultType = 0;                         % All SYSINFO fields are numeric

format = [1 resultType];                % 1=CF_TEXT, Result:NUMERIC=0, STRING=1
timeout = 3000;                         % timeout in ms

% Retrieve the data from TEMPO.  The actual data is stored as a matrix
% of integers.  The number of rows corresponds to the period (number of
% bins) in the database.  The columns corresponds to the channels acquired.

nValue = ddereq(channel, itemString, format, timeout);

% If you plan to access this topic many times, you should leave
% the channel open and get all the data you want before closing it.

ddeterm(channel);                       % Close channel to TEMPO
