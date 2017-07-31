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
    numClass = 4;
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
        
        indexMat = reshape((1:numClass*numFiles1),[numClass,numFiles1])';
        stemIndex = 1;
        for i = 1:numFiles1
            figI = figure(i);
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
             % both class columns and SPKC name from file 1 and 2 should be same since
             % both files are from same conditions
             colNumClass = strcmp(firstRow1, [' ', 'Class']);
             colFileName = strcmp(firstRow1, ['', 'FileName']);
             colSPKCName = strcmp(firstRow1, [' ', 'SPKCName']);
             firstCol = cell1((2:end),colNum1);
             secCol = cell2((2:end),colNum2);
             thirdCol = cell3((2:end),colNum3);
             fileCol = cell1((2:end), colFileName);
             SPKCCol = cell1((2:end), colSPKCName);
             %If firstCol doesn't have class, delegate to secondClass
             if sum(colNumClass) == 0
                 colNumClass = strcmp(firstRow2, [' ', 'Class']);
                 classCol =cell2((2:end),colNumClass);
             else
                classCol = cell1((2:end),colNumClass);
             end
             firstCol(strcmp(firstCol, ' NaN')) = {NaN};
             secCol(strcmp(secCol,' NaN')) = {NaN};
             thirdCol(strcmp(thirdCol,' NaN')) = {NaN};
             
             x_y_z = cell2mat([firstCol, secCol, thirdCol, classCol]);
             %Delete rows where one of the columns has a NaN value
             new_x_y_z = x_y_z(~any(isnan(x_y_z),2),:);
             newFileCol = fileCol(~any(isnan(x_y_z),2),:);
             newSPKCCol = SPKCCol(~any(isnan(x_y_z),2),:);
             %Median of results for both functions
             output1(i) = median(new_x_y_z(:,1));
             output2(i) = median(new_x_y_z(:,2));
             output3(i) = median(new_x_y_z(:,3));

             %Creates dataStructs which will be stored in axes of figure
             dataStats = struct();
             dataStats.x =  new_x_y_z(:,1);
             dataStats.y = new_x_y_z(:,2);
             dataStats.z = new_x_y_z(:,3);
             dataStats.fileName = newFileCol;
             dataStats.SPKC = newSPKCCol;

             allMatrix = new_x_y_z(:,:);
             for class = 1:numClass
                classMatrix = allMatrix(allMatrix(:,4) == (class - 1),:);
                sizeMat = size(classMatrix);
                numRows = sizeMat(1);
                hold on
                h(stemIndex) = stem3(classMatrix(:,1), classMatrix(:,2), classMatrix(:,3), [colors(class), 'o']);
                stemIndex = stemIndex + 1;
             end
             grid
             rotate3d on 
             hold off
             xlabel(fxn1);
             ylabel(fxn2);
             zlabel(fxn3);
             setappdata(gca, 'dataStats', dataStats);
             %Sets baseline Value to figure's bottom Z Limit value for 
             minZ = figI.CurrentAxes.ZLim(1);
             currIndices = indexMat(i,:);
             for k = 1:numClass
                currIndex = currIndices(k);
                h(currIndex).BaseValue =  minZ;
             end
             title([fxn1 ' vs. ' fxn2 ' vs. ' fxn3 ' for ' directory1(i).name]);
             lgd = legend('No Class', 'Regular', 'Irregular', 'Burst');
        end
    else
        error(['There exists no results for this fxn. Please make sure to ' , ... 
            'run the functions and have the results before using the extract ', ...
            'function.'])
    end
end