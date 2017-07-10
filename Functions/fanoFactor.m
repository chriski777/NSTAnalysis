function result = fanoFactor(data)
%Chris Ki, June 2017, Gittis Lab
%fanoFactorAnalysis: Performs fano Factor analysis to analyze self-similarity
%   over a range of time scales. The fano factor is defined as the variance
%   of the spike count divided by its mean.
%
%   SPKC = A single spike train vector where each entry is the timepoint at
%       occurence of a spike
    %Non-overlapping time window
    t = 0.05;
    endTime = data.end;
    startTime = 0;
    windows = (startTime:t:endTime);
    numSpikes = zeros(length(windows) - 1,1);
    for i = 1:length(windows) - 1
        spikeWindow = data.SPKC((data.SPKC > windows(i)) & data.SPKC <= windows(i+1));
        numSpikes(i) = length(spikeWindow);
    end
    result = var(numSpikes)/mean(numSpikes);
end