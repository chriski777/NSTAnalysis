function result = ISIkurtosis(data)
%Chris Ki, July 2017, Gittis Lab
%ISIKurtosis: Calculates the Pearson kurtosis, "tailedness", of an ISI
%histogram with bins the size of binLength. The kurtosis is simply the
%fourth moment divided by the standard deviation to the fourth power. 

%Input: 
%data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
  if data.numISIs < length(data.SPKC) - 1 
        binLength = 0.004;
        endBin = 0.4;
        ctrs = [0:binLength:endBin];
        ISIs = ISIconverter(data.SPKC,length(data.SPKC)- 1);
        quantiles = quantile(ISIs, [0, 0.25, 0.5, 0.75, 1.0]);
        botExtreme = quantiles(2) - 1.5*iqr(ISIs);
        topExtreme = quantiles(4) + 1.5*iqr(ISIs);
        %convert each bin count to center of bin to check accurately for skew;
        %   checking the kurtosis for the histogram
        counter = 1;
        totalISIs = [];
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
        %Fourth central moment
        fourthMoment = sum((totalISIs - repmat(meanAllISIs,1,length(totalISIs))).^4)/length(totalISIs);
        result = fourthMoment/((stdAllISIs)^4);
  else
        warning(['The length of the spike train is ' num2str(length(data.SPKC)) ...
            ' less than ' num2str(data.numISIs)])
        result = NaN;
  end
end