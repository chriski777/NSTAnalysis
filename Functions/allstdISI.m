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
    ISIs = ISIconverter(data.SPKC,length(data.SPKC)-1);
    stdAllISIs = std(ISIs);
    result = stdAllISIs;