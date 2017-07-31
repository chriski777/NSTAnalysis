function result = hurstExp(data)
%Chris Ki, July 2017, Gittis Lab
%hurstExp: Outputs a measure of self-similarity known as the Hurst
%   Exponent. A hurst exponent below 0.5 indicates anti-persistent behavior
%   while one above 0.5 shows persistence (Darbin, Soares, Wichmann 2006).
%   Related to the autocorrelation and is considered the index of
%   dependence. 

%NOT COMPLETE DO NOT USE FOR ANALYSIS

%Input Parameters:
%   data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
%       data.end = timestamp at which spike recording stopped
%       data.numISIs = number of ISIs you are testing with   
    
    numISIs = data.numISIs;
    if numISIs < length(data.SPKC) - 1
        segments = [];
        numSegs = [];
        ISIs = ISIconverter(data.SPKC, data.numISIs);
        fullLength = length(ISIs);
        counter = 1;
        %Minimum of 4 ISIs in each chunk needed 
        while numISIs > 0
            divided = floor(numISIs/2);
            segments = [segments, divided];
            numSegs = [numSegs, ceil(data.numISIs/divided)];
            numISIs = divided;
            counter = counter + 1;
        end
        segments = segments(segments > 4);
        numSegs = numSegs(segments > 4);
        totalResults = zeros(length(segments),1);
        for i = 1:length(segments)
            segSize = segments(i);
            numChunks = numSegs(i);
            segMeans = zeros(numChunks,1);
            segSDs = zeros(numChunks,1);
            accumDev = zeros(numChunk,1);
            %split current ISI data into smaller segments & calculate stds
            %and means
            for k = 1: numChunks
                firstIndex = segSize*(k-1) + 1;
                secIndex = segSize*(k);
                if secIndex > numISIs
                    secIndex = numISIs;
                end
                currInterval = ISIs(firstIndex:secIndex);
                segMeans(k) = mean(currInterval,1);
                segSDs(k) = std(currInterval);
                accumDev(k) = sum(currInterval - mean(currInterval, 1));
            end
        end
    end
    result = 1;
end