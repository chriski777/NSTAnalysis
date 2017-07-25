function result = ISIkurtosis(data)
%Chris Ki, July 2017, Gittis Lab
%ISIKurtosis: Calculates the Pearson kurtosis, "tailedness", of an ISI
%histogram with bins the size of binLength. The kurtosis is simply the
%fourth moment divided by the standard deviation to the fourth power. 

%Input: 
%data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
    binLength = 0.004;
    ctrs = [0:binLength:1.0];
    ISIs = ISIconverter(data.SPKC,length(data.SPKC)-1);
    hist = histogram(ISIs,ctrs); 
    %convert each bin count to center of bin to check accurately for skew;
    %   checking the kurtosis for the histogram
    totalISIs = [];
    for i = 1:length(hist.Values)
        binCtr = (binLength*i + binLength*(i-1))/2;
        totalISIs = [totalISIs, repmat(binCtr,1,hist.Values(i))];
    end
    stdAllISIs = std(totalISIs);
    meanAllISIs = mean(totalISIs);
    %Fourth central moment
    fourthMoment = sum((totalISIs - repmat(meanAllISIs,1,length(totalISIs))).^4)/length(totalISIs);
    result = fourthMoment/((stdAllISIs)^4);
end