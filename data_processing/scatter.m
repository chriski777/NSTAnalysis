function [result] = scatter(fxn1,fxn2)
    addpath('..\results')
    if (exist(['..\results\', fxn1], 'file') == 7 && exist(['..\results\', fxn2], 'file') == 7 )
        directory1 = dir(['..\results\', fxn1, '\*.csv']);
        directory2 = dir(['..\results\', fxn2, '\*.csv']);
        numFiles1 = length(directory1(not([directory1.isdir])));
        numFiles2 = length(directory2(not([directory2.isdir])));
        if numFiles1 == 0 
            error(['There are not any results in the ', fxn1, ' directory.'])
        end 
        if numFiles2 == 0 
            error(['There are not any results in the ', fxn2, ' directory.'])
        end 
        for i = 1:numFiles1
             fileName1 = ['..\results\', fxn1,'\', directory1(i).name];
             [~,~,cell1] = xlsread(fileName1);
             firstRow1 = cell1(1,:);
             colNum1 = find(strcmp(firstRow1, [' ',fxn1]));
             column =  
        end
    else
        error(['There exists no results for this fxn. Please make sure to ' , ... 
            'run the functions and have the results before using the extract ', ...
            'function.'])
    end
end