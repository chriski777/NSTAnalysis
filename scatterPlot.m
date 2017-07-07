function scatterPlot(fxn1,fxn2)
%Chris Ki, June 2017, Gittis Lab
%scatterPlot
    addpath('results\')
    if (exist(['results\', fxn1], 'file') == 7 && exist(['results\', fxn2], 'file') == 7 )
        directory1 = dir(['results\', fxn1, '\*.csv']);
        directory2 = dir(['results\', fxn2, '\*.csv']);
        numFiles1 = length(directory1(not([directory1.isdir])));
        numFiles2 = length(directory2(not([directory2.isdir])));
        if numFiles1 == 0 
            error(['There are not any results in the ', fxn1, ' directory.'])
        end 
        if numFiles2 == 0 
            error(['There are not any results in the ', fxn2, ' directory.'])
        end 
        figure
        for i = 1:numFiles1
            %directory1 name can be the same as the same results are read
             fileName1 = ['results\', fxn1,'\', directory1(i).name];
             fileName2 = ['results\', fxn2,'\', directory1(i).name];
             [~,~,cell1] = xlsread(fileName1);
             [~,~,cell2] = xlsread(fileName2);
             firstRow1 = cell1(1,:);
             colNum1 = strcmp(firstRow1, [' ',fxn1]);
             firstRow2 = cell2(1,:);
             colNum2 = strcmp(firstRow2, [' ',fxn2]);
             firstCol = cell1((2:end),colNum1);
             secCol = cell2((2:end),colNum2);
             firstCol(strcmp(firstCol, ' NaN')) = {NaN};
             secCol(strcmp(secCol,' NaN')) = {NaN};
             x_y = cell2mat([firstCol, secCol]);
             x_y = x_y(~any(isnan(x_y),2),:);
             directory1(i).name
             median(x_y(:,1))
             subplot(4,2,i)   
             scatter(x_y(:,1), x_y(:,2))
             xlabel(fxn1);
             ylabel(fxn2);
             title([fxn1 ' vs. ' fxn2 ' for ' directory1(i).name]);
        end
    else
        error(['There exists no results for this fxn. Please make sure to ' , ... 
            'run the functions and have the results before using the extract ', ...
            'function.'])
    end
end