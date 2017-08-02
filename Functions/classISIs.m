function output = classISIs(data, resultType)
%Chris Ki, July 2017, Gittis Lab
%classISIs: Function that splits ISIs/spikeTrains into groups with matching classes

%Output Parameter: 
%   Output depends on resultType parameter
%   If resultType is 'ISI': ISIs of all spike trains will be split into the
%   4 different classes (No class, Regular, Irregular, Burst)
%   If resultType is 'Spike': timestamps of all spike trains will be split
%   into the 4 classes listed above

%Input Parameter:
%   data: Must have the following fields
%       data.type: Specifies condition that data belongs to : E.G ('Naive',
%       'Acute',etc.)
%       data.ts: A cell of All Time Stamps of spike trains
%       data.files: Cell of fileNames associated with the spike trains
%   resultType: Specifies whether you want ISIs or Spikes split into
%       classes. Only accepts 'ISI' or 'Spike' (case insensitive)

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
   if strcmpi(resultType,'ISI')
       for k = 1:totalResults
           allISIs{k} = ISIconverter(allTimeStamps{k},length(allTimeStamps{k})-1);
       end
   elseif strcmpi(resultType,'Spike')
       for l = 1:totalResults
           allISIs{l} = allTimeStamps{l};
       end
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
   typeCell = typeAssign('custClassification.xlsx',currType);
   M = combineType(typeCell,N,SPKChanNames);
   M = [M(:,1), SPKChanNames , M(:,2:3)];
   classVector = cell2mat(M(:,4));
   sepClasses = cell(4,1);
   for i = 1:4
    classes = M(classVector == (i-1),:);
    sepClasses{i} = classes;
   end
   output = sepClasses;
end