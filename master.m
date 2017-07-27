function master(fxn, dataTypes,movement)
%Chris Ki, June 2017, Gittis Lab

%Master function : Applies fxn to the total dataset. Outputs results of fxn
%   applied to all of dataset through .csv files

%Input parameters:
%   fxn : A character vector of the function you would like to apply to all
%   the in vivo data
%   dataTypes : Specifies whether the fxn is applied to the FULL dataset or just the TEST
%       Two options exist for this parameter : FULL or TEST
%   movement : Options are -1, 0, 1. -1 means to only perform analyses on
%       non-movement phases. 0 means to perform the analysis on the full
%       SPK train. 1 means to perform the analysis on only movement phases.

    addpath('Functions')
    if strcmpi(dataTypes,'full')
        %FULL
        %8x1 cells for the 8 types of data we have
        typeNames = ['Acute,' 'Alpha-Syn,' 'Gradual 35%,' 'Gradual 65%,' ...
            'Gradual,' 'Naive,' 'Unilateral Depleted,' 'Unilateral Intact'];
    elseif strcmpi(dataTypes,'test')
        %Naive
        typeNames = ['test'];   
    elseif strcmpi(dataTypes,'Acute')
        typeNames = ['Acute'];  
    elseif strcmpi(dataTypes,'Alpha-Syn')
        typeNames = ['Alpha-Syn'];  
    elseif strcmpi(dataTypes, 'Gradual 35%')
        typeNames = ['Gradual 35%'];
    elseif strcmpi(dataTypes, 'Gradual 65%')
        typeNames = ['Gradual 65%'];
    elseif strcmpi(dataTypes, 'Gradual')
        typeNames = ['Gradual'];
    elseif strcmpi(dataTypes, 'Unilateral Depleted')
        typeNames = ['Unilateral Depleted'];
    elseif strcmpi(dataTypes, 'Unilateral Intact')
        typeNames = ['Unilateral Intact'];
    elseif strcmpi(dataTypes, 'Naive')
        typeNames = ['Naive'];
    else 
        error('Invalid dataTypes parameter. Please select either TEST or FULL.')
    end    
    if ~(any(movement == [-1,0,1]))
        error('Invalid Movement parameter. Please select either -1, 0, 1. ')
    end
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
            if strcmpi(fxn,'spikedensityfunction')
               mapper(data,fxn,movement,1);
            elseif strcmpi(fxn, 'cellbycellISIAutos')
                sepData = classISIs(data,'spike');
                cellbycellISIAutos(sepData);
            elseif strcmpi(fxn, 'expFitAutos')
                sepData = classISIs(data, 'spike');
                expFitAutos(sepData);
            elseif strcmpi(fxn, 'classISIHists')
                sepData = classISIs(data, 'ISI');
                classISIHists(sepData,currType);
            else
               mapper(data,fxn,movement,0);
            end
        end
    else
        error('That is not a valid custom function.')
    end
    cd(oldFolder);
end