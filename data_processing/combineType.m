function M = combineType(typeCell,N,spkChannels)
%%Chris Ki, July 2017, Gittis Lab
%combineType: Outputs a cell that is N with the associated excel classifications
%   attached as the last column

%Input Parameters:
%   TypeCell = an n x 4 cell array with a fileName column, SPK channel Column,
%       unit column, and classification column
%   N = a cell array with n rows, the columns may be variable. The first column of N 
%       must be the fileNames. 
%
%   spkChannels = an n x 1 cell array that contains the corresponding spike
%       channel and unit for each row of N
%       E.G: {'10b', '10c', '10d', 2b',etc.}
    keySet = cell(length(typeCell),1);
    valSet = zeros(length(typeCell),1);
    for i = 1:length(typeCell)
        currRow = typeCell(i,:);
        name = currRow(1);
        channel = currRow(2);
        unit = currRow(3);
        key = [name{1}, num2str(channel{1}), unit{1}];
        val = currRow(4);
        valSet(i) = val{1};
        keySet{i} = key;
    end
    typeMap = containers.Map(keySet,valSet);
    typeVals = zeros(length(N),1);
    for j = 1:length(N)
        currNRow = N(j,:);
        Nname = currNRow(1);
        Nchannel = spkChannels(j);
        nKey = [Nname{1},Nchannel{1}];
        try
            typeVal = typeMap(nKey);
            typeVals(j) = typeVal;
        catch 
            typeVal = 0;
        	typeVals(j) = typeVal;
        end
    end
    M = [N,num2cell(typeVals)];
end
