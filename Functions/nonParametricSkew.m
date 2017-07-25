function result = nonParametricSkew(data)
%Chris Ki, July 2017, Gittis Lab
%nonParametricSkew : Calculates the nonParametric Skew that
%   is given by (mean- median) /std.

%Input: 
%data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
    ISIs = ISIconverter(data.SPKC,length(data.SPKC)-1);
    stdAllISIs = std(ISIs);
    meanAllISIs = mean(ISIs);
    medAllISIs = median(ISIs);
    result = (meanAllISIs - medAllISIs)/stdAllISIs;
