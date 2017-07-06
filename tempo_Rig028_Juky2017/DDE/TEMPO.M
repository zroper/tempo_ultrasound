function success = Tempo(command)
%TEMPO - Execute a TEMPO command from MATLAB
%
% IN
%       command         A TEMPO Command string
%
% OUT
%       success         =1 if success, =0 if failed to send command
%                       This indicates only whether TEMPO receives and
%                       executed the command.  It does not indicate
%                       whether the command performed its intended work
%                       without errors.
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

service = 'TEMPO';
topic = 'COMMAND';
channel = ddeinit(service, topic);      % Open channel to TEMPO

% SPECIFY THE TEMPO COMMAND WE WANT TO EXECUTE.
% YOU CAN TELL TEMPO TO EXECUTE JUST ABOUT ANY COMMAND FROM HERE.
% THIS INCLUDES STARTING/STOPPING, LOADING NEW PROTOCOLS,
% CHANGING VARIABLES, EXECUTE TEMPO COMMAND FILES, DIALOGS
% AND RUNNING OTHER PROGRAMS.
% IN MATLAB, THE ddeexec() SENDS THE COMMAND TO TEMPO.

item = '';                              % Not used by TEMPO
timeout = 3000;                         % timeout in ms
success = ddeexec(channel, command, item, timeout);
                                        % 1=success, 0=failure

% WE CLOSE THE CHANNEL.  IF YOU PLAN TO SEND MANY COMMANDS TO TEMPO
% LEAVE THE CHANNEL OPEN SO YOU CAN REUSE IT.

ddeterm(channel);                       % Close channelto TEMPO
