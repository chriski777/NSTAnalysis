function expFitClasses(sepData)
%Chris Ki, July 2017, Gittis Lab
    binLength = 0.004;
    
    %Time limits for autoCorr
    startTime = 0;
    %Usually 500ms is enough for SNR studies
    endTime = 0.5;
    numCoeffs = 4;
    avgBins = 1:length(startTime:binLength:endTime);
    avgIndexMat = reshape(avgBins,[2,length(avgBins)/2])';
    titleSet = {'black', 'blue', 'green', 'magenta'};
    keySet = [1,2,3,4];
    titleMap = containers.Map(keySet,titleSet);  
    figure
    hold on
    for i = 1: 4
        totalClassCells = sepData{i};
        for j = 1: length(sepData{i})
            currRow = totalClassCells(j,:);
            cellSpikes = currRow{3};           
            %For AutoCorrs
            dt = binLength;
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
            %Find max within 200 ms
            maxVal = max(intAuto(intTime > dt & intTime < 0.2));
            maxIndices = find(intAuto == maxVal);
            maxIndices = maxIndices(intTime(maxIndices) > 0);
            firstMax = maxIndices(1); 
            
            %Find min in interval between 400ms and maxTime
            minVal = min(intAuto(intTime >  intTime(firstMax) & intTime < 0.4));
            minIndices = find(intAuto == minVal);
            minIndices = minIndices(intTime(minIndices) > intTime(firstMax));
            firstMin = minIndices(1);

            fitX = intTime(intTime >= intTime(firstMax) & intTime <= intTime(firstMin))';
            fitY = intAuto(intTime >= intTime(firstMax) & intTime <= intTime(firstMin));           
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
                if length(cellSpikes) > 500
                    fitY = fitY./maxVal;
                    expFit = fit(fitX',fitY,'exp2');
                    plt = plot(expFit,fitX,fitY);
                    plt(1).MarkerSize = 1;
                    set(plt,'Color', titleMap(i))
                end
            end
            xlim([dt,0.5])
        end
    end
end