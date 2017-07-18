function M = combineType(typeCell,N)
    keySet = cell(length(typeCell),1);
    valSet = zeros(length(typeCell),1);
    for i = 1:length(typeCell)
        currRow = typeCell(i,:);
        key = currRow(1:3);
        val = currRow(4);
        valSet(i) = val{1};
        keySet{i} = key;
    end
    typeMap = containers.Map(keySet,valSet);
    M = typeMap;
end