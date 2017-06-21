function results = mapper(data,fxn)
%Chris Ki, June 2017, Gittis Lab
%Mapper: Applies function (fxn) of your choice to the spike trains
%   in data
%
%   data = Data struct of files that you get from Tim's open_data.m
%       function
%   fxn = Character vector that specifies user function that you would like to apply to the data
%       struct

   addpath('Functions')
   fh = str2func(fxn);
   %Will contain all the file Names associated with its own spike counts 
   allNames = [];
   %An array of all the timestamps 
   allTimeStamps = getit(data.ts);
   %Isolate the times of the different experiments, should be same length
   %    as allTimeStamps
   allTimes = [];
   for i = 1:length(data.ts)
       allTimes = [allTimes,repelem([data.T(i)],length(data.ts{i}))];
       %Truncate the latter parts to remove extensions
       rmIndex = strfind(data.files{i},'AWsorttt.pl2') - 1;
       truncName = data.files{i}(1:rmIndex);
       cellString = cell(1);
       cellString{1,1} = truncName;
       allNames = [allNames,repelem([cellString],length(data.ts{i}))];
   end
   %Results vector should have length of total spike Counts vectors
   %    available
   totalResults = length(allTimeStamps);
   results = zeros(totalResults, 1);
   %Apply fxn to each of the spike trains in allTimeStamps
   for i = (1:totalResults)
       input = struct();
       input.SPKC = allTimeStamps{i};
       input.end = allTimes(i);
       results(i) = fh(input);
   end
   allNames = transpose(allNames);
   results = allNames;
   %Writes a .csv Files with corresponding names and results
   %csvwrite('results.csv',[allNames,results]);
end