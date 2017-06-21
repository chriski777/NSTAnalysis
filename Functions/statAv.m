function result = statAv(data)
%Chris Ki, June 2017, Gittis Lab
%StatAv: Calculates the StatAv Parameter (Palazzolo et al., 1998). The StatAv has 
%   been adapted to follow the analysis conducted in "Nonlinear Anlaysis of Discharge
%   patterns in monkey basal ganglia" (Wichmann 2006). The StatAv Parameter
%   assesses the stationarity of the data stream. The closer to zero the
%   StatAv Parameter is the more stationary the data series is.

%Input Parameter
%   data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
%       data.end = timestamp at which spike recording stopped
    outPut = struct();
    %Divide the data series into segments of equal duration 
    numOfEqualSegs = 40;
    if numOfEqualSegs > length(data.SPKC)
        warning(['There are less than numOfEqualSegs = ' num2str(numOfEqualSegs) ' spikes in this spike train!'])
    end
    %Round down to the first time entry of the data series which should be
    %zero.
    data_start = 0;
    %Round up to the last time entry of the data series
    data_end = ceil(data.end);
    %Calculate increments of time to get data series into numOfEqualSegs equal segments
    increments = (data_end - data_start)/numOfEqualSegs;
    splits = (data_start:increments:data_end);
    intervals = zeros(numOfEqualSegs,2);
    for i = (1:numOfEqualSegs)
        intervals(i,:) = [splits(i),splits(i+1)];
    end
    %Segment spike data into numOfEqualSegs equal segments based on intervals 
    meanInterval = zeros(numOfEqualSegs,1);
    for j = (1:numOfEqualSegs)
       intervalData = data.SPKC(data.SPKC >= intervals(j,1) & data.SPKC < intervals(j,2));
       numISIsInt = length(intervalData) -1;
       intervalISIs = zeros(numISIsInt,1);
       %Calculate ISIs for each intervals
       for k = (1:numISIsInt)
           intervalISIs(k) = intervalData(k+1) - intervalData(k);
       end
       meanInterval(j) = mean(intervalISIs);
    end
    %Standard deviation of the means of ISIs in the numOfEqualSegs segments
    stdMeanIntervals = std(meanInterval);
    
    %Calculate the std of all ISIs
    numISIs = length(data.SPKC) - 1;
    ISIs = zeros(numISIs,1);
    for l = 1:numISIs
        ISIs(l) = data.SPKC(l+1) - data.SPKC(l);
    end
    stdAllISIs = std(ISIs);
    
    %Output is StatAv Parm which is SD of mean of ISIs in numOfEqualSegs segments divided by
    %stdAllISIs.
    statAvParam = stdMeanIntervals/stdAllISIs;
    
    %output.splits tells you the start and end of each interval
    outPut.splits = splits;
    %outPut.statAvParam gives you the statAvParam for the spike train
    outPut.statAvParam = statAvParam;
    %outPut.stdAllISIs gives the standard deviation of all ISIs
    outPut.stdAllISIs = stdAllISIs;
    %outPut.ISIs outputs a vector of all the ISIs
    outPut.ISIs = ISIs;
    %outPut.meanInterval gives vector of means of ISIs for each segment
    outPut.meanInterval = meanInterval;
    %outPut.stdMeanIntervals gives you the std of the numOfEqualSegs means 
    outPut.stdMeanIntervals = stdMeanIntervals;
    
    result = outPut.stdAllISIs;
end