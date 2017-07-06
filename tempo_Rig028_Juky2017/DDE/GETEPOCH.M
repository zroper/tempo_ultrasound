function nEpoch = GetEpoch(db)
%GETEPOCH - Retrieve Number of database epochs from TEMPO/COBALT
% Example of how to retrieve a database epoch count from TEMPO/COBALT
%
% IN
%       db      A database number [1, ...]
% OUT
%       nEpoch  Epoch count (0 = no data)
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

item = sprintf('epochcount %d', db);    % Number of epochs in database

format = [1 0];                         % 1=text, 0=numeric
timeout = 3000;                         % timeout in ms

% Retrieve the data from TEMPO.  The actual data is stored as a matrix
% of integers.  The number of rows corresponds to the period (number of
% bins) in the database.  The columns corresponds to the channels acquired.

nEpoch = ddereq(channel, item, format, timeout);

% If you plan to access tempo's GETDBEPOCH topic many times, you should leave
% the channel open and get all the data you want before closing it.

ddeterm(channel);                       % Close channel to TEMPO
