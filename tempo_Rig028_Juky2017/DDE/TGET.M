% TGET.M - Example of how to retrieve the value a protocol variable
%
% SEE ALSO
%   Matlab's online documentation Ch 5 Using the MATLAB Engine, p5-14
%   \matlab\help\techdoc\apiref
%   \matlab\help\techdoc\pdfdocs\apiguide.pdf
%   \matlab\help\techdoc\pdfdocs\apiref.pdf

% OPEN CONVERSATION WITH TEMPO/Win.
% First run TEMPO/Win with the ACQUIRE protocol
% then run this from MATLAB.

service = 'TEMPO';
topic = 'EXPR';
cGetVar = ddeinit(service, topic);      % Open channel to TEMPO

% SPECIFY WHICH VARIABLE WE WANT TO RETRIEVE AS THE ITEM
% IN MATLAB, THE DDEREQ RETRIEVES THE VALUE OF A PROTOCOL
% VARIABLE.

item = 'x';                             % Name of protocol variable
format = [1 0];                         % 1=text, 0=numeric
timeout = 3000;                         % timeout in ms
value = ddereq(cGetVar, item, format, timeout);
value                                   % Display retrieved value

% IF YOU ACCESS TEMPO'S GETVAR TOPIC MANY TIMES, YOU SHOULD LEAVE
% THE CHANNEL OPEN AND GET ALL THE DATA YOU WANT BEFORE CLOSING IT.

ddeterm(cGetVar);                       % Close channelto TEMPO
