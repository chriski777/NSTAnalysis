function master(fxn)
%Chris Ki, June 2017, Gittis Lab

%Master function : Applies fxn to the total dataset. Outputs results of fxn
%   applied to all of dataset through .csv files

%Input parameters:
%   fxn : A character vector of the function you would like to apply to all
%   the in vivo data

    addpath('Functions')
    %8x1 cells for the 8 types of data we have
%     typeNames = ['Acute,' 'Alpha-Syn,' 'Gradual 35%,' 'Gradual 65%,' ...
%         'Gradual,' 'Naive,' 'Unilateral Depleted,' 'Unilateral Intact'];
%     
    %TEST 
    typeNames = ['Naive'];
    sepTypes = textscan(typeNames,'%s', 'Delimiter',',');
    cellTypes = sepTypes{:}; 
    numTypes = length(cellTypes);

    if exist(fxn, 'file') == 2
        if exist('results', 'file' ) ~= 7
            mkdir results;
        end
        newFolder = ['results/',fxn];
        if exist(newFolder, 'file') ~= 7 
            mkdir('results',fxn);
        end
        oldFolder = pwd;
        cd(newFolder);
        addpath('..\..\Functions')
        addpath('..\..\data_processing')
        for i = 1: numTypes
            currType = cellTypes{i};
            data = dataInitializer(currType);
            mapper(data,fxn);
        end
    else
        error('That is not a valid custom function.')
    end
    cd(oldFolder);
end