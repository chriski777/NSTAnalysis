function result = meanISI(data)
%Chris Ki, July 2017, Gittis Lab
%meanISI: Function that calculates the mean of the ISIs
%Input Parameter
%   data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
%       data.end = timestamp at which spike recording stopped

    %Calculate the mean of all ISIs
    numISIs = length(data.SPKC) - 1;
    ISIs = ISIconverter(data.SPKC,length(data.SPKC)-1);
    result = mean(ISIs);
