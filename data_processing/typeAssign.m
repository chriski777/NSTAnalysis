function output = typeAssign(fileName,sheetType)
%Chris Ki, July 2017, Gittis Lab
%typeAssign: Function that assigns a number (burst classification) to every
%   cell in our dataset
%   Make sure to add the file through the set path. Set the file name to
%   'classifications.xlsx'. If you would like another fileName you can
%   change the fileName input in the mapper fxn line 112.

%Input Parameters:
%   fileName: excel file witht the classifications you want to import. This
%   file must have 4 columns: a column that contains 'FullRegularIrregularBurst' with
%   the classifications for each neuron, column with file name, column with number of spikes,
%   and a column with STD of ISIs. Use with .xlsx files.

%Output Parameters:
%   Output: a cell of corresponding 

    [~,sheets] = xlsfinfo(fileName);
    currIndex = find(strcmp(sheets,sheetType));
    [num,str] = xlsread(fileName,currIndex);
    
    firstRow = str(1,:);
    typeIndex = find(~cellfun(@isempty,strfind(firstRow, 'FullRegularIrregularBurst')));
    spikeIndex = find(~cellfun(@isempty,strfind(firstRow, 'SPKC')));
    unitIndex = find(~cellfun(@isempty,strfind(firstRow, 'Unit')));
    fileIndex = find(~cellfun(@isempty,strfind(firstRow, 'Filename')));
    
    keySet = {'No Class', 'Regular', 'Irregular', 'Bursty'};
    valueSet = [0,1,2,3];
    typeMap = containers.Map(keySet,valueSet);
    typeCol = str(2:end,typeIndex);
    converted = zeros(length(typeCol),1);
    nameCol = str(2:end,fileIndex);

    for i = 1:length(typeCol)
        converted(i) = typeMap(strtrim(typeCol{i}));
        currName = nameCol(i);
        nameArr = strfind(currName,'AWsorttt');
        if ~isempty(nameArr{1})
            stringName = currName{1};
            nameCol(i) = {stringName(1:nameArr{1}-1)};
        end
    end
    remFirst = str(2:end,:);
    cellMats = num2cell(num);
    remFirst(:,spikeIndex) = cellMats;
    remFirst(:,typeIndex) = num2cell(converted);
    remFirst(:,fileIndex) = nameCol;
    output = remFirst;
    end
    