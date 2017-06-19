function intervalSPK = rasterPlot(SPKC,firstTimeStamp, endTimeStamp)
%Chris Ki, June 2017, Gittis Lab
%rasterPlot: Draws rasterplot for a given spike train in a timeInterval
%   SPKC = A single spike train vector where each entry is the timepoint at
%       occurence of a spike
%   firstTimeStamp = Left end of time interval for Raster plot
%   endTimeStamp = right end of time interval 
    if firstTimeStamp > endTimeStamp || endTimeStamp > length(SPKC) || firstTimeStamp == endTimeStamp
         error('Cannot generate a raster plot')
    end
    format long
    intervalSPK = SPKC((SPKC >= firstTimeStamp) & SPKC <= endTimeStamp);
    nSpikes = length(intervalSPK);
    for i = 1:nSpikes
        line([intervalSPK(i), intervalSPK(i)],[0,1],'Color','k');
    end
    set(gca, 'YTick', []);
    xlabel('Time (ms)'); % Time is in millisecond
    title(['Raster Plot from time ' num2str(firstTimeStamp) 'ms to ' num2str(endTimeStamp) 'ms']);
end
