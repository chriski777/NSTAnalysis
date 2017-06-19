function intervalSPK = rastorPlot(SPKC,firstTimeStamp, endTimeStamp)
    %Chris Ki, June 2017, Gittis Lab
    %Given a vector representing a spike train
    %This can only represent a single trial
    %Provides a temporal Rastor plot for the given spike train
    %Meant to be used in conjunction with Neuroexplorer
    if firstTimeStamp > endTimeStamp || endTimeStamp > length(SPKC) || firstTimeStamp == endTimeStamp
         error('Cannot generate a rastor plot')
    end
    format long
    intervalSPK = SPKC((SPKC >= firstTimeStamp) & SPKC <= endTimeStamp);
    nSpikes = length(intervalSPK);
    for i = 1:nSpikes
        line([intervalSPK(i), intervalSPK(i)],[0,1],'Color','k');
    end
    set(gca, 'YTick', []);
    xlabel('Time (ms)'); % Time is in millisecond
    title(['Rastor Plot from time ' num2str(firstTimeStamp) 'ms to ' num2str(endTimeStamp) 'ms']);
end
