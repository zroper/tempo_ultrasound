% TWATCH.M - Example of how to establish a HOT connection between MATLAB and TEMPO
% MATLAB requests that TEMPO automatically send updates whenever an expression
% changes value.  Matlab receives and displays the new value.
%
% Run TEMPO/Win before running this MATLAB script.

service = 'TEMPO';
topic = 'EXPR';                         % This establishes a hot connection
conver = ddeinit(service, topic);       % From TEMPO to MATLAB

x = 0;                                  % Set initial value
y = 0;                                  % Set initial value
item = 'x';                             % TEMPO Expression to watch
callback = 'disp(sprintf(''(x,y)=(%d,%d)'', x, y))';  % This function is evaluated by MATLAB
                                        % ..each time TEMPO sends us an update
newValue = 'x';                         % This is the name of the MATLAB variable
                                        % ..that receives the updated value
                                        % By specifying this, we create a HOT link
                                        % ..instead of a WARM link.  See ddeadv() documentation.
format = [1 0];                         % See ddeadv() documentation
timeout = 3000;                         % (ms) timeout to establish advisory link

rc = ddeadv(conver, item, callback, newValue, format, timeout);
rc = ddeadv(conver, 'y', callback, 'y', format, timeout);

% Put up a dialog that allows user to close the hot link.
% The CLOSE button's callback is a (MATLAB callback) string that is
% evaluated when the user click the button.  This string closes the
% HOT link and terminates the conversation.

c = uicontrol('String', '&Close', ...
        'Position', [5 5 80 30], ...
        'Callback', 'rc = ddeunadv(conver, item); ddeterm(conver); close;');
