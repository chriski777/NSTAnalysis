function result = meanFR(data)
%Chris Ki, July 2017, Gittis Lab
%meanFR: Calculates the mean firing rate of the spike train by dividing the
%   toal number of spikes by the total time of the recording

%Input Parameter
%   data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
%       data.end = timestamp at which spike recording stopped
    result = length(data.SPKC)/data.end;