function result = spikeDensityFunction(data)
    if isempty(data.movet_rs) || isempty(data.moving_rs)
        msg = ['There is no movement file associated with this ' data.fileName];
        warning(msg)
    else
        figure
        allTimes = data.movet_rs;
        movements = data.moving_rs;
        %vector of all Onsets
        onSets = find(diff(movements) == 1);
        offSets = find(diff(movements) == -1);
        minLength = min(offSets - onSets);
        beforeOnS = 3; %2 seconds before movement Onset
        std = 0.1;
        dt = 0.001;
        lo = 0;
        hi = data.end;
        binm = 1/dt;
        nbins = length(lo:dt:hi);
        delt = zeros(1,nbins);
        delt(round(binm*data.SPKC(data.SPKC< hi)) + 1) = 1;
        gauss = normpdf(-std*3:dt:std*3,0,std);
        sdf_full = conv(delt,gauss,'same');
        sdf = sdf_full(binm*std*3+1:end-binm*std*3);
        totalSDF = zeros(length(onSets), beforeOnS*1000 + minLength + 1);
        for i = 1: length(onSets)
            begin = onSets(i) + 1;
            if begin + minLength > length(sdf)
                begin
                data.end
                begin + minLength
                length(sdf)
                begin - beforeOnS*1000
                size(sdf)
                size(totalSDF)
                totalSDF(i,:) = sdf(begin - beforeOnS*1000: end);
            else 
                totalSDF(i,:) = sdf(begin - beforeOnS*1000: begin + minLength);
            end
        end
        meanSDF = mean(totalSDF);
        times = (-beforeOnS: dt : minLength/1000);
        plot(times,meanSDF)
        title(['Average SDF for movement phase in ' data.fileName])
        xlabel('Time from movement Onset')
        ylabel('SDF value')
    end
    result = 1;
end