function Analyze(db, nEpoch)
%ANALYZE - Download an epoch, analyze and display results
%

%gregd1(1);     % DEBUG only

if (nEpoch == 0)
    nEpoch = GetEpoch(db);
    if (nEpoch == 0)
        disp(sprintf('DB %d has no data', db));
    end
end
    
e = Getdata(db, nEpoch);            % Download latest epoch
esize = size(e);                    % =[rows columns]

if (esize(1) ~= 1)                  % Did we get any data?
    rotate3d on                     % Drag an axis for 3d rotation!
    t = sprintf('TEMPO Database %d Epoch %d analyzed and plotted by Matlab during an experiment.', db, nEpoch);
    disp(t);                        % Display the title on Matlab's command line

%   mesh(e);                        % Plot as a wire diagram
%   colormap(zeros(64,3));          % Plot in black & white (for printing)

    surfc(e);                       % Plot as a surface with contour plot
%   surfl(e);                       % Plot as a surface
%   surf(e);                        % Plot as a surface
%   shading interp;                 % Plot as a smooth surface
    shading faceted;                % Plot with skeleton

    title(t);
    zlabel('Millivolts');
    xlabel('Channels');
    ylabel('Milliseconds');
end
