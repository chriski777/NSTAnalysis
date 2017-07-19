function M = combineType(typeCell,N,spkChannels)
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
