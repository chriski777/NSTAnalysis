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

    if data.numISIs < length(data.SPKC) - 1 
        binLength = 0.004;
        %Look up to 400ms
        endBin = 0.4;
        ctrs = [0:binLength:endBin];
        %Perform analysis on first data.numISIs spikes
        ISIs = ISIconverter(data.SPKC,length(data.SPKC)- 1);
        quantiles = quantile(ISIs, [0, 0.25, 0.5, 0.75, 1.0]);
        botExtreme = quantiles(2) - 1.5*iqr(ISIs);
        topExtreme = quantiles(4) + 1.5*iqr(ISIs);
        totalISIs = [];
        counter = 1;
        for i = 1:length(ISIs)
            %Be within the botExtreme and topExtreme
            currISI = ISIs(i);
            if ((botExtreme < currISI) & (currISI < topExtreme) & (counter <= data.numISIs))
                totalISIs = [totalISIs,currISI];
                counter = counter + 1;
            end
        end
        stdAllISIs = std(totalISIs);
        meanAllISIs = mean(totalISIs);
        thirdMoment = sum((totalISIs - repmat(meanAllISIs,1,length(totalISIs))).^3)/length(totalISIs);
        skewNess = thirdMoment/((stdAllISIs)^3);
        %We must take care of the bias present in the sample by multiplying by
        %   sqrt(n*n-1)/n-2
        sampFactor = sqrt(length(totalISIs)*(length(totalISIs) - 1))/(length(totalISIs) - 2);
        result = skewNess*sampFactor;
    else
        warning(['The length of the spike train is ' num2str(length(data.SPKC)) ...
            ' less than ' num2str(data.numISIs)])
        result = NaN;
    end
end