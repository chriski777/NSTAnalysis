function output = mapper(data,fxn)
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
   %Apply fxn to each of the spike trains in allTimeStamps
   for i = (1:totalResults)
       input = struct();
       %for StatAv Parameter
       input.numOfEqualSegs = 40;
       input.SPKC = allTimeStamps{i};
       input.end = allTimes(i);
       results(i) = fh(input);
       stds(i) = allstdISI(input);
   end
   allNames = transpose(allNames);
   fid = fopen('results.csv','wt');
   %Writes results to results.csv file with corresponding name and result
   headers = {'FileName,', 'allISIstd,', [fxn ',']};
   M = [headers; allNames, num2cell(stds), num2cell(results)];
   output = M;
   if fid > 0 
       %Writes column headers
       fprintf(fid,'%s %s %s \n', M{1,1}, M{1,2},  M{1,3});
       for k = 2:size(M,1)
        fprintf(fid,'%s, %f, %f\n',M{k,1}, M{k,2},  M{k,3});
       end
       fclose(fid);
   end
end