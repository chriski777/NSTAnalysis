function result = spikeDensityFunction(data)
    if isempty(data.movet_rs) || isempty(data.moving_rs)
        msg = ['There is no movement file associated with this ' data.fileName{1}];
        warning(msg)
    else
        allTimes = data.movet_rs;
        movements = data.moving_rs;
        %vector of all Onsets
        onSets = find(diff(movements) == 1);
        offSets = find(diff(movements) == -1);
        %if movement continues all the way to the end
        if onSets(end) > offSets(end)
            offSets = [offSets; length(movements)- 1];
        end
        %if mouse starts moving at beginning of recording
        if offSets(1) < onSets(1)
            onSets = [0; onSets];
        end
        beforeOnS =3; %2 seconds before movement Onset
        timeAfterOffS = 2;
        stdevation = 0.1;
        dt = 0.001;
        lo = 0;
        hi = data.end;
        binm = 1/dt;
        nbins = length(lo:dt:hi);
        delt = zeros(1,nbins);
        delt(round(binm*data.SPKC(data.SPKC< hi)) + 1) = 1;
        gauss = normpdf(-stdevation*3:dt:stdevation*3,0,stdevation);
        sdf_full = conv(delt,gauss,'same');
        sdf = sdf_full(binm*stdevation*3+1:end-binm*stdevation*3);
        %check each onset/offset value to make sure time preceding movement
        %   is not a negative index
        offSets = offSets((onSets + 1 - beforeOnS*1000) > 0);
        onSets = onSets((onSets + 1 - beforeOnS*1000) > 0);
        %Make sure time before onSet is no movement
        toDelete = zeros(1,length(onSets));
        for i = 1: length(onSets)
            preIndex = onSets(i) + 1 - beforeOnS*1000;
            %delete if there is movement in the time before the movement
            %   onSet
            if sum(movements(preIndex:onSets(i) + 1)) > 1
                toDelete(i) = 1;
            end
        end
        onSets = onSets(toDelete ==1);
        offSets = offSets(toDelete == 1);
        figure(data.iteration)
        if length(onSets) ~= 0
            totalSDF = zeros(length(onSets), beforeOnS*1000 + timeAfterOffS*1000 + 1);
            times = (-beforeOnS: dt : timeAfterOffS);
            hold on
            for i = 1: length(onSets)
                begin = onSets(i) + 1  - beforeOnS*1000;
                endIndex = onSets(i) + 1 + timeAfterOffS*1000;
                totalSDF(i,:) = sdf(begin: endIndex);
                movePhase = ['Time ' num2str(begin/1000) ' to ' num2str(endIndex/1000) ];
                plot(times,totalSDF(i,:),'DisplayName',movePhase)
            end
            if (exist('shadeBars.m', 'file') == 2)
                [errorBars, dataLine] = shadeBars(times,mean(totalSDF,1),std(totalSDF));
            end
            hold off
            title(['Average SDF for movement phase in ' data.fileName])
            xlabel('Time from movement Onset')
            ylabel('SDF value')
            lgd = legend('show');
            lgd.String(end-1) = [];
            lgd.String{end} = 'Average';
        else
           plot(allTimes,movements)
           msg = ['There is movement in a phase before this onset in ' data.fileName{1}];
           warning(msg)            
        end
    end
    result = 1;
end