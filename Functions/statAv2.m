function result  = statAv2( data )
%Chris Ki, June 2017, Gittis Lab
%StatAv2: Calculates the StatAv Parameter (Terry and Griffin 2010). The StatAv2 has 
%   been adapted to follow the analysis conducted in "Coherence and short-term synchronization
%   are insensitive to motor unit spike train nonstationarity. The StatAv Parameter
%   assesses the stationarity of the data stream. The StatAv2 measures the
%   statAv parameter of the firing rates rather than the ISIs. 

%Input Parameter
%   data = A struct that has two fields.
%       data.SPKC = single spike train vector where each entry is the timepoint at
%       occurence of a spike
%       data.end = timestamp at which spike recording stopped

    %Divide the data series into segments of equal duration 
    numOfEqualSegs = data.numOfEqualSegs;
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
    stdInterval = zeros(numOfEqualSegs,1);
    for j = (1:numOfEqualSegs)
       intervalData = data.SPKC(data.SPKC >= intervals(j,1) & data.SPKC <= intervals(j,2));
       numISIsInt = length(intervalData) -1;
       if numISIsInt <= 0
           warning(['There is not enough data in the interval ' num2str(intervals(j,1)) ' to ' num2str(intervals(j,2))])
       end
       intervalISIs = zeros(numISIsInt,1);
       %Calculate ISIs for each intervals
       for k = (1:numISIsInt)
           intervalISIs(k) = intervalData(k+1) - intervalData(k);
       end
       %Calculate standard deviations of the firing rates
       stdInterval(j) = std(intervalISIs);
    end
    %to get rid of the NaN values
    stdInterval = stdInterval(~isnan(stdInterval));
    %Mean of the SDs of ISIs in the numOfEqualSegs segments
    stdMeanIntervals = mean(stdInterval);
    
    %Calculate the std of all FRs
    stdAllISIs = allstdISI(data);
    %Output is StatAv Parm which is SD of mean of ISIs in numOfEqualSegs segments divided by
    %stdAllISIs.
    statAvParam = stdMeanIntervals/stdAllISIs;
    result = statAvParam;
    
end

