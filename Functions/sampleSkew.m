function result = sampleSkew(data)
%Chris Ki, July 2017, Gittis Lab
%sampleSkew: Calculates the pearson moment of skewedness using the third
%   moment and the standard deviation. The sample skew is a measure of the
%   degree of asymmetry given by the third moment divided by the standard
%   deviation to the third power. 

%Input: 
%data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
    binLength = 0.004;
    ctrs = [0:binLength:1.0];
    ISIs = ISIconverter(data.SPKC,length(data.SPKC)-1);
    hist = histogram(ISIs,ctrs); 
    %convert each bin count to center of bin to check accurately for skew
    %of the binned histogram
    totalISIs = [];
    for i = 1:length(hist.Values)
        binCtr = (binLength*i + binLength*(i-1))/2;
        totalISIs = [totalISIs, repmat(binCtr,1,hist.Values(i))];
    end
    stdAllISIs = std(totalISIs);
    meanAllISIs = mean(totalISIs);
    thirdMoment = sum((totalISIs - repmat(meanAllISIs,1,length(totalISIs))).^3)/length(totalISIs);
    skewNess = thirdMoment/((stdAllISIs)^3);
    %We must take care of the bias present in the sample by multiplying by
    %   sqrt(n*n-1)/n-2
    sampFactor = sqrt(length(totalISIs)*(length(totalISIs) - 1))/(length(totalISIs) - 2);
    result = skewNess*sampFactor;