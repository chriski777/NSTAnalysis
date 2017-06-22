function result = allstdISI(data)
%Chris Ki, June 2017, Gittis Lab
%allstdISI: Function that calculates the standard deviation of all the ISIs

%Input Parameter
%   data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
%       data.end = timestamp at which spike recording stopped

    %Calculate the std of all ISIs
    numISIs = length(data.SPKC) - 1;
    ISIs = zeros(numISIs,1);
    for l = 1:numISIs
        ISIs(l) = data.SPKC(l+1) - data.SPKC(l);
    end
    stdAllISIs = std(ISIs);
    result = stdAllISIs;