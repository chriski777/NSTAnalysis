function [output1] =  reCustClassify(fxn1,fxn2, fxn3)
%Chris Ki, July 2017, Gittis Lab
%reCustClassify: Reclassifies based on customClassify function for three
%function results listed above

%Input Parameters: 
%   fxn1: String that contains the first function handle
%   fxn2: String that contains the second function handle
%   fxn3: String that contains the third function handle

%Output Parameters:
    addpath('results\')
    orderOfFxns = {fxn1, fxn2, fxn3};
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
        
        for i = 1:numFiles1
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
             %ONLY USE BELOW IF YOU NEED TO RECALCULATE CUSTCLASSIFICATIONS
             %Writes new Classification.csv
             newClasses = customClassify(x_y_z(:,1:3),orderOfFxns);
             directory1(i).name
             headers = {'FileName', 'SPKC', 'Unit', 'Class'};
             classMap = {'No Class', 'Regular', 'Irregular', 'Bursty'};
             newClassCol = cell(length(newClasses),1);
             newSPKCol = cell(length(SPKCCol),1);
             unitCol = cell(length(SPKCCol),1);
             for z = 1:length(newClasses)
                 currUnit = SPKCCol{z};
                 newSPKCol{z} = currUnit(~isletter(currUnit));
                 unitCol{z} = currUnit(isletter(currUnit));
                 newClassCol{z} = classMap{newClasses(z)+1};
             end
             newMat = [fileCol,newSPKCol,unitCol, newClassCol];
             newMat = [headers;newMat]
             resFileName = sprintf('%s', directory1(i).name);
             fid = fopen(resFileName,'wt');          
             if fid > 0 
                %Writes column headers
                fprintf(fid,'%s, %s, %s, %s\n', newMat{1,1}, newMat{1,2},  newMat{1,3}, newMat{1,4});
                for k = 2:size(newMat,1)
                  fprintf(fid,'%s, %s, %s, %s\n',newMat{k,1}, newMat{k,2},  newMat{k,3}, newMat{k,4});
                end
                fclose(fid);
             end         
        end
    else
        error(['There exists no results for this fxn. Please make sure to ' , ... 
            'run the functions and have the results before using the extract ', ...
            'function.'])
    end
end