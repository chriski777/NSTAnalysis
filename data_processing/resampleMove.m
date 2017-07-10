function [tout, yout] = resampleMove( t, y, FS )
% Taken binary vector (e.g., bin_lo from detectMove), resamples at uniform rate 

dy = diff([0; y]);

tout = (round(t(1)*FS)/FS:1/FS:round(t(end)*FS)/FS)';
starts = round(t(dy==1)*FS)/FS;
stops = round(t(dy==-1)*FS)/FS;
starti = round((starts-t(1))*FS+1);
stopi = round((stops-t(1))*FS+1);
yout = zeros(size(tout));
for i = 1:length(starti)
    try
        yout(starti(i):stopi(i)-1)=1;
    catch % if ends while moving st missing last stopi element
        yout(starti(i):end)=1;
        break
    end
end
end