function result = expFitResults(data)
%expFitResults: Returns the coefficients related to the exponential Fit of
%the Autocorrelogram signal between the first peak and the first minimum
%found. 
    resultA = NaN; resultB = NaN; resultC = NaN; resultD = NaN; m = NaN;
    if (length(data.SPKC)/data.end) > 5
        binLength = 0.004;
        startTime = 0;
        endTime = 0.5;
        numCoeffs = 4;
        avgBins = 1:length(startTime:binLength:endTime);
        avgIndexMat = reshape(avgBins,[2,length(avgBins)/2])';

        %For AutoCorrs
        dt = binLength;
        cellSpikes = data.SPKC;
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
        maxTime = intTime(firstMax);

        minVal = min(intAuto(intTime >  intTime(firstMax) & intTime < 0.4));
        minIndices = find(intAuto == minVal);
        minIndices = minIndices(intTime(minIndices) > intTime(firstMax));
        firstMin = minIndices(1);
        minTime = intTime(firstMin);
        
        fitX = intTime(intTime >= intTime(firstMax) & intTime <= intTime(firstMin))';
        fitY = intAuto(intTime >= intTime(firstMax) & intTime <= intTime(firstMin));
        
        %If not enough data points, just do it for the regular
        %   sequences
        if length(fitX) < numCoeffs && length(fitY) < numCoeffs
            maxVal = max(result(newTime > dt & newTime < 0.2));
            maxIndices = find(result == maxVal);
            maxIndices = maxIndices(newTime(maxIndices) > 0);
            firstMax = maxIndices(1); 
            maxTime = newTime(firstMax);

            minVal = min(result(newTime >  newTime(firstMax) & newTime < 0.4));
            minIndices = find(result == minVal);
            minIndices = minIndices(newTime(minIndices) > newTime(firstMax));
            firstMin = minIndices(1);
            minTime = newTime(firstMin);

            fitX = newTime(newTime >= newTime(firstMax) & newTime <= newTime(firstMin));
            fitY = result(newTime >= newTime(firstMax) & newTime <= newTime(firstMin));  
        end
        if length(fitX) >= numCoeffs && length(fitY) >= numCoeffs
            expFit = fit(fitX',fitY,'exp2');
            resultA = expFit.a;
            resultB = expFit.b;
            resultC = expFit.c;
            resultD = expFit.d;
            topVal = (resultA*exp(resultB*maxTime) + resultC*exp(resultD*maxTime))/maxVal;
            botVal = (resultA*exp(resultB*minTime) + resultC*exp(resultD*minTime))/maxVal;
            m = (topVal - botVal)/(maxTime - minTime);
        end
    end
    result = m;
end