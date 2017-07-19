function result = CV(data)
%Chris Ki, July 2017, Gittis Lab
%CV: Function that calculates the coefficient of variation (the std ISI/
%   meanISI)
%Input Parameter
%   data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
%       data.end = timestamp at which spike recording stopped
    result = allstdISI(data)/meanISI(data);