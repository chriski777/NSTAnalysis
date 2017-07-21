function output = cellbycellISIAutos(sepData)
%Chris Ki, July 2017, Gittis Lab
%cellbycellISIAutos : Plots a 4 x 2 plot of ISI figures on the left and corresponding 
%Autocorrelograms on the right
    placeMat = [1 2; 3 4; 5 6; 7 8 ];
    titleSet = {'No class', 'Regular', 'Irregular', 'Burst'};
    keySet = [1,2,3,4];
    titleMap = containers.Map(keySet,titleSet);  
    binLength = 0.004;
    ctrs = [0:binLength:1.0];
    for i = 1: 4
        totalClassCells = sepData{i};
        for j = 1: length(sepData{i})
            if mod((j - 1),4) == 0 
                figure
            end
            currRow = totalClassCells(j,:);
            fileName = currRow{1};
            cellSpikes = currRow{2};          
            currFigRowNum = mod(j-1,4) + 1;
            
            %For ISI Hist
            subplot(4,2,placeMat(currFigRowNum, 1))
            cellISIs = ISIconverter(cellSpikes, length(cellSpikes) - 1);
            n = histc(cellISIs,ctrs);
            bar(ctrs,n,'histc')
            title([fileName ' ' titleMap(i) ' bin = ' num2str(binLength) 'ms'])             
            %For AutoCorrs
            dt = 0.004;
            subplot(4,2,placeMat(currFigRowNum, 2))
            binaryTrain = binarySpikes(cellSpikes,dt);
            newTime = (-round(cellSpikes(end)/dt)*dt:dt:round(cellSpikes(end)/dt)*dt);
            result = xcorr(binaryTrain,binaryTrain);
            plot(newTime',result)
            xlim([dt,0.5])
        end
    end
end