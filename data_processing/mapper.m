function output = mapper(data,fxn,movement,graph)
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
   fileType = data.type;
   for i = 1:length(data.ts)
       allTimes = [allTimes,repelem([data.T(i)],length(data.ts{i}))];
       %Truncate the latter parts to remove extensions
       rmIndex = strfind(data.files{i},'AWsorttt.pl2') - 1;
       if length(rmIndex) == 0
           rmIndex = strfind(data.files{i}, 'AWsorttt-01.pl2') -1;
       end
       truncName = data.files{i}(1:rmIndex);
       cellString = cell(1);
       cellString{1,1} = truncName;
       allNames = [allNames,repelem([cellString],length(data.ts{i}))];
   end
   %Results vector should have length of total spike Counts vectors
   %    available
   totalResults = length(allTimeStamps);
   results = zeros(totalResults, 1);
   %Standard deviations vector is used as reference to make sure the
   %results match up with the spreadsheet.
   stds = zeros(totalResults,1);
   spikes = zeros(totalResults,1);
   times = zeros(totalResults,1);
   %Repeat the movements and fileNames
   allMovements = cell(totalResults,1);
   allMTimes = cell(totalResults,1);
   %Repeat the movements and fileNames
   startIndex = 1;
   for i = 1:length(data.ts)
    endIndex = startIndex + length(data.ts{i}) - 1;
    for j = startIndex:endIndex
        allMTimes(j,1) = data.movet_rs(i);
        allMovements(j,1) = data.moving_rs(i);
    end
    startIndex = endIndex + 1;
   end
   if logical(graph)
      counter = 0;
   end
   
   %Apply fxn to each of the spike trains in allTimeStamps
   %%FUNCTION FIELDS VERY IMPORTANT
   for i = (1:totalResults)
       %For Graphs
       if logical(graph)
          if mod(i-1,4) == 0
            counter = counter+1;
            figure(counter)
          end
       end
       input = struct();
       %for StatAv Parameter
       input.numOfEqualSegs = 40;
       %for AppEntropy parameter
       input.AppEnumISIs = 1000;
       input.m = 2;
       input.shuffPop = 100;
 
       %For SDF 
       input.iteration = i;
       input.movet_rs  = allMTimes{i};
       input.moving_rs = allMovements{i};
       
       input.type = data.type;
       input.fileName = allNames(i); 
       input.SPKC = allTimeStamps{i};
       input.end = allTimes(i);
       results(i) = fh(input);
       spikes(i) = length(input.SPKC);
       stds(i) = allstdISI(input);
       times(i) = input.end;
   end
   allNames = transpose(allNames);
   resFileName = sprintf('%s Results.csv', fileType);
   fid = fopen(resFileName,'wt');

   SPKChanGroups = getit(data.spkchans);
   SPKChanNames = cell(totalResults,1);
   counter = 1;
   for i = 1:length(SPKChanGroups)
       currChannels = SPKChanGroups{i};
       [uniqueChannels,index] = unique(currChannels);
       uniqueChannels = currChannels(sort(index));
       for k = 1:length(uniqueChannels)
           uChan = uniqueChannels(k);
           frequency = sum(currChannels == uChan);
           for j = 1:frequency
               charVal = [num2str(uChan),char(97+j)];
               SPKChanNames{counter} = charVal;
               counter = counter + 1;
           end
       end 
   end
   typeCell = typeAssign('classifications.xlsx',fileType);
   %Writes results to results.csv file with corresponding name and result
   headers = {'FileName', 'Spikes', 'EndTimeStamp', 'allISIstd', [fxn], 'Class'};   
   N = [ allNames, num2cell(spikes), num2cell(times), num2cell(stds), num2cell(results)];
   M = [headers; combineType(typeCell,N,SPKChanNames)];
   output = M;
   if fid > 0 
       %Writes column headers
       fprintf(fid,'%s, %s, %s, %s, %s, %s\n', M{1,1}, M{1,2},  M{1,3}, M{1,4}, M{1,5}, M{1,6});
       for k = 2:size(M,1)
        fprintf(fid,'%s, %d, %f, %f, %f, %f\n',M{k,1}, M{k,2},  M{k,3}, M{k,4}, M{k,5}, M{k,6});
       end
       fclose(fid);
   end
end