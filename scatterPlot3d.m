function [output1, output2, output3] =  scatterPlot3d(fxn1,fxn2, fxn3)
%Chris Ki, July 2017, Gittis Lab
%scatterPlot3d: Displays the 3d scatterplot of the result of three functions. The
%   scatterPlot3d function does NOT apply the functions to the results. It
%   only can be used AFTER the function scripts have been used and results
%   have been successfully produced.

%Input Parameters: 
%   fxn1: String that contains the first function handle
%   fxn2: String that contains the second function handle
%   fxn3: String that contains the third function handle

%Output Parameters:
%   output1 : N (number of files/conditions) x 1 vector containing Medians of results of first fxn
%   output2 : N x 1 vector containing medians of results of second fxn
%   output3 : N vector containing medians of results of third fxn
    addpath('results\')
    colors = 'kbgm';
    if (exist(['results\', fxn1], 'file') == 7 && exist(['results\', fxn2], 'file') == 7  && exist(['results\', fxn3], 'file') == 7)
        directory1 = dir(['results\', fxn1, '\*.csv']);
        directory2 = dir(['results\', fxn2, '\*.csv']);
        directory3 = dir(['results\', fxn3, '\*.csv']);
        numFiles1 = length(directory1(not([directory1.isdir])));
        numFiles2 = length(directory2(not([directory2.isdir])));
        numFiles3 = length(directory3(not([directory3.isdir])));
        if numFiles1 == 0 
            error(['There are not any results in the ', fxn1, ' directory.'])
        end 
        if numFiles2 == 0 
            error(['There are not any results in the ', fxn2, ' directory.'])
        end 
        if numFiles3 == 0
            error(['There are not any results in the ', fxn3, ' directory.'])            
        end
        output1 = zeros(numFiles1,1);
        output2 = zeros(numFiles1,1);
        output3 = zeros(numFiles1,1);
        for i = 1:numFiles1
            figure(i)
            %directory1 name can be the same as the same results are read
             fileName1 = ['results\', fxn1,'\', directory1(i).name];
             fileName2 = ['results\', fxn2,'\', directory1(i).name];
             fileName3 = ['results\', fxn3,'\', directory1(i).name];
             [~,~,cell1] = xlsread(fileName1);
             [~,~,cell2] = xlsread(fileName2);
             [~,~,cell3] = xlsread(fileName3);
             %Isolate the columns with the fxn results from each cell
             firstRow1 = cell1(1,:);
             colNum1 = strcmp(firstRow1, [' ',fxn1]);
             firstRow2 = cell2(1,:);
             colNum2 = strcmp(firstRow2, [' ',fxn2]);
             firstRow3 = cell3(1,:);
             colNum3 = strcmp(firstRow3, [' ',fxn3]);
             %3rd column will hold the corresponding class integers
             % both class columns from file 1 and 2 should be same since
             % both files are from same conditions
             colNumClass = strcmp(firstRow1, [' ', 'Class']);
             firstCol = cell1((2:end),colNum1);
             secCol = cell2((2:end),colNum2);
             thirdCol = cell3((2:end),colNum3);
             if sum(colNumClass) == 0
                 colNumClass = strcmp(firstRow2, [' ', 'Class']);
                 classCol =cell2((2:end),colNumClass);
             else
                classCol = cell1((2:end),colNumClass);
             end
             firstCol(strcmp(firstCol, ' NaN')) = {NaN};
             secCol(strcmp(secCol,' NaN')) = {NaN};
             thirdCol(strcmp(thirdCol,' NaN')) = {NaN};
             x_y = cell2mat([firstCol, secCol, thirdCol, classCol]);
             %Delete rows where one of the columns has a NaN value
             x_y = x_y(~any(isnan(x_y),2),:);
             
             %Median of results for both functions
             output1(i) = median(x_y(:,1));
             output2(i) = median(x_y(:,2));
             output3(i) = median(x_y(:,3));
             allMatrix = x_y;
             for class = 1:4
                classMatrix = allMatrix(allMatrix(:,4) == (class - 1),:);
                sizeMat = size(classMatrix);
                numRows = sizeMat(1);
                for k = 1:numRows
                 plot3(classMatrix(k,1), classMatrix(k,2), classMatrix(k,3), [colors(class), 'o'])                   
                end
                hold on
             end
             grid
             rotate3d on 
             hold off
             xlabel(fxn1);
             ylabel(fxn2);
             zlabel(fxn3);
             title([fxn1 ' vs. ' fxn2 'vs. ' fxn3 ' for ' directory1(i).name]);
             lgd = legend('No Class', 'Regular', 'Irregular', 'Burst');
        end
    else
        error(['There exists no results for this fxn. Please make sure to ' , ... 
            'run the functions and have the results before using the extract ', ...
            'function.'])
    end
end