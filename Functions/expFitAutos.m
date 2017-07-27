function expFitAutos(sepData)
%Chris Ki, July 2017, Gittis Lab
%expFitAutos : Plots a 4 x 2 plot of ISI figures on the left and corresponding 
%Autocorrelograms on the right along with an exponential fit on the first
%peak and first minimum detected. 
    placeMat = [1 2; 3 4; 5 6; 7 8 ];
    titleSet = {'No class', 'Regular', 'Irregular', 'Burst'};
    keySet = [1,2,3,4];
    titleMap = containers.Map(keySet,titleSet);  
    binLength = 0.004;
    
    %Time limits for autoCorr
    startTime = 0;
    %Usually 500ms is enough for SNR studies
    endTime = 0.5;
    numCoeffs = 4;
    avgBins = 1:length(startTime:binLength:endTime);
    avgIndexMat = reshape(avgBins,[2,length(avgBins)/2])';
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
            title([fileName ' ' titleMap(i) ' bin = ' num2str(binLength*1000) 'ms'])             
            %For AutoCorrs
            dt = binLength;
            subplot(4,2,placeMat(currFigRowNum, 2))
            binaryTrain = binarySpikes(cellSpikes,dt);
            newTime = (-round(cellSpikes(end)/dt)*dt:dt:round(cellSpikes(end)/dt)*dt);
            result = xcorr(binaryTrain,binaryTrain);
            %Normalize autocorrelogram by value at time lag = 0
            zeroIndex = find(newTime == 0);
            normVal = result(zeroIndex);
            result = result./normVal;
            
            %Average over 2 points to smooth function
            tempAuto = result(newTime >= 0 & newTime <= endTime);
            tempTime = newTime(newTime >= 0 & newTime <= endTime);
            intAuto = zeros(length(tempAuto)/2,1);
            intTime = zeros(length(tempTime)/2,1);
            for k = 1:length(intAuto)
                firstIndex = avgIndexMat(k,1);
                secIndex = avgIndexMat(k,2);
                if firstIndex == 1
                    intAuto(k) = tempAuto(secIndex);
                    intTime(k) = tempTime(secIndex);
                else
                    intAuto(k) = mean([tempAuto(firstIndex), tempAuto(secIndex)]);
                    intTime(k) = mean([tempTime(firstIndex), tempTime(secIndex)]);
                end
            end
            
            %Try to find the max and min for the smoothed AutoCorr
            maxVal = max(intAuto(intTime > dt & intTime < 0.2));
            maxIndices = find(intAuto == maxVal);
            maxIndices = maxIndices(intTime(maxIndices) > 0);
            firstMax = maxIndices(1); 
            
            minVal = min(intAuto(intTime >  intTime(firstMax) & intTime < 0.4));
            minIndices = find(intAuto == minVal);
            minIndices = minIndices(intTime(minIndices) > intTime(firstMax));
            firstMin = minIndices(1);

            fitX = intTime(intTime >= intTime(firstMax) & intTime <= intTime(firstMin))';
            fitY = intAuto(intTime >= intTime(firstMax) & intTime <= intTime(firstMin));           
            hold on
            plot(newTime',result)
            %If not enough data points, just do it for the regular
            %   sequences
            if length(fitX) < numCoeffs && length(fitY) < numCoeffs
                maxVal = max(result(newTime > dt & newTime < 0.2));
                maxIndices = find(result == maxVal);
                maxIndices = maxIndices(newTime(maxIndices) > 0);
                firstMax = maxIndices(1); 

                minVal = min(result(newTime >  newTime(firstMax) & newTime < 0.4));
                minIndices = find(result == minVal);
                minIndices = minIndices(newTime(minIndices) > newTime(firstMax));
                firstMin = minIndices(1);

                fitX = newTime(newTime >= newTime(firstMax) & newTime <= newTime(firstMin));
                fitY = result(newTime >= newTime(firstMax) & newTime <= newTime(firstMin));  
            end
            if length(fitX) >= numCoeffs && length(fitY) >= numCoeffs
                expFit = fit(fitX',fitY,'exp2');
                plot(expFit,fitX,fitY)
                str = ['A = '  num2str(expFit.a) ' B = '  num2str(expFit.b) ' C = '  num2str(expFit.c) ' D = '  num2str(expFit.d)];
                text(0.1,maxVal*1.10, str)
            end
            plot(intTime, intAuto, '-k')
            hold off
            xlim([dt,0.5])
        end
    end
end