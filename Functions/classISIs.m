function output = classISIs(data)
%Chris Ki, July 2017, Gittis Lab
%classISIs: Function that splits ISIs into groups with matching classes

   addpath('Functions')
   currType = data.type;
   allTimeStamps = getit(data.ts);
   allNames = [];
   
   %Gets a column of allFileNames
   for i = 1:length(data.ts)
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
   totalResults = length(allTimeStamps);
   
   %Column of allISIs for each spike train
   allISIs = cell(totalResults,1);
   for k = 1:totalResults
       allISIs{k} = ISIconverter(allTimeStamps{k},length(allTimeStamps{k})-1);
   end
   
   %Finds corresponding Spike channel and unit
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
   allNames = transpose(allNames);
   N = [allNames,allISIs];
   typeCell = typeAssign('classifications.xlsx',currType);
   M = combineType(typeCell,N,SPKChanNames);
   classVector = cell2mat(M(:,3));
   sepClasses = cell(4,1);
   for i = 1:4
    classes = M(classVector == (i-1),:);
    sepClasses{i} = classes;
   end
   output = sepClasses;
end