function [output1, output2] =  scatterPlot(fxn1,fxn2)
%Chris Ki, June 2017, Gittis Lab
%scatterPlot: Displays the scatterplot of the result of two functions. The
%   scatterPlot function does NOT apply the functions to the results. It
%   only can be used AFTER the function scripts have been used.

%Input Parameters: 
%   fxn1: String that contains the first function handle
%   fxn2: String that contains the second function handle

%Output Parameters:
%   output1 : N (number of files/conditions) x 1 vector containing Medians of results of first fxn
%   output2 : N x 1 vector containing medians of results of second fxn
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
        output1 = zeros(numFiles1, 1);
        output2 = zeros(numFiles1,1);
        figure
        for i = 1:numFiles1
            %directory1 name can be the same as the same results are read
             fileName1 = ['results\', fxn1,'\', directory1(i).name];
             fileName2 = ['results\', fxn2,'\', directory1(i).name];
             [~,~,cell1] = xlsread(fileName1);
             [~,~,cell2] = xlsread(fileName2);
             %Isolate the columns with the fxn results from each cell
             firstRow1 = cell1(1,:);
             colNum1 = strcmp(firstRow1, [' ',fxn1]);
             firstRow2 = cell2(1,:);
             colNum2 = strcmp(firstRow2, [' ',fxn2]);
             %3rd column will hold the corresponding class integers
             % both class columns from file 1 and 2 should be same since
             % both files are from same conditions
             colNumClass = strcmp(firstRow1, [' ', 'Class']);
             firstCol = cell1((2:end),colNum1);
             secCol = cell2((2:end),colNum2);
             if sum(colNumClass) == 0
                 colNumClass = strcmp(firstRow2, [' ', 'Class']);
                 classCol =cell2((2:end),colNumClass);
             else
                classCol = cell1((2:end),colNumClass);
             end
             firstCol(strcmp(firstCol, ' NaN')) = {NaN};
             secCol(strcmp(secCol,' NaN')) = {NaN};
             x_y = cell2mat([firstCol, secCol, classCol]);
             %Delete rows where one of the columns has a NaN value
             x_y = x_y(~any(isnan(x_y),2),:);
             
             %Median of results for both functions
             output1(i) = median(x_y(:,1));
             output2(i) = median(x_y(:,2));
             axes(i) = subplot(4,2,i);   
             gscatter(x_y(:,1), x_y(:,2),x_y(:,3),'kbgm', 'oooo')
             xlabel(fxn1);
             ylabel(fxn2);
             title([fxn1 ' vs. ' fxn2 ' for ' directory1(i).name]);
             lgd = legend('No Class', 'Regular', 'Irregular', 'Burst');
        end
        linkaxes(axes)
    else
        error(['There exists no results for this fxn. Please make sure to ' , ... 
            'run the functions and have the results before using the extract ', ...
            'function.'])
    end
end