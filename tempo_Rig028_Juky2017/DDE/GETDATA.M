function epoch = GetData(db, nEpoch)
%GETDATA - Retrieve a database epoch from TEMPO.
% Example of how to retrieve a database epoch from TEMPO.
%
% IN
%       db      A database number [1, ...]
%       nEpoch  An epoch number [1...].  If 0, the latest epoch is returned
% OUT
%       epoch   Epoch data, rows=time, cols=channels.
%
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

% OPEN CONVERSATION WITH TEMPO/Win.
% First run TEMPO/Win with the ACQUIRE protocol
% then run this from MATLAB.

service = 'TEMPO';                     % 'TEMPO' or 'COBALT' Service used to retrieve DB data
%service = 'COBALT';                     % 'TEMPO' or 'COBALT' Service used to retrieve DB data
topic = 'DB';                           % Topic used to retrieve DB data
channel = ddeinit(service, topic);      % Open channel to TEMPO

% Specify which database and which epoch we want to retrieve as the item.
% If the epoch is not specified, TEMPO returns the latest epoch.
% The ddereq retrieves the data for the epoch.

item = sprintf('epochdata %d %d', db, nEpoch); % latest epoch as a matrix

format = [1 0];                         % 1=text, 0=numeric
timeout = 3000;                         % timeout in ms

% Retrieve the data from TEMPO.  The actual data is stored as a matrix
% of integers.  The number of rows corresponds to the period (number of
% bins) in the database.  The columns corresponds to the channels acquired.

epoch = ddereq(channel, item, format, timeout);

% If you plan to access tempo's GETDBEPOCH topic many times, you should leave
% the channel open and get all the data you want before closing it.

ddeterm(channel);                       % Close channel to TEMPO
