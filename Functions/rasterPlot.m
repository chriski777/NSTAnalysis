function intervalSPK = rasterPlot(data)
%Chris Ki, June 2017, Gittis Lab
%rasterPlot: Draws rasterplot for a given spike train in a timeInterval
%   SPKC = A single spike train vector where each entry is the timepoint at
%       occurence of a spike
%   firstTimeStamp = Left end of time interval for Raster plot
%   endTimeStamp = right end of time interval 
    firstTimeStamp = data.firstTS;
    endTimeStamp = data.endTS;
    if firstTimeStamp > endTimeStamp || endTimeStamp > length(data.SPKC) || firstTimeStamp == endTimeStamp
         error('Cannot generate a raster plot')
    end
    format long
    intervalSPK = data.SPKC((data.SPKC >= firstTimeStamp) & data.SPKC <= endTimeStamp);
    nSpikes = length(intervalSPK);
    for i = 1:nSpikes
        line([intervalSPK(i), intervalSPK(i)],[-0.5,0.5],'Color','k');
    end
    ylim([-0.5,0.5])
    set(gca, 'YTick', []);
    xlabel('Time (s)'); % Time is in second
    title(['Raster Plot from time ' num2str(firstTimeStamp) 's to ' num2str(endTimeStamp) 's']);
end
